import SwiftUI

struct OrderHistoryView: View {
    @Bindable var viewModel: HubViewModel
    @Environment(MarketplaceViewModel.self) private var marketplaceViewModel
    @State private var supportAlertMessage: String?
    @State private var selectedOrder: Order?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.orders.isEmpty {
                    ContentUnavailableView(
                        "No Orders Yet",
                        systemImage: "shippingbox",
                        description: Text("Your past orders will appear here.")
                    )
                    .padding(.top, 100)
                } else {
                    ForEach(viewModel.orders) { order in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Order #\(order.id.prefix(8))")
                                    .fontWeight(.bold)
                                Spacer()
                                StatusBadge(status: order.status)
                            }
                            
                            Text("\(order.items.count) Items")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(order.restaurantName) • \(order.createdAt.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Text("Total: \(order.total.currencyString())")
                                    .fontWeight(.medium)
                                Spacer()
                                Button("Request Return") {
                                    viewModel.requestReturn(orderId: order.id)
                                    supportAlertMessage = viewModel.lastSupportMessage
                                }
                                .disabled(viewModel.hasRequestedReturn(orderId: order.id))
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background((viewModel.hasRequestedReturn(orderId: order.id) ? Color.green : Color.orange).opacity(0.12))
                                .foregroundColor(viewModel.hasRequestedReturn(orderId: order.id) ? .green : .orange)
                                .cornerRadius(12)

                                Button("Reorder") {
                                    marketplaceViewModel.reorder(from: order)
                                    supportAlertMessage = "Order added back to cart for quick checkout."
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.green.opacity(0.12))
                                .foregroundColor(.green)
                                .cornerRadius(12)
                            }

                            Button("View Receipt") {
                                selectedOrder = order
                            }
                            .font(.caption)
                        }
                        .padding()
                        .glassCard(cornerRadius: 20)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Order History")
        .background(Color(.systemGroupedBackground))
        .alert("Support Update", isPresented: Binding(
            get: { supportAlertMessage != nil },
            set: { newValue in
                if !newValue { supportAlertMessage = nil }
            }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(supportAlertMessage ?? "")
        }
        .sheet(item: $selectedOrder) { order in
            ReceiptDetailView(order: order)
        }
    }
}

struct StatusBadge: View {
    let status: OrderStatus
    
    var color: Color {
        switch status {
        case .received: return .blue
        case .confirmed: return .cyan
        case .preparing: return .orange
        case .riderAssigned: return .purple
        case .onTheWay: return .indigo
        case .delivered: return .green
        }
    }
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(8)
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
        Delivery Fee: \((order.total - order.subtotal - order.serviceFee + order.discount - order.tip).currencyString())
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
                    .glassCard(cornerRadius: 16)
                    .padding()
            }
            .navigationTitle("Order Receipt")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: receiptText) {
                        Label("Export PDF", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}
