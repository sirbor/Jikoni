import SwiftUI

struct OrderHistoryView: View {
    @Bindable var viewModel: HubViewModel
    
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
                            
                            HStack {
                                Text("Total: $\(order.total.formatted())")
                                    .fontWeight(.medium)
                                Spacer()
                                Button("Request Return") {
                                    viewModel.requestReturn(orderId: order.id)
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Order History")
        .background(Color(.systemGroupedBackground))
    }
}

struct StatusBadge: View {
    let status: OrderStatus
    
    var color: Color {
        switch status {
        case .placed: return .blue
        case .preparing: return .orange
        case .pickedUp: return .purple
        case .delivering: return .indigo
        case .completed: return .green
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
