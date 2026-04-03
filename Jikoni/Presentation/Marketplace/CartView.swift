import SwiftUI

struct CartView: View {
    @Bindable var viewModel: MarketplaceViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if viewModel.cart.isEmpty {
                ContentUnavailableView(
                    "Your Cart is Empty",
                    systemImage: "cart",
                    description: Text("Add ingredients from recipes or browse the marketplace.")
                )
            } else {
                List {
                    ForEach(viewModel.cartItemsByVendor.keys.sorted(), id: \.self) { vendorId in
                        let vendor = viewModel.vendorForId(vendorId)
                        let items = viewModel.cartItemsByVendor[vendorId] ?? []
                        
                        Section {
                            ForEach(items) { ingredient in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(ingredient.name)
                                            .fontWeight(.medium)
                                        HStack {
                                            Text(ingredient.amount)
                                            Text("•")
                                            Text("$\(ingredient.price.formatted())")
                                        }
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Button { viewModel.removeFromCart(ingredient: ingredient) } label: {
                                            Image(systemName: "minus.circle")
                                        }
                                        
                                        Text("\(viewModel.cart[ingredient] ?? 0)")
                                            .frame(minWidth: 30)
                                        
                                        Button { viewModel.addToCart(ingredient: ingredient) } label: {
                                            Image(systemName: "plus.circle")
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    .foregroundColor(.orange)
                                }
                            }
                        } header: {
                            HStack {
                                Text(vendor?.name ?? "Unknown Vendor")
                                Spacer()
                                if let fee = vendor?.deliveryFee {
                                    Text("Delivery: $\(fee.formatted())")
                                        .font(.caption2)
                                }
                            }
                        } footer: {
                            HStack {
                                Spacer()
                                Text("Subtotal: $\(viewModel.totalForVendor(vendorId).formatted())")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("$\(viewModel.totalCartPrice.formatted())")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    JikoniButton("Checkout") {
                        Task {
                            await viewModel.checkout()
                            dismiss()
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .navigationTitle("Your Cart")
    }
}
