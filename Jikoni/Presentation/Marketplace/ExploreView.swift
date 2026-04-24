import SwiftUI
import MapKit

struct ExploreView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State var viewModel: MarketplaceViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if viewModel.isMapView {
                    vendorMap
                } else {
                    vendorGrid
                }
                
                FloatingCartButton(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Discover")
                        .font(.custom("Georgia-Bold", size: 24))
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                            viewModel.isMapView.toggle()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: viewModel.isMapView ? "square.grid.2x2.fill" : "map.fill")
                            Text(viewModel.isMapView ? "Grid" : "Map")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "D4AF37").opacity(0.1))
                        .foregroundStyle(Color(hex: "D4AF37"))
                        .clipShape(Capsule())
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Dish, restaurant, cuisine")
            .safeAreaInset(edge: .top) {
                filtersPanel
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.filteredVendors.count)
            .task {
                await viewModel.fetchVendors()
            }
        }
    }
    
    private var vendorGrid: some View {
        ScrollView {
            featuredBanners
                .padding(.top, 8)

            recentlyOrdered

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredVendors) { vendor in
                    NavigationLink {
                        VendorDetailView(vendor: vendor)
                    } label: {
                        VendorCard(vendor: vendor)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
        }
        .background(
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color(hex: "111111"), Color(hex: "1A1A1A"), Color(hex: "262014")]
                    : [Color(hex: "FFFCF5"), Color.white, Color(hex: "F5EAD6")],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var vendorMap: some View {
        Map {
            ForEach(viewModel.filteredVendors) { vendor in
                Annotation(vendor.name, coordinate: CLLocationCoordinate2D(latitude: vendor.location.latitude, longitude: vendor.location.longitude)) {
                    NavigationLink {
                        VendorDetailView(vendor: vendor)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color(hex: "D4AF37"))
                                .background(.black)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                            
                            Text(vendor.name)
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
    }

    private var filtersPanel: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !viewModel.searchQuery.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.suggestedSearches(), id: \.self) { suggestion in
                            Button(suggestion) { viewModel.searchQuery = suggestion }
                                .buttonStyle(.bordered)
                        }
                    }
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.cuisineChips, id: \.self) { chip in
                        Button(chip) {
                            viewModel.selectedCuisine = (viewModel.selectedCuisine == chip ? nil : chip)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(viewModel.selectedCuisine == chip ? .orange : .gray.opacity(0.4))
                    }
                }
            }

            HStack {
                Toggle("Open Now", isOn: $viewModel.showOpenNowOnly)
                Spacer()
                Menu("Filters") {
                    Menu("Dietary") {
                        ForEach(["Halal", "Vegan", "Gluten-Free"], id: \.self) { tag in
                            Button(viewModel.selectedDietaryTags.contains(tag) ? "Remove \(tag)" : "Add \(tag)") {
                                if viewModel.selectedDietaryTags.contains(tag) {
                                    viewModel.selectedDietaryTags.remove(tag)
                                } else {
                                    viewModel.selectedDietaryTags.insert(tag)
                                }
                            }
                        }
                    }
                    Picker("Max Delivery", selection: $viewModel.maxDeliveryMinutes) {
                        Text("20m").tag(20)
                        Text("30m").tag(30)
                        Text("45m").tag(45)
                        Text("60m").tag(60)
                    }
                    Picker("Rating", selection: $viewModel.minimumRating) {
                        Text("Any").tag(0.0)
                        Text("4.0+").tag(4.0)
                        Text("4.5+").tag(4.5)
                    }
                    Picker("Price", selection: Binding(get: { viewModel.selectedPriceRange ?? "Any" }, set: { viewModel.selectedPriceRange = $0 == "Any" ? nil : $0 })) {
                        Text("Any").tag("Any")
                        Text("$").tag("$")
                        Text("$$").tag("$$")
                        Text("$$$").tag("$$$")
                    }
                }
            }
            .font(.subheadline)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "D4AF37").opacity(0.25), lineWidth: 1)
                .padding(.horizontal, 10)
        )
    }

    private var featuredBanners: some View {
        TabView {
            ForEach(viewModel.featuredVendors.isEmpty ? Array(viewModel.filteredVendors.prefix(4)) : viewModel.featuredVendors) { vendor in
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: vendor.imageUrls.first ?? "")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Rectangle().fill(.gray.opacity(0.2))
                    }
                    LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    VStack(alignment: .leading) {
                        Text("Flash Deal")
                            .font(.caption.bold())
                            .padding(6)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "F8E7B5"), Color(hex: "D4AF37")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundStyle(.black)
                            .clipShape(Capsule())
                        Text(vendor.name).font(.headline).foregroundStyle(.white)
                    }
                    .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 12)
            }
        }
        .frame(height: 170)
        .tabViewStyle(.page)
    }

    private var recentlyOrdered: some View {
        let recent = viewModel.recentRestaurantIds.compactMap { viewModel.vendorForId($0) }
        return Group {
            if !recent.isEmpty {
                VStack(alignment: .leading) {
                    Text("Recently Ordered")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? Color(hex: "F8E7B5") : Color(hex: "8B6D1F"))
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(recent) { vendor in
                                NavigationLink(vendor.name) {
                                    VendorDetailView(vendor: vendor)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color(hex: "D4AF37"))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
