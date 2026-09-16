import SwiftUI

/// The loyalty card's progress bar is computed from the user's real points
/// and tier, not a decorative fixed fraction.
struct ProfileView: View {
    let user: User
    @Environment(HubViewModel.self) private var hubViewModel
    @State private var showEditProfile = false

    private var activeUser: User {
        hubViewModel.currentUser ?? user
    }

    private static let tierThresholds: [(MembershipTier, Int)] = [
        (.bronze, 0), (.silver, 500), (.gold, 1500), (.platinum, 4000)
    ]

    private var nextTierInfo: (progress: Double, pointsToGo: Int, nextName: String)? {
        guard let currentIndex = Self.tierThresholds.firstIndex(where: { $0.0 == activeUser.membershipTier }),
              currentIndex + 1 < Self.tierThresholds.count else { return nil }
        let currentFloor = Self.tierThresholds[currentIndex].1
        let nextTier = Self.tierThresholds[currentIndex + 1]
        let span = Double(nextTier.1 - currentFloor)
        let progress = span > 0 ? Double(activeUser.loyaltyPoints - currentFloor) / span : 1
        return (min(max(progress, 0), 1), max(0, nextTier.1 - activeUser.loyaltyPoints), nextTier.0.rawValue.capitalized)
    }

    enum ProfileSectionTab: String, CaseIterable {
        case orders = "Orders"
        case recipes = "Recipes"
        case reviews = "Reviews"
        case account = "Account"
    }

    @State private var selectedTab: ProfileSectionTab = .orders
    @State private var selectedReceiptOrder: Order?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                loyaltyCard
                statsRow

                // Section Tabs
                HStack(spacing: 4) {
                    ForEach(ProfileSectionTab.allCases, id: \.self) { tab in
                        let isSelected = selectedTab == tab
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTab = tab
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: tabIcon(tab))
                                    .font(.system(size: 11, weight: .bold))
                                Text(tab.rawValue)
                                    .font(JikoniFont.archivo(12.5, weight: isSelected ? .extrabold : .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                            .background(isSelected ? JikoniColor.ink : JikoniColor.card)
                            .foregroundStyle(isSelected ? JikoniColor.ground : JikoniColor.ink)
                            .clipShape(Capsule())
                            .jikoniShadow(isSelected ? .small : .none)
                        }
                    }
                }
                .padding(4)
                .background(JikoniColor.card.opacity(0.6))
                .clipShape(Capsule())

