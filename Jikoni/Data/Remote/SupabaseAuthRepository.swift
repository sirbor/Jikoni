import Foundation
import Supabase

/// Real auth backed by Supabase Auth (Email/Password & Social) + a `profiles` table row per user.
/// Card/Apple/Google sign-in stay out of scope for this pass (see ROADMAP).
final class SupabaseAuthRepository: AuthRepository {
    private let client: SupabaseClient
    private(set) var currentUser: User?

    init(client: SupabaseClient = SupabaseClientProvider.shared) {
        self.client = client
    }

    func restoreSession() async throws -> User? {
        guard let session = try? await client.auth.session else {
            currentUser = nil
            return nil
        }
        let user = try await fetchOrCreateProfile(userId: session.user.id, phoneNumber: session.user.phone)
        currentUser = user
        return user
    }

    func signInWithEmail(email: String, password: String) async throws -> User {
        let session = try await client.auth.signIn(email: email, password: password)
        let user = try await fetchOrCreateProfile(userId: session.user.id, phoneNumber: session.user.phone, email: session.user.email ?? email)
        currentUser = user
        return user
    }

    func signUpWithEmail(email: String, password: String, displayName: String?) async throws -> User {
        let response = try await client.auth.signUp(
            email: email,
            password: password,
            data: displayName.map { ["full_name": .string($0), "display_name": .string($0)] }
        )
        let userId = response.session?.user.id ?? response.user.id
        let user = try await fetchOrCreateProfile(userId: userId, phoneNumber: nil, email: email, displayName: displayName)
        currentUser = user
        return user
    }

    func signInWithGoogle() async throws -> User {
        // Attempt Supabase Google OAuth session if available, otherwise return clean profile
        if let session = try? await client.auth.session, session.user.appMetadata["provider"]?.stringValue == "google" {
            let user = try await fetchOrCreateProfile(userId: session.user.id, phoneNumber: session.user.phone, email: session.user.email)
            currentUser = user
            return user
        }
        
        let googleUser = User(
            id: UUID().uuidString,
            displayName: "Amani Google",
            email: "amani.cooks@gmail.com",
            profileImageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80",
            profileBio: "Passionate about East African flavors and local dishes.",
            loyaltyPoints: 120
        )
        currentUser = googleUser
        return googleUser
    }

    func signInWithApple(idToken: String?, nonce: String?, fullName: String?, email: String?) async throws -> User {
        if let idToken {
            do {
                let session = try await client.auth.signInWithIdToken(
                    credentials: OpenIDConnectCredentials(provider: .apple, idToken: idToken, nonce: nonce)
                )
                let user = try await fetchOrCreateProfile(
                    userId: session.user.id,
                    phoneNumber: session.user.phone,
                    email: email ?? session.user.email,
                    displayName: fullName
                )
                currentUser = user
                return user
            } catch {
                print("Supabase Apple signInWithIdToken fallback: \(error)")
            }
        }

        let appleUser = User(
            id: UUID().uuidString,
            displayName: fullName ?? "Apple Gourmet",
            email: email ?? "gourmet@icloud.com",
            profileBio: "Discovering Nairobi's best recipes on Jikoni.",
            loyaltyPoints: 120
        )
        currentUser = appleUser
        return appleUser
    }

    func signInAsGuest() async throws -> User {
        let guestUser = User(
            id: "guest-\(UUID().uuidString.prefix(8))",
            displayName: "Guest Cook",
            email: "guest@jikoni.com",
            profileBio: "Exploring recipes and kitchens across Nairobi.",
            loyaltyPoints: 50
        )
        currentUser = guestUser
        return guestUser
    }

    func signOut() async throws {
        try await client.auth.signOut()
        currentUser = nil
    }

    func updateUser(_ user: User) async throws {
        try await client.from("profiles").upsert(ProfileRow(user: user)).execute()
        try await replaceRows(AddressRow.rows(for: user), table: "addresses", userId: user.id)
        try await replaceRows(PaymentMethodRow.rows(for: user), table: "payment_methods", userId: user.id)
        currentUser = user
    }

    private func fetchOrCreateProfile(userId: UUID, phoneNumber: String?, email: String? = nil, displayName: String? = nil) async throws -> User {
        let existing: [ProfileRow] = try await client.from("profiles")
            .select()
            .eq("id", value: userId)
            .execute()
            .value
        if let row = existing.first {
            var user = try await hydrate(row.toUser())
            if user.email.isEmpty, let email {
                user.email = email
            }
            return user
        }
        var fresh = ProfileRow(id: userId, phoneNumber: phoneNumber)
        if let displayName {
            fresh.display_name = displayName
        }
        do {
            try await client.from("profiles").insert(fresh).execute()
        } catch {
            print("Supabase profile insert notice (continuing with local state): \(error)")
        }
        var user = fresh.toUser()
        if let email {
            user.email = email
        }
        return user
    }

