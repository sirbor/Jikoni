import SwiftUI
import MapKit

/// Dish-first, not vendor-first — "Popular tonight" flattens every vendor's
/// menu into one grid, since people order a plate, not a restaurant.
struct OrderView: View {
    @Bindable var viewModel: MarketplaceViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    @State private var showAddress = false
    @State private var showCart = false

    private var allDishes: [(vendor: Vendor, dish: Ingredient)] {
        var result: [(vendor: Vendor, dish: Ingredient)] = []
        for vendor in viewModel.filteredVendors {
            for items in (vendor.inventory ?? [:]).values {
                for item in items { result.append((vendor, item)) }
            }
        }
        return result
    }

    private var popularDishes: [(vendor: Vendor, dish: Ingredient)] {
        Array(allDishes.sorted { $0.vendor.rating > $1.vendor.rating }.prefix(6))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header
                    searchAndFilter
                    addressRow
                    promoBanner

                    if !viewModel.cuisineChips.isEmpty {
                        categoryTiles
                    }

                    if !popularDishes.isEmpty {
                        sectionHeader("Popular tonight")
                        popularGrid
                    }

                    if !viewModel.filteredVendors.isEmpty {
                        sectionHeader("Kitchens near you")
                        VStack(spacing: 12) {
                            ForEach(viewModel.filteredVendors) { vendor in
                                NavigationLink { VendorDetailView(vendor: vendor) } label: {
                                    vendorRow(vendor)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 18)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(JikoniColor.ground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .task { if viewModel.vendors.isEmpty { await viewModel.fetchVendors() } }
            .refreshable { await viewModel.fetchVendors() }
            .overlay(alignment: .bottom) {
                FloatingCartButton(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
            .sheet(isPresented: $showAddress) { AddressView() }
            .sheet(isPresented: $showCart) { CartView(viewModel: viewModel) }
            .sheet(item: Bindable(viewModel).cartConflict) { conflict in
                CartConflictSheet(conflict: conflict, viewModel: viewModel)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Habari, \(hubViewModel.currentUser?.displayName ?? "there")!")
                    .font(JikoniFont.archivo(19, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Text("What are we ordering tonight?")
                    .font(JikoniFont.archivo(12.5))
                    .foregroundStyle(JikoniColor.textSecondary)
            }
            Spacer()
            Button { showCart = true } label: {
                Image(systemName: "bag")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(JikoniColor.ink)
                    .frame(width: 44, height: 44)
                    .background(JikoniColor.card)
                    .clipShape(Circle())
                    .jikoniShadow(.small)
            }
            Button { viewModel.isMapView.toggle() } label: {
                Image(systemName: "map")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(JikoniColor.ink)
                    .frame(width: 44, height: 44)
                    .background(JikoniColor.card)
                    .clipShape(Circle())
                    .jikoniShadow(.small)
            }
        }
        .padding(.horizontal, 18)
        .sheet(isPresented: $viewModel.isMapView) { vendorMap }
    }

    private var searchAndFilter: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass").foregroundStyle(JikoniColor.textSecondary)
                TextField("search dishes and kitchens", text: $viewModel.searchQuery)
                    .font(JikoniFont.archivo(13.5))
                if !viewModel.searchQuery.isEmpty {
                    Button {
                        viewModel.searchQuery = ""
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

            Button { viewModel.showOpenNowOnly.toggle() } label: {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(viewModel.showOpenNowOnly ? .white : JikoniColor.ink)
                    .frame(width: 52, height: 52)
                    .background(viewModel.showOpenNowOnly ? JikoniColor.ink : JikoniColor.card)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 18)
    }

    private var addressRow: some View {
        Button { showAddress = true } label: {
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(JikoniColor.accent)
                VStack(alignment: .leading, spacing: 3) {
                    Text(hubViewModel.currentUser?.addresses.first(where: \.isDefault)?.line1 ?? "Add a delivery address")
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                    Text("Delivering to this address tonight")
                        .font(JikoniFont.archivo(11))
                        .foregroundStyle(JikoniColor.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(JikoniColor.textSecondary)
            }
            .padding(14)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
            .jikoniShadow(.small)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 18)
    }

    private var promoBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("KARIBU10")
                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    .foregroundStyle(JikoniColor.accent)
                Text("10% off your first order tonight")
                    .font(JikoniFont.archivo(13.5, weight: .extrabold))
                    .foregroundStyle(.white)
            }
            Spacer()
            Button {
                viewModel.promoCode = "KARIBU10"
                viewModel.applyPromoCode()
            } label: {
                Text(viewModel.promoDiscount > 0 ? "Applied" : "Get started")
                    .font(JikoniFont.archivo(12, weight: .extrabold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.white)
                    .foregroundStyle(JikoniColor.ink)
                    .clipShape(Capsule())
            }
            .disabled(viewModel.promoDiscount > 0)
        }
        .padding(16)
        .background(JikoniColor.ink)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .padding(.horizontal, 18)
    }

    private var categoryTiles: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.cuisineChips, id: \.self) { cuisine in
                    let selected = viewModel.selectedCuisine == cuisine
                    Button {
                        viewModel.selectedCuisine = selected ? nil : cuisine
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "fork.knife.circle.fill").font(.system(size: 22))
                            Text(cuisine).font(JikoniFont.archivo(10.5, weight: .extrabold)).lineLimit(1)
                        }
                        .frame(width: 76, height: 76)
                        .background(selected ? JikoniColor.ink : JikoniColor.card)
                        .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.ink)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                        .jikoniShadow(.small)
                    }
                }
            }
            .padding(.horizontal, 18)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(JikoniFont.archivo(17, weight: .extrabold))
            .foregroundStyle(JikoniColor.ink)
            .padding(.horizontal, 18)
    }

    private var popularGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
            ForEach(Array(popularDishes.enumerated()), id: \.offset) { _, pair in
                NavigationLink { ItemDetailView(vendor: pair.vendor, ingredient: pair.dish) } label: {
                    dishTile(pair.vendor, pair.dish)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 18)
    }

    private func dishTile(_ vendor: Vendor, _ dish: Ingredient) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: dish.imageUrl ?? "")) { phase in
                switch phase {
                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                default: Rectangle().fill(JikoniColor.placeholder)
                }
            }
            .frame(height: 110)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.cardSmall - 1))

            VStack(alignment: .leading, spacing: 4) {
                Text(dish.name).font(JikoniFont.archivo(12.5, weight: .extrabold)).foregroundStyle(JikoniColor.ink).lineLimit(1)
                Text(vendor.name).font(JikoniFont.archivo(10.5)).foregroundStyle(JikoniColor.textSecondary).lineLimit(1)
                Text(dish.price.currencyString()).font(JikoniFont.archivo(12, weight: .extrabold)).foregroundStyle(JikoniColor.ink)
            }
            .padding(EdgeInsets(top: 9, leading: 8, bottom: 9, trailing: 8))
        }
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.cardSmall))
        .jikoniShadow(.small)
    }

    private func vendorRow(_ vendor: Vendor) -> some View {
        HStack(spacing: 13) {
            AsyncImage(url: URL(string: vendor.imageUrls.first ?? "")) { phase in
                switch phase {
                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                default: Rectangle().fill(JikoniColor.placeholder)
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 4) {
                Text(vendor.name).font(JikoniFont.archivo(14, weight: .extrabold)).foregroundStyle(JikoniColor.ink)
                Text(vendor.cuisine).font(JikoniFont.archivo(11.5)).foregroundStyle(JikoniColor.textSecondary)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(JikoniColor.accent)
                    Text("\(String(format: "%.1f", vendor.rating)) · \(vendor.estimatedDeliveryMinutes) min")
                        .font(JikoniFont.archivo(11, weight: .extrabold))
                        .foregroundStyle(JikoniColor.textSecondary)
                }
            }
            Spacer()
        }
        .padding(12)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
        .jikoniShadow(.small)
    }

    private var vendorMap: some View {
        NavigationStack {
            Map {
                ForEach(viewModel.filteredVendors) { vendor in
                    Marker(vendor.name, coordinate: .init(latitude: vendor.location.latitude, longitude: vendor.location.longitude))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { viewModel.isMapView = false }
                }
            }
        }
    }
}
