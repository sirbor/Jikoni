import SwiftUI

struct ProfileView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    let user: User
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        if let imageUrl = user.profileImageUrl, !imageUrl.isEmpty {
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.1))
                            }
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(hex: "D4AF37"), lineWidth: 2))
                        } else {
                            Circle()
                                .fill(.black)
                                .frame(width: 70, height: 70)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(Color(hex: "D4AF37"))
                                        .font(.system(size: 30))
                                }
                                .overlay(Circle().stroke(Color(hex: "D4AF37"), lineWidth: 2))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.displayName ?? "Chef")
                                .font(.custom("Georgia-Bold", size: 20))
                            Text(user.skillLevel)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: EditProfileView()) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color(hex: "D4AF37"))
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("My Kitchen") {
                    NavigationLink(destination: SavedRecipesView()) {
                        Label("Digital Cookbook", systemImage: "book.fill")
                    }
                    
                    NavigationLink(destination: SavedRecipesView()) {
                        Label("My Wishlist", systemImage: "heart.fill")
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
