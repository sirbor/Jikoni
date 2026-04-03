import Foundation

protocol RecipeRepository {
    func fetchRecipes() async throws -> [Recipe]
    func streamRecipes() -> AsyncStream<[Recipe]>
    func toggleLike(recipeId: String) async throws
    func createRecipe(_ recipe: Recipe) async throws
}
