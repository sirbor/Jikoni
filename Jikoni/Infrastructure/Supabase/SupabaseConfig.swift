import Foundation

/// Reads Supabase credentials from `Secrets.plist` (gitignored, not committed).
/// See `Secrets.example.plist` for the template. Missing/empty values mean
/// "not configured" — `RepositoryFactory` falls back to the Mock* repositories
/// in that case, so the app always runs in demo mode with zero setup.
enum SupabaseConfig {
    static var url: URL? {
        guard let string = value(for: "SUPABASE_URL"), !string.isEmpty else { return nil }
        return URL(string: string)
    }

    static var anonKey: String? {
        value(for: "SUPABASE_ANON_KEY")
    }

    static var isConfigured: Bool {
        url != nil && !(anonKey ?? "").isEmpty
    }

    private static let secrets: [String: Any] = {
        guard
            let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let data = FileManager.default.contents(atPath: path),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any]
        else {
            return [:]
        }
        return plist
    }()

    private static func value(for key: String) -> String? {
        (secrets[key] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
