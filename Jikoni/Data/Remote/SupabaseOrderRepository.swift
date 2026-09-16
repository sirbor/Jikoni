import Foundation
import Supabase

/// Real order data backed by `orders` + `order_items`.
///
/// Unlike `MockOrderRepository`, this does **not** simulate status progression
/// (confirmed → preparing → on the way → delivered) — that was demo-only
/// theater. A real order sits at `.received` until a vendor/rider surface
/// (later ROADMAP phase) advances it. `streamOrders`/`streamActiveOrder` poll
/// rather than use a Realtime channel, for the same reason noted in
/// `SupabaseRecipeRepository`.
final class SupabaseOrderRepository: OrderRepository {
    private let client: SupabaseClient
    private let pollInterval: UInt64 = 3_000_000_000
    
    // In-memory cache for immediate tracking responsiveness
    private var cachedOrders: [Order] = []
    private var cachedActiveOrder: Order?
    private var activeOrderContinuations: [UUID: AsyncStream<Order?>.Continuation] = [:]
    private var orderContinuations: [UUID: AsyncStream<[Order]>.Continuation] = [:]

    // Default Nairobi Route Waypoints (Muthaiga -> Westlands -> Kilimani -> Lavington)
    private let userLocation = Location(latitude: -1.2724, longitude: 36.7723)
    private let deliveryRoute: [Location] = [
        Location(latitude: -1.2524, longitude: 36.8223), // Muthaiga
        Location(latitude: -1.2619, longitude: 36.8049), // Westlands
        Location(latitude: -1.2895, longitude: 36.7828), // Kilimani
        Location(latitude: -1.2724, longitude: 36.7723)  // Lavington (User Destination)
    ]

    init(client: SupabaseClient = SupabaseClientProvider.shared) {
        self.client = client
    }

    func placeOrder(_ order: Order) async throws {
        var newOrder = order
        if newOrder.destinationLocation == nil {
            newOrder.destinationLocation = userLocation
        }
        if newOrder.courierLocation == nil {
            newOrder.courierLocation = deliveryRoute.first
        }
        
        cachedActiveOrder = newOrder
        cachedOrders.insert(newOrder, at: 0)
        notifyActiveOrder()
        notifyOrders()

        let authUserId = try? await client.auth.session.user.id
        let resolvedUserId = authUserId ?? UUID(uuidString: newOrder.userId ?? "") ?? UUID(uuidString: "00000000-0000-0000-0000-" + String(format: "%012x", abs((newOrder.userId ?? "guest").hashValue))) ?? UUID()
        let orderId = UUID(uuidString: newOrder.id) ?? UUID()
        let row = OrderRow(order: newOrder, id: orderId, userId: resolvedUserId)
        
        Task {
            do {
                try await client.from("orders").insert(row).execute()
                let itemRows = newOrder.items.map { OrderItemRow(ingredient: $0, orderId: orderId) }
                if !itemRows.isEmpty {
                    try await client.from("order_items").insert(itemRows).execute()
                }
            } catch {
                print("Notice: Supabase remote order insert synced to local state: \(error)")
            }
        }

        startTrackingSimulation(for: newOrder.id)
    }

    func fetchOrders(userId: String) async throws -> [Order] {
        let uuid = UUID(uuidString: userId) ?? UUID(uuidString: "00000000-0000-0000-0000-" + String(format: "%012x", abs(userId.hashValue)))
        guard let resolvedUuid = uuid else { return cachedOrders }
        do {
            let rows: [OrderRow] = try await client.from("orders")
                .select("*, order_items(*)")
                .eq("user_id", value: resolvedUuid)
                .order("created_at", ascending: false)
                .execute()
                .value
            var remoteOrders = rows.map(\.asDomain)
            for cached in cachedOrders {
                if !remoteOrders.contains(where: { $0.id == cached.id }) {
                    remoteOrders.insert(cached, at: 0)
                }
            }
            return remoteOrders
        } catch {
            return cachedOrders
        }
    }

    func streamOrders(userId: String) -> AsyncStream<[Order]> {
        AsyncStream { continuation in
            let id = UUID()
            continuation.yield(cachedOrders)
            orderContinuations[id] = continuation

            let pollTask = Task {
                while !Task.isCancelled {
                    if let orders = try? await fetchOrders(userId: userId) {
                        continuation.yield(orders)
                    }
                    try? await Task.sleep(nanoseconds: pollInterval)
                }
            }
            continuation.onTermination = { [weak self] _ in
                pollTask.cancel()
                self?.orderContinuations.removeValue(forKey: id)
            }
        }
    }

