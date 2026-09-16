import SwiftUI

/// Saves grouped by occasion rather than cuisine. Collections are a
/// lightweight on-device tag (no backend schema for them yet) so the
/// grouping is real, not decorative.
struct CookbookView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    @Environment(\.dismiss) private var dismiss

    @AppStorage("cookbookCollections") private var collectionsRaw: String = ""
    @State private var activeCollection = "All"
    @State private var showNewCollectionPrompt = false
    @State private var newCollectionName = ""
    @State private var pendingRecipeId: String?

    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    private var assignments: [String: String] {
        guard let data = collectionsRaw.data(using: .utf8),
              let dict = try? JSONDecoder().decode([String: String].self, from: data) else { return [:] }
        return dict
    }

    var savedRecipes: [Recipe] {
        feedViewModel.recipes.filter { hubViewModel.isRecipeSaved($0.id) }
    }

    private var collections: [String] {
        var names = Set(assignments.values)
        names.insert("All")
        return ["All"] + names.subtracting(["All"]).sorted()
    }

    private var visibleRecipes: [Recipe] {
        guard activeCollection != "All" else { return savedRecipes }
        return savedRecipes.filter { (assignments[$0.id] ?? "Uncategorized") == activeCollection }
    }

    var body: some View {
        VStack(spacing: 0) {
            JikoniHeaderRow(title: "My Cookbook", onBack: { dismiss() })

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(collections, id: \.self) { name in
                        let selected = activeCollection == name
                        Button {
                            activeCollection = name
                        } label: {
                            Text(name)
                                .font(JikoniFont.archivo(12, weight: .extrabold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(selected ? JikoniColor.ink : JikoniColor.card)
                                .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.textSecondary)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 18)
            }
            .padding(.bottom, 12)

            ScrollView {
                if savedRecipes.isEmpty {
                    ContentUnavailableView("No Saved Recipes", systemImage: "bookmark.slash", description: Text("Recipes you save will appear here."))
                        .padding(.top, 100)
                } else {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(visibleRecipes) { recipe in
                            cookbookTile(recipe)
                        }
                    }
                    .padding(18)
                }
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .task { await feedViewModel.fetchRecipes() }
        .alert("New collection", isPresented: $showNewCollectionPrompt) {
            TextField("Collection name", text: $newCollectionName)
            Button("Cancel", role: .cancel) { pendingRecipeId = nil }
            Button("Save") {
                if let id = pendingRecipeId, !newCollectionName.trimmingCharacters(in: .whitespaces).isEmpty {
                    assign(recipeId: id, to: newCollectionName)
                }
                newCollectionName = ""
                pendingRecipeId = nil
            }
        }
    }

    private func cookbookTile(_ recipe: Recipe) -> some View {
        NavigationLink {
            RecipeDetailView(recipe: recipe)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: recipe.imageUrls.first ?? "")) { phase in
                    switch phase {
                    case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                    default: Rectangle().fill(JikoniColor.placeholder)
                    }
                }
                .frame(height: 116)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.cardSmall - 1))

                VStack(alignment: .leading, spacing: 5) {
                    Text(recipe.title)
                        .font(JikoniFont.instrumentSerif(18))
                        .foregroundStyle(JikoniColor.ink)
                        .lineLimit(1)
                    HStack {
                        Text(assignments[recipe.id] ?? "Uncategorized")
                            .font(JikoniFont.archivo(9.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.textSecondary)
                        Spacer()
                        Menu {
                            ForEach(collections.filter { $0 != "All" }, id: \.self) { name in
                                Button(name) { assign(recipeId: recipe.id, to: name) }
                            }
                            Button("New collection…") {
                                pendingRecipeId = recipe.id
                                showNewCollectionPrompt = true
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(JikoniColor.textSecondary)
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 8, bottom: 9, trailing: 8))
            }
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.cardSmall))
            .jikoniShadow(.small)
        }
        .buttonStyle(.plain)
    }

    private func assign(recipeId: String, to collection: String) {
        var dict = assignments
        dict[recipeId] = collection
        if let data = try? JSONEncoder().encode(dict), let string = String(data: data, encoding: .utf8) {
            collectionsRaw = string
        }
    }
}
