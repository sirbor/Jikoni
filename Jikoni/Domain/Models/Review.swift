import Foundation

struct Review: Identifiable, Codable, Equatable {
    let id: UUID
    let author: String
    let comment: String
    let rating: Int
    let date: Date
    
    init(id: UUID = UUID(), author: String, comment: String, rating: Int, date: Date = Date()) {
        self.id = id
        self.author = author
        self.comment = comment
        self.rating = rating
        self.date = date
    }
}
