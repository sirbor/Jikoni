import SwiftUI

struct VendorCard: View {
    let vendor: Vendor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: vendor.imageUrls.first ?? "")) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.15))
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
                .frame(height: 120)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.58)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(vendor.name)
                    .font(.custom("Georgia-Bold", size: 13))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                HStack {
                    Text(vendor.cuisine)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(hex: "CFB53B"))
                    
                    Spacer()
                    
                    Label(vendor.deliveryFee.currencyString(), systemImage: "bicycle")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                }

                HStack(spacing: 8) {
                    Text(vendor.isOpenNow ? "Open" : "Closed")
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background((vendor.isOpenNow ? Color.green : Color.gray).opacity(0.16))
                        .foregroundStyle(vendor.isOpenNow ? .green : .secondary)
                        .clipShape(Capsule())

                    Text("~\(vendor.estimatedDeliveryMinutes)m")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(10)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0.95), Color(hex: "F8F5ED").opacity(0.92)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .frame(width: 150)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(hex: "D4AF37").opacity(0.35), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}
