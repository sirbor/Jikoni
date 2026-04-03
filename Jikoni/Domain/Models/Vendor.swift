import Foundation

struct Vendor: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let imageUrl: String
    let deliveryFee: Double
    let rating: Double
    let location: Location
    var inventory: [String: [Ingredient]]?
}