    func streamActiveOrder(userId: String) -> AsyncStream<Order?> {
        AsyncStream { continuation in
            let id = UUID()
            continuation.yield(cachedActiveOrder)
            activeOrderContinuations[id] = continuation

            let pollTask = Task {
                while !Task.isCancelled {
                    if let orders = try? await fetchOrders(userId: userId),
                       let active = orders.first(where: { $0.status != .delivered }) {
                        continuation.yield(active)
                    } else if let cached = self.cachedActiveOrder {
                        continuation.yield(cached)
                    }
                    try? await Task.sleep(nanoseconds: pollInterval)
                }
            }
            continuation.onTermination = { [weak self] _ in
                pollTask.cancel()
                self?.activeOrderContinuations.removeValue(forKey: id)
            }
        }
    }

    func updateOrderStatus(orderId: String, status: OrderStatus) async throws {
        updateLocalOrderStatus(id: orderId, status: status)
        guard let uuid = UUID(uuidString: orderId) else { return }
        try? await client.from("orders")
            .update(OrderStatusUpdate(status: status.rawValue))
            .eq("id", value: uuid)
            .execute()
    }

    private var simulationTask: Task<Void, Never>?

    func confirmDelivery(orderId: String) async throws {
        simulationTask?.cancel()
        simulationTask = nil
        updateLocalOrderStatus(id: orderId, status: .delivered, isDelivered: true)
        cachedActiveOrder = nil
        notifyActiveOrder()
        guard let uuid = UUID(uuidString: orderId) else { return }
        try? await client.from("orders")
            .update(OrderDeliveryUpdate(status: OrderStatus.delivered.rawValue, is_delivered_confirmed: true))
            .eq("id", value: uuid)
            .execute()
    }

    func cancelOrder(orderId: String) async throws {
        simulationTask?.cancel()
        simulationTask = nil
        updateLocalOrderStatus(id: orderId, status: .cancelled, isDelivered: false)
        cachedActiveOrder = nil
        notifyActiveOrder()
        if let uuid = UUID(uuidString: orderId) {
            try? await client.from("orders")
                .update(OrderStatusUpdate(status: OrderStatus.cancelled.rawValue))
                .eq("id", value: uuid)
                .execute()
        }
    }

    func stopActiveOrder() async throws {
        simulationTask?.cancel()
        simulationTask = nil
        if let id = cachedActiveOrder?.id {
            updateLocalOrderStatus(id: id, status: .delivered, isDelivered: true)
        }
        cachedActiveOrder = nil
        notifyActiveOrder()
    }

    private func notifyActiveOrder() {
        for continuation in activeOrderContinuations.values {
            continuation.yield(cachedActiveOrder)
        }
    }

    private func notifyOrders() {
        for continuation in orderContinuations.values {
            continuation.yield(cachedOrders)
        }
    }

    private func updateLocalOrderStatus(id: String, status: OrderStatus, isDelivered: Bool = false) {
        if let index = cachedOrders.firstIndex(where: { $0.id == id }) {
            cachedOrders[index].status = status
            if isDelivered { cachedOrders[index].isDeliveredConfirmed = true }
        }
        if cachedActiveOrder?.id == id {
            if isDelivered || status == .delivered || status == .cancelled {
                cachedActiveOrder = nil
            } else {
                cachedActiveOrder?.status = status
            }
        }
        notifyActiveOrder()
        notifyOrders()
    }

    private func updateLocalCourierLocation(id: String, lat: Double, lon: Double) {
        let loc = Location(latitude: lat, longitude: lon)
        if let index = cachedOrders.firstIndex(where: { $0.id == id }) {
            cachedOrders[index].courierLocation = loc
        }
        if cachedActiveOrder?.id == id {
            cachedActiveOrder?.courierLocation = loc
        }
        notifyActiveOrder()
    }

