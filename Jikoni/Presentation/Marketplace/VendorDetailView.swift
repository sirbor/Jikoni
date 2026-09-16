import SwiftUI

struct VendorDetailView: View {
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(FeedViewModel.self) private var feedViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss
    let vendor: Vendor
    @State private var selectedIngredient: Ingredient?
    @State private var showReviewSheet = false

    private var currentVendor: Vendor {
        marketplaceViewModel.vendorForId(vendor.id) ?? vendor
    }

    private var linkedRecipe: Recipe? {
        feedViewModel.recipes.first { $0.vendorId == vendor.id }
    }

    private var orderedCategories: [String] {
        let inventory = currentVendor.inventory ?? [:]
        return inventory.keys.sorted()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                photoHeader

                VStack(alignment: .leading, spacing: 22) {
                    header
                    statRow

                    if let recipe = linkedRecipe {
                        Text("From the Jikoni feed")
                            .font(JikoniFont.archivo(17, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            linkedRecipeRow(recipe)
                        }
                        .buttonStyle(.plain)
                    }

                    ForEach(orderedCategories, id: \.self) { category in
                        if let items = currentVendor.inventory?[category] {
                            Text(category)
                                .font(JikoniFont.archivo(17, weight: .extrabold))
                                .foregroundStyle(JikoniColor.ink)
                            VStack(spacing: 10) {
                                ForEach(items) { item in
                                    Button { selectedIngredient = item } label: {
                                        menuRow(item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    reviewsSection
                }
                .padding(18)
                .padding(.bottom, 100)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            FloatingCartButton(viewModel: marketplaceViewModel)
                .padding(.bottom, 20)
        }
        .sheet(item: $selectedIngredient) { ingredient in
            ItemDetailView(vendor: currentVendor, ingredient: ingredient)
        }
        .sheet(item: Bindable(marketplaceViewModel).cartConflict) { conflict in
            CartConflictSheet(conflict: conflict, viewModel: marketplaceViewModel)
        }
        .sheet(isPresented: $showReviewSheet) {
            AddVendorReviewSheet(vendor: currentVendor)
        }
    }

    private var photoHeader: some View {
        JikoniPhotoHeader(imageUrl: vendor.imageUrls.first, height: 200) {
            HStack {
                JikoniCircleButton(systemImage: "chevron.left", accessibilityText: "Back") { dismiss() }
                Spacer()
                let isFav = marketplaceViewModel.isFavoriteRestaurant(vendor.id)
                JikoniCircleButton(
                    systemImage: isFav ? "heart.fill" : "heart",
                    isFilled: isFav,
                    accessibilityText: "Save kitchen"
                ) {
                    marketplaceViewModel.toggleFavoriteRestaurant(vendor.id)
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(currentVendor.name)
                    .font(JikoniFont.archivo(24, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Text("\(currentVendor.cuisine) · \(currentVendor.location.latitude == 0 ? "" : "1.8 km")")
                    .font(JikoniFont.archivo(12))
                    .foregroundStyle(JikoniColor.textSecondary)
            }
            Spacer()
            Text(currentVendor.isOpenNow ? "Open till \(currentVendor.openingHours.split(separator: "-").last.map(String.init) ?? "late")" : "Closed")
                .font(JikoniFont.archivo(10.5, weight: .extrabold))
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(JikoniColor.card)
                .foregroundStyle(JikoniColor.textSecondary)
                .clipShape(Capsule())
                .jikoniShadow(.small)
        }
    }

    private var statRow: some View {
        HStack(spacing: 10) {
            statBox(title: "Rating", value: String(format: "%.1f", currentVendor.rating))
            statBox(title: "Arrives", value: "\(currentVendor.estimatedDeliveryMinutes)m")
            statBox(title: "Delivery", value: currentVendor.deliveryFee.currencyString())
        }
    }

    private func statBox(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(JikoniFont.archivo(9.5, weight: .extrabold))
                .foregroundStyle(JikoniColor.textSecondary)
            Text(value)
                .font(JikoniFont.archivo(17, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
        .jikoniShadow(.small)
    }

    private func linkedRecipeRow(_ recipe: Recipe) -> some View {
        HStack(spacing: 13) {
            AsyncImage(url: URL(string: recipe.imageUrls.first ?? "")) { phase in
                if case .success(let image) = phase {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    JikoniColor.placeholder
                }
            }
            .frame(width: 84, height: 84)
            .clipShape(RoundedRectangle(cornerRadius: 18))

            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.title)
                    .font(JikoniFont.instrumentSerif(19))
                    .foregroundStyle(JikoniColor.ink)
                Text("\(recipe.author)'s recipe")
                    .font(JikoniFont.archivo(11))
                    .foregroundStyle(JikoniColor.textSecondary)
                Text("View recipe")
                    .font(JikoniFont.archivo(11, weight: .extrabold))
                    .foregroundStyle(JikoniColor.accent)
            }
            Spacer()
        }
        .padding(10)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .jikoniShadow(.small)
    }

    private func menuRow(_ item: Ingredient) -> some View {
        HStack(spacing: 13) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(JikoniFont.archivo(14, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Text(item.details.isEmpty ? item.amount : item.details)
                    .font(JikoniFont.archivo(11.5))
                    .foregroundStyle(JikoniColor.textSecondary)
                    .lineLimit(2)
                Text(item.price.currencyString())
                    .font(JikoniFont.archivo(13.5, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
            }
            Spacer()
            Button {
                marketplaceViewModel.addToCart(ingredient: item)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(JikoniColor.ink)
                    .frame(width: 40, height: 40)
                    .background(JikoniColor.ground)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
        .jikoniShadow(.small)
    }

    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Kitchen Reviews")
                        .font(JikoniFont.archivo(17, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(JikoniColor.accent)
                        Text(String(format: "%.1f", currentVendor.rating))
                            .font(JikoniFont.archivo(12, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)
                        let count = currentVendor.reviews?.count ?? currentVendor.reviewCount
                        Text("(\(count) \(count == 1 ? "review" : "reviews"))")
                            .font(JikoniFont.archivo(12))
                            .foregroundStyle(JikoniColor.textSecondary)
                    }
                }

                Spacer()

                Button {
                    showReviewSheet = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 11))
                        Text("Add Review")
                            .font(JikoniFont.archivo(12, weight: .extrabold))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(JikoniColor.card)
                    .foregroundStyle(JikoniColor.ink)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(JikoniColor.placeholder, lineWidth: 1)
                    )
                }
            }
            .padding(.top, 10)

            if let reviews = currentVendor.reviews, !reviews.isEmpty {
                VStack(spacing: 10) {
                    ForEach(reviews) { review in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(review.author)
                                    .font(JikoniFont.archivo(13, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                                Spacer()
                                HStack(spacing: 2) {
                                    ForEach(1...5, id: \.self) { star in
                                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                                            .font(.system(size: 10))
                                            .foregroundStyle(star <= review.rating ? JikoniColor.accent : JikoniColor.placeholder)
                                    }
                                }
                            }

                            Text(review.comment)
                                .font(JikoniFont.archivo(12.5))
                                .foregroundStyle(JikoniColor.textBody)
                                .lineSpacing(2)

                            Text(review.date.formatted(date: .abbreviated, time: .omitted))
                                .font(JikoniFont.archivo(10.5))
                                .foregroundStyle(JikoniColor.textSecondary)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                        .jikoniShadow(.small)
                    }
                }
            } else {
                Text("No reviews yet. Be the first to review this kitchen!")
                    .font(JikoniFont.archivo(12))
                    .foregroundStyle(JikoniColor.textSecondary)
                    .padding(.vertical, 8)
            }
        }
    }
}

/// The multi-kitchen conflict sheet from the Modernist design canvas — three explicit ways out.
struct CartConflictSheet: View {
    let conflict: CartConflict
    @Bindable var viewModel: MarketplaceViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .fill(JikoniColor.placeholder)
                .frame(width: 44, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 14)
                .padding(.bottom, 20)

            Text("DIFFERENT KITCHEN")
                .font(JikoniFont.archivo(11, weight: .extrabold))
                .tracking(1.4)
                .foregroundStyle(JikoniColor.accent)

            Text("Start a new basket?")
                .font(JikoniFont.instrumentSerif(30))
                .foregroundStyle(JikoniColor.ink)
                .padding(.top, 8)

            Text("Your basket has items from **\(conflict.existingVendorName)**. Jikoni delivers one kitchen per trip, so adding **\(conflict.pendingIngredient.name)** starts a fresh basket.")
                .font(JikoniFont.archivo(13.5))
                .foregroundStyle(JikoniColor.textBody)
                .padding(.top, 10)

            VStack(spacing: 9) {
                Button {
                    viewModel.resolveConflictWithNewBasket()
                    dismiss()
                } label: {
                    Text("Start new basket here")
                        .font(JikoniFont.archivo(14, weight: .extrabold))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 52)
                        .background(JikoniColor.ink)
                        .foregroundStyle(JikoniColor.ground)
                        .clipShape(Capsule())
                }

                Button {
                    viewModel.resolveConflictKeepingExisting()
                    dismiss()
                } label: {
                    Text("Keep \(conflict.existingVendorName)")
                        .font(JikoniFont.archivo(14, weight: .extrabold))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 52)
                        .background(JikoniColor.ground)
                        .foregroundStyle(JikoniColor.ink)
                        .clipShape(Capsule())
                }

                Button {
                    viewModel.resolveConflictKeepingExisting()
                    dismiss()
                } label: {
                    Text("Schedule both — deliver separately")
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 44)
                        .background(Color.clear)
                        .foregroundStyle(JikoniColor.textSecondary)
                }
            }
            .padding(.top, 24)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .background(JikoniColor.card)
        .presentationDetents([.fraction(0.48), .medium])
        .presentationDragIndicator(.hidden)
    }
}

struct AddVendorReviewSheet: View {
    let vendor: Vendor
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var rating = 5
    @State private var comment = ""
    @State private var isSubmitting = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Capsule()
                .fill(JikoniColor.placeholder)
                .frame(width: 44, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.top, 14)

            Text("REVIEW KITCHEN")
                .font(JikoniFont.archivo(11, weight: .extrabold))
                .tracking(1.4)
                .foregroundStyle(JikoniColor.accent)

            Text("Rate \(vendor.name)")
                .font(JikoniFont.instrumentSerif(28))
                .foregroundStyle(JikoniColor.ink)

            // Star selector
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        rating = star
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 26))
                            .foregroundStyle(star <= rating ? JikoniColor.accent : JikoniColor.placeholder)
                    }
                    .buttonStyle(.plain)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Your Experience")
                    .font(JikoniFont.archivo(12, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)

                TextField("What did you enjoy? (e.g. food quality, delivery speed, flavors)", text: $comment, axis: .vertical)
                    .lineLimit(3...5)
                    .font(JikoniFont.archivo(13))
                    .padding(14)
                    .background(JikoniColor.ground)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
            }

            Button {
                let trimmed = comment.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return }
                isSubmitting = true
                let authorName = hubViewModel.currentUser?.displayName ?? "Guest Cook"
                let newReview = Review(author: authorName, comment: trimmed, rating: rating)
                Task {
                    await marketplaceViewModel.addVendorReview(vendorId: vendor.id, review: newReview)
                    isSubmitting = false
                    dismiss()
                }
            } label: {
                if isSubmitting {
                    ProgressView().tint(JikoniColor.ground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                } else {
                    Text("Submit Review")
                        .font(JikoniFont.archivo(14, weight: .extrabold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
            }
            .background(comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? JikoniColor.placeholder : JikoniColor.ink)
            .foregroundStyle(JikoniColor.ground)
            .clipShape(Capsule())
            .disabled(comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSubmitting)

            Spacer()
        }
        .padding(.horizontal, 20)
        .background(JikoniColor.card)
        .presentationDetents([.fraction(0.55), .medium])
    }
}

