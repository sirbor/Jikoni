import Foundation
import Supabase

/// Real recipe data backed by `recipes` + `recipe_ingredients` + `recipe_likes`.
///
/// `streamRecipes()` polls rather than using a Supabase Realtime channel —
/// deliberate for this pass: it keeps the implementation on the well-documented
/// Postgrest query API instead of betting on a Realtime channel signature that
/// can only be confirmed once the `supabase-swift` package is actually resolved
/// in Xcode. Swapping this for a push-based Realtime channel is a safe,
/// isolated follow-up once the package version is pinned.
final class SupabaseRecipeRepository: RecipeRepository {
    private let client: SupabaseClient
    private let pollInterval: UInt64 = 4_000_000_000

    init(client: SupabaseClient = SupabaseClientProvider.shared) {
        self.client = client
    }

    func fetchRecipes() async throws -> [Recipe] {
        let currentUserId = try? await client.auth.session.user.id
        let rows: [RecipeRow] = try await client.from("recipes")
            .select("*, recipe_ingredients(*), profiles!recipes_author_id_fkey(display_name)")
            .order("created_at", ascending: false)
            .execute()
            .value
        let likeCounts = try await likeCounts(recipeIds: rows.map(\.id))
        let myLikes = try await myLikedRecipeIds(userId: currentUserId)
        return rows.map { row in
            row.toRecipe(likes: likeCounts[row.id] ?? 0, isLikedByMe: myLikes.contains(row.id))
        }
    }

    func streamRecipes() -> AsyncStream<[Recipe]> {
        AsyncStream { continuation in
            let task = Task {
                while !Task.isCancelled {
                    if let recipes = try? await fetchRecipes() {
                        continuation.yield(recipes)
                    }
                    try? await Task.sleep(nanoseconds: pollInterval)
                }
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    func toggleLike(recipeId: String) async throws {
        guard let recipeUUID = UUID(uuidString: recipeId), let userId = try? await client.auth.session.user.id else { return }
        let existing: [RecipeLikeRow] = try await client.from("recipe_likes")
            .select()
            .eq("recipe_id", value: recipeUUID)
            .eq("user_id", value: userId)
            .execute()
            .value
        if existing.isEmpty {
            try await client.from("recipe_likes").insert(RecipeLikeRow(recipe_id: recipeUUID, user_id: userId)).execute()
        } else {
            try await client.from("recipe_likes")
                .delete()
                .eq("recipe_id", value: recipeUUID)
                .eq("user_id", value: userId)
                .execute()
        }
    }

    func createRecipe(_ recipe: Recipe) async throws {
        guard let authorId = try? await client.auth.session.user.id else { return }
        let row = RecipeInsertRow(recipe: recipe, authorId: authorId)
        let inserted: [RecipeIdOnly] = try await client.from("recipes").insert(row).select("id").execute().value
        guard let recipeId = inserted.first?.id else { return }
        let ingredientRows = recipe.ingredients.map { IngredientInsertRow(ingredient: $0, recipeId: recipeId) }
        if !ingredientRows.isEmpty {
            try await client.from("recipe_ingredients").insert(ingredientRows).execute()
        }
    }

    func addComment(recipeId: String, comment: Comment) async throws {
        guard let recipeUUID = UUID(uuidString: recipeId),
              let authorId = try? await client.auth.session.user.id else { return }
        let row = CommentInsertRow(
            id: comment.id,
            recipe_id: recipeUUID,
            author_id: authorId,
            text: comment.text,
            created_at: comment.date
        )
        try await client.from("comments").insert(row).execute()
    }

    private func likeCounts(recipeIds: [UUID]) async throws -> [UUID: Int] {
        guard !recipeIds.isEmpty else { return [:] }
        let rows: [RecipeLikeRow] = try await client.from("recipe_likes")
            .select()
            .in("recipe_id", values: recipeIds)
            .execute()
            .value
        var counts: [UUID: Int] = [:]
        for row in rows { counts[row.recipe_id, default: 0] += 1 }
        return counts
    }

    private func myLikedRecipeIds(userId: UUID?) async throws -> Set<UUID> {
        guard let userId else { return [] }
        let rows: [RecipeLikeRow] = try await client.from("recipe_likes")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value
        return Set(rows.map(\.recipe_id))
    }
}

private struct RecipeLikeRow: Codable {
    let recipe_id: UUID
    let user_id: UUID
}

private struct RecipeIdOnly: Codable {
    let id: UUID
}

private struct RecipeIngredientRow: Codable {
    let id: UUID
    let name: String
    let amount: String
    let price: Double
    let vendor_id: String?
    let details: String
    let image_url: String?
    let is_available: Bool
    let nutritional_notes: String
    let dietary_tags: [String]

    var asDomain: Ingredient {
        Ingredient(name: name, amount: amount, price: price, vendorId: vendor_id, details: details, imageUrl: image_url, isAvailable: is_available, nutritionalNotes: nutritional_notes, dietaryTags: dietary_tags)
    }
}

private struct AuthorRow: Codable {
    let display_name: String?
}

private struct RecipeRow: Codable {
    let id: UUID
    let author_id: UUID
    let vendor_id: String?
    let title: String
    let image_urls: [String]
    let description: String
    let instructions: [String]
    let created_at: Date
    let recipe_ingredients: [RecipeIngredientRow]?
    let profiles: AuthorRow?

    func toRecipe(likes: Int, isLikedByMe: Bool) -> Recipe {
        Recipe(
            id: id.uuidString,
            title: title,
            author: profiles?.display_name ?? "Jikoni cook",
            vendorId: vendor_id ?? "",
            imageUrls: image_urls,
            description: description,
            ingredients: (recipe_ingredients ?? []).map(\.asDomain),
            instructions: instructions,
            likes: likes,
            isLikedByMe: isLikedByMe,
            comments: []
        )
    }
}

private struct RecipeInsertRow: Encodable {
    let author_id: UUID
    let vendor_id: String?
    let title: String
    let image_urls: [String]
    let description: String
    let instructions: [String]

    init(recipe: Recipe, authorId: UUID) {
        author_id = authorId
        vendor_id = recipe.vendorId.isEmpty ? nil : recipe.vendorId
        title = recipe.title
        image_urls = recipe.imageUrls
        description = recipe.description
        instructions = recipe.instructions
    }
}

private struct IngredientInsertRow: Encodable {
    let recipe_id: UUID
    let name: String
    let amount: String
    let price: Double
    let vendor_id: String?
    let details: String
    let image_url: String?
    let is_available: Bool
    let nutritional_notes: String
    let dietary_tags: [String]

    init(ingredient: Ingredient, recipeId: UUID) {
        recipe_id = recipeId
        name = ingredient.name
        amount = ingredient.amount
        price = ingredient.price
        vendor_id = ingredient.vendorId
        details = ingredient.details
        image_url = ingredient.imageUrl
        is_available = ingredient.isAvailable
        nutritional_notes = ingredient.nutritionalNotes
        dietary_tags = ingredient.dietaryTags
    }
}

private struct CommentInsertRow: Encodable {
    let id: UUID
    let recipe_id: UUID
    let author_id: UUID
    let text: String
    let created_at: Date
}
