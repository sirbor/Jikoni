import Foundation
import Observation
import MapKit
import SwiftUI

@Observable
class TrackingViewModel {
    private let repository: OrderRepository
    
    var activeOrder: Order?
    var pastOrders: [Order] = []
    var isLoading: Bool = false
    
    var region: MKCoordinateRegion?
    
    var statusProgress: Double {
        guard let order = activeOrder else { return 0 }
        switch order.status {
        case .received: return 0.15
        case .confirmed: return 0.3
        case .preparing: return 0.5
        case .riderAssigned: return 0.7
        case .onTheWay: return 0.9
        case .delivered, .cancelled: return 1.0
        }
    }
    
    init(repository: OrderRepository) {
        self.repository = repository
    }

    @MainActor
    func trackOrder(_ order: Order) {
        self.activeOrder = order
        if let courier = order.courierLocation {
            withAnimation(.easeInOut) {
                self.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: courier.latitude, longitude: courier.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
    }

    @MainActor
    func fetchOrderHistory(userId: String?) async {
        let effectiveUserId = userId ?? "user-guest"
        do {
            let fetched = try await repository.fetchOrders(userId: effectiveUserId)
            self.pastOrders = fetched.sorted(by: { $0.createdAt > $1.createdAt })
        } catch {
            print("Error fetching order history for tracking: \(error)")
        }
    }

    /// Streams the active order for the current user (or guest fallback).
    func startTracking(userId: String?) async {
        let effectiveUserId = userId ?? "user-guest"
        isLoading = true
        await fetchOrderHistory(userId: effectiveUserId)

        for await order in repository.streamActiveOrder(userId: effectiveUserId) {
            self.activeOrder = order
            self.isLoading = false
            await fetchOrderHistory(userId: effectiveUserId)

            // Auto-center map on rider
            if let courier = order?.courierLocation {
                withAnimation(.easeInOut) {
                    self.region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: courier.latitude, longitude: courier.longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                }
            }
        }
    }

    @MainActor
    func startDemoOrder(userId: String? = nil) async {
        let demoOrder = Order(
            id: "jk-\(Int.random(in: 1000...9999))",
            userId: userId ?? "user-guest",
            items: [
                Ingredient(name: "Swahili Goat Soup", amount: "1 Bowl", price: 450.0, vendorId: "v-1"),
                Ingredient(name: "Traditional Beef Pilau", amount: "1 portion", price: 750.0, vendorId: "v-1")
            ],
            status: .received,
            total: 1320.0,
            courierLocation: Location(latitude: -1.2524, longitude: 36.8223),
            destinationLocation: Location(latitude: -1.2724, longitude: 36.7723),
            restaurantName: "Mama Juma's African Kitchen",
            createdAt: .now,
            paymentMethod: "M-Pesa STK Push",
            subtotal: 1200.0,
            serviceFee: 120.0,
            receiptNotes: "Ring bell at front gate",
            isDeliveredConfirmed: false
        )
        try? await repository.placeOrder(demoOrder)
    }

    @MainActor
    func stopActiveOrder() async {
        do {
            try await repository.stopActiveOrder()
            activeOrder = nil
        } catch {
            print("Error stopping active order: \(error)")
            activeOrder = nil
        }
    }

    @MainActor
    func cancelActiveOrder() async {
        guard let orderId = activeOrder?.id else {
            activeOrder = nil
            return
        }
        do {
            try await repository.cancelOrder(orderId: orderId)
            activeOrder = nil
        } catch {
            print("Error cancelling active order: \(error)")
            activeOrder = nil
        }
    }

    @MainActor
    func confirmDelivery() async {
        guard let orderId = activeOrder?.id else { return }
        do {
            try await repository.confirmDelivery(orderId: orderId)
            activeOrder = nil
        } catch {
            print("Error confirming delivery: \(error)")
            activeOrder = nil
        }
    }
}
