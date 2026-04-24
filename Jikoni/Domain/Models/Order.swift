import Foundation

struct Order: Identifiable, Codable, Equatable {
    let id: String
    let items: [Ingredient]
    var status: OrderStatus
    var total: Double
    var courierLocation: Location?
    var destinationLocation: Location?
    var restaurantName: String = "Jikoni Partner"
    var createdAt: Date = .now
    var paymentMethod: String = "M-Pesa"
    var subtotal: Double = 0
    var serviceFee: Double = 0
    var discount: Double = 0
    var tip: Double = 0
    var receiptNotes: String = ""
    var isDeliveredConfirmed: Bool = false
}

enum OrderStatus: String, Codable, CaseIterable {
    case received
    case confirmed
    case preparing
    case riderAssigned
    case onTheWay
    case delivered
}
