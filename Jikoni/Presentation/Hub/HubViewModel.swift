import Foundation
import Observation

@Observable
class HubViewModel {
    private let authRepository: AuthRepository
    private let orderRepository: OrderRepository
    
    var orders: [Order] = []
    var isLoading: Bool = false
    var rewardCode: String?
    var requestedReturnOrderIds: Set<String> = []
    var lastSupportMessage: String?
    var sessionUser: User?
    
    var currentUser: User? {
        sessionUser
    }
    
    init(authRepository: AuthRepository, orderRepository: OrderRepository) {
        self.authRepository = authRepository
        self.orderRepository = orderRepository
        self.sessionUser = authRepository.currentUser
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
    
    func register(name: String, skillLevel: String, dietaryGoals: [String]) async {
        isLoading = true
        do {
            let user = User(
                id: "user-\(UUID().uuidString.prefix(8))",
                displayName: name,
                email: "\(name.lowercased())@jikoni.com",
                phoneNumber: nil,
                profileBio: "Food lover discovering the city one delivery at a time.",
                skillLevel: skillLevel,
                dietaryGoals: dietaryGoals,
                loyaltyPoints: 100, // Welcome bonus
                cookbookIds: [],
                followersCount: 0,
                followingCount: 0,
                recipesCount: 0,
                averageRating: 5.0,
                reviews: [],
                membershipTier: .bronze,
                memberSince: .now,
                favoriteCuisines: [],
                addresses: [],
                paymentMethods: [],
                preferredContact: .email,
                allowsPushNotifications: true,
                allowsPromotionalEmails: true
            )
            _ = try await authRepository.signIn(email: "\(name.lowercased())@jikoni.com")
            try await authRepository.updateUser(user)
            sessionUser = user
        } catch {
            print("Error registering: \(error)")
        }
        isLoading = false
    }
    
    func signIn() async {
        await signIn(email: "chef@jikoni.com")
    }

    func signIn(email: String) async {
        isLoading = true
        do {
            let user = try await authRepository.signIn(email: email)
            sessionUser = user
        } catch {
            print("Error signing in: \(error)")
        }
        isLoading = false
    }
    
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
}
