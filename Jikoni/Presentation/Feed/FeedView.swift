import SwiftUI

struct FeedView: View {
    @State var viewModel: FeedViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.filteredRecipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            RecipeCard(
                                recipe: recipe,
                                isLiked: recipe.isLikedByMe,
                                onLike: {
                                    withAnimation(.spring()) {
                                        viewModel.toggleLike(for: recipe)
                                    }
                                }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    JikoniLogo(size: 30)
                }
            }
            .navigationTitle("") // Logo handles the title
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Search recipes or categories")
            .overlay {
                if viewModel.isLoading && viewModel.recipes.isEmpty {
                    ProgressView()
                } else if viewModel.filteredRecipes.isEmpty && !viewModel.searchText.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            }
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}
