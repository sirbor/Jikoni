import SwiftUI

/// Seamless multi-mode checkout payment supporting M-Pesa STK Push,
/// Card authorization, and Cash on delivery with automatic tab pre-selection.
struct PaymentView: View {
    @Bindable var viewModel: MarketplaceViewModel
    @Environment(HubViewModel.self) private var hubViewModel
    let onDone: () -> Void

    enum PaymentMode: String, CaseIterable {
        case mpesa = "M-Pesa STK"
        case card = "Card"
        case cash = "Cash on Delivery"
    }

    private enum Stage { case pending, processing, done }

    @State private var selectedMode: PaymentMode
    @State private var stage: Stage = .pending
    @State private var secondsRemaining = 5
    @State private var referenceCode = ""
    @State private var timerTask: Task<Void, Never>?
    @State private var chargedTotal: Double = 0
    @State private var cardholderName = "Wanjiku Mwangi"
    @State private var cardNumber = "•••• •••• •••• 4242"
    @State private var cardExpiry = "08/28"
    @State private var cardCVV = "•••"
    @State private var cashNeedChange = false

    init(viewModel: MarketplaceViewModel, onDone: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onDone = onDone
        let initial: PaymentMode
        if viewModel.selectedPaymentMethod.contains("Card") {
            initial = .card
        } else if viewModel.selectedPaymentMethod.contains("Cash") {
            initial = .cash
        } else {
            initial = .mpesa
        }
        _selectedMode = State(initialValue: initial)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header row
            HStack {
                Text("Checkout Payment")
                    .font(JikoniFont.archivo(16, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Spacer()
                if stage != .done {
                    Button("Cancel") {
                        timerTask?.cancel()
                        onDone()
                    }
                    .font(JikoniFont.archivo(12.5, weight: .bold))
                    .foregroundStyle(JikoniColor.textSecondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 12)

            // Mode Selector Tabs (Pick between Cash, M-Pesa, or Card)
            if stage != .done {
                HStack(spacing: 6) {
                    ForEach(PaymentMode.allCases, id: \.self) { mode in
                        let isSelected = selectedMode == mode
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedMode = mode
                                switch mode {
                                case .mpesa: viewModel.selectedPaymentMethod = "M-Pesa STK Push"
                                case .card: viewModel.selectedPaymentMethod = "Card"
                                case .cash: viewModel.selectedPaymentMethod = "Cash on delivery"
                                }
                                timerTask?.cancel()
                                stage = .pending
                                if mode == .mpesa {
                                    startMpesaTimer()
                                }
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: modeIcon(mode))
                                    .font(.system(size: 11, weight: .bold))
                                Text(mode.rawValue)
                                    .font(JikoniFont.archivo(11.5, weight: isSelected ? .extrabold : .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                            .background(isSelected ? JikoniColor.ink : JikoniColor.card)
                            .foregroundStyle(isSelected ? JikoniColor.ground : JikoniColor.ink)
                            .clipShape(Capsule())
                            .jikoniShadow(isSelected ? .small : .none)
                        }
                    }
                }
                .padding(4)
                .background(JikoniColor.card.opacity(0.6))
                .clipShape(Capsule())
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            Spacer()

            switch stage {
            case .pending:
                pendingViewForMode
            case .processing:
                processingViewForMode
            case .done:
                doneContent
            }

            Spacer()
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .task {
            chargedTotal = viewModel.totalCartPrice
            if let user = hubViewModel.currentUser, let name = user.displayName, !name.isEmpty {
                cardholderName = name
            }
            if selectedMode == .mpesa {
                startMpesaTimer()
            }
        }
        .onDisappear { timerTask?.cancel() }
    }

    private func modeIcon(_ mode: PaymentMode) -> String {
        switch mode {
        case .mpesa: return "iphone.radiowaves.left.and.right"
        case .card: return "creditcard.fill"
        case .cash: return "banknote.fill"
        }
    }

    @ViewBuilder
    private var pendingViewForMode: some View {
        switch selectedMode {
        case .mpesa:
            mpesaPendingView
        case .card:
            cardPendingView
        case .cash:
            cashPendingView
        }
    }

    // MARK: - M-Pesa Flow
    private var mpesaPendingView: some View {
        VStack(spacing: 18) {
            ProgressView()
                .controlSize(.large)
                .tint(JikoniColor.ink)

            Text("Check your phone")
                .font(JikoniFont.instrumentSerif(32))
                .foregroundStyle(JikoniColor.ink)

            Text("We sent an STK Push prompt to **\(maskedPhone)** for **\(chargedTotal.currencyString())**. Enter your M-Pesa PIN to approve.")
                .font(JikoniFont.archivo(13))
                .foregroundStyle(JikoniColor.textBody)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Text("Waiting for Safaricom · 0:0\(secondsRemaining)")
                .font(JikoniFont.archivo(11, weight: .extrabold))
                .foregroundStyle(JikoniColor.textSecondary)
                .padding(.top, 4)

            VStack(spacing: 12) {
                Text("No prompt? Dial *334# and approve the pending transaction. Your food is prepared immediately upon receipt.")
                    .font(JikoniFont.archivo(12))
                    .foregroundStyle(JikoniColor.textBody)
                    .lineSpacing(2)

                Button {
                    resendMpesa()
                } label: {
                    Text("Resend prompt")
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(JikoniColor.card)
                        .foregroundStyle(JikoniColor.ink)
                        .clipShape(Capsule())
                }
            }
            .padding(18)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
            .jikoniShadow(.small)
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Card Flow
    private var cardPendingView: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle().fill(JikoniColor.card).frame(width: 72, height: 72).jikoniShadow(.small)
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(JikoniColor.accent)
            }

            Text("Confirm Card Payment")
                .font(JikoniFont.instrumentSerif(32))
                .foregroundStyle(JikoniColor.ink)

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("CARD NUMBER")
                            .font(JikoniFont.archivo(9.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.textSecondary)
                        Text(cardNumber)
                            .font(JikoniFont.archivo(14, weight: .bold))
                            .foregroundStyle(JikoniColor.ink)
                    }
                    Spacer()
                    Image(systemName: "shield.lefthalf.filled.trianglebadge.exclamationmark")
                        .font(.system(size: 18))
                        .foregroundStyle(JikoniColor.accent)
                }

                HStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("CARDHOLDER")
                            .font(JikoniFont.archivo(9.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.textSecondary)
                        Text(cardholderName)
                            .font(JikoniFont.archivo(13, weight: .semibold))
                            .foregroundStyle(JikoniColor.ink)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 3) {
                        Text("EXPIRES")
                            .font(JikoniFont.archivo(9.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.textSecondary)
                        Text(cardExpiry)
                            .font(JikoniFont.archivo(13, weight: .semibold))
                            .foregroundStyle(JikoniColor.ink)
                    }
                }
            }
            .padding(18)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
            .jikoniShadow(.small)
            .padding(.horizontal, 20)

            Button {
                Task { await runCardPayment() }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 13))
                    Text("Pay \(chargedTotal.currencyString())")
                        .font(JikoniFont.archivo(14.5, weight: .extrabold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(JikoniColor.ink)
                .foregroundStyle(JikoniColor.ground)
                .clipShape(Capsule())
                .padding(.horizontal, 20)
            }

            Text("Authorized securely via 3D Secure / Stripe")
                .font(JikoniFont.archivo(11))
                .foregroundStyle(JikoniColor.textSecondary)
        }
    }

    // MARK: - Cash on Delivery Flow
    private var cashPendingView: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle().fill(JikoniColor.card).frame(width: 72, height: 72).jikoniShadow(.small)
                Image(systemName: "banknote.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(JikoniColor.accent)
            }

            Text("Cash on Delivery")
                .font(JikoniFont.instrumentSerif(32))
                .foregroundStyle(JikoniColor.ink)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Total to pay courier:")
                        .font(JikoniFont.archivo(13))
                        .foregroundStyle(JikoniColor.textSecondary)
                    Spacer()
                    Text(chargedTotal.currencyString())
                        .font(JikoniFont.archivo(16, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                }

                Divider().opacity(0.4)

                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(JikoniColor.accent)
                        .font(.system(size: 14))
                    Text("The courier will deliver to your doorstep. Please have exact cash ready.")
                        .font(JikoniFont.archivo(12))
                        .foregroundStyle(JikoniColor.textBody)
                }

                Toggle(isOn: $cashNeedChange) {
                    Text("I need change for a KSh 1,000 / 2,000 note")
                        .font(JikoniFont.archivo(12, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                }
                .tint(JikoniColor.accent)
            }
            .padding(18)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
            .jikoniShadow(.small)
            .padding(.horizontal, 20)

            Button {
                Task { await runCashPayment() }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                    Text("Confirm Order · \(chargedTotal.currencyString())")
                        .font(JikoniFont.archivo(14.5, weight: .extrabold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(JikoniColor.ink)
                .foregroundStyle(JikoniColor.ground)
                .clipShape(Capsule())
                .padding(.horizontal, 20)
            }
        }
    }

    private var processingViewForMode: some View {
        VStack(spacing: 20) {
            ProgressView()
                .controlSize(.large)
                .tint(JikoniColor.ink)
            Text(selectedMode == .card ? "Authorizing 3D Secure..." : "Confirming Order...")
                .font(JikoniFont.instrumentSerif(28))
                .foregroundStyle(JikoniColor.ink)
            Text("Connecting with payment network...")
                .font(JikoniFont.archivo(12.5))
                .foregroundStyle(JikoniColor.textSecondary)
        }
    }

    // MARK: - Done Content
    private var doneContent: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle().fill(JikoniColor.ink).frame(width: 72, height: 72)
                Image(systemName: "checkmark")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(JikoniColor.ground)
            }

            Text(doneTitle)
                .font(JikoniFont.instrumentSerif(32))
                .foregroundStyle(JikoniColor.ink)

            Text(doneSubtitle)
                .font(JikoniFont.archivo(13))
                .foregroundStyle(JikoniColor.textBody)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            VStack(spacing: 0) {
                HStack {
                    Text("Order").foregroundStyle(JikoniColor.textSecondary)
                    Spacer()
                    Text("#JK-\(String(referenceCode.prefix(4)))").font(JikoniFont.archivo(13, weight: .extrabold))
                }
                .padding(.vertical, 12)
                Divider().opacity(0.35)
                HStack {
                    Text("Payment").foregroundStyle(JikoniColor.textSecondary)
                    Spacer()
                    Text(selectedMode.rawValue).font(JikoniFont.archivo(13, weight: .bold))
                }
                .padding(.vertical, 12)
                Divider().opacity(0.35)
                HStack {
                    Text("Arrives").foregroundStyle(JikoniColor.textSecondary)
                    Spacer()
                    Text("25–35 min").font(JikoniFont.archivo(13, weight: .extrabold))
                }
                .padding(.vertical, 12)
                Divider().opacity(0.35)
                HStack {
                    Text("Loyalty earned").foregroundStyle(JikoniColor.textSecondary)
                    Spacer()
                    Text("+\(Int(chargedTotal * 10)) pts").font(JikoniFont.archivo(13, weight: .extrabold)).foregroundStyle(JikoniColor.accent)
                }
                .padding(.vertical, 12)
            }
            .font(JikoniFont.archivo(13))
            .padding(.horizontal, 18)
            .background(JikoniColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .jikoniShadow(.small)
            .padding(.horizontal, 20)

            Button {
                onDone()
            } label: {
                Text("Track the rider")
                    .font(JikoniFont.archivo(14, weight: .extrabold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(JikoniColor.ink)
                    .foregroundStyle(JikoniColor.ground)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
        }
    }

    private var doneTitle: String {
        switch selectedMode {
        case .mpesa: return "Paid via M-Pesa"
        case .card: return "Payment Approved"
        case .cash: return "Order Confirmed"
        }
    }

    private var doneSubtitle: String {
        switch selectedMode {
        case .mpesa:
            return "\(chargedTotal.currencyString()) received. M-Pesa code **\(referenceCode)**."
        case .card:
            return "\(chargedTotal.currencyString()) authorized. Auth code **\(referenceCode)**."
        case .cash:
            return "Kitchen notified. Please prepare \(chargedTotal.currencyString()) cash for the rider."
        }
    }

    private var maskedPhone: String {
        let digits = viewModel.mpesaPhone.filter(\.isNumber)
        guard digits.count >= 4 else { return viewModel.mpesaPhone.isEmpty ? "07•• ••• 456" : viewModel.mpesaPhone }
        return "07•• ••• " + digits.suffix(3)
    }

    private func resendMpesa() {
        timerTask?.cancel()
        secondsRemaining = 5
        startMpesaTimer()
    }

    private func startMpesaTimer() {
        timerTask?.cancel()
        timerTask = Task {
            if chargedTotal == 0 { chargedTotal = viewModel.totalCartPrice }
            for remaining in stride(from: 5, through: 1, by: -1) {
                secondsRemaining = remaining
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { return }
            }
            referenceCode = Self.randomCode(prefix: "QA")
            await completeCheckout()
        }
    }

    private func runCardPayment() async {
        stage = .processing
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        referenceCode = Self.randomCode(prefix: "CD")
        await completeCheckout()
    }

    private func runCashPayment() async {
        stage = .processing
        try? await Task.sleep(nanoseconds: 800_000_000)
        referenceCode = Self.randomCode(prefix: "CS")
        await completeCheckout()
    }

    private func completeCheckout() async {
        let earnedPoints = Int(chargedTotal * 10)
        await viewModel.checkout(userId: hubViewModel.currentUser?.id)
        await hubViewModel.updateCurrentUser { user in
            user.loyaltyPoints += earnedPoints
        }
        withAnimation { stage = .done }
    }

    private static func randomCode(prefix: String) -> String {
        let letters = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        let randomPart = String((0..<8).map { _ in letters.randomElement()! })
        return "\(prefix)\(randomPart)"
    }
}
