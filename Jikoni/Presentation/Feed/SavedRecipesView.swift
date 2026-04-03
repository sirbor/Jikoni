import SwiftUI

struct SavedRecipesView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    
    var savedRecipes: [Recipe] {
        feedViewModel.recipes.filter { hubViewModel.isRecipeSaved($0.id) }
    }
    
    var body: some View {
        ScrollView {
            if savedRecipes.isEmpty {
                ContentUnavailableView("No Saved Recipes", systemImage: "bookmark.slash", description: Text("Recipes you save will appear here."))
                    .padding(.top, 100)
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(savedRecipes) { recipe in
                        RecipeCard(
                            recipe: recipe,
                            isLiked: recipe.isLikedByMe,
                            onLike: {
                                withAnimation(.spring()) {
                                    feedViewModel.toggleLike(for: recipe)
                                }
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Digital Cookbook")
    }
}
