import SwiftUI

struct VendorDetailView: View {
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    let vendor: Vendor
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Image
                AsyncImage(url: URL(string: vendor.imageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .frame(height: 250)
                .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
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
                        Spacer()
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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}
