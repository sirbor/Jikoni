import SwiftUI

struct RewardsView: View {
    @Bindable var viewModel: HubViewModel
    @State private var referralCode = "JIKONI-REF-254"
    @State private var flashDealEnds = Date().addingTimeInterval(1800)
    
    var body: some View {
        VStack(spacing: 24) {
            // Loyalty Points Card
            VStack(spacing: 8) {
                Text("Your Balance")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(viewModel.currentUser?.loyaltyPoints ?? 0)")
                    .font(.system(size: 64, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Points")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                LinearGradient(
                    colors: [Color(hex: "D4AF37"), Color(hex: "8A6A1C")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color(hex: "D4AF37").opacity(0.3), radius: 10, x: 0, y: 10)
            
            // Convert Section
            VStack(spacing: 16) {
                Text("Tier: \(viewModel.currentUser?.membershipTier.rawValue.capitalized ?? "Bronze")")
                    .font(.headline)
                Text("Redeem Rewards")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("Convert your points into exclusive discount codes for your next order.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let code = viewModel.rewardCode {
                    VStack(spacing: 8) {
                        Text("Your Reward Code")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(code)
                            .font(.title2)
                            .fontWeight(.black)
                            .monospaced()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [8]))
                            )
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Button {
                    withAnimation {
                        viewModel.generateRewardCode()
                    }
                } label: {
                    HStack {
                        Image(systemName: "ticket")
                        Text("Convert to Code")
                    }
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Referral Program")
                        .font(.headline)
                    Text("Share your code and both users get first-order discounts.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    HStack {
                        Text(referralCode)
                            .font(.subheadline.monospaced())
                        Spacer()
                        ShareLink(item: "Use my Jikoni code: \(referralCode)") {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    Divider()
                    Text("Flash deal ends: \(flashDealEnds.formatted(date: .omitted, time: .shortened))")
                        .font(.caption)
                }
                .padding()
                .glassCard(cornerRadius: 12)
            }
            .padding()
            .glassCard(cornerRadius: 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Jikoni Rewards")
    }
}
