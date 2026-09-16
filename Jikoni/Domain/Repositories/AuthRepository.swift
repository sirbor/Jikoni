import Foundation

protocol AuthRepository {
    var currentUser: User? { get }
    func restoreSession() async throws -> User?
    func signInWithEmail(email: String, password: String) async throws -> User
    func signUpWithEmail(email: String, password: String, displayName: String?) async throws -> User
    func signInWithGoogle() async throws -> User
    func signInWithApple(idToken: String?, nonce: String?, fullName: String?, email: String?) async throws -> User
    func signInAsGuest() async throws -> User
    func signOut() async throws
    func updateUser(_ user: User) async throws
}
