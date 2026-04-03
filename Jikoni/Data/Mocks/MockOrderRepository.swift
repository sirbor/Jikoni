import Foundation

class MockOrderRepository: OrderRepository {
    private var orders: [Order] = []
    private var activeOrder: Order?
    
    private var orderContinuations: [UUID: AsyncStream<[Order]>.Continuation] = [:]
    private var activeOrderContinuations: [UUID: AsyncStream<Order?>.Continuation] = [:]
    
    // Default destination (user location simulation - Central Nairobi)
    private let userLocation = Location(latitude: -1.2921, longitude: 36.8219)
    // Start location for rider (Westlands area)
    private let riderStartLocation = Location(latitude: -1.2661, longitude: 36.8049)
    
    func placeOrder(_ order: Order) async throws {
        var newOrder = order
        newOrder.destinationLocation = userLocation
        newOrder.courierLocation = riderStartLocation
        orders.append(newOrder)
        activeOrder = newOrder
        notifyOrders()
        notifyActiveOrder()
        
        // Start detailed simulation
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
            // 1. Preparing (5 seconds)
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            updateOrderStatus(id: orderId, status: .preparing)
            
            // 2. Picked Up (5 seconds)
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            updateOrderStatus(id: orderId, status: .pickedUp)
            
            // 3. Delivering + Movement (Approx 4.5 minutes)
            updateOrderStatus(id: orderId, status: .delivering)
            
            let steps = 135 // 135 steps, 2 seconds each = 270 seconds (4.5 mins)
            for i in 1...steps {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                let progress = Double(i) / Double(steps)
                
                let lat = riderStartLocation.latitude + (userLocation.latitude - riderStartLocation.latitude) * progress
                let lon = riderStartLocation.longitude + (userLocation.longitude - riderStartLocation.longitude) * progress
                
                updateOrderLocation(id: orderId, lat: lat, lon: lon)
            }
            
            // 4. Completed
            try? await Task.sleep(nanoseconds: 2_000_000_000)
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
