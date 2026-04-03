import SwiftUI

struct VendorCard: View {
    let vendor: Vendor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: vendor.imageUrl)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 100)
            .clipped()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(vendor.name)
                    .font(.system(size: 13, weight: .bold))
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 9))
                    Text(String(format: "%.1f", vendor.rating))
                        .font(.system(size: 11, weight: .medium))
                    
                    Text("•")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Text("$\(vendor.deliveryFee.formatted())")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                if let inventory = vendor.inventory, !inventory.isEmpty {
                    Text(inventory.keys.joined(separator: ", "))
                        .font(.system(size: 9))
                        .foregroundColor(.orange)
                        .lineLimit(1)
                } else {
                    Text("Local Restaurant")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
