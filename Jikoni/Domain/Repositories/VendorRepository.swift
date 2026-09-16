import Foundation

protocol VendorRepository {
    func fetchVendors() async throws -> [Vendor]
    func fetchVendor(id: String) async throws -> Vendor?
    func addReview(vendorId: String, review: Review) async throws
}
