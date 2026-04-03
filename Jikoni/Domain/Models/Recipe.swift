import Foundation

struct Recipe: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let author: String
    let vendorId: String
    let imageUrls: [String]
    let description: String
    let ingredients: [Ingredient]
    let instructions: [String]
    var likes: Int
    var isLikedByMe: Bool
    var comments: [Comment]
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct Comment: Identifiable, Codable, Equatable {
    let id: UUID
    let author: String
    let text: String
    let date: Date
    var replies: [Comment]
}
