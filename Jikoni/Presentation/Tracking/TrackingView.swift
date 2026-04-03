import SwiftUI
import MapKit

struct TrackingView: View {
    @State var viewModel: TrackingViewModel
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if let activeOrder = viewModel.activeOrder {
                    Map(position: $position) {
                        if let dest = activeOrder.destinationLocation {
                            Marker("You", systemImage: "house.fill", coordinate: CLLocationCoordinate2D(latitude: dest.latitude, longitude: dest.longitude))
                                .tint(.blue)
                        }
                        
                        if let courier = activeOrder.courierLocation {
                            Annotation("Rider", coordinate: CLLocationCoordinate2D(latitude: courier.latitude, longitude: courier.longitude)) {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 40, height: 40)
                                        .shadow(radius: 5)
                                    
                                    Image(systemName: "moped.fill")
                                        .foregroundStyle(.orange)
                                        .font(.title3)
                                }
                            }
                        }
                    }
                    .mapStyle(.standard(elevation: .realistic))
                    
                    statusCard(order: activeOrder)
                        .padding()
                } else {
                    ContentUnavailableView(
                        "No Active Orders",
                        systemImage: "truck.box",
                        description: Text("Place an order in the marketplace to track it here.")
                    )
                }
            }
            .navigationTitle("Track Order")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.activeOrder?.courierLocation) { _, newLoc in
                if let loc = newLoc {
                    withAnimation {
                        position = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude), distance: 1000))
                    }
                }
            }
            .task {
                await viewModel.startTracking()
            }
        }
    }
    
    private func statusCard(order: Order) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text(order.status.rawValue.capitalized)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text(deliverySubtitle(for: order.status))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "moped.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
            }
            
            ProgressView(value: viewModel.statusProgress)
                .tint(.orange)
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            Divider()
            
            HStack {
                Text("Order Total")
                    .fontWeight(.semibold)
                Spacer()
                Text("$\(order.total.formatted())")
            }
            .font(.footnote)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private func deliverySubtitle(for status: OrderStatus) -> String {
        switch status {
        case .placed: return "Waiting for confirmation"
        case .preparing: return "Chef is preparing your items"
        case .pickedUp: return "Rider has your items"
        case .delivering: return "Rider is approaching"
        case .completed: return "Delivered to your doorstep"
        }
    }
}
