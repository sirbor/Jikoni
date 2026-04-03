import Foundation

class MockAuthRepository: AuthRepository {
    var currentUser: User? = User(
        id: "user-123",
        displayName: "Chef Jikoni",
        skillLevel: "Executive Chef",
        dietaryGoals: ["Healthy", "Organic"],
        loyaltyPoints: 1250,
        cookbookIds: ["r-1", "r-3", "r-6"],
        followersCount: 1540,
        followingCount: 320,
        recipesCount: 24,
        averageRating: 4.9,
        reviews: []
    )
    
    func signIn(email: String) async throws -> User {
        let user = User(
            id: "user-123",
            displayName: "Chef Jikoni",
            skillLevel: "Executive Chef",
            dietaryGoals: ["Healthy", "Organic"],
            loyaltyPoints: 1250,
            cookbookIds: ["r-1", "r-3", "r-6"],
            followersCount: 1540,
            followingCount: 320,
            recipesCount: 24,
            averageRating: 4.9,
            reviews: []
        )
        currentUser = user
        return user
    }
    
    func signOut() async throws {
        // Keeping it for protocol satisfaction, but we won't show the screen
        currentUser = nil
    }
    
    func updateUser(_ user: User) async throws {
        currentUser = user
    }
}
