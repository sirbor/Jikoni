import SwiftUI

struct CartView: View {
    @Bindable var viewModel: MarketplaceViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) var dismiss
    @State private var scheduleForLater = false
    
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
                                            Text(ingredient.price.currencyString())
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
                                    Text("Delivery: \(fee.currencyString())")
                                        .font(.caption2)
                                }
                            }
                        } footer: {
                            HStack {
                                Spacer()
                                Text("Subtotal: \(viewModel.totalForVendor(vendorId).currencyString())")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    Picker("Address", selection: $viewModel.selectedAddressLabel) {
                        ForEach(hubViewModel.currentUser?.addresses ?? [], id: \.label) { address in
                            Text("\(address.label) - \(address.line1)").tag(address.label)
                        }
                        Text("Drop New Pin").tag("New Pin")
                    }
                    .pickerStyle(.menu)

                    Toggle("Schedule for later", isOn: $scheduleForLater)
                    if scheduleForLater {
                        DatePicker(
                            "Delivery Time",
                            selection: Binding(
                                get: { viewModel.scheduledDelivery ?? .now.addingTimeInterval(3600) },
                                set: { viewModel.scheduledDelivery = $0 }
                            ),
                            in: Date()...Date().addingTimeInterval(60 * 60 * 24),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }

                    HStack {
                        TextField("Promo Code", text: $viewModel.promoCode)
                            .textFieldStyle(.roundedBorder)
                        Button("Apply") { viewModel.applyPromoCode() }
                    }

                    Picker("Payment", selection: $viewModel.selectedPaymentMethod) {
                        Text("M-Pesa STK Push").tag("M-Pesa STK Push")
                        Text("Card (Stripe/Flutterwave)").tag("Card")
                    }
                    .pickerStyle(.segmented)

                    if viewModel.selectedPaymentMethod == "M-Pesa STK Push" {
                        TextField("M-Pesa Number", text: $viewModel.mpesaPhone)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.phonePad)
                    }

                    Picker("Tip", selection: $viewModel.selectedTip) {
                        Text("No Tip").tag(0.0)
                        Text((0.5).currencyString()).tag(50.0)
                        Text((1.0).currencyString()).tag(100.0)
                        Text((2.0).currencyString()).tag(200.0)
                    }
                    .pickerStyle(.segmented)

                    let subtotal = viewModel.cart.reduce(0) { $0 + ($1.key.price * Double($1.value)) } * 100
                    let delivery = (viewModel.cart.keys.compactMap(\.vendorId).first).flatMap(viewModel.vendorForId)?.deliveryFee ?? 0
                    let service = max(subtotal * 0.05, 30)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Subtotal: \((subtotal / 100).currencyString())")
                            Text("Delivery Fee: \(delivery.currencyString())")
                            Text("Service Fee: \((service / 100).currencyString())")
                            Text("Discount: -\((viewModel.promoDiscount / 100).currencyString())")
                            Text("Tip: \((viewModel.selectedTip / 100).currencyString())")
                        }
                        .font(.caption)
                        Spacer()
                        Text((viewModel.totalCartPrice / 100).currencyString())
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    JikoniButton("Place Order • \((viewModel.totalCartPrice / 100).currencyString())") {
                        Task {
                            let earnedPoints = Int(viewModel.totalCartPrice / 10)
                            await viewModel.checkout()
                            await hubViewModel.updateCurrentUser { user in
                                user.loyaltyPoints += earnedPoints
                            }
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
