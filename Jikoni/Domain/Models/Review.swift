import Foundation

struct Review: Identifiable, Codable, Equatable {
    let id: UUID
    let author: String
    let comment: String
    let rating: Int
    let date: Date
    var photoUrls: [String] = []
    
    init(id: UUID = UUID(), author: String, comment: String, rating: Int, date: Date = Date(), photoUrls: [String] = []) {
        self.id = id
        self.author = author
        self.comment = comment
        self.rating = rating
        self.date = date
        self.photoUrls = photoUrls
    }
}
