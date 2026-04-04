import Foundation

struct Vendor: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let cuisine: String
    let imageUrls: [String]
    let deliveryFee: Double
    let rating: Double
    let location: Location
    var inventory: [String: [Ingredient]]?
    var reviews: [Review]?
}
