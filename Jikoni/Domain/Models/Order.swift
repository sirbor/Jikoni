import Foundation

struct Order: Identifiable, Codable, Equatable {
    let id: String
    let items: [Ingredient]
    var status: OrderStatus
    var total: Double
    var courierLocation: Location?
    var destinationLocation: Location?
}

enum OrderStatus: String, Codable, CaseIterable {
    case placed
    case preparing
    case pickedUp
    case delivering
    case completed
}
