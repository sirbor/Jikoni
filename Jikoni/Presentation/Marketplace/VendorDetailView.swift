import SwiftUI

struct VendorDetailView: View {
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    let vendor: Vendor
    
    @State private var showingReviewSheet = false
    @State private var selectedTab = 0
    @State private var selectedIngredient: Ingredient?
    @State private var selectedCategory: String?
    
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
                                Label("~\(vendor.estimatedDeliveryMinutes) min • Min \(vendor.minimumOrder.currencyString()) • Fee \(vendor.deliveryFee.currencyString())", systemImage: "clock")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()

                            VStack(spacing: 8) {
                                Button {
                                    marketplaceViewModel.toggleFavoriteRestaurant(vendor.id)
                                } label: {
                                    Image(systemName: marketplaceViewModel.isFavoriteRestaurant(vendor.id) ? "heart.fill" : "heart")
                                        .foregroundStyle(.pink)
                                        .padding(8)
                                        .background(.pink.opacity(0.12))
                                        .clipShape(Circle())
                                }

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
                        }

                        Picker("Content", selection: $selectedTab) {
                            Text("Menu").tag(0)
                            Text("Info").tag(1)
                            Text("Reviews").tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        Divider()

                        if selectedTab == 0 {
                            menuContent
                        } else if selectedTab == 1 {
                            infoContent
                        } else {
                            reviewsContent
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
        .sheet(item: $selectedIngredient) { ingredient in
            ItemDetailSheet(ingredient: ingredient) {
                marketplaceViewModel.addToCart(ingredient: $0)
            }
        }
    }

    private var orderedCategories: [String] {
        let inventory = vendor.inventory ?? [:]
        let preferred = ["Starters", "Mains", "Sides", "Drinks", "Desserts", "Soups", "Meals"]
        let existingPreferred = preferred.filter { inventory[$0] != nil }
        let remaining = inventory.keys.filter { !existingPreferred.contains($0) }.sorted()
        return existingPreferred + remaining
    }

    private var menuContent: some View {
        let inventory = vendor.inventory ?? [:]
        return VStack(alignment: .leading, spacing: 14) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(orderedCategories, id: \.self) { category in
                        Button(category) { selectedCategory = category }
                            .buttonStyle(.borderedProminent)
                            .tint(selectedCategory == category ? .orange : .gray.opacity(0.35))
                    }
                }
            }

            ForEach(orderedCategories.filter { selectedCategory == nil || $0 == selectedCategory }, id: \.self) { category in
                if let items = inventory[category] {
                    Text(category)
                        .font(.custom("Georgia-Bold", size: 20))
                    ForEach(items) { item in
                        Button {
                            selectedIngredient = item
                        } label: {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.orange.opacity(0.15))
                                    .frame(width: 64, height: 64)
                                    .overlay(Image(systemName: "fork.knife").foregroundStyle(.orange))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(item.details.isEmpty ? "Delicious chef special." : item.details)
                                        .font(.caption)
                                        .lineLimit(2)
                                        .foregroundStyle(.secondary)
                                    Text(item.price.currencyString())
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.orange)
                                }
                                Spacer()
                                Button {
                                    marketplaceViewModel.toggleFavoriteDish(item.id)
                                } label: {
                                    Image(systemName: marketplaceViewModel.favoriteDishIds.contains(item.id) ? "heart.fill" : "heart")
                                        .foregroundStyle(.pink)
                                }
                                Text(item.isAvailable ? "Available" : "Sold Out")
                                    .font(.caption2.bold())
                                    .padding(6)
                                    .background((item.isAvailable ? Color.green : Color.red).opacity(0.12))
                                    .foregroundStyle(item.isAvailable ? .green : .red)
                                    .clipShape(Capsule())
                            }
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var infoContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(vendor.openingHours, systemImage: "clock")
            Label(vendor.phoneNumber, systemImage: "phone")
            Label("Hygiene Rating: \(vendor.hygieneRating)", systemImage: "checkmark.shield")
            Label("Map: \(vendor.location.latitude.formatted()), \(vendor.location.longitude.formatted())", systemImage: "map")
            Label("Delivery fee \(vendor.deliveryFee.currencyString())", systemImage: "scooter")
        }
        .font(.subheadline)
    }

    private var reviewsContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(vendor.reviews ?? []) { review in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(review.author).font(.headline)
                        Spacer()
                        Text(review.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(String(repeating: "★", count: review.rating))
                        .foregroundStyle(.orange)
                    Text(review.comment)
                        .font(.subheadline)
                    if !review.photoUrls.isEmpty {
                        Text("Photo attachments: \(review.photoUrls.count)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            if (vendor.reviews ?? []).isEmpty {
                Text("No reviews yet.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ItemDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let ingredient: Ingredient
    let onAdd: (Ingredient) -> Void
    @State private var quantity = 1
    @State private var variant = "Regular"
    @State private var extras: Set<String> = []
    @State private var notes = ""

    private let variants = ["Small", "Regular", "Large"]
    private let extraOptions: [(String, Double)] = [("Extra Cheese", 50), ("Protein Boost", 120), ("Spicy Sauce", 30)]

    private var total: Double {
        let extrasCost = extraOptions.filter { extras.contains($0.0) }.reduce(0) { $0 + $1.1 }
        return (ingredient.price * 100 + extrasCost) * Double(quantity)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.orange.opacity(0.2))
                    .frame(height: 180)
                    .overlay(Image(systemName: "photo").font(.largeTitle))
                Text(ingredient.name).font(.title3.bold())
                Text(ingredient.details.isEmpty ? "Chef-crafted dish with fresh ingredients." : ingredient.details)
                    .font(.subheadline).foregroundStyle(.secondary)
                Text(ingredient.nutritionalNotes.isEmpty ? "Nutritional notes available on request." : ingredient.nutritionalNotes)
                    .font(.caption)
                Picker("Size", selection: $variant) {
                    ForEach(variants, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.segmented)
                VStack(alignment: .leading) {
                    Text("Extras")
                    ForEach(extraOptions, id: \.0) { option in
                        Toggle("\(option.0) +\((option.1 / 100).currencyString())", isOn: Binding(
                            get: { extras.contains(option.0) },
                            set: { isOn in
                                if isOn { extras.insert(option.0) } else { extras.remove(option.0) }
                            })
                        )
                    }
                }
                TextField("Special instructions", text: $notes, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                Spacer()
                Button("Add to Cart • \((total / 100).currencyString())") {
                    var customized = ingredient
                    customized.details = "Variant: \(variant). Notes: \(notes)"
                    onAdd(customized)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .navigationTitle("Customize Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
