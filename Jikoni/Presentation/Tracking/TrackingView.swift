import SwiftUI
import MapKit

struct TrackingView: View {
    @State var viewModel: TrackingViewModel
    @State private var position: MapCameraPosition = .automatic
    @Environment(\.openURL) private var openURL
    @State private var chatMessage = ""
    @State private var etaMinutes = 28
    @State private var showDeliveredAlert = false
    
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
            .onChange(of: viewModel.activeOrder?.status) { _, newStatus in
                switch newStatus {
                case .received: etaMinutes = 32
                case .confirmed: etaMinutes = 28
                case .preparing: etaMinutes = 22
                case .riderAssigned: etaMinutes = 16
                case .onTheWay: etaMinutes = 8
                case .delivered: etaMinutes = 0
                case .none: break
                }
            }
            .alert("Delivery Confirmed", isPresented: $showDeliveredAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Thanks! Please leave a quick review from your order history.")
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

            HStack {
                Label("ETA", systemImage: "clock")
                Spacer()
                Text("\(etaMinutes) min")
                    .fontWeight(.bold)
            }
            .font(.subheadline)
            
            ProgressView(value: viewModel.statusProgress)
                .tint(.orange)
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            Divider()
            
            HStack {
                Text("Order Total")
                    .fontWeight(.semibold)
                Spacer()
                Text(order.total.currencyString())
            }
            .font(.footnote)

            HStack(spacing: 10) {
                Button {
                    if let phoneURL = URL(string: "tel://+254700987654") { openURL(phoneURL) }
                } label: {
                    Label("Call Rider", systemImage: "phone.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    if let whatsappURL = URL(string: "https://wa.me/254700987654") { openURL(whatsappURL) }
                } label: {
                    Label("WhatsApp", systemImage: "message.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Restaurant Chat")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("Send quick note to restaurant", text: $chatMessage)
                    .textFieldStyle(.roundedBorder)
                Button("Send Message") {
                    chatMessage = ""
                }
                .buttonStyle(.borderedProminent)
                .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if order.status == .delivered {
                Button("Confirm Receipt") {
                    showDeliveredAlert = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private func deliverySubtitle(for status: OrderStatus) -> String {
        switch status {
        case .received: return "Order received by restaurant"
        case .confirmed: return "Restaurant confirmed your order"
        case .preparing: return "Chef is preparing your items"
        case .riderAssigned: return "A rider has been assigned"
        case .onTheWay: return "Rider is approaching"
        case .delivered: return "Delivered to your doorstep"
        }
    }
}
