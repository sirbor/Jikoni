import Foundation
import Observation

@Observable
class FeedViewModel {
    private let repository: RecipeRepository
    
    var recipes: [Recipe] = []
    var searchText: String = ""
    var isLoading: Bool = false
    
    var filteredRecipes: [Recipe] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty {
            return recipes
        } else {
            return recipes.filter {
                $0.title.localizedCaseInsensitiveContains(q) ||
                $0.author.localizedCaseInsensitiveContains(q) ||
                $0.description.localizedCaseInsensitiveContains(q) ||
                $0.ingredients.contains { $0.name.localizedCaseInsensitiveContains(q) }
            }
        }
    }
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    @MainActor
    func fetchRecipes() async {
        guard recipes.isEmpty else { return }
        await refreshRecipes()
        
        Task {
            for await newRecipes in repository.streamRecipes() {
                self.recipes = newRecipes
            }
        }
    }

    @MainActor
    func refreshRecipes() async {
        isLoading = true
        do {
            self.recipes = try await repository.fetchRecipes()
        } catch {
            print("Error fetching recipes: \(error)")
        }
        isLoading = false
    }
    
    @MainActor
    func createRecipe(_ recipe: Recipe) async {
        recipes.insert(recipe, at: 0)
        do {
            try await repository.createRecipe(recipe)
        } catch {
            print("Error creating recipe: \(error)")
            recipes.removeAll { $0.id == recipe.id }
        }
    }

    @MainActor
    func toggleLike(for recipe: Recipe) {
        if let idx = recipes.firstIndex(where: { $0.id == recipe.id }) {
            let wasLiked = recipes[idx].isLikedByMe
            recipes[idx].isLikedByMe.toggle()
            recipes[idx].likes += wasLiked ? -1 : 1
        }
        Task {
            do {
                try await repository.toggleLike(recipeId: recipe.id)
            } catch {
                print("Error toggling like: \(error)")
                if let idx = self.recipes.firstIndex(where: { $0.id == recipe.id }) {
                    let wasLiked = self.recipes[idx].isLikedByMe
                    self.recipes[idx].isLikedByMe.toggle()
                    self.recipes[idx].likes += wasLiked ? -1 : 1
                }
            }
        }
    }

    @MainActor
    func addComment(to recipeId: String, comment: Comment) async {
        if let idx = recipes.firstIndex(where: { $0.id == recipeId }) {
            recipes[idx].comments.append(comment)
        }
        do {
            try await repository.addComment(recipeId: recipeId, comment: comment)
        } catch {
            print("Error adding comment: \(error)")
        }
    }
    
    func findRecipe(for dishName: String) -> Recipe? {
        recipes.first { recipe in
            recipe.title.localizedCaseInsensitiveContains(dishName) || 
            dishName.localizedCaseInsensitiveContains(recipe.title)
        }
    }
}
