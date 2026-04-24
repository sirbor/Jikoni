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
    var reviewCount: Int = 0
    var estimatedDeliveryMinutes: Int = 35
    var minimumOrder: Double = 500
    var phoneNumber: String = "+254700000000"
    var hygieneRating: String = "A"
    var openingHours: String = "08:00 - 23:00"
    var isOpenNow: Bool = true
    var priceRange: String = "$$"
    var dietaryTags: [String] = ["Halal", "Vegan", "Gluten-Free"]
    var isFeatured: Bool = false
}
