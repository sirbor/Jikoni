import Foundation

class MockAuthRepository: AuthRepository {
    var currentUser: User? = nil
    private let seedUser: User = User(
        id: "user-123",
        displayName: "Chef Jikoni",
        email: "chef@jikoni.com",
        phoneNumber: "+254 700 123 456",
        profileBio: "I love discovering bold African flavors and quick gourmet delivery options.",
        skillLevel: "Executive Chef",
        dietaryGoals: ["Healthy", "Organic"],
        loyaltyPoints: 1250,
        cookbookIds: ["r-1", "r-3", "r-6"],
        followersCount: 1540,
        followingCount: 320,
        recipesCount: 24,
        averageRating: 4.9,
        reviews: [],
        membershipTier: .gold,
        memberSince: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5)) ?? .now,
        favoriteCuisines: ["Swahili", "Italian", "Japanese"],
        addresses: [
            SavedAddress(
                id: "addr-1",
                label: "Home",
                line1: "123 Chef Street",
                line2: "Lavington",
                city: "Nairobi",
                deliveryNotes: "Call when at the gate",
                isDefault: true
            ),
            SavedAddress(
                id: "addr-2",
                label: "Office",
                line1: "Jikoni HQ",
                line2: "Westlands",
                city: "Nairobi",
                deliveryNotes: "Deliver at reception",
                isDefault: false
            )
        ],
        paymentMethods: [
            PaymentMethod(
                id: "pm-1",
                brand: "Visa",
                lastFour: "1234",
                expiry: "12/27",
                holderName: "Chef Jikoni",
                isDefault: true
            ),
            PaymentMethod(
                id: "pm-2",
                brand: "Mastercard",
                lastFour: "9876",
                expiry: "08/26",
                holderName: "Chef Jikoni",
                isDefault: false
            )
        ],
        preferredContact: .email,
        allowsPushNotifications: true,
        allowsPromotionalEmails: true
    )
    
    func signIn(email: String) async throws -> User {
        var signedIn = seedUser
        signedIn.email = email
        if signedIn.displayName == nil || signedIn.displayName?.isEmpty == true {
            signedIn.displayName = email.components(separatedBy: "@").first?.capitalized
        }
        currentUser = signedIn
        return signedIn
    }
    
    func signOut() async throws {
        // Keeping it for protocol satisfaction, but we won't show the screen
        currentUser = nil
    }
    
    func updateUser(_ user: User) async throws {
        currentUser = user
    }
}
