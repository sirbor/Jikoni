import Foundation
import Observation

@Observable
class HubViewModel {
    private let authRepository: AuthRepository
    private let orderRepository: OrderRepository
    
    var orders: [Order] = []
    var isLoading: Bool = false
    var rewardCode: String?
    
    var currentUser: User? {
        authRepository.currentUser
    }
    
    init(authRepository: AuthRepository, orderRepository: OrderRepository) {
        self.authRepository = authRepository
        self.orderRepository = orderRepository
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
                skillLevel: skillLevel,
                dietaryGoals: dietaryGoals,
                loyaltyPoints: 100, // Welcome bonus
                cookbookIds: [],
                followersCount: 0,
                followingCount: 0,
                recipesCount: 0,
                averageRating: 5.0,
                reviews: []
            )
            _ = try await authRepository.signIn(email: "\(name.lowercased())@jikoni.com")
            try await authRepository.updateUser(user)
        } catch {
            print("Error registering: \(error)")
        }
        isLoading = false
    }
    
    func signIn() async {
        isLoading = true
        do {
            _ = try await authRepository.signIn(email: "chef@jikoni.com")
        } catch {
            print("Error signing in: \(error)")
        }
        isLoading = false
    }
    
    func signOut() async {
        do {
            try await authRepository.signOut()
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
        } catch {
            print("Error updating profile: \(error)")
        }
    }
    
    @MainActor
    func toggleSavedRecipe(_ recipeId: String) {
        guard var user = currentUser else { return }
        if user.cookbookIds.contains(recipeId) {
            user.cookbookIds.removeAll { $0 == recipeId }
        } else {
            user.cookbookIds.append(recipeId)
        }
        
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
        print("Return requested for order \(orderId)")
    }
}
