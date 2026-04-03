import SwiftUI
import MapKit

struct ExploreView: View {
    @State var viewModel: MarketplaceViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isMapView {
                    vendorMap
                } else {
                    vendorGrid
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 12) {
                        JikoniLogo(size: 30, showText: false)
                        Text("Explore")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring()) { viewModel.isMapView.toggle() }
                    } label: {
                        Image(systemName: viewModel.isMapView ? "square.grid.2x2.fill" : "map.fill")
                            .foregroundStyle(.orange)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: CartView(viewModel: viewModel)) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart.fill")
                                .font(.title3)
                                .foregroundStyle(.orange)
                            
                            if !viewModel.cart.isEmpty {
                                Text("\(viewModel.cart.values.reduce(0, +))")
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(4)
                                    .background(.red)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .offset(x: 10, y: -10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchVendors()
            }
        }
    }
    
    private var vendorGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.vendors) { vendor in
                    NavigationLink {
                        VendorDetailView(vendor: vendor)
                    } label: {
                        VendorCard(vendor: vendor)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var vendorMap: some View {
        Map {
            ForEach(viewModel.vendors) { vendor in
                Annotation(vendor.name, coordinate: CLLocationCoordinate2D(latitude: vendor.location.latitude, longitude: vendor.location.longitude)) {
                    VStack {
                        Image(systemName: "storefront.fill")
                            .padding(8)
                            .background(.orange)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                        
                        Text(vendor.name)
                            .font(.caption2)
                            .padding(4)
                            .background(.ultraThinMaterial)
                            .cornerRadius(4)
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
    }
}
