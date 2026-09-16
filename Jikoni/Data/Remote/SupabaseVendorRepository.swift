import Foundation
import Supabase

/// Real vendor/menu data backed by `vendors` + `menu_items`, regrouped
/// client-side into `Vendor.inventory: [String: [Ingredient]]` so no
/// downstream view code needs to change shape.
final class SupabaseVendorRepository: VendorRepository {
    private let client: SupabaseClient

    init(client: SupabaseClient = SupabaseClientProvider.shared) {
        self.client = client
    }

    func fetchVendors() async throws -> [Vendor] {
        let rows: [VendorRow] = try await client.from("vendors")
            .select("*, menu_items(*), vendor_reviews(*)")
            .execute()
            .value
        return rows.map(\.asDomain)
    }

    func fetchVendor(id: String) async throws -> Vendor? {
        let rows: [VendorRow] = try await client.from("vendors")
            .select("*, menu_items(*), vendor_reviews(*)")
            .eq("id", value: id)
            .execute()
            .value
        return rows.first?.asDomain
    }

    func addReview(vendorId: String, review: Review) async throws {
        struct NewVendorReviewRow: Encodable {
            let id: UUID
            let vendor_id: String
            let author: String
            let comment: String
            let rating: Int
            let photo_urls: [String]
        }
        let payload = NewVendorReviewRow(
            id: review.id,
            vendor_id: vendorId,
            author: review.author,
            comment: review.comment,
            rating: review.rating,
            photo_urls: review.photoUrls
        )
        try await client.from("vendor_reviews").insert(payload).execute()
    }
}

private struct MenuItemRow: Codable {
    let category: String
    let name: String
    let amount: String
    let price: Double
    let vendor_id: String
    let details: String
    let image_url: String?
    let is_available: Bool
    let nutritional_notes: String
    let dietary_tags: [String]

    var asDomain: Ingredient {
        Ingredient(name: name, amount: amount, price: price, vendorId: vendor_id, details: details, imageUrl: image_url, isAvailable: is_available, nutritionalNotes: nutritional_notes, dietaryTags: dietary_tags)
    }
}

private struct VendorReviewRow: Codable {
    let id: UUID
    let author: String
    let comment: String
    let rating: Int
    let date: Date
    let photo_urls: [String]

    var asDomain: Review {
        Review(id: id, author: author, comment: comment, rating: rating, date: date, photoUrls: photo_urls)
    }
}

private struct VendorRow: Codable {
    let id: String
    let name: String
    let cuisine: String
    let image_urls: [String]
    let delivery_fee: Double
    let rating: Double
    let latitude: Double
    let longitude: Double
    let review_count: Int
    let estimated_delivery_minutes: Int
    let minimum_order: Double
    let phone_number: String
    let hygiene_rating: String
    let opening_hours: String
    let is_open_now: Bool
    let price_range: String
    let dietary_tags: [String]
    let is_featured: Bool
    let menu_items: [MenuItemRow]?
    let vendor_reviews: [VendorReviewRow]?

    var asDomain: Vendor {
        var inventory: [String: [Ingredient]] = [:]
        for item in menu_items ?? [] {
            inventory[item.category, default: []].append(item.asDomain)
        }
        return Vendor(
            id: id,
            name: name,
            cuisine: cuisine,
            imageUrls: image_urls,
            deliveryFee: delivery_fee,
            rating: rating,
            location: Location(latitude: latitude, longitude: longitude),
            inventory: inventory,
            reviews: (vendor_reviews ?? []).map(\.asDomain),
            reviewCount: review_count,
            estimatedDeliveryMinutes: estimated_delivery_minutes,
            minimumOrder: minimum_order,
            phoneNumber: phone_number,
            hygieneRating: hygiene_rating,
            openingHours: opening_hours,
            isOpenNow: is_open_now,
            priceRange: price_range,
            dietaryTags: dietary_tags,
            isFeatured: is_featured
        )
    }
}
