import SwiftUI

struct ProfileView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    let user: User
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(.orange.gradient)
                            .frame(width: 60, height: 60)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.displayName ?? "Chef")
                                .font(.headline)
                            Text(user.skillLevel)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("My Kitchen") {
                    NavigationLink(destination: SavedRecipesView()) {
                        Label("Digital Cookbook", systemImage: "book.fill")
                    }
                    NavigationLink(destination: OrderHistoryView(viewModel: hubViewModel)) {
                        Label("Order History", systemImage: "clock.fill")
                    }
                    NavigationLink(destination: RewardsView(viewModel: hubViewModel)) {
                        Label("Rewards & Points", systemImage: "star.fill")
                    }
                }
                
                Section("Settings") {
                    NavigationLink(destination: AddressVaultView()) {
                        Label("Addresses", systemImage: "mappin")
                    }
                    NavigationLink(destination: PaymentVaultView()) {
                        Label("Payments", systemImage: "creditcard")
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
}

#Preview {
    ProfileView(user: User(id: "1", displayName: "Chef Jikoni", skillLevel: "Master Chef", dietaryGoals: ["Keto"], loyaltyPoints: 100, cookbookIds: [], followersCount: 0, followingCount: 0, recipesCount: 0, averageRating: 5.0, reviews: []))
        .environment(HubViewModel(authRepository: MockAuthRepository(), orderRepository: MockOrderRepository()))
}
