import SwiftUI

struct FeedView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var viewModel: FeedViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                JikoniLogo(size: 34, showText: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)

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
            .background(
                LinearGradient(
                    colors: colorScheme == .dark
                        ? [Color(hex: "111111"), Color(hex: "1A1A1A"), Color(hex: "262014")]
                        : [Color(hex: "FFFDF8"), Color.white, Color(hex: "F6EAD1")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Jikoni")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Search recipes or categories")
            .overlay {
                if viewModel.isLoading && viewModel.recipes.isEmpty {
                    ProgressView("Loading fresh picks...")
                        .tint(Color(hex: "D4AF37"))
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
