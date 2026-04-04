import SwiftUI

struct VendorDetailView: View {
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    let vendor: Vendor
    
    @State private var showingReviewSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                    .frame(height: 250)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(vendor.name)
                                    .font(.custom("Georgia-Bold", size: 28))
                                
                                HStack {
                                    Text(vendor.cuisine)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color(hex: "D4AF37"))
                                    Text("•")
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(Color(hex: "D4AF37"))
                                        Text(String(format: "%.1f", vendor.rating))
                                    }
                                }
                                .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Button {
                                showingReviewSheet = true
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: "square.and.pencil")
                                    Text("Review")
                                        .font(.system(size: 10, weight: .bold))
                                }
                                .foregroundStyle(Color(hex: "D4AF37"))
                                .padding(10)
                                .background(Color(hex: "D4AF37").opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        Divider()
                        
                        // Inventory Categories
                        let inventory = vendor.inventory ?? [:]
                        
                        if !inventory.isEmpty {
                            // Soups Section
                            if let soups = inventory["Soups"] {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Soups")
                                        .font(.custom("Georgia-Bold", size: 20))
                                    
                                    ForEach(soups) { soup in
                                        IngredientRow(ingredient: soup) {
                                            marketplaceViewModel.addToCart(ingredient: soup)
                                        }
                                    }
                                }
                                .padding(.bottom, 12)
                            }

                            // Meals Section
                            if let meals = inventory["Meals"] {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Main Meals")
                                        .font(.custom("Georgia-Bold", size: 20))
                                    
                                    ForEach(meals) { meal in
                                        IngredientRow(ingredient: meal) {
                                            marketplaceViewModel.addToCart(ingredient: meal)
                                        }
                                    }
                                }
                            }
                            
                            // Cocktails Section
                            if let cocktails = inventory["Drinks"] {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Bar & Drinks")
                                        .font(.custom("Georgia-Bold", size: 20))
                                        .padding(.top, 12)
                                    
                                    ForEach(cocktails) { drink in
                                        IngredientRow(ingredient: drink) {
                                            marketplaceViewModel.addToCart(ingredient: drink)
                                        }
                                    }
                                }
                            }
                        } else {
                            ContentUnavailableView("No Items", systemImage: "basket", description: Text("This vendor currently has no items in stock."))
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 100) // Space for floating button
                }
            }
            
            FloatingCartButton(viewModel: marketplaceViewModel)
                .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showingReviewSheet) {
            AddReviewView { review in
                // Submit review logic (mocked)
                print("Review submitted: \(review.comment)")
            }
        }
    }
}
