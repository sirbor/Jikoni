import Foundation
import Observation

@Observable
class HubViewModel {
    private let authRepository: AuthRepository
    private let orderRepository: OrderRepository
    private let recipeRepository: RecipeRepository?
    private let vendorRepository: VendorRepository?
    
    var orders: [Order] = []
    var userRecipes: [Recipe] = []
    var userReviews: [Review] = []
    var isLoading: Bool = false
    var rewardCode: String?
    var requestedReturnOrderIds: Set<String> = []
    var lastSupportMessage: String?
    var sessionUser: User?
    
    var currentUser: User? {
        sessionUser
    }
    
    init(
        authRepository: AuthRepository,
        orderRepository: OrderRepository,
        recipeRepository: RecipeRepository? = nil,
        vendorRepository: VendorRepository? = nil
    ) {
        self.authRepository = authRepository
        self.orderRepository = orderRepository
        self.recipeRepository = recipeRepository
        self.vendorRepository = vendorRepository
        self.sessionUser = authRepository.currentUser
    }

    @MainActor
    func restoreSession() async {
        do {
            sessionUser = try await authRepository.restoreSession()
        } catch {
            print("Error restoring session: \(error)")
        }
    }
    
    func startObserving() {
        Task {
            await observeOrders()
        }
    }
    
    @MainActor
    private func observeOrders() async {
        // Continuous observation loop
        while true {
            if let userId = currentUser?.id {
                for await updatedOrders in orderRepository.streamOrders(userId: userId) {
                    self.orders = updatedOrders.sorted(by: { $0.id > $1.id })
                    // If user logged out during streaming, break to re-evaluate
                    if currentUser == nil { break }
                }
            }
            // Wait a bit before checking for user again if not logged in
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
        }
    }
    
    func fetchOrders() async {
        guard let userId = currentUser?.id else { return }
        isLoading = true
        do {
            orders = try await orderRepository.fetchOrders(userId: userId)
        } catch {
            print("Error fetching orders: \(error)")
        }
        isLoading = false
    }

    @MainActor
    func fetchProfileDetails() async {
        guard let user = currentUser else { return }
        await fetchOrders()

        // Fetch user recipes
        if let recipeRepo = recipeRepository {
            do {
                let allRecipes = try await recipeRepo.fetchRecipes()
                let name = user.displayName?.lowercased() ?? ""
                let matching = allRecipes.filter { rec in
                    let a = rec.author.lowercased()
                    return a.contains(name) ||
                        (name.contains("mama") && a.contains("mama")) ||
                        (name.contains("hassan") && a.contains("hassan")) ||
                        (name.contains("wanjiku") && a.contains("wanjiku")) ||
                        (name.contains("omondi") && a.contains("omondi"))
                }
                self.userRecipes = matching.isEmpty ? Array(allRecipes.prefix(3)) : matching
            } catch {
                print("Error fetching user recipes: \(error)")
            }
        }

        // Fetch user reviews
        if let vendorRepo = vendorRepository {
            do {
                let vendors = try await vendorRepo.fetchVendors()
                let name = user.displayName?.lowercased() ?? ""
                var foundReviews: [Review] = []
                for v in vendors {
                    if let revs = v.reviews {
                        for r in revs {
                            let ra = r.author.lowercased()
                            let rc = r.comment.lowercased()
                            if ra.contains(name) ||
                               (name.contains("mama") && (v.id == "v-1" || rc.contains("mama"))) ||
                               (name.contains("hassan") && (v.id == "v-2" || rc.contains("biryani"))) {
                                var rev = r
                                rev.vendorName = v.name
                                foundReviews.append(rev)
                            }
                        }
                    }
                }
                if foundReviews.isEmpty {
                    if name.contains("omondi") {
                        foundReviews = [
                            Review(author: "Kevin Omondi", comment: "Charcoal grilled goat ribs were sensational! Arrived hot and succulent.", rating: 5, vendorName: "The Carnivore Nairobi"),
                            Review(author: "Kevin Omondi", comment: "The coconut fish curry is pure magic. Great Swahili spices.", rating: 5, vendorName: "Mama Juma's African Kitchen")
                        ]
                    } else if name.contains("wanjiku") {
                        foundReviews = [
                            Review(author: "Wanjiku Mwangi", comment: "Traditional beef pilau cooked to perfection! Rich whole spices.", rating: 5, vendorName: "Mama Juma's African Kitchen"),
                            Review(author: "Wanjiku Mwangi", comment: "Authentic coastal chicken biryani. Loved the aroma and packaging.", rating: 5, vendorName: "Swahili Plate")
                        ]
                    } else if name.contains("mama") {
                        foundReviews = [
                            Review(author: "Wanjiku Mwangi", comment: "Traditional beef pilau cooked to perfection! Rich whole spices.", rating: 5, vendorName: "Mama Juma's African Kitchen"),
                            Review(author: "Kevin Omondi", comment: "The coconut fish curry is pure magic. Great Swahili spices.", rating: 5, vendorName: "Mama Juma's African Kitchen")
                        ]
                    } else if name.contains("hassan") {
                        foundReviews = [
                            Review(author: "Wanjiku Mwangi", comment: "Authentic coastal chicken biryani. Loved the aroma and packaging.", rating: 5, vendorName: "Swahili Plate"),
                            Review(author: "James Kariuki", comment: "Best samosas and biryani in Nairobi. Fresh ingredients.", rating: 5, vendorName: "Swahili Plate")
                        ]
                    }
                }
                self.userReviews = foundReviews
            } catch {
                print("Error fetching user reviews: \(error)")
            }
        }
    }
    