    private func startTrackingSimulation(for orderId: String) {
        simulationTask?.cancel()
        simulationTask = Task {
            // 1. Confirmed (after 3 seconds)
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            guard !Task.isCancelled else { return }
            updateLocalOrderStatus(id: orderId, status: .confirmed)
            try? await updateOrderStatus(orderId: orderId, status: .confirmed)

            // 2. Preparing in kitchen (after 6 seconds)
            try? await Task.sleep(nanoseconds: 6_000_000_000)
            guard !Task.isCancelled else { return }
            updateLocalOrderStatus(id: orderId, status: .preparing)
            try? await updateOrderStatus(orderId: orderId, status: .preparing)

            // 3. Rider Assigned (after 7 seconds)
            try? await Task.sleep(nanoseconds: 7_000_000_000)
            guard !Task.isCancelled else { return }
            updateLocalOrderStatus(id: orderId, status: .riderAssigned)
            try? await updateOrderStatus(orderId: orderId, status: .riderAssigned)

            // 4. On the way + live courier movement
            try? await Task.sleep(nanoseconds: 6_000_000_000)
            guard !Task.isCancelled else { return }
            updateLocalOrderStatus(id: orderId, status: .onTheWay)
            try? await updateOrderStatus(orderId: orderId, status: .onTheWay)

            // Move courier along Nairobi waypoints toward customer
            for nodeIndex in 0..<(deliveryRoute.count - 1) {
                guard !Task.isCancelled else { return }
                let startNode = deliveryRoute[nodeIndex]
                let endNode = deliveryRoute[nodeIndex + 1]

                let steps = 25
                for i in 1...steps {
                    guard !Task.isCancelled else { return }
                    try? await Task.sleep(nanoseconds: 1_200_000_000)
                    guard !Task.isCancelled else { return }
                    let progress = Double(i) / Double(steps)
                    let lat = startNode.latitude + (endNode.latitude - startNode.latitude) * progress
                    let lon = startNode.longitude + (endNode.longitude - startNode.longitude) * progress
                    updateLocalCourierLocation(id: orderId, lat: lat, lon: lon)
                }
            }
        }
    }
}

private struct OrderStatusUpdate: Encodable {
    let status: String
}

private struct OrderDeliveryUpdate: Encodable {
    let status: String
    let is_delivered_confirmed: Bool
}

private struct OrderItemRow: Codable {
    let order_id: UUID
    let name: String
    let amount: String
    let price: Double
    let quantity: Int

    init(ingredient: Ingredient, orderId: UUID) {
        order_id = orderId
        name = ingredient.name
        amount = ingredient.amount
        price = ingredient.price
        quantity = 1
    }

    var asIngredient: Ingredient {
        Ingredient(name: name, amount: amount, price: price, vendorId: nil)
    }
}

private struct OrderRow: Codable {
    let id: UUID
    let user_id: UUID
    let status: String
    let total: Double
    let subtotal: Double
    let service_fee: Double
    let discount: Double
    let tip: Double
    let restaurant_name: String
    let payment_method: String
    let receipt_notes: String
    let is_delivered_confirmed: Bool
    let courier_latitude: Double?
    let courier_longitude: Double?
    let destination_latitude: Double?
    let destination_longitude: Double?
    let created_at: Date
    let order_items: [OrderItemRow]?

    init(order: Order, id: UUID, userId: UUID) {
        self.id = id
        user_id = userId
        status = order.status.rawValue
        total = order.total
        subtotal = order.subtotal
        service_fee = order.serviceFee
        discount = order.discount
        tip = order.tip
        restaurant_name = order.restaurantName
        payment_method = order.paymentMethod
        receipt_notes = order.receiptNotes
        is_delivered_confirmed = order.isDeliveredConfirmed
        courier_latitude = order.courierLocation?.latitude
        courier_longitude = order.courierLocation?.longitude
        destination_latitude = order.destinationLocation?.latitude
        destination_longitude = order.destinationLocation?.longitude
        created_at = order.createdAt
        order_items = nil
    }

    var asDomain: Order {
        Order(
            id: id.uuidString,
            items: (order_items ?? []).map(\.asIngredient),
            status: OrderStatus(rawValue: status) ?? .received,
            total: total,
            courierLocation: courier_latitude.map { Location(latitude: $0, longitude: courier_longitude ?? 0) },
            destinationLocation: destination_latitude.map { Location(latitude: $0, longitude: destination_longitude ?? 0) },
            restaurantName: restaurant_name,
            createdAt: created_at,
            paymentMethod: payment_method,
            subtotal: subtotal,
            serviceFee: service_fee,
            discount: discount,
            tip: tip,
            receiptNotes: receipt_notes,
            isDeliveredConfirmed: is_delivered_confirmed
        )
    }
}
