import Foundation

class MockOrderRepository: OrderRepository {
    private var orders: [Order] = []
    private var activeOrder: Order?
    
    private var orderContinuations: [UUID: AsyncStream<[Order]>.Continuation] = [:]
    private var activeOrderContinuations: [UUID: AsyncStream<Order?>.Continuation] = [:]
    
    // User location (Central Posh Area - Lavington)
    private let userLocation = Location(latitude: -1.2724, longitude: 36.7723)
    
    // Detailed multi-district route waypoints
    private let deliveryRoute: [Location] = [
        Location(latitude: -1.2524, longitude: 36.8223), // 1. Muthaiga (Pickup Start)
        Location(latitude: -1.2224, longitude: 36.8123), // 2. Runda
        Location(latitude: -1.2619, longitude: 36.8049), // 3. Westlands
        Location(latitude: -1.3324, longitude: 36.7123), // 4. Karen
        Location(latitude: -1.2724, longitude: 36.7723)  // 5. Lavington (User Home)
    ]
    
    private let userDefaultsKey = "jikoni_mock_orders"

    init() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let saved = try? JSONDecoder().decode([Order].self, from: data), !saved.isEmpty,
           (saved.first?.total ?? 0) > 100 {
            self.orders = saved
            self.activeOrder = saved.first { $0.status != .delivered }
        } else {
            // Seed realistic initial orders for rich hub display
            let seedOrders: [Order] = [
                Order(
                    id: "jk-8291",
                    items: [
                        Ingredient(name: "Traditional Beef Pilau", amount: "1 portion", price: 750.0, vendorId: "v-1"),
                        Ingredient(name: "Swahili Goat Soup", amount: "Bowl", price: 450.0, vendorId: "v-1"),
                        Ingredient(name: "Dawa Signature", amount: "Cocktail", price: 500.0, vendorId: "v-1")
                    ],
                    status: .delivered,
                    total: 1820.0,
                    courierLocation: userLocation,
                    destinationLocation: userLocation,
                    restaurantName: "Mama Juma's African Kitchen",
                    createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? .now,
                    paymentMethod: "M-Pesa STK Push",
                    subtotal: 1700.0,
                    serviceFee: 120.0,
                    discount: 0,
                    tip: 0,
                    receiptNotes: "Delivered to reception",
                    isDeliveredConfirmed: true
                ),
                Order(
                    id: "jk-7412",
                    items: [
                        Ingredient(name: "Classic Beef Lasagna", amount: "1 portion", price: 1000.0, vendorId: "v-2"),
                        Ingredient(name: "Roasted Tomato Basil", amount: "Bowl", price: 400.0, vendorId: "v-2")
                    ],
                    status: .delivered,
                    total: 1500.0,
                    courierLocation: userLocation,
                    destinationLocation: userLocation,
                    restaurantName: "La Trattoria Italiana",
                    createdAt: Calendar.current.date(byAdding: .day, value: -6, to: .now) ?? .now,
                    paymentMethod: "Visa ···· 1234",
                    subtotal: 1400.0,
                    serviceFee: 100.0,
                    discount: 0,
                    tip: 0,
                    receiptNotes: "Leave at door",
                    isDeliveredConfirmed: true
                )
            ]
            self.orders = seedOrders
            let initialActive = Order(
                id: "jk-9104",
                items: [
                    Ingredient(name: "Traditional Beef Pilau", amount: "1 portion", price: 750.0, vendorId: "v-1"),
                    Ingredient(name: "Swahili Goat Soup", amount: "1 Bowl", price: 450.0, vendorId: "v-1")
                ],
                status: .onTheWay,
                total: 1320.0,
                courierLocation: deliveryRoute[2],
                destinationLocation: userLocation,
                restaurantName: "Mama Juma's African Kitchen",
                createdAt: .now,
                paymentMethod: "M-Pesa STK Push",
                subtotal: 1200.0,
                serviceFee: 120.0,
                discount: 0,
                tip: 0,
                receiptNotes: "Ring doorbell at gate 4B",
                isDeliveredConfirmed: false
            )
            self.orders.insert(initialActive, at: 0)
            self.activeOrder = initialActive
            persistOrders()
        }
    }
    
    func placeOrder(_ order: Order) async throws {
        var newOrder = order
        newOrder.destinationLocation = userLocation
        newOrder.courierLocation = deliveryRoute.first
        orders.insert(newOrder, at: 0)
        activeOrder = newOrder
        persistOrders()
        notifyOrders()
        notifyActiveOrder()
        
        startSimulation(for: newOrder.id)
    }
    
    func fetchOrders(userId: String) async throws -> [Order] {
        return orders
    }
    
    func streamOrders(userId: String) -> AsyncStream<[Order]> {
        AsyncStream { continuation in
            let id = UUID()
            continuation.yield(orders)
            orderContinuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.orderContinuations.removeValue(forKey: id)
            }
        }
    }
    
    func streamActiveOrder(userId: String) -> AsyncStream<Order?> {
        AsyncStream { continuation in
            let id = UUID()
            continuation.yield(activeOrder)
            activeOrderContinuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                self?.activeOrderContinuations.removeValue(forKey: id)
            }
        }
    }

    func updateOrderStatus(orderId: String, status: OrderStatus) async throws {
        updateOrderStatusInternal(id: orderId, status: status)
    }

    private var simulationTask: Task<Void, Never>?

    func confirmDelivery(orderId: String) async throws {
        simulationTask?.cancel()
        simulationTask = nil
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = .delivered
            orders[index].isDeliveredConfirmed = true
            if activeOrder?.id == orderId {
                activeOrder = nil
            }
            persistOrders()
            notifyOrders()
            notifyActiveOrder()
        }
    }

    func cancelOrder(orderId: String) async throws {
        simulationTask?.cancel()
        simulationTask = nil
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            orders[index].status = .cancelled
            orders[index].isDeliveredConfirmed = false
        }
        if activeOrder?.id == orderId {
            activeOrder = nil
        }
        persistOrders()
        notifyOrders()
        notifyActiveOrder()
    }

    func stopActiveOrder() async throws {
        simulationTask?.cancel()
        simulationTask = nil
        if let id = activeOrder?.id, let index = orders.firstIndex(where: { $0.id == id }) {
            orders[index].status = .delivered
            orders[index].isDeliveredConfirmed = true
        }
        activeOrder = nil
        persistOrders()
        notifyOrders()
        notifyActiveOrder()
    }
    
    private func startSimulation(for orderId: String) {
        simulationTask?.cancel()
        simulationTask = Task {
            // 1. Confirmed
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            guard !Task.isCancelled else { return }
            updateOrderStatusInternal(id: orderId, status: .confirmed)
            
            // 2. Preparing
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            guard !Task.isCancelled else { return }
            updateOrderStatusInternal(id: orderId, status: .preparing)
            
            // 3. Rider Assigned
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            guard !Task.isCancelled else { return }
            updateOrderStatusInternal(id: orderId, status: .riderAssigned)

            // 4. On the way + movement
            updateOrderStatusInternal(id: orderId, status: .onTheWay)
            
            for nodeIndex in 0..<(deliveryRoute.count - 1) {
                guard !Task.isCancelled else { return }
                let startNode = deliveryRoute[nodeIndex]
                let endNode = deliveryRoute[nodeIndex + 1]
                
                let steps = 40
                for i in 1...steps {
                    guard !Task.isCancelled else { return }
                    try? await Task.sleep(nanoseconds: 800_000_000)
                    guard !Task.isCancelled else { return }
                    let progress = Double(i) / Double(steps)
                    
                    let lat = startNode.latitude + (endNode.latitude - startNode.latitude) * progress
                    let lon = startNode.longitude + (endNode.longitude - startNode.longitude) * progress
                    
                    updateOrderLocation(id: orderId, lat: lat, lon: lon)
                }
            }
        }
    }
    
    private func updateOrderStatusInternal(id: String, status: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.id == id }) {
            orders[index].status = status
            if activeOrder?.id == id {
                activeOrder?.status = status
            }
            persistOrders()
            notifyOrders()
            notifyActiveOrder()
        }
    }
    
    private func updateOrderLocation(id: String, lat: Double, lon: Double) {
        let newLoc = Location(latitude: lat, longitude: lon)
        if let index = orders.firstIndex(where: { $0.id == id }) {
            orders[index].courierLocation = newLoc
            if activeOrder?.id == id {
                activeOrder?.courierLocation = newLoc
            }
            notifyOrders()
            notifyActiveOrder()
        }
    }

    private func persistOrders() {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func notifyOrders() {
        for c in orderContinuations.values {
            c.yield(orders)
        }
    }
    
    private func notifyActiveOrder() {
        for c in activeOrderContinuations.values {
            c.yield(activeOrder)
        }
    }
}
