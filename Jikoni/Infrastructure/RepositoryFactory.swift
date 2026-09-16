import Foundation

/// Picks real Supabase-backed repositories when `Secrets.plist` is configured,
/// otherwise falls back to the `Mock*Repository` demo data — so the app keeps
/// running with zero setup, and switches to a live backend once credentials
/// are supplied.
enum RepositoryFactory {
    static func makeAuth() -> AuthRepository {
        SupabaseConfig.isConfigured ? SupabaseAuthRepository() : MockAuthRepository()
    }

    static func makeRecipes() -> RecipeRepository {
        SupabaseConfig.isConfigured ? SupabaseRecipeRepository() : MockRecipeRepository()
    }

    static func makeVendors() -> VendorRepository {
        SupabaseConfig.isConfigured ? SupabaseVendorRepository() : MockVendorRepository()
    }

    static func makeOrders() -> OrderRepository {
        SupabaseConfig.isConfigured ? SupabaseOrderRepository() : MockOrderRepository()
    }
}
