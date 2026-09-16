import SwiftUI

/// Portion and add-ons priced live — the running total sits in the button,
/// so nobody taps "add" without knowing the number.
struct ItemDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    let vendor: Vendor
    let ingredient: Ingredient

    @State private var quantity = 1
    @State private var variant = "Regular"
    @State private var extras: Set<String> = []

    private let variants = ["Small", "Regular", "Large"]
    private let variantMultiplier: [String: Double] = ["Small": 0.7, "Regular": 1.0, "Large": 1.4]
    private let extraOptions: [(String, Double)] = [("Extra portion", 150), ("Extra sauce", 80), ("Spicy", 0)]

    private var total: Double {
        let base = ingredient.price * (variantMultiplier[variant] ?? 1)
        let extrasCost = extraOptions.filter { extras.contains($0.0) }.reduce(0) { $0 + $1.1 }
        return (base + extrasCost) * Double(quantity)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                photoHeader

                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(ingredient.name)
                                .font(JikoniFont.instrumentSerif(29))
                                .foregroundStyle(JikoniColor.ink)
                            Text(vendor.name)
                                .font(JikoniFont.archivo(11.5))
                                .foregroundStyle(JikoniColor.textSecondary)
                        }
                        Spacer()
                        Text(ingredient.price.currencyString())
                            .font(JikoniFont.archivo(23, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)
                    }

                    // Meta chips
                    HStack(spacing: 8) {
                        itemChip(icon: "location.fill", text: "1.8 km")
                        itemChip(icon: "clock.fill", text: "25–35 min")
                        itemChip(icon: "star.fill", text: String(format: "%.1f", vendor.rating))
                        itemChip(icon: "flame.fill", text: "620 kcal")
                    }

                    Text(ingredient.details.isEmpty ? "Charcoal-grilled goat ribs cut against the grain, served with raw tomato-and-onion kachumbari and a wedge of lime." : ingredient.details)
                        .font(JikoniFont.archivo(13))
                        .foregroundStyle(JikoniColor.textBody)

                    Text("Portion")
                        .font(JikoniFont.archivo(16, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                    HStack(spacing: 9) {
                        ForEach(variants, id: \.self) { size in
                            let selected = variant == size
                            Button {
                                variant = size
                            } label: {
                                VStack(spacing: 4) {
                                    Text(size)
                                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                                    Text(sizedPrice(size).currencyString())
                                        .font(JikoniFont.archivo(11))
                                }
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(selected ? JikoniColor.ink : JikoniColor.ground)
                                .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.ink)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Text("Add-ons")
                        .font(JikoniFont.archivo(16, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                    VStack(spacing: 0) {
                        ForEach(Array(extraOptions.enumerated()), id: \.offset) { index, option in
                            Button {
                                if extras.contains(option.0) { extras.remove(option.0) } else { extras.insert(option.0) }
                            } label: {
                                HStack {
                                    let on = extras.contains(option.0)
                                    Image(systemName: on ? "checkmark.square.fill" : "square")
                                        .foregroundStyle(on ? JikoniColor.ink : JikoniColor.placeholder)
                                    Text(option.0)
                                        .font(JikoniFont.archivo(13))
                                        .foregroundStyle(JikoniColor.ink)
                                    Spacer()
                                    Text(option.1 > 0 ? "+\(option.1.currencyString())" : "Free")
                                        .font(JikoniFont.archivo(12, weight: .extrabold))
                                        .foregroundStyle(JikoniColor.textSecondary)
                                }
                                .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)
                            if index < extraOptions.count - 1 { Divider().opacity(0.4) }
                        }
                    }
                    .padding(.horizontal, 16)
                    .background(JikoniColor.ground)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))

                    HStack(spacing: 11) {
                        HStack(spacing: 6) {
                            Button { quantity = max(1, quantity - 1) } label: {
                                Image(systemName: "minus").font(.system(size: 13, weight: .bold))
                                    .frame(width: 40, height: 40).background(JikoniColor.card).foregroundStyle(JikoniColor.ink).clipShape(Circle())
                            }
                            Text("\(quantity)").font(JikoniFont.archivo(15, weight: .extrabold)).frame(minWidth: 20)
                            Button { quantity += 1 } label: {
                                Image(systemName: "plus").font(.system(size: 13, weight: .bold))
                                    .frame(width: 40, height: 40).background(JikoniColor.ink).foregroundStyle(JikoniColor.ground).clipShape(Circle())
                            }
                        }
                        .padding(5)
                        .background(JikoniColor.ground)
                        .clipShape(Capsule())

                        Button {
                            var customized = ingredient
                            customized.price = (total / Double(quantity))
                            customized.details = "Variant: \(variant)" + (extras.isEmpty ? "" : ", " + extras.joined(separator: ", "))
                            for _ in 0..<quantity {
                                marketplaceViewModel.addToCart(ingredient: customized)
                            }
                            if marketplaceViewModel.cartConflict == nil {
                                dismiss()
                            }
                        } label: {
                            HStack {
                                Text("Add to basket")
                                Spacer()
                                Text(total.currencyString())
                            }
                            .font(JikoniFont.archivo(14, weight: .extrabold))
                            .padding(.horizontal, 22)
                            .frame(height: 56)
                            .background(JikoniColor.ink)
                            .foregroundStyle(JikoniColor.ground)
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(18)
                .padding(.bottom, 30)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .sheet(item: Bindable(marketplaceViewModel).cartConflict) { conflict in
            CartConflictSheet(conflict: conflict, viewModel: marketplaceViewModel)
        }
    }

    private func itemChip(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundStyle(JikoniColor.accent)
            Text(text)
                .font(JikoniFont.archivo(11.5, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 8)
        .background(JikoniColor.ground)
        .clipShape(Capsule())
    }

    private func sizedPrice(_ size: String) -> Double {
        ingredient.price * (variantMultiplier[size] ?? 1)
    }

    private var photoHeader: some View {
        JikoniPhotoHeader(imageUrl: ingredient.imageUrl, height: 328) {
            ZStack(alignment: .bottom) {
                HStack {
                    JikoniCircleButton(systemImage: "chevron.left", accessibilityText: "Back") { dismiss() }
                    Spacer()
                    let isFav = marketplaceViewModel.favoriteDishIds.contains(ingredient.id)
                    JikoniCircleButton(
                        systemImage: isFav ? "heart.fill" : "heart",
                        isFilled: isFav,
                        accessibilityText: "Favorite"
                    ) {
                        marketplaceViewModel.toggleFavoriteDish(ingredient.id)
                    }
                }

                HStack(spacing: 6) {
                    Capsule().fill(JikoniColor.ink).frame(width: 22, height: 6)
                    Circle().fill(JikoniColor.ink.opacity(0.3)).frame(width: 6, height: 6)
                    Circle().fill(JikoniColor.ink.opacity(0.3)).frame(width: 6, height: 6)
                }
                .padding(.bottom, 20)
            }
        }
    }
}
