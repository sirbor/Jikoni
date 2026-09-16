import SwiftUI

/// Map drawn as an abstraction, not decoration — the timeline below carries
/// the detail the map cannot.
struct TrackingView: View {
    @State var viewModel: TrackingViewModel
    @Environment(\.openURL) private var openURL
    @Environment(\.switchTab) private var switchTab
    enum TrackingMode: String, CaseIterable {
        case active = "Active Delivery"
        case history = "Order History"
    }

    @State private var trackingMode: TrackingMode = .active
    @State private var selectedReceiptOrder: Order?
    @State private var chatMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Segmented Mode Selector
                HStack(spacing: 4) {
                    ForEach(TrackingMode.allCases, id: \.self) { mode in
                        let isSelected = trackingMode == mode
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                trackingMode = mode
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: mode == .active ? "location.fill" : "clock.arrow.circlepath")
                                    .font(.system(size: 11, weight: .bold))
                                Text(mode == .active ? "Live Delivery" : "Order History (\(viewModel.pastOrders.count))")
                                    .font(JikoniFont.archivo(12.5, weight: isSelected ? .extrabold : .semibold))
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
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 8)

                ScrollView {
                    if trackingMode == .active {
                        activeDeliveryContent
                    } else {
                        orderHistoryContent
                    }
                }
            }
            .background(JikoniColor.ground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .sheet(item: $selectedReceiptOrder) { order in
                ReceiptDetailView(order: order)
            }
        }
    }

    @ViewBuilder
    private var activeDeliveryContent: some View {
        if let order = viewModel.activeOrder {
            header(order)
            liveOrderActionsBar(order)
            abstractMap
            riderCard
            timelineCard(order)
            if let note = order.receiptNotes.isEmpty ? nil : order.receiptNotes {
                dropOffNote(note)
            }

            VStack(spacing: 10) {
                Button {
                    Task { await viewModel.confirmDelivery() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 15))
                        Text("I have received my order")
                            .font(JikoniFont.archivo(13.5, weight: .extrabold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(JikoniColor.ink)
                    .foregroundStyle(JikoniColor.ground)
                    .clipShape(Capsule())
                }

                Button {
                    Task { await viewModel.stopActiveOrder() }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 14))
                        Text("Cancel / Stop Tracking")
                            .font(JikoniFont.archivo(12.5, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.clear)
                    .foregroundStyle(JikoniColor.accent)
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 24)
        } else {
            emptyTrackingState
        }
    }

    private var orderHistoryContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("PAST ORDERS & RECEIPTS")
                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    .tracking(1.2)
                    .foregroundStyle(JikoniColor.textSecondary)
                Spacer()
                Text("\(viewModel.pastOrders.count) orders")
                    .font(JikoniFont.archivo(11))
                    .foregroundStyle(JikoniColor.textSecondary)
            }

            if viewModel.pastOrders.isEmpty {
                VStack(spacing: 14) {
                    Image(systemName: "shippingbox.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(JikoniColor.textSecondary.opacity(0.6))
                    Text("No past orders found")
                        .font(JikoniFont.archivo(15, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                    Text("Orders you place from local kitchens and cooks will be archived here.")
                        .font(JikoniFont.archivo(12.5))
                        .foregroundStyle(JikoniColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
                .background(JikoniColor.card)
                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                .jikoniShadow(.small)
            } else {
                ForEach(viewModel.pastOrders) { order in
                    Button {
                        selectedReceiptOrder = order
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(order.restaurantName)
                                    .font(JikoniFont.archivo(15, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                                Spacer()
                                Text(order.status == .delivered ? "Delivered" : "In Transit")
                                    .font(JikoniFont.archivo(11, weight: .extrabold))
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 4)
                                    .background(order.status == .delivered ? JikoniColor.accent.opacity(0.12) : JikoniColor.ink)
                                    .foregroundStyle(order.status == .delivered ? JikoniColor.accent : JikoniColor.ground)
                                    .clipShape(Capsule())
                            }

                            Text(order.items.map { "\($0.amount) \($0.name)" }.joined(separator: ", "))
                                .font(JikoniFont.archivo(12))
                                .foregroundStyle(JikoniColor.textSecondary)
                                .lineLimit(2)

                            Divider().opacity(0.4)

                            HStack {
                                HStack(spacing: 4) {
                                    Image(systemName: order.paymentMethod.contains("Card") ? "creditcard.fill" : (order.paymentMethod.contains("Cash") ? "banknote.fill" : "iphone.radiowaves.left.and.right"))
                                        .font(.system(size: 11))
                                    Text(order.paymentMethod)
                                        .font(JikoniFont.archivo(11))
                                }
                                .foregroundStyle(JikoniColor.textSecondary)

                                Spacer()

                                Text(order.total.currencyString())
                                    .font(JikoniFont.archivo(15, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                            }
                        }
                        .padding(16)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                        .jikoniShadow(.small)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 10)
        .padding(.bottom, 24)
    }

    private var emptyTrackingState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(JikoniColor.card)
                    .frame(width: 90, height: 90)
                    .jikoniShadow(.small)
                Image(systemName: "box.truck.badge.clock")
                    .font(.system(size: 38))
                    .foregroundStyle(JikoniColor.accent)
            }

            VStack(spacing: 6) {
                Text("No Active Deliveries")
                    .font(JikoniFont.instrumentSerif(30))
                    .foregroundStyle(JikoniColor.ink)
                Text("When you order fresh ingredients or dishes from local kitchens, track them here in real time.")
                    .font(JikoniFont.archivo(13))
                    .foregroundStyle(JikoniColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .padding(.horizontal, 32)
            }

            VStack(spacing: 10) {
                Button {
                    switchTab(.order)
                } label: {
                    HStack(spacing: 6) {
                        Text("Explore Kitchens")
                            .font(JikoniFont.archivo(13.5, weight: .extrabold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .frame(maxWidth: 240)
                    .frame(height: 50)
                    .background(JikoniColor.ink)
                    .foregroundStyle(JikoniColor.ground)
                    .clipShape(Capsule())
                    .jikoniShadow(.small)
                }

                Button {
                    Task {
                        await viewModel.startDemoOrder()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 13))
                        Text("Start a Live Demo Order")
                            .font(JikoniFont.archivo(12.5, weight: .bold))
                    }
                    .frame(maxWidth: 240)
                    .frame(height: 44)
                    .background(JikoniColor.card)
                    .foregroundStyle(JikoniColor.ink)
                    .clipShape(Capsule())
                    .jikoniShadow(.small)
                }
            }
            .padding(.top, 6)
        }
        .padding(.top, 80)
    }

    private func header(_ order: Order) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(order.status == .delivered ? "Delivered" : "On the way")
                    .font(JikoniFont.archivo(20, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Text("Order #\(order.id.prefix(6)) · \(order.restaurantName)")
                    .font(JikoniFont.archivo(11.5))
                    .foregroundStyle(JikoniColor.textSecondary)
            }
            Spacer()
            HStack(spacing: 8) {
                Text(etaLabel(order))
                    .font(JikoniFont.archivo(12, weight: .extrabold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(JikoniColor.ink)
                    .foregroundStyle(JikoniColor.ground)
                    .clipShape(Capsule())

                Button {
                    Task { await viewModel.stopActiveOrder() }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(JikoniColor.ink)
                        .padding(10)
                        .background(JikoniColor.card)
                        .clipShape(Circle())
                        .jikoniShadow(.small)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    private func liveOrderActionsBar(_ order: Order) -> some View {
        HStack(spacing: 10) {
            Button {
                Task {
                    await viewModel.stopActiveOrder()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text("Stop Demo Order")
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(JikoniColor.card)
                .foregroundStyle(JikoniColor.accent)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(JikoniColor.accent.opacity(0.35), lineWidth: 1))
                .jikoniShadow(.small)
            }

            Button {
                Task {
                    await viewModel.confirmDelivery()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text("Mark Delivered")
                        .font(JikoniFont.archivo(12.5, weight: .extrabold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(JikoniColor.ink)
                .foregroundStyle(JikoniColor.ground)
                .clipShape(Capsule())
                .jikoniShadow(.small)
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 6)
    }

    private var abstractMap: some View {
        ZStack {
            JikoniColor.surface
            GeometryReader { geo in
                Path { path in
                    let step: CGFloat = 32
                    var x: CGFloat = 0
                    while x < geo.size.width { path.move(to: CGPoint(x: x, y: 0)); path.addLine(to: CGPoint(x: x, y: geo.size.height)); x += step }
                    var y: CGFloat = 0
                    while y < geo.size.height { path.move(to: CGPoint(x: 0, y: y)); path.addLine(to: CGPoint(x: geo.size.width, y: y)); y += step }
                }
                .stroke(JikoniColor.ink.opacity(0.08), lineWidth: 1)

                Path { path in
                    path.move(to: CGPoint(x: geo.size.width * 0.78, y: geo.size.height * 0.82))
                    path.addCurve(
                        to: CGPoint(x: geo.size.width * 0.22, y: geo.size.height * 0.2),
                        control1: CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.55),
                        control2: CGPoint(x: geo.size.width * 0.35, y: geo.size.height * 0.35)
                    )
                }
                .stroke(JikoniColor.ink, style: StrokeStyle(lineWidth: 3, dash: [9, 8]))
            }
            .frame(height: 260)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    riderPin
                    Spacer()
                    Spacer()
                }
                Spacer()
                HStack {
                    destinationPin
                    Spacer()
                }
                Spacer().frame(height: 30)
            }
        }
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .padding(.horizontal, 18)
        .padding(.bottom, 14)
    }

    private var riderPin: some View {
        ZStack {
            Circle().fill(JikoniColor.accent.opacity(0.3)).frame(width: 50, height: 50)
            Circle().fill(JikoniColor.accent).frame(width: 24, height: 24).overlay(Circle().stroke(.white, lineWidth: 4))
        }
    }

    private var destinationPin: some View {
        Circle().fill(JikoniColor.ink).frame(width: 22, height: 22).overlay(Circle().stroke(.white, lineWidth: 4))
    }

    private var riderCard: some View {
        HStack(spacing: 13) {
            Circle().fill(JikoniColor.placeholderAlt).frame(width: 46, height: 46)
            VStack(alignment: .leading, spacing: 3) {
                Text("Your rider").font(JikoniFont.archivo(14, weight: .extrabold)).foregroundStyle(JikoniColor.ink)
                Text("On the way to you").font(JikoniFont.archivo(11.5)).foregroundStyle(JikoniColor.textSecondary)
            }
            Spacer()
            Button {
                if let url = URL(string: "tel://+254700987654") { openURL(url) }
            } label: {
                Image(systemName: "phone.fill")
                    .frame(width: 44, height: 44)
                    .background(JikoniColor.ground)
                    .foregroundStyle(JikoniColor.ink)
                    .clipShape(Circle())
            }
            Button {
                if let url = URL(string: "https://wa.me/254700987654") { openURL(url) }
            } label: {
                Image(systemName: "message.fill")
                    .frame(width: 44, height: 44)
                    .background(JikoniColor.ink)
                    .foregroundStyle(JikoniColor.ground)
                    .clipShape(Circle())
            }
        }
        .padding(14)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
        .jikoniShadow(.small)
        .padding(.horizontal, 18)
        .padding(.bottom, 14)
    }

    private func timelineCard(_ order: Order) -> some View {
        let steps = timelineSteps(for: order.status)
        return VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 13) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(step.state == .todo ? JikoniColor.ground : (step.state == .now ? JikoniColor.accent : JikoniColor.ink))
                                .frame(width: 26, height: 26)
                            if step.state != .todo {
                                Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
                            }
                        }
                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(step.state == .todo ? JikoniColor.placeholder : JikoniColor.ink)
                                .frame(width: 2)
                                .frame(minHeight: 30)
                        }
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text(step.title)
                            .font(JikoniFont.archivo(13.5, weight: .extrabold))
                            .foregroundStyle(step.state == .todo ? JikoniColor.textSecondary : JikoniColor.ink)
                        Text(step.detail)
                            .font(JikoniFont.archivo(11.5))
                            .foregroundStyle(JikoniColor.textSecondary)
                    }
                    .padding(.bottom, 18)
                }
            }
        }
        .padding(18)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .jikoniShadow(.small)
        .padding(.horizontal, 18)
        .padding(.bottom, 14)
    }

    private func dropOffNote(_ note: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("DROP-OFF NOTE")
                .font(JikoniFont.archivo(10.5, weight: .extrabold))
                .foregroundStyle(JikoniColor.textSecondary)
            Text(note)
                .font(JikoniFont.archivo(12.5))
                .foregroundStyle(JikoniColor.ink)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .jikoniShadow(.small)
        .padding(.horizontal, 18)
        .padding(.bottom, 20)
    }

    private enum StepState { case done, now, todo }
    private struct TimelineStep { let title: String; let detail: String; let state: StepState }

    private func timelineSteps(for status: OrderStatus) -> [TimelineStep] {
        let order: [OrderStatus] = [.received, .preparing, .onTheWay, .delivered]
        let currentIndex = order.firstIndex(of: normalizedStatus(status)) ?? 0
        let titles = ["Order placed", "Kitchen cooking", "Rider on the way", "Handed over"]
        let details = ["Paid and confirmed", "Chef is preparing your items", "Rider is approaching", "Delivered to your doorstep"]
        return (0..<4).map { i in
            let state: StepState = i < currentIndex ? .done : (i == currentIndex ? .now : .todo)
            return TimelineStep(title: titles[i], detail: details[i], state: state)
        }
    }

    private func normalizedStatus(_ status: OrderStatus) -> OrderStatus {
        switch status {
        case .received, .confirmed: return .received
        case .preparing, .riderAssigned: return .preparing
        case .onTheWay: return .onTheWay
        case .delivered, .cancelled: return .delivered
        }
    }

    private func etaLabel(_ order: Order) -> String {
        switch order.status {
        case .received: return "32 min"
        case .confirmed: return "28 min"
        case .preparing: return "22 min"
        case .riderAssigned: return "16 min"
        case .onTheWay: return "8 min"
        case .delivered: return "Delivered"
        case .cancelled: return "Cancelled"
        }
    }
}
