import SwiftUI

@main
struct JikoniApp: App {
    // ViewModels
    @State private var feedViewModel: FeedViewModel
    @State private var marketplaceViewModel: MarketplaceViewModel
    @State private var trackingViewModel: TrackingViewModel
    @State private var hubViewModel: HubViewModel

    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isShowingSplash = true

    init() {
        let recipes = RepositoryFactory.makeRecipes()
        let vendors = RepositoryFactory.makeVendors()
        let orders = RepositoryFactory.makeOrders()
        let auth = RepositoryFactory.makeAuth()

        // Re-using the same instances for reactive updates across view models
        _feedViewModel = State(initialValue: FeedViewModel(repository: recipes))
        _marketplaceViewModel = State(initialValue: MarketplaceViewModel(vendorRepository: vendors, orderRepository: orders))
        _trackingViewModel = State(initialValue: TrackingViewModel(repository: orders))
        _hubViewModel = State(initialValue: HubViewModel(authRepository: auth, orderRepository: orders, recipeRepository: recipes, vendorRepository: vendors))

        // Start reactive observers
        _hubViewModel.wrappedValue.startObserving()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                JikoniColor.ground
                    .ignoresSafeArea()

                mainContent
                    .opacity(isShowingSplash ? 0 : 1)

                if isShowingSplash {
                    WelcomeSplashScreenView()
                        .transition(.opacity)
                        .zIndex(999)
                }
            }
            .background(JikoniColor.ground.ignoresSafeArea())
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .task {
                if let autoEmail = ProcessInfo.processInfo.environment["AUTO_LOGIN_EMAIL"],
                   let autoPass = ProcessInfo.processInfo.environment["AUTO_LOGIN_PASSWORD"] {
                    _ = await hubViewModel.signInWithEmail(email: autoEmail, password: autoPass)
                } else {
                    await hubViewModel.restoreSession()
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                withAnimation(.easeInOut(duration: 0.4)) {
                    isShowingSplash = false
                }
            }
            .task(id: hubViewModel.currentUser?.id) {
                await trackingViewModel.startTracking(userId: hubViewModel.currentUser?.id)
            }
        }
    }

    private var mainContent: some View {
        Group {
            if hubViewModel.currentUser != nil {
                JikoniShell(
                    feedViewModel: feedViewModel,
                    marketplaceViewModel: marketplaceViewModel,
                    trackingViewModel: trackingViewModel,
                    hubViewModel: hubViewModel
                )
                .environment(hubViewModel)
                .environment(marketplaceViewModel)
                .environment(feedViewModel)
            } else {
                WelcomeView(viewModel: hubViewModel)
                    .environment(hubViewModel)
                    .environment(marketplaceViewModel)
                    .environment(feedViewModel)
            }
        }
    }
}

private struct JikoniShell: View {
    let feedViewModel: FeedViewModel
    let marketplaceViewModel: MarketplaceViewModel
    let trackingViewModel: TrackingViewModel
    let hubViewModel: HubViewModel
    @State private var activeTab: AppTab = {
        if let tabStr = ProcessInfo.processInfo.environment["INITIAL_TAB"] {
            switch tabStr.lowercased() {
            case "you", "profile": return .you
            case "track", "tracking": return .track
            case "order", "marketplace": return .order
            default: return .feed
            }
        }
        return .feed
    }()

    private var isOrderActive: Bool {
        guard let order = trackingViewModel.activeOrder else { return false }
        return order.status != .delivered && order.status != .cancelled
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch activeTab {
                case .feed: FeedView(viewModel: feedViewModel)
                case .order: OrderView(viewModel: marketplaceViewModel)
                case .track: TrackingView(viewModel: trackingViewModel)
                case .you: HubView(viewModel: hubViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, (isOrderActive && activeTab != .track) ? 144 : 78)
            .ignoresSafeArea(edges: .bottom)

            VStack(spacing: 8) {
                if let order = trackingViewModel.activeOrder, isOrderActive, activeTab != .track {
                    OrderStepBanner(
                        order: order,
                        onTap: {
                            withAnimation(.spring()) {
                                activeTab = .track
                            }
                        },
                        onStop: {
                            Task {
                                await trackingViewModel.stopActiveOrder()
                            }
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                JikoniTabBar(active: $activeTab)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isOrderActive)
        .background(JikoniColor.ground.ignoresSafeArea())
        .environment(\.switchTab, TabSwitchAction(action: { activeTab = $0 }))
        .onAppear {
            if let tabStr = ProcessInfo.processInfo.environment["INITIAL_TAB"] {
                switch tabStr.lowercased() {
                case "you", "profile": activeTab = .you
                case "track", "tracking": activeTab = .track
                case "order", "marketplace": activeTab = .order
                default: break
                }
            }
            marketplaceViewModel.onOrderPlaced = { order in
                trackingViewModel.trackOrder(order)
                withAnimation(.spring()) {
                    activeTab = .track
                }
            }
        }
    }
}

struct HubView: View {
    @Bindable var viewModel: HubViewModel

    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                ProfileView(user: user)
            }
        } else {
            WelcomeView(viewModel: viewModel)
        }
    }
}

/// Seamless splash screen matching the Modernist palette (#F3F2F2)
/// that prevents any black flash/darkness while the app initializes.
struct WelcomeSplashScreenView: View {
    @State private var isPulsing = false
    @State private var appear = false

