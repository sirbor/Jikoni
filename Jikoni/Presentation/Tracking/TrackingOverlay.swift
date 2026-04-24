import SwiftUI

struct TrackingOverlay: View {
    var viewModel: TrackingViewModel
    @State private var isExpanded = false
    
    var body: some View {
        if let order = viewModel.activeOrder, order.status != .delivered {
            VStack(spacing: 0) {
                if isExpanded {
                    TrackingView(viewModel: viewModel)
                        .frame(height: 500)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        .transition(.move(edge: .bottom))
                }
                
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(.orange.gradient)
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "moped.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(isExpanded ? "Live Tracking" : "Tracking Order #\(order.id.prefix(6))")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Text(order.status.rawValue.capitalized)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.orange)
                        }
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.secondary)
                            .padding(10)
                            .background(Circle().fill(.gray.opacity(0.1)))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .onChange(of: order.status) { oldStatus, newStatus in
                if newStatus == .onTheWay && !isExpanded {
                    withAnimation(.spring()) { isExpanded = true }
                }
            }
        }
    }
}
