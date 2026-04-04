import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    var displayName: String?
    var profileImageUrl: String?
    var skillLevel: String
    var dietaryGoals: [String]
    var loyaltyPoints: Int
    var cookbookIds: [String]
    var followersCount: Int
    var followingCount: Int
    var recipesCount: Int
    var averageRating: Double
    var reviews: [Review]
}