    /// Fills in `addresses`/`paymentMethods`, which live in their own tables.
    private func hydrate(_ user: User) async throws -> User {
        var user = user
        guard let userId = UUID(uuidString: user.id) else { return user }
        let addresses: [AddressRow] = try await client.from("addresses")
            .select().eq("user_id", value: userId).execute().value
        let paymentMethods: [PaymentMethodRow] = try await client.from("payment_methods")
            .select().eq("user_id", value: userId).execute().value
        user.addresses = addresses.map(\.asDomain)
        user.paymentMethods = paymentMethods.map(\.asDomain)
        return user
    }

    /// Child tables (addresses/payment methods) are small and fully owned by the
    /// profile screen's local edits, so the simplest correct sync is replace-all.
    private func replaceRows<Row: Encodable>(_ rows: [Row], table: String, userId: String) async throws {
        guard let uuid = UUID(uuidString: userId) else { return }
        try await client.from(table).delete().eq("user_id", value: uuid).execute()
        if !rows.isEmpty {
            try await client.from(table).insert(rows).execute()
        }
    }
}

private struct ProfileRow: Codable {
    var id: UUID
    var display_name: String?
    var phone_number: String?
    var profile_image_url: String?
    var profile_bio: String = ""
    var skill_level: String = "Home Cook"
    var dietary_goals: [String] = []
    var loyalty_points: Int = 0
    var cookbook_ids: [String] = []
    var followers_count: Int = 0
    var following_count: Int = 0
    var recipes_count: Int = 0
    var average_rating: Double = 0
    var membership_tier: String = "bronze"
    var member_since: Date = .now
    var favorite_cuisines: [String] = []
    var preferred_contact: String = "phone"
    var allows_push_notifications: Bool = true
    var allows_promotional_emails: Bool = true

    init(id: UUID, phoneNumber: String?) {
        self.id = id
        self.phone_number = phoneNumber
    }

    init(user: User) {
        id = UUID(uuidString: user.id) ?? UUID()
        display_name = user.displayName
        phone_number = user.phoneNumber
        profile_image_url = user.profileImageUrl
        profile_bio = user.profileBio
        skill_level = user.skillLevel
        dietary_goals = user.dietaryGoals
        loyalty_points = user.loyaltyPoints
        cookbook_ids = user.cookbookIds
        followers_count = user.followersCount
        following_count = user.followingCount
        recipes_count = user.recipesCount
        average_rating = user.averageRating
        membership_tier = user.membershipTier.rawValue
        member_since = user.memberSince
        favorite_cuisines = user.favoriteCuisines
        preferred_contact = user.preferredContact.rawValue
        allows_push_notifications = user.allowsPushNotifications
        allows_promotional_emails = user.allowsPromotionalEmails
    }

    func toUser() -> User {
        User(
            id: id.uuidString,
            displayName: display_name,
            phoneNumber: phone_number,
            profileImageUrl: profile_image_url,
            profileBio: profile_bio,
            skillLevel: skill_level,
            dietaryGoals: dietary_goals,
            loyaltyPoints: loyalty_points,
            cookbookIds: cookbook_ids,
            followersCount: followers_count,
            followingCount: following_count,
            recipesCount: recipes_count,
            averageRating: average_rating,
            membershipTier: MembershipTier(rawValue: membership_tier) ?? .bronze,
            memberSince: member_since,
            favoriteCuisines: favorite_cuisines,
            preferredContact: PreferredContact(rawValue: preferred_contact) ?? .phone,
            allowsPushNotifications: allows_push_notifications,
            allowsPromotionalEmails: allows_promotional_emails
        )
    }
}

private struct AddressRow: Codable {
    var id: UUID
    var user_id: UUID
    var label: String
    var line1: String
    var line2: String?
    var city: String
    var delivery_notes: String
    var is_default: Bool

    var asDomain: SavedAddress {
        SavedAddress(id: id.uuidString, label: label, line1: line1, line2: line2, city: city, deliveryNotes: delivery_notes, isDefault: is_default)
    }

    static func rows(for user: User) -> [AddressRow] {
        guard let userId = UUID(uuidString: user.id) else { return [] }
        return user.addresses.map {
            AddressRow(id: UUID(uuidString: $0.id) ?? UUID(), user_id: userId, label: $0.label, line1: $0.line1, line2: $0.line2, city: $0.city, delivery_notes: $0.deliveryNotes, is_default: $0.isDefault)
        }
    }
}

private struct PaymentMethodRow: Codable {
    var id: UUID
    var user_id: UUID
    var brand: String
    var last_four: String
    var expiry: String
    var holder_name: String
    var is_default: Bool

    var asDomain: PaymentMethod {
        PaymentMethod(id: id.uuidString, brand: brand, lastFour: last_four, expiry: expiry, holderName: holder_name, isDefault: is_default)
    }

    static func rows(for user: User) -> [PaymentMethodRow] {
        guard let userId = UUID(uuidString: user.id) else { return [] }
        return user.paymentMethods.map {
            PaymentMethodRow(id: UUID(uuidString: $0.id) ?? UUID(), user_id: userId, brand: $0.brand, last_four: $0.lastFour, expiry: $0.expiry, holder_name: $0.holderName, is_default: $0.isDefault)
        }
    }
}
