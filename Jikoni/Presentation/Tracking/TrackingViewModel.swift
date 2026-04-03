import Foundation
import Observation
import MapKit
import SwiftUI

@Observable
class TrackingViewModel {
    private let repository: OrderRepository
    
    var activeOrder: Order?
    var isLoading: Bool = false
    
    var region: MKCoordinateRegion?
    
    var statusProgress: Double {
        guard let order = activeOrder else { return 0 }
        switch order.status {
        case .placed: return 0.2
        case .preparing: return 0.4
        case .pickedUp: return 0.6
        case .delivering: return 0.8
        case .completed: return 1.0
        }
    }
    
    init(repository: OrderRepository) {
        self.repository = repository
    }
    
    func startTracking() async {
        isLoading = true
        let userId = "current-user" 
        
        for await order in repository.streamActiveOrder(userId: userId) {
            self.activeOrder = order
            self.isLoading = false
            
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
}
