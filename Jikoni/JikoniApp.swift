import SwiftUI
import SwiftData

@main
struct JikoniApp: App {
    // ViewModels
    @State private var feedViewModel: FeedViewModel
    @State private var marketplaceViewModel: MarketplaceViewModel
    @State private var trackingViewModel: TrackingViewModel
    @State private var hubViewModel: HubViewModel
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isLaunching = true
    
    init() {
        let recipes = MockRecipeRepository()
        let vendors = MockVendorRepository()
        let orders = MockOrderRepository()
        let auth = MockAuthRepository()
        
        // Re-using the same instances for reactive updates across view models
        _feedViewModel = State(initialValue: FeedViewModel(repository: recipes))
        _marketplaceViewModel = State(initialValue: MarketplaceViewModel(vendorRepository: vendors, orderRepository: orders))
        _trackingViewModel = State(initialValue: TrackingViewModel(repository: orders))
        _hubViewModel = State(initialValue: HubViewModel(authRepository: auth, orderRepository: orders))
        
        // Start reactive observers
        _hubViewModel.wrappedValue.startObserving()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLaunching {
                    LaunchScreenView()
                        .transition(.opacity)
                } else {
                    mainContent
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .task {
                // Ensure tracking listener starts immediately
                await trackingViewModel.startTracking()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isLaunching = false
                    }
                }
            }
        }
    }
    
    private var mainContent: some View {
        TabView {
            FeedView(viewModel: feedViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            ExploreView(viewModel: marketplaceViewModel)
                .tabItem {
                    Label("Delivery", systemImage: "scooter")
                }
            
            DrinksView(viewModel: marketplaceViewModel)
                .tabItem {
                    Label("Beverages", systemImage: "wineglass.fill")
                }
            
            HubView(viewModel: hubViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(Color(hex: "D4AF37"))
        .environment(hubViewModel)
        .environment(marketplaceViewModel)
        .environment(feedViewModel)
        .overlay(alignment: .bottom) {
            TrackingOverlay(viewModel: trackingViewModel)
                .padding(.bottom, 60) // Above tab bar
        }
    }
}

struct HubView: View {
    @Bindable var viewModel: HubViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            ProfileView(user: user)
        } else {
            NavigationStack {
                LoginView(viewModel: viewModel)
            }
        }
    }
}