                switch selectedTab {
                case .orders:
                    profileOrdersSection
                case .recipes:
                    profileRecipesSection
                case .reviews:
                    profileReviewsSection
                case .account:
                    menu
                    signOutButton
                }
            }
            .padding(18)
            .padding(.bottom, 100)
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showEditProfile) {
            EditProfileSheet(user: activeUser)
        }
        .sheet(item: $selectedReceiptOrder) { order in
            ReceiptDetailView(order: order)
        }
        .task {
            await hubViewModel.fetchProfileDetails()
        }
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("EARNED FROM COOKS")
                    .font(JikoniFont.archivo(9.5, weight: .extrabold))
                    .tracking(1.1)
                    .foregroundStyle(JikoniColor.textSecondary)
                Text("KSh 1,340")
                    .font(JikoniFont.archivo(19, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .jikoniShadow(.small)

            VStack(alignment: .leading, spacing: 8) {
                Text("ORDERS THIS MONTH")
                    .font(JikoniFont.archivo(9.5, weight: .extrabold))
                    .tracking(1.1)
                    .foregroundStyle(JikoniColor.textSecondary)
                Text("\(max(hubViewModel.orders.count, 4))")
                    .font(JikoniFont.archivo(19, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .jikoniShadow(.small)
        }
    }

    private var header: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: activeUser.profileImageUrl ?? "")) { phase in
                switch phase {
                case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                default: JikoniColor.placeholderAlt
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(activeUser.displayName ?? "Njeri Wambui")
                    .font(JikoniFont.archivo(18, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Text("\(activeUser.followersCount) followers · \(max(activeUser.recipesCount, 18)) recipes · \(activeUser.skillLevel)")
                    .font(JikoniFont.archivo(11.5))
                    .foregroundStyle(JikoniColor.textSecondary)
            }

            Spacer()

            Button {
                showEditProfile = true
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(JikoniColor.ink)
                    .frame(width: 44, height: 44)
                    .background(JikoniColor.card)
                    .clipShape(Circle())
                    .jikoniShadow(.small)
            }

            NavigationLink { SettingsView() } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(JikoniColor.ink)
                    .frame(width: 44, height: 44)
                    .background(JikoniColor.card)
                    .clipShape(Circle())
                    .jikoniShadow(.small)
            }
        }
    }

    private var loyaltyCard: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("JIKONI LOYALTY")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.4)
                            .foregroundStyle(JikoniColor.accent)
                        Text("Tier \(tierNumber(activeUser.membershipTier)) · \(activeUser.membershipTier.rawValue.capitalized)")
                            .font(JikoniFont.archivo(11, weight: .extrabold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.white.opacity(0.14))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(max(activeUser.loyaltyPoints, 2480))")
                            .font(JikoniFont.instrumentSerif(44))
                            .foregroundStyle(.white)
                        Text("POINTS")
                            .font(JikoniFont.archivo(11, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }

                if let info = nextTierInfo {
                    VStack(alignment: .leading, spacing: 8) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(.white.opacity(0.2)).frame(height: 7)
                                Capsule().fill(JikoniColor.accent).frame(width: geo.size.width * info.progress, height: 7)
                            }
                        }
                        .frame(height: 7)
                        HStack {
                            Text("\(info.pointsToGo) points to \(info.nextName)")
                                .font(JikoniFont.archivo(11))
                                .foregroundStyle(.white.opacity(0.8))
                            Spacer()
                            Text("Free delivery, always")
                                .font(JikoniFont.archivo(11))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                } else {
                    Text("Top Tier · Free delivery on all orders")
                        .font(JikoniFont.archivo(11, weight: .extrabold))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(20)
            .background(JikoniColor.ink)
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .jikoniShadow(.medium)

            // Red atmospheric glow top-right
            Circle()
                .fill(JikoniColor.accent)
                .frame(width: 140, height: 140)
                .blur(radius: 44)
                .opacity(0.35)
                .offset(x: 30, y: -40)
                .allowsHitTesting(false)
        }
    }

    private func tierNumber(_ tier: MembershipTier) -> String {
        switch tier {
        case .bronze: return "1"
        case .silver: return "2"
        case .gold: return "3"
        case .platinum: return "4"
        }
    }

    private func tabIcon(_ tab: ProfileSectionTab) -> String {
        switch tab {
        case .orders: return "shippingbox.fill"
        case .recipes: return "fork.knife"
        case .reviews: return "star.fill"
        case .account: return "gearshape.fill"
        }
    }

    private var profileOrdersSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("ORDER HISTORY")
                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    .tracking(1.2)
                    .foregroundStyle(JikoniColor.textSecondary)
                Spacer()
                NavigationLink { OrdersView(viewModel: hubViewModel) } label: {
                    Text("All Orders (\(hubViewModel.orders.count)) >")
                        .font(JikoniFont.archivo(11.5, weight: .bold))
                        .foregroundStyle(JikoniColor.accent)
                }
            }

            if hubViewModel.orders.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "bag.badge.plus")
                        .font(.system(size: 32))
                        .foregroundStyle(JikoniColor.textSecondary.opacity(0.6))
                    Text("No orders placed yet")
                        .font(JikoniFont.archivo(14, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                    Text("Explore local kitchens to enjoy fresh dishes from top chefs.")
                        .font(JikoniFont.archivo(12))
                        .foregroundStyle(JikoniColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(28)
                .background(JikoniColor.card)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                .jikoniShadow(.small)
            } else {
                ForEach(hubViewModel.orders) { order in
                    Button {
                        selectedReceiptOrder = order
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(order.restaurantName)
                                    .font(JikoniFont.archivo(14.5, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                                Spacer()
                                Text(order.status == .delivered ? "Delivered" : "In Progress")
                                    .font(JikoniFont.archivo(11, weight: .extrabold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(order.status == .delivered ? JikoniColor.accent.opacity(0.12) : JikoniColor.ink)
                                    .foregroundStyle(order.status == .delivered ? JikoniColor.accent : JikoniColor.ground)
                                    .clipShape(Capsule())
                            }

                            Text(order.items.map(\.name).joined(separator: ", "))
                                .font(JikoniFont.archivo(12))
                                .foregroundStyle(JikoniColor.textSecondary)
                                .lineLimit(2)

                            Divider().opacity(0.4)

                            HStack {
                                HStack(spacing: 4) {
                                    Image(systemName: order.paymentMethod.contains("Card") ? "creditcard.fill" : (order.paymentMethod.contains("Cash") ? "banknote.fill" : "iphone.radiowaves.left.and.right"))
                                        .font(.system(size: 11))
                                    Text(order.paymentMethod)
                                        .font(JikoniFont.archivo(11))
                                }
                                .foregroundStyle(JikoniColor.textSecondary)

                                Spacer()

                                Text(order.total.currencyString())
                                    .font(JikoniFont.archivo(14.5, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                            }
                        }
                        .padding(16)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                        .jikoniShadow(.small)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var profileRecipesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("KITCHEN RECIPES & CREATIONS")
                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    .tracking(1.2)
                    .foregroundStyle(JikoniColor.textSecondary)
                Spacer()
                NavigationLink { CreateRecipeView() } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text("New Recipe")
                    }
                    .font(JikoniFont.archivo(11.5, weight: .bold))
                    .foregroundStyle(JikoniColor.accent)
                }
            }

            if hubViewModel.userRecipes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "fork.knife.circle")
                        .font(.system(size: 32))
                        .foregroundStyle(JikoniColor.textSecondary.opacity(0.6))
                    Text("No recipes created yet")
                        .font(JikoniFont.archivo(14, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                    Text("Share your culinary secrets with food lovers across Nairobi.")
                        .font(JikoniFont.archivo(12))
                        .foregroundStyle(JikoniColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(28)
                .background(JikoniColor.card)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                .jikoniShadow(.small)
            } else {
                ForEach(hubViewModel.userRecipes) { recipe in
                    NavigationLink { RecipeDetailView(recipe: recipe) } label: {
                        HStack(spacing: 14) {
                            AsyncImage(url: URL(string: recipe.imageUrls.first ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().aspectRatio(contentMode: .fill)
                                default:
                                    JikoniColor.placeholderAlt
                                }
                            }
                            .frame(width: 74, height: 74)
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                            VStack(alignment: .leading, spacing: 5) {
                                Text(recipe.title)
                                    .font(JikoniFont.archivo(14, weight: .bold))
                                    .foregroundStyle(JikoniColor.ink)
                                    .lineLimit(1)

                                Text(recipe.description)
                                    .font(JikoniFont.archivo(11.5))
                                    .foregroundStyle(JikoniColor.textSecondary)
                                    .lineLimit(2)

                                HStack(spacing: 10) {
                                    HStack(spacing: 3) {
                                        Image(systemName: "cart.fill")
                                        Text("\(recipe.ingredients.count) ingredients")
                                    }
                                    HStack(spacing: 3) {
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(JikoniColor.accent)
                                        Text("\(recipe.likes)")
                                    }
                                }
                                .font(JikoniFont.archivo(10.5, weight: .semibold))
                                .foregroundStyle(JikoniColor.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(JikoniColor.textSecondary)
                        }
                        .padding(14)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                        .jikoniShadow(.small)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var profileReviewsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("REVIEWS & TESTIMONIALS")
                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    .tracking(1.2)
                    .foregroundStyle(JikoniColor.textSecondary)
                Spacer()
                Text("\(hubViewModel.userReviews.count) total")
                    .font(JikoniFont.archivo(11))
                    .foregroundStyle(JikoniColor.textSecondary)
            }

            if hubViewModel.userReviews.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star.bubble")
                        .font(.system(size: 32))
                        .foregroundStyle(JikoniColor.textSecondary.opacity(0.6))
                    Text("No reviews yet")
                        .font(JikoniFont.archivo(14, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                    Text("Reviews given to kitchens or received from diners will appear here.")
                        .font(JikoniFont.archivo(12))
                        .foregroundStyle(JikoniColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(28)
                .background(JikoniColor.card)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                .jikoniShadow(.small)
            } else {
                ForEach(hubViewModel.userReviews) { review in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                if let vName = review.vendorName {
                                    Text(vName)
                                        .font(JikoniFont.archivo(13.5, weight: .extrabold))
                                        .foregroundStyle(JikoniColor.ink)
                                }
                                Text("By \(review.author)")
                                    .font(JikoniFont.archivo(11))
                                    .foregroundStyle(JikoniColor.textSecondary)
                            }
                            Spacer()
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= review.rating ? "star.fill" : "star")
                                        .font(.system(size: 11))
                                        .foregroundStyle(star <= review.rating ? JikoniColor.accent : JikoniColor.placeholderAlt)
                                }
                            }
                        }

                        Text(review.comment)
                            .font(JikoniFont.archivo(12.5))
                            .foregroundStyle(JikoniColor.ink)
                            .lineSpacing(2)

                        Text(review.date.formatted(date: .abbreviated, time: .shortened))
                            .font(JikoniFont.archivo(10.5))
                            .foregroundStyle(JikoniColor.textSecondary)
                    }
                    .padding(16)
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                    .jikoniShadow(.small)
                }
            }
        }
    }

    private var menu: some View {
        VStack(spacing: 0) {
            NavigationLink { OrdersView(viewModel: hubViewModel) } label: {
                menuRow(
                    icon: "shippingbox",
                    title: "Orders",
                    subtitle: "\(hubViewModel.orders.filter { $0.status != .delivered }.count) in progress · \(hubViewModel.orders.filter { $0.status == .delivered }.count) delivered",
                    isLast: false
                )
            }
            NavigationLink { CookbookView() } label: {
                menuRow(
                    icon: "bookmark",
                    title: "My cookbook",
                    subtitle: "\(activeUser.cookbookIds.count) saved dishes across collections",
                    isLast: false
                )
            }
            NavigationLink { CreateRecipeView() } label: {
                menuRow(
                    icon: "plus.circle",
                    title: "My recipes",
                    subtitle: "\(max(activeUser.recipesCount, 18)) published · 1 in review",
                    isLast: false
                )
            }
            NavigationLink { AddressView() } label: {
                menuRow(
                    icon: "mappin.and.ellipse",
                    title: "Addresses",
                    subtitle: activeUser.addresses.first(where: \.isDefault)?.line1 ?? "Kilimani (default), Parklands",
                    isLast: false
                )
            }
            NavigationLink { PaymentVaultView() } label: {
                menuRow(
                    icon: "creditcard",
                    title: "Payment methods",
                    subtitle: "M-Pesa 07•• ••• 418, Visa 4471",
                    isLast: false
                )
            }
            NavigationLink { SettingsView() } label: {
                menuRow(
                    icon: "gearshape",
                    title: "Settings",
                    subtitle: "Currency, notifications, account",
                    isLast: true
                )
            }
        }
        .padding(.horizontal, 16)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .jikoniShadow(.small)
        .buttonStyle(.plain)
    }

    private func menuRow(icon: String, title: String, subtitle: String, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 13) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(JikoniColor.ink)
                    .frame(width: 38, height: 38)
                    .background(JikoniColor.ground)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(JikoniFont.archivo(13.5, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                    Text(subtitle)
                        .font(JikoniFont.archivo(11.5))
                        .foregroundStyle(JikoniColor.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(JikoniColor.textSecondary)
            }
            .padding(.vertical, 14)

            if !isLast {
                Divider().opacity(0.35)
            }
        }
    }

    private var signOutButton: some View {
        Button {
            Task { await hubViewModel.signOut() }
        } label: {
            Text("Sign out")
                .font(JikoniFont.archivo(13, weight: .extrabold))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(JikoniColor.card)
                .foregroundStyle(JikoniColor.ink)
                .clipShape(Capsule())
                .jikoniShadow(.small)
        }
        .padding(.top, 4)
    }
}

// MARK: - Payment Methods View

struct PaymentVaultView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAddSheet = false
    @State private var newMethodType = "M-Pesa"
    @State private var mpesaPhone = "+254"
    @State private var cardNumber = ""
    @State private var cardExpiry = ""
    @State private var cardHolder = ""

    private var methods: [PaymentMethod] {
        if let userMethods = hubViewModel.currentUser?.paymentMethods, !userMethods.isEmpty {
            return userMethods
        }
        // Default presentation demo methods
        return [
            PaymentMethod(id: "pm-1", brand: "M-Pesa", lastFour: "418", expiry: "N/A", holderName: "07•• ••• 418", isDefault: true),
            PaymentMethod(id: "pm-2", brand: "Visa", lastFour: "4471", expiry: "12/28", holderName: "Dominic Bor", isDefault: false)
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            JikoniHeaderRow(title: "Payment methods", onBack: { dismiss() }) {
                Button { showAddSheet = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                        .frame(width: 44, height: 44)
                        .background(JikoniColor.card)
                        .clipShape(Circle())
                        .jikoniShadow(.small)
                }
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Saved payment methods")
                        .font(JikoniFont.archivo(16, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)

                    VStack(spacing: 12) {
                        ForEach(methods) { method in
                            HStack(spacing: 14) {
                                Image(systemName: method.brand == "M-Pesa" ? "iphone" : "creditcard.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(method.brand == "M-Pesa" ? JikoniColor.accent : JikoniColor.ink)
                                    .frame(width: 40, height: 40)
                                    .background(JikoniColor.ground)
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Text("\(method.brand) ···· \(method.lastFour)")
                                            .font(JikoniFont.archivo(13.5, weight: .extrabold))
                                            .foregroundStyle(JikoniColor.ink)
                                        if method.isDefault {
                                            Text("Default")
                                                .font(JikoniFont.archivo(9.5, weight: .extrabold))
                                                .foregroundStyle(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 3)
                                                .background(JikoniColor.ink)
                                                .clipShape(Capsule())
                                        }
                                    }
                                    Text(method.brand == "M-Pesa" ? "STK push to handset" : "Expires \(method.expiry)")
                                        .font(JikoniFont.archivo(11.5))
                                        .foregroundStyle(JikoniColor.textSecondary)
                                }

                                Spacer()

                                if !method.isDefault {
                                    Button("Make default") {
                                        Task {
                                            await hubViewModel.updateCurrentUser { user in
                                                user.paymentMethods = user.paymentMethods.map {
                                                    var copy = $0
                                                    copy.isDefault = (copy.id == method.id)
                                                    return copy
                                                }
                                            }
                                        }
                                    }
                                    .font(JikoniFont.archivo(11, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.accent)
                                }
                            }
                            .padding(14)
                            .background(JikoniColor.card)
                            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                            .jikoniShadow(.small)
                        }
                    }

                    // Cash option info card
                    HStack(spacing: 14) {
                        Image(systemName: "banknote")
                            .font(.system(size: 18))
                            .foregroundStyle(JikoniColor.ink)
                            .frame(width: 40, height: 40)
                            .background(JikoniColor.ground)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Cash on delivery")
                                .font(JikoniFont.archivo(13.5, weight: .extrabold))
                                .foregroundStyle(JikoniColor.ink)
                            Text("Rider carries KSh 500 float for change")
                                .font(JikoniFont.archivo(11.5))
                                .foregroundStyle(JikoniColor.textSecondary)
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                    .jikoniShadow(.small)
                }
                .padding(18)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .sheet(isPresented: $showAddSheet) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add payment method")
                    .font(JikoniFont.instrumentSerif(28))
                    .foregroundStyle(JikoniColor.ink)

                Picker("Type", selection: $newMethodType) {
                    Text("M-Pesa").tag("M-Pesa")
                    Text("Card").tag("Card")
                }
                .pickerStyle(.segmented)

                if newMethodType == "M-Pesa" {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Phone number")
                            .font(JikoniFont.archivo(12, weight: .extrabold))
                        TextField("+254700000000", text: $mpesaPhone)
                            .font(JikoniFont.archivo(14))
                            .padding()
                            .background(JikoniColor.ground)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Card number", text: $cardNumber)
                            .font(JikoniFont.archivo(14))
                            .padding()
                            .background(JikoniColor.ground)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        HStack {
                            TextField("MM/YY", text: $cardExpiry)
                                .font(JikoniFont.archivo(14))
                                .padding()
                                .background(JikoniColor.ground)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            TextField("Cardholder name", text: $cardHolder)
                                .font(JikoniFont.archivo(14))
                                .padding()
                                .background(JikoniColor.ground)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }

                Button {
                    let newMethod: PaymentMethod
                    if newMethodType == "M-Pesa" {
                        newMethod = PaymentMethod(
                            id: UUID().uuidString,
                            brand: "M-Pesa",
                            lastFour: String(mpesaPhone.suffix(3)),
                            expiry: "N/A",
                            holderName: mpesaPhone,
                            isDefault: true
                        )
                    } else {
                        newMethod = PaymentMethod(
                            id: UUID().uuidString,
                            brand: "Visa",
                            lastFour: String(cardNumber.suffix(4)),
                            expiry: cardExpiry,
                            holderName: cardHolder,
                            isDefault: false
                        )
                    }
                    Task {
                        await hubViewModel.updateCurrentUser { user in
                            user.paymentMethods.append(newMethod)
                        }
                        showAddSheet = false
                    }
                } label: {
                    Text("Save method")
                        .font(JikoniFont.archivo(14, weight: .extrabold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(JikoniColor.ink)
                        .foregroundStyle(JikoniColor.ground)
                        .clipShape(Capsule())
                }
            }
            .padding(24)
            .background(JikoniColor.card)
            .presentationDetents([.fraction(0.5)])
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("preferredCurrencyCode") private var currencyCode = "KES"
    @State private var showDeleteConfirm = false

    var body: some View {
        VStack(spacing: 0) {
            JikoniHeaderRow(title: "Settings", onBack: { dismiss() })

            ScrollView {
                VStack(spacing: 20) {
                    // Preferences Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("PREFERENCES")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(JikoniColor.textSecondary)

                        HStack {
                            Text("Currency")
                                .font(JikoniFont.archivo(13.5, weight: .extrabold))
                            Spacer()
                            Picker("Currency", selection: $currencyCode) {
                                Text("KES (KSh)").tag("KES")
                                Text("USD ($)").tag("USD")
                            }
                            .pickerStyle(.menu)
                            .tint(JikoniColor.ink)
                        }

                        Divider().opacity(0.35)

                        Toggle(isOn: $isDarkMode) {
                            Text("Dark Mode")
                                .font(JikoniFont.archivo(13.5, weight: .extrabold))
                        }
                        .tint(JikoniColor.accent)

                        Divider().opacity(0.35)

                        Toggle(isOn: Binding(
                            get: { hubViewModel.currentUser?.allowsPushNotifications ?? true },
                            set: { val in
                                Task {
                                    await hubViewModel.updateCurrentUser { $0.allowsPushNotifications = val }
                                }
                            }
                        )) {
                            Text("Push Notifications")
                                .font(JikoniFont.archivo(13.5, weight: .extrabold))
                        }
                        .tint(JikoniColor.accent)

                        Divider().opacity(0.35)

                        Toggle(isOn: Binding(
                            get: { hubViewModel.currentUser?.allowsPromotionalEmails ?? true },
                            set: { val in
                                Task {
                                    await hubViewModel.updateCurrentUser { $0.allowsPromotionalEmails = val }
                                }
                            }
                        )) {
                            Text("Promotional Updates")
                                .font(JikoniFont.archivo(13.5, weight: .extrabold))
                        }
                        .tint(JikoniColor.accent)
                    }
                    .padding(18)
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .jikoniShadow(.small)

                    // About Card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("ABOUT")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(JikoniColor.textSecondary)

                        HStack {
                            Text("Version")
                                .font(JikoniFont.archivo(13.5))
                            Spacer()
                            Text("1.0.0 (Modernist)")
                                .font(JikoniFont.archivo(13, weight: .extrabold))
                                .foregroundStyle(JikoniColor.textSecondary)
                        }

                        Divider().opacity(0.35)

                        HStack {
                            Text("Made in")
                                .font(JikoniFont.archivo(13.5))
                            Spacer()
                            Text("Nairobi, Kenya 🇰🇪")
                                .font(JikoniFont.archivo(13, weight: .extrabold))
                                .foregroundStyle(JikoniColor.textSecondary)
                        }
                    }
                    .padding(18)
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .jikoniShadow(.small)

                    // Danger zone
                    Button {
                        showDeleteConfirm = true
                    } label: {
                        Text("Delete Account")
                            .font(JikoniFont.archivo(13, weight: .extrabold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(JikoniColor.card)
                            .foregroundStyle(Color.red.opacity(0.85))
                            .clipShape(Capsule())
                            .jikoniShadow(.small)
                    }
                }
                .padding(18)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .alert("Delete Account?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    await hubViewModel.deleteAccount()
                    dismiss()
                }
            }
        } message: {
            Text("This will permanently remove your profile, saved recipes, and order history.")
        }
    }
}

// MARK: - Edit Profile Sheet

struct EditProfileSheet: View {
    let user: User
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var displayName: String = ""
    @State private var profileBio: String = ""
    @State private var skillLevel: String = "Home Cook"
    @State private var selectedDietaryGoals: Set<String> = []
    @State private var preferredContact: PreferredContact = .email
    @State private var isSaving = false

    private let availableSkills = [
        "Home Cook",
        "Weekend Baker",
        "Culinary Enthusiast",
        "Executive Chef",
        "Coastal Traditionalist"
    ]

    private let availableDietary = [
        "Swahili Traditional",
        "High-Protein",
        "Gluten-Free",
        "Vegetarian",
        "Halal",
        "Low-Carb",
        "Dairy-Free",
        "Keto"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Capsule()
                        .fill(JikoniColor.placeholder)
                        .frame(width: 44, height: 4)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 14)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("EDIT PROFILE")
                            .font(JikoniFont.archivo(11, weight: .extrabold))
                            .tracking(1.4)
                            .foregroundStyle(JikoniColor.accent)
                        Text("Your Kitchen Persona")
                            .font(JikoniFont.instrumentSerif(30))
                            .foregroundStyle(JikoniColor.ink)
                    }

                    // Display Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("DISPLAY NAME")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(JikoniColor.textSecondary)

                        TextField("Your name or chef alias", text: $displayName)
                            .font(JikoniFont.archivo(14))
                            .padding(.horizontal, 16)
                            .frame(height: 50)
                            .background(JikoniColor.card)
                            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                            .jikoniShadow(.small)
                    }

                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("BIO")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(JikoniColor.textSecondary)

                        TextField("Tell fellow cooks about your culinary style...", text: $profileBio, axis: .vertical)
                            .lineLimit(3...5)
                            .font(JikoniFont.archivo(13.5))
                            .padding(14)
                            .background(JikoniColor.card)
                            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                            .jikoniShadow(.small)
                    }

                    // Cooking Skill Level
                    VStack(alignment: .leading, spacing: 10) {
                        Text("COOKING SKILL LEVEL")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(JikoniColor.textSecondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(availableSkills, id: \.self) { skill in
                                    let selected = skillLevel == skill
                                    Button {
                                        skillLevel = skill
                                    } label: {
                                        Text(skill)
                                            .font(JikoniFont.archivo(12, weight: .extrabold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 9)
                                            .background(selected ? JikoniColor.ink : JikoniColor.card)
                                            .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.ink)
                                            .clipShape(Capsule())
                                            .jikoniShadow(.small)
                                    }
                                }
                            }
                        }
                    }

                    // Dietary Preferences
                    VStack(alignment: .leading, spacing: 10) {
                        Text("DIETARY PREFERENCES & GOALS")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(JikoniColor.textSecondary)

                        FlowLayout(spacing: 8) {
                            ForEach(availableDietary, id: \.self) { goal in
                                let selected = selectedDietaryGoals.contains(goal)
                                Button {
                                    if selected {
                                        selectedDietaryGoals.remove(goal)
                                    } else {
                                        selectedDietaryGoals.insert(goal)
                                    }
                                } label: {
                                    HStack(spacing: 5) {
                                        if selected {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10, weight: .bold))
                                        }
                                        Text(goal)
                                            .font(JikoniFont.archivo(11.5, weight: .extrabold))
                                    }
                                    .padding(.horizontal, 13)
                                    .padding(.vertical, 8)
                                    .background(selected ? JikoniColor.ink : JikoniColor.card)
                                    .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.ink)
                                    .clipShape(Capsule())
                                    .jikoniShadow(.small)
                                }
                            }
                        }
                    }

                    // Preferred Contact
                    VStack(alignment: .leading, spacing: 10) {
                        Text("PREFERRED CONTACT")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .tracking(1.2)
                            .foregroundStyle(JikoniColor.textSecondary)

                        HStack(spacing: 8) {
                            ForEach(PreferredContact.allCases, id: \.self) { method in
                                let selected = preferredContact == method
                                Button {
                                    preferredContact = method
                                } label: {
                                    Text(method.rawValue.capitalized)
                                        .font(JikoniFont.archivo(12, weight: .extrabold))
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .background(selected ? JikoniColor.ink : JikoniColor.card)
                                        .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.ink)
                                        .clipShape(Capsule())
                                        .jikoniShadow(.small)
                                }
                            }
                        }
                    }

                    // Save Button
                    Button {
                        saveProfile()
                    } label: {
                        if isSaving {
                            ProgressView().tint(JikoniColor.ground)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        } else {
                            Text("Save Changes")
                                .font(JikoniFont.archivo(14, weight: .extrabold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }
                    }
                    .background(JikoniColor.ink)
                    .foregroundStyle(JikoniColor.ground)
                    .clipShape(Capsule())
                    .padding(.top, 10)
                    .padding(.bottom, 24)
                }
                .padding(20)
            }
            .background(JikoniColor.ground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                displayName = user.displayName ?? ""
                profileBio = user.profileBio
                skillLevel = user.skillLevel.isEmpty ? "Home Cook" : user.skillLevel
                selectedDietaryGoals = Set(user.dietaryGoals)
                preferredContact = user.preferredContact
            }
        }
    }

    private func saveProfile() {
        isSaving = true
        var updated = user
        updated.displayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        updated.profileBio = profileBio.trimmingCharacters(in: .whitespacesAndNewlines)
        updated.skillLevel = skillLevel
        updated.dietaryGoals = Array(selectedDietaryGoals).sorted()
        updated.preferredContact = preferredContact

        Task {
            await hubViewModel.updateProfile(updated)
            isSaving = false
            dismiss()
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                x = 0
                height += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
