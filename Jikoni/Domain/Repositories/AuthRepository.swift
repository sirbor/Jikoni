import Foundation

protocol AuthRepository {
    var currentUser: User? { get }
    func signIn(email: String) async throws -> User
    func signOut() async throws
    func updateUser(_ user: User) async throws
}
