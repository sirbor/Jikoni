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
    
    func placeOrder(_ order: Order) async throws {
        var newOrder = order
        newOrder.destinationLocation = userLocation
        newOrder.courierLocation = deliveryRoute.first
        orders.append(newOrder)
        activeOrder = newOrder
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
    
    private func startSimulation(for orderId: String) {
        Task {
            // 1. Preparing
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            updateOrderStatus(id: orderId, status: .preparing)
            
            // 2. Picked Up
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            updateOrderStatus(id: orderId, status: .pickedUp)
            
            // 3. Delivering + Movement through 5 Posh Districts
            updateOrderStatus(id: orderId, status: .delivering)
            
            for nodeIndex in 0..<(deliveryRoute.count - 1) {
                let startNode = deliveryRoute[nodeIndex]
                let endNode = deliveryRoute[nodeIndex + 1]
                
                let steps = 40 // More steps for smoother movement
                for i in 1...steps {
                    try? await Task.sleep(nanoseconds: 800_000_000) // Slightly faster updates
                    let progress = Double(i) / Double(steps)
                    
                    let lat = startNode.latitude + (endNode.latitude - startNode.latitude) * progress
                    let lon = startNode.longitude + (endNode.longitude - startNode.longitude) * progress
                    
                    updateOrderLocation(id: orderId, lat: lat, lon: lon)
                }
            }
            
            // 4. Completed
            updateOrderStatus(id: orderId, status: .completed)
            activeOrder = nil
            notifyActiveOrder()
        }
    }
    
    private func updateOrderStatus(id: String, status: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.id == id }) {
            orders[index].status = status
            if activeOrder?.id == id {
                activeOrder?.status = status
            }
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
