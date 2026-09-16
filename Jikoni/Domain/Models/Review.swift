import Foundation

struct Review: Identifiable, Codable, Equatable {
    let id: UUID
    let author: String
    let comment: String
    let rating: Int
    let date: Date
    var photoUrls: [String] = []
    var vendorName: String? = nil
    
    init(id: UUID = UUID(), author: String, comment: String, rating: Int, date: Date = Date(), photoUrls: [String] = [], vendorName: String? = nil) {
        self.id = id
        self.author = author
        self.comment = comment
        self.rating = rating
        self.date = date
        self.photoUrls = photoUrls
        self.vendorName = vendorName
    }
}
