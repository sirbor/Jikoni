import SwiftUI

/// Appears only once something is actually in the basket — an empty pill
/// floating over every browse screen would just be noise.
struct FloatingCartButton: View {
    @Bindable var viewModel: MarketplaceViewModel
    @State private var showingCart = false

    var body: some View {
        if !viewModel.cart.isEmpty {
            Button {
                showingCart = true
            } label: {
                HStack {
                    Text("\(viewModel.cart.values.reduce(0, +)) items")
                    Spacer()
                    Text(viewModel.totalCartPrice.currencyString())
                }
                .font(JikoniFont.archivo(13.5, weight: .extrabold))
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(JikoniColor.ink)
                .foregroundStyle(JikoniColor.ground)
                .clipShape(Capsule())
                .jikoniShadow(.medium)
            }
            .padding(.horizontal, 18)
            .sheet(isPresented: $showingCart) {
                CartView(viewModel: viewModel)
            }
        }
    }
}
