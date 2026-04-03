import SwiftUI

struct CartAndWishlistView: View {
    @Bindable var marketplaceViewModel: MarketplaceViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    @State private var selectedTab = 0
    
    var savedRecipes: [Recipe] {
        feedViewModel.recipes.filter { hubViewModel.isRecipeSaved($0.id) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("View", selection: $selectedTab) {
                    Text("Cart (\(marketplaceViewModel.cart.values.reduce(0, +)))").tag(0)
                    Text("Wishlist (\(savedRecipes.count))").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                .background(Color(.systemGroupedBackground))
                
                if selectedTab == 0 {
                    CartView(viewModel: marketplaceViewModel)
                } else {
                    wishlistContent
                }
            }
            .navigationTitle(selectedTab == 0 ? "My Cart" : "My Wishlist")
        }
    }
    
    private var wishlistContent: some View {
        ScrollView {
            if savedRecipes.isEmpty {
                ContentUnavailableView(
                    "Your Wishlist is Empty",
                    systemImage: "heart.slash",
                    description: Text("Recipes you save will appear here.")
                )
                .padding(.top, 100)
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(savedRecipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
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
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
