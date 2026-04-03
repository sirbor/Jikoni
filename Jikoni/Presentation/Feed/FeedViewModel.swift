import Foundation
import Observation

@Observable
class FeedViewModel {
    private let repository: RecipeRepository
    
    var recipes: [Recipe] = []
    var searchText: String = ""
    var isLoading: Bool = false
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    @MainActor
    func fetchRecipes() async {
        guard recipes.isEmpty else { return }
        isLoading = true
        
        do {
            self.recipes = try await repository.fetchRecipes()
            isLoading = false
            
            for await newRecipes in repository.streamRecipes() {
                self.recipes = newRecipes
            }
        } catch {
            print("Error: \(error)")
            isLoading = false
        }
    }
    
    func toggleLike(for recipe: Recipe) {
        Task {
            do {
                try await repository.toggleLike(recipeId: recipe.id)
            } catch {
                print("Error toggling like: \(error)")
            }
        }
    }
    
    func findRecipe(for dishName: String) -> Recipe? {
        recipes.first { recipe in
            recipe.title.localizedCaseInsensitiveContains(dishName) || 
            dishName.localizedCaseInsensitiveContains(recipe.title)
        }
    }
}
