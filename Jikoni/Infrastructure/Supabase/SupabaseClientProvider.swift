import Foundation
import Supabase

/// Shared Supabase client, built from `SupabaseConfig`. Only ever constructed
/// when `SupabaseConfig.isConfigured` is true — see `RepositoryFactory`.
enum SupabaseClientProvider {
    static let shared: SupabaseClient = {
        guard let url = SupabaseConfig.url, let anonKey = SupabaseConfig.anonKey else {
            preconditionFailure("SupabaseClientProvider.shared accessed while Supabase is not configured")
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }()
}
