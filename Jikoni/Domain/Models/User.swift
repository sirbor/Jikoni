import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: String
    var displayName: String? = nil
    var email: String = ""
    var phoneNumber: String? = nil
    var profileImageUrl: String? = nil
    var profileBio: String = ""
    var skillLevel: String = "Home Cook"
    var dietaryGoals: [String] = []
    var loyaltyPoints: Int = 0
    var cookbookIds: [String] = []
    var followersCount: Int = 0
    var followingCount: Int = 0
    var recipesCount: Int = 0
    var averageRating: Double = 0
    var reviews: [Review] = []
    var membershipTier: MembershipTier = .bronze
    var memberSince: Date = .now
    var favoriteCuisines: [String] = []
    var addresses: [SavedAddress] = []
    var paymentMethods: [PaymentMethod] = []
    var preferredContact: PreferredContact = .email
    var allowsPushNotifications: Bool = true
    var allowsPromotionalEmails: Bool = true
}

enum MembershipTier: String, Codable, CaseIterable {
    case bronze
    case silver
    case gold
    case platinum
}

enum PreferredContact: String, Codable, CaseIterable {
    case phone
    case email
    case sms
}

struct SavedAddress: Identifiable, Codable, Equatable {
    let id: String
    var label: String
    var line1: String
    var line2: String?
    var city: String
    var deliveryNotes: String
    var isDefault: Bool
}

struct PaymentMethod: Identifiable, Codable, Equatable {
    let id: String
    var brand: String
    var lastFour: String
    var expiry: String
    var holderName: String
    var isDefault: Bool
}
