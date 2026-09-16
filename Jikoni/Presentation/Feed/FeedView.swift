import SwiftUI

/// The app's front door — recipes first, ordering is one tap away.
struct FeedView: View {
    @Bindable var viewModel: FeedViewModel
    @Environment(HubViewModel.self) private var hubViewModel

    private enum FeedTab: String, CaseIterable { case forYou = "For you", following = "Following", quick = "Quick", coastal = "Coastal" }
    @State private var feedTab: FeedTab = .forYou
    @State private var showEasyOnly = false

    private var tabbedRecipes: [Recipe] {
        var list: [Recipe]
        switch feedTab {
        case .forYou:
            list = viewModel.filteredRecipes
        case .following:
            list = viewModel.filteredRecipes.filter(\.isLikedByMe)
        case .quick:
            list = viewModel.filteredRecipes.filter { $0.instructions.count <= 3 }
        case .coastal:
            list = viewModel.filteredRecipes.filter {
                let text = ($0.title + " " + $0.description).lowercased()
                return text.contains("coastal") || text.contains("swahili") || text.contains("coconut")
            }
        }
        if showEasyOnly {
            list = list.filter { $0.instructions.count <= 4 }
        }
        return list
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    searchAndFilter
                    feedTabs

                    if viewModel.isLoading && viewModel.recipes.isEmpty {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                    } else if tabbedRecipes.isEmpty {
                        ContentUnavailableView(
                            "No Recipes Yet",
                            systemImage: "fork.knife",
                            description: Text("Recipes from cooks near you will show up here.")
                        )
                        .padding(.top, 60)
                    } else {
                        LazyVStack(spacing: 20) {
                            ForEach(tabbedRecipes) { recipe in
                                RecipeCard(
                                    recipe: recipe,
                                    isLiked: recipe.isLikedByMe,
                                    onLike: {
                                        withAnimation(.spring()) {
                                            viewModel.toggleLike(for: recipe)
                                        }
                                    },
                                    destination: { RecipeDetailView(recipe: recipe) }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(JikoniColor.ground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .task { await viewModel.fetchRecipes() }
            .refreshable { await viewModel.refreshRecipes() }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(JikoniColor.placeholderAlt)
                .frame(width: 46, height: 46)

            VStack(alignment: .leading, spacing: 2) {
                Text("Habari, \(hubViewModel.currentUser?.displayName ?? "there")!")
                    .font(JikoniFont.archivo(19, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Text("What are you cooking today?")
                    .font(JikoniFont.archivo(12.5))
                    .foregroundStyle(JikoniColor.textSecondary)
            }

            Spacer()

            NavigationLink { CreateRecipeView() } label: {
                JikoniCircleButtonLabel(systemImage: "plus")
            }
            NavigationLink { CookbookView() } label: {
                JikoniCircleButtonLabel(systemImage: "books.vertical.fill")
            }
        }
        .padding(.horizontal, 18)
    }

    private var searchAndFilter: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(JikoniColor.textSecondary)
                TextField("search recipes, cooks, ingredients", text: $viewModel.searchText)
                    .font(JikoniFont.archivo(13.5))
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(JikoniColor.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(JikoniColor.card)
            .clipShape(Capsule())
            .jikoniShadow(.small)

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    showEasyOnly.toggle()
                }
            } label: {
                Image(systemName: showEasyOnly ? "flame.fill" : "slider.horizontal.3")
                    .foregroundStyle(showEasyOnly ? JikoniColor.ground : JikoniColor.ink)
                    .frame(width: 52, height: 52)
                    .background(showEasyOnly ? JikoniColor.accent : JikoniColor.card)
                    .clipShape(Circle())
                    .jikoniShadow(.small)
            }
        }
        .padding(.horizontal, 18)
    }

    private var feedTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FeedTab.allCases, id: \.self) { tab in
                    let selected = feedTab == tab
                    Button {
                        feedTab = tab
                    } label: {
                        Text(tab.rawValue)
                            .font(JikoniFont.archivo(13, weight: .extrabold))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 11)
                            .background(selected ? JikoniColor.ink : JikoniColor.card)
                            .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.textSecondary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 18)
        }
    }
}

/// A 44pt circular icon button matching `JikoniCircleButton`'s look, used here
/// as a `NavigationLink` label (the real component's `action:` closure form
/// doesn't compose with `NavigationLink`).
private struct JikoniCircleButtonLabel: View {
    let systemImage: String

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(JikoniColor.ink)
            .frame(width: 44, height: 44)
            .background(JikoniColor.card)
            .clipShape(Circle())
            .jikoniShadow(.small)
    }
}
