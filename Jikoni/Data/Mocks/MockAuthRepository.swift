import Foundation

struct MockAccount: Codable {
    var user: User
    var password: String
}

class MockAuthRepository: AuthRepository {
    var currentUser: User? = nil
    
    private var accounts: [String: MockAccount] = [:]
    private let userDefaultsSessionKey = "jikoni_mock_session_user"
    private let userDefaultsAccountsKey = "jikoni_mock_registered_accounts"

    // MARK: - Pre-populated Test Accounts
    static let testChefUser = User(
        id: "user-chef-01",
        displayName: "Amani Mwangi",
        email: "chef@jikoni.com",
        phoneNumber: "+254 700 123 456",
        profileImageUrl: "https://images.unsplash.com/photo-1577219491135-ce391730fb2c?auto=format&fit=crop&w=400&q=80",
        profileBio: "Executive Chef & Culinary Curator at Jikoni. Exploring Coastal Swahili traditions and contemporary East African street gastronomy.",
        skillLevel: "Executive Chef",
        dietaryGoals: ["Healthy", "Organic", "Swahili Special"],
        loyaltyPoints: 1250,
        cookbookIds: ["r-1", "r-3", "r-6"],
        followersCount: 1540,
        followingCount: 320,
        recipesCount: 24,
        averageRating: 4.9,
        reviews: [],
        membershipTier: .gold,
        memberSince: Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5)) ?? .now,
        favoriteCuisines: ["Swahili", "Italian", "Ethiopian"],
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
                label: "Kitchen",
                line1: "Jikoni Kitchens HQ",
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
                holderName: "Amani Mwangi",
                isDefault: true
            ),
            PaymentMethod(
                id: "pm-2",
                brand: "Mastercard",
                lastFour: "9876",
                expiry: "08/26",
                holderName: "Amani Mwangi",
                isDefault: false
            )
        ],
        preferredContact: .email,
        allowsPushNotifications: true,
        allowsPromotionalEmails: true
    )

    static let testHomeCookUser = User(
        id: "user-homecook-02",
        displayName: "Wambui Kamau",
        email: "wambui@jikoni.com",
        phoneNumber: "+254 711 987 654",
        profileImageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80",
        profileBio: "Home cook, food lover, and Sunday family dinner specialist in Kilimani. Obsessed with hearty stews, fresh market ingredients, and quick weeknight meals.",
        skillLevel: "Home Cook",
        dietaryGoals: ["Quick Meals", "Plant-based"],
        loyaltyPoints: 450,
        cookbookIds: ["r-2", "r-4"],
        followersCount: 340,
        followingCount: 180,
        recipesCount: 8,
        averageRating: 4.8,
        reviews: [],
        membershipTier: .silver,
        memberSince: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 15)) ?? .now,
        favoriteCuisines: ["Kenyan", "Quick Meals", "Coastal"],
        addresses: [
            SavedAddress(
                id: "addr-3",
                label: "Home",
                line1: "45 Acacia Grove",
                line2: "Kilimani",
                city: "Nairobi",
                deliveryNotes: "Leave at apartment reception 4B",
                isDefault: true
            )
        ],
        paymentMethods: [
            PaymentMethod(
                id: "pm-3",
                brand: "Mastercard",
                lastFour: "5432",
                expiry: "05/28",
                holderName: "Wambui Kamau",
                isDefault: true
            )
        ],
        preferredContact: .phone,
        allowsPushNotifications: true,
        allowsPromotionalEmails: false
    )

    init() {
        loadPersistedAccounts()
        ensureSeedAccounts()
        restorePersistedSession()
    }

    private func normalize(_ key: String) -> String {
        key.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func loadPersistedAccounts() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsAccountsKey),
           let saved = try? JSONDecoder().decode([String: MockAccount].self, from: data) {
            self.accounts = saved
        }
    }

    private func persistAccounts() {
        if let data = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(data, forKey: userDefaultsAccountsKey)
        }
    }

    private func ensureSeedAccounts() {
        // Account 1: Chef Amani Mwangi
        let chefAccount = MockAccount(
            user: Self.testChefUser,
            password: "Password123!"
        )
        accounts[normalize(Self.testChefUser.email)] = chefAccount
        if let phone = Self.testChefUser.phoneNumber {
            accounts[normalize(phone)] = chefAccount
        }

        // Account 2: Home Cook Wambui Kamau
        let homeCookAccount = MockAccount(
            user: Self.testHomeCookUser,
            password: "Password123!"
        )
        accounts[normalize(Self.testHomeCookUser.email)] = homeCookAccount
        if let phone = Self.testHomeCookUser.phoneNumber {
            accounts[normalize(phone)] = homeCookAccount
        }

        persistAccounts()
    }

    private func restorePersistedSession() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsSessionKey),
           let saved = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = saved
        }
    }

    private func persistSession() {
        if let user = currentUser, let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsSessionKey)
        } else {
            UserDefaults.standard.removeObject(forKey: userDefaultsSessionKey)
        }
    }

    func restoreSession() async throws -> User? {
        restorePersistedSession()
        return currentUser
    }

    func signInWithEmail(email: String, password: String) async throws -> User {
        let cleanEmail = normalize(email)
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let account = accounts[cleanEmail] else {
            throw NSError(
                domain: "AuthError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "No account found for '\(email)'. Tap 'Sign Up' above to create a new account."]
            )
        }

        // Validate password (supports Password123! or custom password)
        if account.password != cleanPassword && cleanPassword != "Password123!" && cleanPassword != "password123" {
            throw NSError(
                domain: "AuthError",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Incorrect password. Try 'Password123!' or tap test account fill."]
            )
        }

        currentUser = account.user
        persistSession()
        return account.user
    }

    func signUpWithEmail(email: String, password: String, displayName: String?) async throws -> User {
        let cleanEmail = normalize(email)
        guard cleanEmail.contains("@") && cleanEmail.contains(".") else {
            throw NSError(domain: "AuthError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Please enter a valid email address."])
        }

        guard password.count >= 6 else {
            throw NSError(domain: "AuthError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Password must be at least 6 characters long."])
        }

        if accounts[cleanEmail] != nil {
            throw NSError(domain: "AuthError", code: 409, userInfo: [NSLocalizedDescriptionKey: "An account with '\(email)' already exists. Please sign in instead."])
        }

        let cleanName = (displayName?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
            ? displayName!.trimmingCharacters(in: .whitespacesAndNewlines)
            : (cleanEmail.split(separator: "@").first.map { String($0).capitalized } ?? "New Cook")

        let newId = "user-\(UUID().uuidString.prefix(8).lowercased())"
        let newUser = User(
            id: newId,
            displayName: cleanName,
            email: cleanEmail,
            phoneNumber: nil,
            profileBio: "Passionate cook and food lover at Jikoni.",
            skillLevel: "Home Cook",
            dietaryGoals: ["Healthy", "Quick Meals"],
            loyaltyPoints: 100, // 100 welcome bonus points
            cookbookIds: [],
            followersCount: 0,
            followingCount: 0,
            recipesCount: 0,
            averageRating: 5.0,
            reviews: [],
            membershipTier: .bronze,
            memberSince: .now,
            favoriteCuisines: ["Swahili", "Kenyan"],
            addresses: [
                SavedAddress(
                    id: UUID().uuidString,
                    label: "Home",
                    line1: "Nairobi",
                    line2: nil,
                    city: "Nairobi",
                    deliveryNotes: "",
                    isDefault: true
                )
            ],
            paymentMethods: [
                PaymentMethod(
                    id: UUID().uuidString,
                    brand: "M-Pesa",
                    lastFour: "0000",
                    expiry: "N/A",
                    holderName: cleanName,
                    isDefault: true
                )
            ]
        )

        let account = MockAccount(user: newUser, password: password)
        accounts[cleanEmail] = account
        persistAccounts()

        currentUser = newUser
        persistSession()
        return newUser
    }

    func signInWithGoogle() async throws -> User {
        let user = Self.testChefUser
        currentUser = user
        persistSession()
        return user
    }

    func signInWithApple(idToken: String?, nonce: String?, fullName: String?, email: String?) async throws -> User {
        let user = Self.testHomeCookUser
        currentUser = user
        persistSession()
        return user
    }

    func signInAsGuest() async throws -> User {
        var user = Self.testHomeCookUser
        user.id = "guest-\(Int.random(in: 1000...9999))"
        user.displayName = "Guest Cook"
        user.email = "guest@jikoni.com"
        currentUser = user
        persistSession()
        return user
    }
    
    func signOut() async throws {
        currentUser = nil
        persistSession()
    }
    
    func updateUser(_ user: User) async throws {
        currentUser = user
        let cleanEmail = normalize(user.email)
        if var account = accounts[cleanEmail] {
            account.user = user
            accounts[cleanEmail] = account
            persistAccounts()
        }
        persistSession()
    }
}
