import SwiftUI

struct VendorCard: View {
    let vendor: Vendor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // Rectangular Image Holder
                AsyncImage(url: URL(string: vendor.imageUrls.first ?? "")) { phase in
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
                
                // Rating Overlay
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(hex: "D4AF37"))
                        .font(.system(size: 8))
                    Text(String(format: "%.1f", vendor.rating))
                        .font(.system(size: 10, weight: .bold))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(6)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(vendor.name)
                    .font(.custom("Georgia-Bold", size: 13))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack {
                    Text(vendor.cuisine)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "CFB53B"))
                    
                    Spacer()
                    
                    Label("$\(vendor.deliveryFee.formatted())", systemImage: "bicycle")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(8)
            .background(.ultraThinMaterial)
        }
        .frame(width: 150)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "D4AF37").opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
