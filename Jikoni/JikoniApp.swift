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
                    Label("Discovery", systemImage: "house.fill")
                }
            
            ExploreView(viewModel: marketplaceViewModel)
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
            
            DrinksView(viewModel: marketplaceViewModel)
                .tabItem {
                    Label("Drinks", systemImage: "wineglass.fill")
                }
            
            HubView(viewModel: hubViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.orange)
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
    let viewModel: HubViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            ProfileView(user: user)
        } else {
            // Fallback just in case, but currentUser is now default
            ProgressView()
                .onAppear {
                    Task {
                        await viewModel.signIn()
                    }
                }
        }
    }
}
