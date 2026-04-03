import Foundation

protocol VendorRepository {
    func fetchVendors() async throws -> [Vendor]
    func fetchVendor(id: String) async throws -> Vendor?
}