    var body: some View {
        ZStack {
            JikoniColor.ground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top brand kicker
                HStack(spacing: 8) {
                    Circle()
                        .fill(JikoniColor.accent)
                        .frame(width: 7, height: 7)
                    Text("JIKONI · NAIROBI")
                        .font(JikoniFont.archivo(11, weight: .extrabold))
                        .tracking(2.5)
                        .foregroundStyle(JikoniColor.ink)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(JikoniColor.card)
                .clipShape(Capsule())
                .jikoniShadow(.small)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : -10)
                .padding(.top, 60)

                Spacer()

                // Center hero word logo in brand colors
                VStack(spacing: 14) {
                    ZStack {
                        // Ambient subtle glow in brand accent color
                        Circle()
                            .fill(JikoniColor.accent.opacity(isPulsing ? 0.16 : 0.06))
                            .frame(width: 140, height: 140)
                            .blur(radius: 22)
                            .scaleEffect(isPulsing ? 1.15 : 0.9)
                            .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: isPulsing)

                        JikoniWordmarkView(
                            size: 76,
                            isDarkBackground: false,
                            showSubtitle: true,
                            subtitleText: "NAIROBI"
                        )
                    }

                    Text("Recipes that end in dinner.")
                        .font(JikoniFont.archivo(13.5, weight: .semibold))
                        .foregroundStyle(JikoniColor.textSecondary)
                        .padding(.top, 4)
                }
                .opacity(appear ? 1 : 0)
                .scaleEffect(appear ? 1 : 0.94)

                Spacer()

                // Bottom loading indicator
                VStack(spacing: 12) {
                    HStack(spacing: 6) {
                        ForEach(0..<3) { idx in
                            Circle()
                                .fill(idx == 1 ? JikoniColor.accent : JikoniColor.ink)
                                .frame(width: 6, height: 6)
                                .scaleEffect(isPulsing ? 1.3 : 0.75)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(idx) * 0.2),
                                    value: isPulsing
                                )
                        }
                    }

                    Text("KITCHENS & HOME COOKS")
                        .font(JikoniFont.archivo(10, weight: .extrabold))
                        .tracking(1.8)
                        .foregroundStyle(JikoniColor.textSecondary.opacity(0.75))
                }
                .padding(.bottom, 48)
                .opacity(appear ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appear = true
            }
            isPulsing = true
        }
    }
}

/// Floating order status banner displayed above the persistent bottom navigation bar
/// across browsable tabs whenever an order is actively in progress.
struct OrderStepBanner: View {
    let order: Order
    let onTap: () -> Void
    var onStop: (() -> Void)? = nil

    @State private var isPulsing = false

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    // Status icon circle
                    ZStack {
                        Circle()
                            .fill(JikoniColor.accent.opacity(0.14))
                            .frame(width: 40, height: 40)

                        Image(systemName: statusIconName)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(JikoniColor.accent)
                    }

                    // Middle: Step info and restaurant
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(JikoniColor.accent)
                                .frame(width: 6, height: 6)
                                .scaleEffect(isPulsing ? 1.25 : 0.8)
                                .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: isPulsing)

                            Text(stepLabel.uppercased())
                                .font(JikoniFont.archivo(10.5, weight: .extrabold))
                                .tracking(0.8)
                                .foregroundStyle(JikoniColor.accent)
                        }

                        HStack(spacing: 6) {
                            Text(order.restaurantName)
                                .font(JikoniFont.archivo(13.5, weight: .bold))
                                .foregroundStyle(JikoniColor.ink)
                                .lineLimit(1)

                            Text("· \(statusDescription)")
                                .font(JikoniFont.archivo(12.5, weight: .regular))
                                .foregroundStyle(JikoniColor.textSecondary)
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    // Action pill
                    HStack(spacing: 4) {
                        Text("Track")
                            .font(JikoniFont.archivo(12, weight: .extrabold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .padding(.horizontal, 13)
                    .padding(.vertical, 8)
                    .background(JikoniColor.ink)
                    .foregroundStyle(JikoniColor.ground)
                    .clipShape(Capsule())
                }
            }
            .buttonStyle(.plain)

            if let onStop {
                Button(action: onStop) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                        .frame(width: 32, height: 32)
                        .background(JikoniColor.ground)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: JikoniRadius.control, style: .continuous)
                .stroke(JikoniColor.ink.opacity(0.08), lineWidth: 1)
        )
        .jikoniShadow(.medium)
        .padding(.horizontal, 16)
        .onAppear {
            isPulsing = true
        }
    }

    private var stepLabel: String {
        switch order.status {
        case .received:
            return "Step 1 of 4"
        case .confirmed, .preparing:
            return "Step 2 of 4"
        case .riderAssigned:
            return "Step 3 of 4"
        case .onTheWay:
            return "Step 4 of 4"
        case .delivered:
            return "Delivered"
        case .cancelled:
            return "Cancelled"
        }
    }

    private var statusDescription: String {
        switch order.status {
        case .received:
            return "Order Placed"
        case .confirmed:
            return "Confirmed"
        case .preparing:
            return "Cooking"
        case .riderAssigned:
            return "Rider Assigned"
        case .onTheWay:
            return "On the way"
        case .delivered:
            return "Delivered"
        case .cancelled:
            return "Cancelled"
        }
    }

    private var statusIconName: String {
        switch order.status {
        case .received:
            return "clock.arrow.2.circlepath"
        case .confirmed, .preparing:
            return "frying.pan.fill"
        case .riderAssigned:
            return "person.badge.shield.checkmark.fill"
        case .onTheWay:
            return "bicycle"
        case .delivered:
            return "checkmark.seal.fill"
        case .cancelled:
            return "xmark.circle.fill"
        }
    }
}

