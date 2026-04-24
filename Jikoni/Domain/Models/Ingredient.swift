import Foundation

struct Ingredient: Identifiable, Codable, Equatable, Hashable {
    var id: String { name }
    let name: String
    let amount: String
    let price: Double
    let vendorId: String?
    var details: String = ""
    var imageUrl: String? = nil
    var isAvailable: Bool = true
    var nutritionalNotes: String = ""
    var dietaryTags: [String] = []
}
