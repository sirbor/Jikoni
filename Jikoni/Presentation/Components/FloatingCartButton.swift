import SwiftUI

struct FloatingCartButton: View {
    let viewModel: MarketplaceViewModel
    @State private var showingCart = false
    
    var itemCount: Int {
        viewModel.cart.values.reduce(0, +)
    }
    
    var body: some View {
        if itemCount > 0 {
            Button {
                showingCart = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 18, weight: .bold))
                    
                    Text("\(itemCount) \(itemCount == 1 ? "Item" : "Items")")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                    
                    Text("•")
                    
                    Text("$\(viewModel.totalCartPrice.formatted())")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color(hex: "D4AF37"))
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .foregroundStyle(.black)
                .overlay(
                    Capsule()
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                )
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .sheet(isPresented: $showingCart) {
                CartView(viewModel: viewModel)
            }
        }
    }
}
