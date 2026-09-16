import SwiftUI

/// Active order pinned in the surface tone; reorder re-prices before charging.
struct OrdersView: View {
    @Bindable var viewModel: HubViewModel
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.switchTab) private var switchTab
    @State private var supportAlertMessage: String?
    @State private var selectedOrder: Order?

    private var activeOrder: Order? {
        viewModel.orders.first { $0.status != .delivered }
    }

    private var pastOrders: [Order] {
        viewModel.orders.filter { $0.status == .delivered }
    }

    var body: some View {
        VStack(spacing: 0) {
            JikoniHeaderRow(title: "Orders", onBack: { dismiss() })

            ScrollView {
                if viewModel.orders.isEmpty {
                    ContentUnavailableView(
                        "No Orders Yet",
                        systemImage: "shippingbox",
                        description: Text("Your past orders will appear here.")
                    )
                    .padding(.top, 100)
                } else {
                    VStack(spacing: 16) {
                        if let order = activeOrder {
                            activeOrderCard(order)
                        }

                        if !pastOrders.isEmpty {
                            Text("Past orders")
                                .font(JikoniFont.archivo(17, weight: .extrabold))
                                .foregroundStyle(JikoniColor.ink)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(pastOrders) { order in
                                pastOrderRow(order)
                            }
                        }
                    }
                    .padding(18)
                }
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .task {
            await viewModel.fetchOrders()
            if marketplaceViewModel.vendors.isEmpty { await marketplaceViewModel.fetchVendors() }
        }
        .alert("Support Update", isPresented: Binding(
            get: { supportAlertMessage != nil },
            set: { if !$0 { supportAlertMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(supportAlertMessage ?? "")
        }
        .sheet(item: $selectedOrder) { order in
            ReceiptDetailView(order: order)
        }
    }

    private static func statusLabel(_ status: OrderStatus) -> String {
        switch status {
        case .received: return "Received"
        case .confirmed: return "Confirmed"
        case .preparing: return "Preparing"
        case .riderAssigned: return "Rider assigned"
        case .onTheWay: return "On the way"
        case .delivered: return "Delivered"
        case .cancelled: return "Cancelled"
        }
    }

    private func activeOrderCard(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle().fill(JikoniColor.accent).frame(width: 8, height: 8)
                Text("IN PROGRESS")
                    .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    .tracking(1.2)
                    .foregroundStyle(JikoniColor.accent)
                Spacer()
                Text(Self.statusLabel(order.status))
                    .font(JikoniFont.archivo(12, weight: .extrabold))
                    .foregroundStyle(.white)
            }
            Text("\(order.restaurantName) · #\(order.id.prefix(6))")
                .font(JikoniFont.archivo(16, weight: .extrabold))
                .foregroundStyle(.white)
            Text("\(order.items.count) items · \(order.total.currencyString())")
                .font(JikoniFont.archivo(11.5))
                .foregroundStyle(.white.opacity(0.7))

            Button {
                switchTab(.track)
            } label: {
                Text("Track order")
                    .font(JikoniFont.archivo(13, weight: .extrabold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(JikoniColor.ground)
                    .foregroundStyle(JikoniColor.ink)
                    .clipShape(Capsule())
            }
        }
        .padding(18)
        .background(JikoniColor.ink)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .jikoniShadow(.medium)
    }

    private func pastOrderRow(_ order: Order) -> some View {
        HStack(spacing: 13) {
            Rectangle().fill(JikoniColor.placeholder).frame(width: 64, height: 64).clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 4) {
                Text(order.restaurantName).font(JikoniFont.archivo(14, weight: .extrabold)).foregroundStyle(JikoniColor.ink)
                Text("\(order.items.count) items")
                    .font(JikoniFont.archivo(11.5))
                    .foregroundStyle(JikoniColor.textSecondary)
                Text("\(order.createdAt.formatted(date: .abbreviated, time: .omitted)) · \(order.total.currencyString())")
                    .font(JikoniFont.archivo(11.5, weight: .extrabold))
                    .foregroundStyle(JikoniColor.textSecondary)
            }
            Spacer()
            Button {
                let skipped = marketplaceViewModel.reorder(from: order)
                supportAlertMessage = skipped == 0
                    ? "Order added back to your basket, re-priced against tonight's menu."
                    : "Added back to your basket at tonight's prices. \(skipped) item\(skipped == 1 ? "" : "s") no longer on the menu were left out."
            } label: {
                Text("Reorder")
                    .font(JikoniFont.archivo(11.5, weight: .extrabold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(JikoniColor.ground)
                    .foregroundStyle(JikoniColor.ink)
                    .clipShape(Capsule())
            }
        }
        .padding(12)
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
        .jikoniShadow(.small)
        .onTapGesture { selectedOrder = order }
    }
}

struct ReceiptDetailView: View {
    let order: Order

    private var receiptText: String {
        let lines = order.items.map { "- \($0.name) \($0.price.currencyString())" }.joined(separator: "\n")
        return """
        Order ID: \(order.id)
        Date: \(order.createdAt.formatted(date: .abbreviated, time: .shortened))
        Restaurant: \(order.restaurantName)
        Payment: \(order.paymentMethod)

        Items:
        \(lines)

        Subtotal: \(order.subtotal.currencyString())
        Service Fee: \(order.serviceFee.currencyString())
        Discount: -\(order.discount.currencyString())
        Tip: \(order.tip.currencyString())
        Total: \(order.total.currencyString())
        """
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(receiptText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .font(.system(.footnote, design: .monospaced))
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                    .padding()
            }
            .background(JikoniColor.ground.ignoresSafeArea())
            .navigationTitle("Order Receipt")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: receiptText) {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}