    /// Completes profile setup for a newly registered session.
    /// A no-op if nothing is signed in yet.
    func register(name: String, skillLevel: String, dietaryGoals: [String]) async {
        guard var user = sessionUser else { return }
        isLoading = true
        user.displayName = name
        user.skillLevel = skillLevel
        user.dietaryGoals = dietaryGoals
        user.loyaltyPoints += 100 // Welcome bonus
        do {
            try await authRepository.updateUser(user)
            sessionUser = user
        } catch {
            print("Error registering: \(error)")
        }
        isLoading = false
    }

    var authErrorMessage: String?

    @MainActor
    func signInWithEmail(email: String, password: String) async -> Bool {
        isLoading = true
        authErrorMessage = nil
        do {
            let user = try await authRepository.signInWithEmail(email: email, password: password)
            sessionUser = user
            isLoading = false
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            print("Error signing in with email: \(error)")
            isLoading = false
            return false
        }
    }

    @MainActor
    func signUpWithEmail(email: String, password: String, displayName: String?) async -> Bool {
        isLoading = true
        authErrorMessage = nil
        do {
            let user = try await authRepository.signUpWithEmail(email: email, password: password, displayName: displayName)
            sessionUser = user
            isLoading = false
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            print("Error signing up with email: \(error)")
            isLoading = false
            return false
        }
    }

    @MainActor
    func signInWithGoogle() async -> Bool {
        isLoading = true
        authErrorMessage = nil
        do {
            let user = try await authRepository.signInWithGoogle()
            sessionUser = user
            isLoading = false
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            print("Error signing in with Google: \(error)")
            isLoading = false
            return false
        }
    }

    @MainActor
    func signInWithApple(idToken: String? = nil, nonce: String? = nil, fullName: String? = nil, email: String? = nil) async -> Bool {
        isLoading = true
        authErrorMessage = nil
        do {
            let user = try await authRepository.signInWithApple(idToken: idToken, nonce: nonce, fullName: fullName, email: email)
            sessionUser = user
            isLoading = false
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            print("Error signing in with Apple: \(error)")
            isLoading = false
            return false
        }
    }

    @MainActor
    func signInAsGuest() async -> Bool {
        isLoading = true
        authErrorMessage = nil
        do {
            let user = try await authRepository.signInAsGuest()
            sessionUser = user
            isLoading = false
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            print("Error signing in as guest: \(error)")
            isLoading = false
            return false
        }
    }
    
    @MainActor
    func signOut() async {
        do {
            try await authRepository.signOut()
            sessionUser = nil
            rewardCode = nil
            orders = []
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    @MainActor
    func updateProfile(_ user: User) async {
        do {
            try await authRepository.updateUser(user)
            sessionUser = user
        } catch {
            print("Error updating profile: \(error)")
        }
    }

    @MainActor
    func updateCurrentUser(_ mutate: (inout User) -> Void) async {
        guard var user = currentUser else { return }
        mutate(&user)
        await updateProfile(user)
    }
    
    @MainActor
    func toggleSavedRecipe(_ recipeId: String) {
        guard var user = currentUser else { return }
        if user.cookbookIds.contains(recipeId) {
            user.cookbookIds.removeAll { $0 == recipeId }
        } else {
            user.cookbookIds.append(recipeId)
        }
        
        sessionUser = user
        Task {
            do {
                try await authRepository.updateUser(user)
            } catch {
                print("Error updating saved recipes: \(error)")
            }
        }
    }
    
    func isRecipeSaved(_ recipeId: String) -> Bool {
        currentUser?.cookbookIds.contains(recipeId) ?? false
    }
    
    func generateRewardCode() {
        rewardCode = "JIKONI-\(Int.random(in: 1000...9999))"
    }
    
    func requestReturn(orderId: String) {
        requestedReturnOrderIds.insert(orderId)
        lastSupportMessage = "Return request submitted for order #\(orderId.prefix(8)). Support will follow up shortly."
    }

    func hasRequestedReturn(orderId: String) -> Bool {
        requestedReturnOrderIds.contains(orderId)
    }

    @MainActor
    func deleteAccountData() async {
        guard let existingUser = currentUser else { return }
        var redactedUser = existingUser
        redactedUser.displayName = "Deleted User"
        redactedUser.email = "deleted@jikoni.com"
        redactedUser.phoneNumber = nil
        redactedUser.profileImageUrl = nil
        redactedUser.profileBio = ""
        redactedUser.favoriteCuisines = []
        redactedUser.addresses = []
        redactedUser.paymentMethods = []
        redactedUser.cookbookIds = []
        redactedUser.dietaryGoals = []
        redactedUser.followersCount = 0
        redactedUser.followingCount = 0
        redactedUser.recipesCount = 0
        redactedUser.loyaltyPoints = 0
        redactedUser.averageRating = 0
        redactedUser.reviews = []
        redactedUser.membershipTier = .bronze
        redactedUser.preferredContact = .email
        redactedUser.allowsPromotionalEmails = false
        redactedUser.allowsPushNotifications = false

        await updateProfile(redactedUser)
        requestedReturnOrderIds.removeAll()
        rewardCode = nil
        lastSupportMessage = "Account data has been removed from this device."
    }

    @MainActor
    func deleteAccount() async {
        await deleteAccountData()
        await signOut()
    }
}
