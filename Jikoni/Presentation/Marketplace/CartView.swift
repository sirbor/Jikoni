import SwiftUI

struct CartView: View {
    @Bindable var viewModel: MarketplaceViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.switchTab) private var switchTab
    @State private var deliveryMode = "Delivery"
    @State private var showPayment = false
    @State private var showAddAddress = false

    private var subtotal: Double {
        viewModel.cart.reduce(0) { $0 + ($1.key.price * Double($1.value)) }
    }

    private var deliveryFee: Double {
        let vendorId = viewModel.cart.keys.compactMap(\.vendorId).first
        return vendorId.flatMap(viewModel.vendorForId)?.deliveryFee ?? 0
    }

    private var serviceFee: Double { max(subtotal * 0.05, 30) }

    var body: some View {
        VStack(spacing: 0) {
            JikoniHeaderRow(title: "My Basket", onBack: { dismiss() })

            if viewModel.cart.isEmpty {
                Spacer()
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(JikoniColor.card)
                            .frame(width: 88, height: 88)
                            .jikoniShadow(.small)
                        Image(systemName: "bag")
                            .font(.system(size: 38))
                            .foregroundStyle(JikoniColor.accent)
                    }

                    VStack(spacing: 6) {
                        Text("Your Basket is Empty")
                            .font(JikoniFont.instrumentSerif(30))
                            .foregroundStyle(JikoniColor.ink)
                        Text("Explore fresh local ingredients, artisanal groceries, and prepared meals.")
                            .font(JikoniFont.archivo(13))
                            .foregroundStyle(JikoniColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 36)
                    }

                    Button {
                        dismiss()
                        switchTab(.order)
                    } label: {
                        Text("Explore Marketplace")
                            .font(JikoniFont.archivo(13.5, weight: .extrabold))
                            .padding(.horizontal, 24)
                            .frame(height: 48)
                            .background(JikoniColor.ink)
                            .foregroundStyle(JikoniColor.ground)
                            .clipShape(Capsule())
                            .jikoniShadow(.small)
                    }
                }
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        modeToggle
                        addressRow
                        itemsCard
                        promoRow
                        paymentSection
                        totalsCard
                    }
                    .padding(18)
                }
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .sheet(isPresented: $showAddAddress) {
            AddressView()
        }
        .fullScreenCover(isPresented: $showPayment) {
            PaymentView(viewModel: viewModel) {
                showPayment = false
                dismiss()
                switchTab(.track)
            }
        }
    }

    private var modeToggle: some View {
        HStack(spacing: 4) {
            ForEach(["Delivery", "Pickup"], id: \.self) { mode in
                let selected = deliveryMode == mode
                Button {
                    deliveryMode = mode
                    viewModel.isPickup = (mode == "Pickup")
                } label: {
                    Text(mode)
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(selected ? JikoniColor.ink : Color.clear)
                        .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.textSecondary)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(JikoniColor.card)
        .clipShape(Capsule())
        .jikoniShadow(.small)
    }

    private var addressRow: some View {
        Button { showAddAddress = true } label: {
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(JikoniColor.accent)
                VStack(alignment: .leading, spacing: 3) {
                    Text(hubViewModel.currentUser?.addresses.first(where: \.isDefault)?.line1 ?? "Add a delivery address")
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                    Text("Arrives in 25–35 min")
                        .font(JikoniFont.archivo(11))
                        .foregroundStyle(JikoniColor.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(JikoniColor.textSecondary)
            }
            .padding(14)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
            .jikoniShadow(.small)
        }
        .buttonStyle(.plain)
    }

    private var itemsCard: some View {
        VStack(spacing: 12) {
            ForEach(Array(viewModel.cart.keys.sorted { $0.name < $1.name }.enumerated()), id: \.element) { index, ingredient in
                let count = viewModel.cart[ingredient] ?? 0
                HStack(spacing: 13) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ingredient.name)
                            .font(JikoniFont.archivo(13.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)
                        if !ingredient.details.isEmpty {
                            Text(ingredient.details)
                                .font(JikoniFont.archivo(11))
                                .foregroundStyle(JikoniColor.textSecondary)
                        }
                        Text(ingredient.price.currencyString())
                            .font(JikoniFont.archivo(13, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)
                    }
                    Spacer()
                    HStack(spacing: 6) {
                        Button { viewModel.removeFromCart(ingredient: ingredient) } label: {
                            Image(systemName: "minus").font(.system(size: 12, weight: .bold))
                                .frame(width: 30, height: 30).background(JikoniColor.ground).foregroundStyle(JikoniColor.ink).clipShape(Circle())
                        }
                        Text("\(count)").font(JikoniFont.archivo(13, weight: .extrabold)).frame(minWidth: 16)
                        Button { viewModel.addToCart(ingredient: ingredient) } label: {
                            Image(systemName: "plus").font(.system(size: 12, weight: .bold))
                                .frame(width: 30, height: 30).background(JikoniColor.ink).foregroundStyle(JikoniColor.ground).clipShape(Circle())
                        }
                    }
                }
                if index < viewModel.cart.count - 1 { Divider().opacity(0.4) }
            }
        }
        .padding(14)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .jikoniShadow(.small)
    }

    private var promoRow: some View {
        HStack {
            TextField("Add a promo code", text: $viewModel.promoCode)
                .font(JikoniFont.archivo(12.5))
            Button("Apply") { viewModel.applyPromoCode() }
                .font(JikoniFont.archivo(12, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
        .jikoniShadow(.small)
    }

    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(JikoniFont.archivo(16, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)

            ForEach(["M-Pesa STK Push", "Card", "Cash on delivery"], id: \.self) { method in
                Button {
                    viewModel.selectedPaymentMethod = method
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.selectedPaymentMethod == method ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(viewModel.selectedPaymentMethod == method ? JikoniColor.accent : JikoniColor.textSecondary)

                        Image(systemName: method.contains("Card") ? "creditcard.fill" : (method.contains("Cash") ? "banknote.fill" : "iphone.radiowaves.left.and.right"))
                            .font(.system(size: 14))
                            .foregroundStyle(JikoniColor.ink)

                        Text(method)
                            .font(JikoniFont.archivo(13, weight: .extrabold))
                            .foregroundStyle(JikoniColor.ink)

                        Spacer()
                    }
                    .padding(14)
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                    .jikoniShadow(.small)
                }
                .buttonStyle(.plain)
            }

            if viewModel.selectedPaymentMethod == "M-Pesa STK Push" {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Safaricom Phone Number for STK Push")
                        .font(JikoniFont.archivo(11, weight: .bold))
                        .foregroundStyle(JikoniColor.textSecondary)
                    TextField("M-Pesa number (e.g. 0712 345 678)", text: $viewModel.mpesaPhone)
                        .keyboardType(.phonePad)
                        .font(JikoniFont.archivo(13))
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                        .jikoniShadow(.small)
                }
            } else if viewModel.selectedPaymentMethod == "Card" {
                HStack(spacing: 12) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(JikoniColor.accent)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Visa / Mastercard •••• 4242")
                            .font(JikoniFont.archivo(13, weight: .bold))
                            .foregroundStyle(JikoniColor.ink)
                        Text("Expires 08/28 · Secured via 3D Secure")
                            .font(JikoniFont.archivo(11))
                            .foregroundStyle(JikoniColor.textSecondary)
                    }
                    Spacer()
                    Text("CHANGE")
                        .font(JikoniFont.archivo(10.5, weight: .extrabold))
                        .foregroundStyle(JikoniColor.accent)
                }
                .padding(14)
                .background(JikoniColor.card)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                .jikoniShadow(.small)
            } else if viewModel.selectedPaymentMethod == "Cash on delivery" {
                HStack(spacing: 12) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(JikoniColor.accent)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pay Courier in Cash")
                            .font(JikoniFont.archivo(13, weight: .bold))
                            .foregroundStyle(JikoniColor.ink)
                        Text("Please prepare exact cash or note for the rider upon arrival.")
                            .font(JikoniFont.archivo(11))
                            .foregroundStyle(JikoniColor.textSecondary)
                    }
                }
                .padding(14)
                .background(JikoniColor.card)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                .jikoniShadow(.small)
            }
        }
    }

    private var cooksShare: Double { subtotal * 0.10 }

    private var totalsCard: some View {
        VStack(spacing: 14) {
            row("Subtotal", subtotal.currencyString())
            row("Cook's share (10% · included)", cooksShare.currencyString())
            row("Delivery", deliveryFee.currencyString())
            row("Service", serviceFee.currencyString())
            if viewModel.promoDiscount > 0 {
                row("Discount", "-\(viewModel.promoDiscount.currencyString())")
            }
            Divider()
            HStack {
                Text("Total").font(JikoniFont.archivo(15, weight: .extrabold))
                Spacer()
                Text(viewModel.totalCartPrice.currencyString()).font(JikoniFont.archivo(22, weight: .extrabold))
            }
            .foregroundStyle(JikoniColor.ink)

            Button {
                showPayment = true
            } label: {
                HStack {
                    Text(checkoutButtonTitle)
                    Spacer()
                    Text(viewModel.totalCartPrice.currencyString())
                }
                .font(JikoniFont.archivo(14.5, weight: .extrabold))
                .padding(.horizontal, 22)
                .frame(height: 58)
                .background(JikoniColor.ink)
                .foregroundStyle(JikoniColor.ground)
                .clipShape(Capsule())
            }

            Text(checkoutDisclosureText)
                .font(JikoniFont.archivo(10.5))
                .foregroundStyle(JikoniColor.textSecondary)
        }
        .padding(18)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .jikoniShadow(.small)
    }

    private var checkoutButtonTitle: String {
        if viewModel.selectedPaymentMethod.contains("Card") {
            return "Pay with Card"
        } else if viewModel.selectedPaymentMethod.contains("Cash") {
            return "Place Order (Cash)"
        } else {
            return "Pay with M-Pesa STK"
        }
    }

    private var checkoutDisclosureText: String {
        if viewModel.selectedPaymentMethod.contains("Card") {
            return "Encrypted & authorized via 3D Secure / Stripe"
        } else if viewModel.selectedPaymentMethod.contains("Cash") {
            return "Pay directly to the courier when your food arrives"
        } else {
            return "Payments are processed securely via Safaricom M-Pesa"
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).foregroundStyle(JikoniColor.textSecondary)
            Spacer()
            Text(value).fontWeight(.semibold).foregroundStyle(JikoniColor.ink)
        }
        .font(JikoniFont.archivo(13))
    }
}
