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
            ZStack(alignment: .bottom) {
                if viewModel.isMapView {
                    vendorMap
                } else {
                    vendorGrid
                }
                
                FloatingCartButton(viewModel: viewModel)
                    .padding(.bottom, 20)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Explore")
                        .font(.custom("Georgia-Bold", size: 24))
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                            viewModel.isMapView.toggle()
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: viewModel.isMapView ? "square.grid.2x2.fill" : "map.fill")
                            Text(viewModel.isMapView ? "Grid" : "Map")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "D4AF37").opacity(0.1))
                        .foregroundStyle(Color(hex: "D4AF37"))
                        .clipShape(Capsule())
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
                    NavigationLink {
                        VendorDetailView(vendor: vendor)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color(hex: "D4AF37"))
                                .background(.black)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                            
                            Text(vendor.name)
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
    }
}
