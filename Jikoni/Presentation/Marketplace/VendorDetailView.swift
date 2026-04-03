import SwiftUI

struct VendorDetailView: View {
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    let vendor: Vendor
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image Header Carousel
                TabView {
                    ForEach(vendor.imageUrls, id: \.self) { imageUrl in
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
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vendor.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text(String(format: "%.1f", vendor.rating))
                            Text("•")
                            Text("$\(vendor.deliveryFee.formatted()) delivery")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    // Link to Signature Recipe (Discovery Link)
                    if let signatureRecipe = feedViewModel.recipes.first(where: { $0.vendorId == vendor.id }) {
                        NavigationLink {
                            RecipeDetailView(recipe: signatureRecipe)
                        } label: {
                            HStack(spacing: 16) {
                                AsyncImage(url: URL(string: signatureRecipe.imageUrls.first ?? "")) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Rectangle().fill(Color.gray.opacity(0.1))
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Signature Recipe")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.orange)
                                    
                                    Text(signatureRecipe.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text("Learn to cook this dish at home")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    
                    Divider()
                    
                    let inventory = vendor.inventory ?? [:]
                    
                    if !inventory.isEmpty {
                        ForEach(Array(inventory.keys).sorted(), id: \.self) { category in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(category)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                ForEach(inventory[category] ?? []) { ingredient in
                                    HStack(spacing: 12) {
                                        IngredientRow(ingredient: ingredient) {
                                            marketplaceViewModel.addToCart(ingredient: ingredient)
                                        }
                                        
                                        if let matchingRecipe = feedViewModel.findRecipe(for: ingredient.name) {
                                            NavigationLink {
                                                RecipeDetailView(recipe: matchingRecipe)
                                            } label: {
                                                Image(systemName: "text.book.closed.fill")
                                                    .font(.title3)
                                                    .foregroundStyle(.orange)
                                                    .padding(12)
                                                    .background(.orange.opacity(0.1))
                                                    .clipShape(Circle())
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                    } else {
                        ContentUnavailableView("No Items", systemImage: "basket", description: Text("This vendor currently has no items in stock."))
                    }
                }
                .padding()
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}
