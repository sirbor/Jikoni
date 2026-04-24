import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(HubViewModel.self) private var hubViewModel
    let user: User
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    headerCard
                }
                
                Section("Delivery Hub") {
                    NavigationLink(destination: SavedRecipesView()) {
                        Label("Saved Meals", systemImage: "book.fill")
                    }
                    
                    NavigationLink(destination: SavedRecipesView()) {
                        Label("Wishlist", systemImage: "heart.fill")
                    }
                    
                    NavigationLink(destination: OrderHistoryView(viewModel: hubViewModel)) {
                        Label("Order History", systemImage: "clock.fill")
                    }
                    NavigationLink(destination: RewardsView(viewModel: hubViewModel)) {
                        Label("Rewards & Points", systemImage: "star.fill")
                    }
                    NavigationLink(destination: FavoritesView()) {
                        Label("Favourites", systemImage: "heart.text.square")
                    }
                }
                
                Section("Settings") {
                    NavigationLink(destination: AddressVaultView()) {
                        Label("Addresses", systemImage: "mappin")
                    }
                    NavigationLink(destination: PaymentVaultView()) {
                        Label("Payments", systemImage: "creditcard")
                    }
                    NavigationLink(destination: SupportCenterView()) {
                        Label("Support Center", systemImage: "lifepreserver")
                    }
                    NavigationLink(destination: SettingsView()) {
                        Label("App Settings", systemImage: "gearshape")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        Task { await hubViewModel.signOut() }
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                avatar

                VStack(alignment: .leading, spacing: 4) {
                    Text(user.displayName ?? "Jikoni Customer")
                        .font(.title3.bold())
                        .foregroundStyle(primaryCardTextColor)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundStyle(secondaryCardTextColor)
                    tierChip
                }
                Spacer()
                NavigationLink(destination: EditProfileView()) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(hex: "D4AF37"))
                        .padding(10)
                        .background(.white.opacity(0.22))
                        .clipShape(Circle())
                }
            }

            if !user.profileBio.isEmpty {
                Text(user.profileBio)
                    .font(.subheadline)
                    .foregroundStyle(secondaryCardTextColor)
            }

            HStack {
                stat(title: "Orders", value: "\(hubViewModel.orders.count)")
                stat(title: "Points", value: "\(user.loyaltyPoints)")
                stat(title: "Saved", value: "\(user.cookbookIds.count)")
            }

            if let defaultAddress = user.addresses.first(where: { $0.isDefault }) {
                Label("\(defaultAddress.label): \(defaultAddress.line1), \(defaultAddress.city)", systemImage: "location.fill")
                    .font(.caption)
                    .foregroundStyle(primaryCardTextColor)
                    .padding(10)
                    .background(colorScheme == .dark ? .white.opacity(0.14) : .black.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                LinearGradient(
                    colors: colorScheme == .dark
                        ? [
                            Color(hex: "D4AF37").opacity(0.30),
                            .white.opacity(0.10),
                            Color(hex: "8A6A1C").opacity(0.24)
                        ]
                        : [
                            Color(hex: "F8E7B5").opacity(0.80),
                            Color(hex: "D4AF37").opacity(0.45),
                            .white.opacity(0.60)
                        ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(colorScheme == .dark ? .white.opacity(0.30) : Color(hex: "8A6A1C").opacity(0.28), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.14), radius: 16, x: 0, y: 8)
        .listRowInsets(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0))
        .listRowBackground(Color.clear)
    }

    private var avatar: some View {
        Group {
            if let imageUrl = user.profileImageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.1))
                }
            } else {
                Circle()
                    .fill(.black)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color(hex: "D4AF37"))
                            .font(.system(size: 30))
                    }
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(hex: "D4AF37"), lineWidth: 2.2))
        .shadow(color: Color(hex: "D4AF37").opacity(0.35), radius: 8, x: 0, y: 2)
    }

    private var tierChip: some View {
        Text(user.membershipTier.rawValue.capitalized + " Member")
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.orange.opacity(0.15))
            .foregroundStyle(.orange)
            .clipShape(Capsule())
    }

    private func stat(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline)
                .foregroundStyle(primaryCardTextColor)
            Text(title)
                .font(.caption2)
                .foregroundStyle(secondaryCardTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(colorScheme == .dark ? .white.opacity(0.12) : .black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var primaryCardTextColor: Color {
        colorScheme == .dark ? .white : Color(hex: "1F1A10")
    }

    private var secondaryCardTextColor: Color {
        colorScheme == .dark ? .white.opacity(0.82) : Color(hex: "5A4A2A")
    }
}

struct FavoritesView: View {
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel

    var body: some View {
        List {
            Section("Favourite Restaurants") {
                let vendors = marketplaceViewModel.vendors.filter { marketplaceViewModel.favoriteRestaurantIds.contains($0.id) }
                if vendors.isEmpty {
                    Text("No favourite restaurants yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(vendors) { vendor in
                        VStack(alignment: .leading) {
                            Text(vendor.name).fontWeight(.semibold)
                            Text(vendor.cuisine).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Favourite Dishes") {
                if marketplaceViewModel.favoriteDishIds.isEmpty {
                    Text("No favourite dishes yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(marketplaceViewModel.favoriteDishIds), id: \.self) { dish in
                        Text(dish)
                    }
                }
            }
        }
        .navigationTitle("Favourites")
    }
}
