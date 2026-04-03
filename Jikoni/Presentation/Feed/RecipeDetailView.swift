import SwiftUI

struct RecipeDetailView: View {
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    let recipe: Recipe
    @State private var newComment = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image Header Carousel
                TabView {
                    ForEach(recipe.imageUrls, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                Rectangle().fill(Color.gray.opacity(0.1)).overlay(ProgressView())
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            case .failure:
                                Rectangle().fill(Color.gray.opacity(0.2)).overlay(Image(systemName: "photo"))
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 300)
                .clipped()
                
                VStack(alignment: .leading, spacing: 24) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Text(recipe.title)
                                .font(.system(.title2, design: .rounded, weight: .black))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: { 
                                withAnimation(.spring()) {
                                    hubViewModel.toggleSavedRecipe(recipe.id)
                                }
                            }) {
                                Image(systemName: hubViewModel.isRecipeSaved(recipe.id) ? "bookmark.fill" : "bookmark")
                                    .font(.title3)
                                    .foregroundStyle(.orange)
                                    .padding(10)
                                    .background(.orange.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        
                        if let vendor = marketplaceViewModel.vendors.first(where: { $0.id == recipe.vendorId }) {
                            NavigationLink {
                                VendorDetailView(vendor: vendor)
                            } label: {
                                HStack {
                                    Image(systemName: "storefront.fill")
                                    Text("From \(vendor.name)")
                                        .fontWeight(.bold)
                                }
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                                .padding(.vertical, 4)
                            }
                        } else {
                            Text("by \(recipe.author)")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                    
                    Text(recipe.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Ingredients
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ingredients")
                            .font(.headline)
                        
                        ForEach(recipe.ingredients) { ingredient in
                            IngredientRow(ingredient: ingredient) {
                                marketplaceViewModel.addToCart(ingredient: ingredient)
                            }
                        }
                    }
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Cooking Steps")
                            .font(.headline)
                        
                        ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                    .background(.orange.gradient)
                                    .clipShape(Circle())
                                
                                Text(instruction)
                                    .font(.subheadline)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(nil)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    Divider().padding(.vertical, 8)
                    
                    // Comments
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Community Reviews (\(recipe.comments.count))")
                            .font(.headline)
                        
                        HStack {
                            TextField("Share your thoughts...", text: $newComment)
                                .font(.subheadline)
                                .padding(10)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Button("Post") {
                                newComment = ""
                            }
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                        }
                        
                        ForEach(recipe.comments) { comment in
                            CommentView(comment: comment)
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

struct CommentView: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(comment.author)
                    .fontWeight(.bold)
                    .font(.caption)
                Text(comment.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
            }
            
            Text(comment.text)
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !comment.replies.isEmpty {
                ForEach(comment.replies) { reply in
                    CommentView(comment: reply)
                        .padding(.leading, 12)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe(id: "1", title: "Pasta Carbonara", author: "Chef Mario", vendorId: "v-2", imageUrls: ["https://images.unsplash.com/photo-1612874742237-6526221588e3", "https://images.unsplash.com/photo-1546069901-ba9599a7e63c", "https://images.unsplash.com/photo-1546767012-bc750392dd33"], description: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.", ingredients: [], instructions: ["Boil water", "Cook pasta", "Mix eggs and cheese"], likes: 120, isLikedByMe: false, comments: [
        Comment(id: UUID(), author: "Julia", text: "Best carbonara ever!", date: Date(), replies: [
            Comment(id: UUID(), author: "Mario", text: "Glad you liked it!", date: Date(), replies: [])
        ])
    ]))
}
