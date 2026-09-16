import SwiftUI

/// Every recipe carries a one-tap bridge into the marketplace via "Order it".
struct RecipeCard<Destination: View>: View {
    let recipe: Recipe
    var isLiked: Bool = false
    let onLike: () -> Void
    @ViewBuilder var destination: () -> Destination

    @Environment(\.switchTab) private var switchTab

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                Circle()
                    .fill(JikoniColor.placeholderAlt)
                    .frame(width: 34, height: 34)
                Text(recipe.author)
                    .font(JikoniFont.archivo(12.5, weight: .extrabold))
                    .foregroundStyle(JikoniColor.ink)
                Spacer()
            }
            .padding(.bottom, 12)

            NavigationLink(destination: destination) {
                VStack(alignment: .leading, spacing: 0) {
                    AsyncImage(url: URL(string: recipe.imageUrls.first ?? "")) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(JikoniColor.placeholder)
                                .overlay(ProgressView())
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Rectangle()
                                .fill(JikoniColor.placeholder)
                                .overlay(Image(systemName: "photo").foregroundStyle(JikoniColor.textSecondary))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 198)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.cardSmall))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(recipe.title)
                            .font(JikoniFont.instrumentSerif(26))
                            .foregroundStyle(JikoniColor.ink)
                            .lineLimit(1)

                        Text(recipe.description)
                            .font(JikoniFont.archivo(12))
                            .foregroundStyle(JikoniColor.textSecondary)
                            .lineLimit(2)
                    }
                    .padding(.top, 14)
                }
            }
            .buttonStyle(.plain)
            .overlay(alignment: .topTrailing) {
                Button(action: onLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isLiked ? JikoniColor.accent : JikoniColor.ink)
                        .padding(10)
                        .background(JikoniColor.card)
                        .clipShape(Circle())
                        .jikoniShadow(.small)
                        .padding(12)
                }
            }

            HStack(spacing: 14) {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("25 min")
                }
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(JikoniColor.accent)
                    Text("\(recipe.likes)")
                }
                Spacer()
                Button {
                    switchTab(.order)
                } label: {
                    Text("Order it")
                        .font(JikoniFont.archivo(12, weight: .extrabold))
                        .padding(.horizontal, 20)
                        .frame(height: 42)
                        .background(JikoniColor.ink)
                        .foregroundStyle(JikoniColor.ground)
                        .clipShape(Capsule())
                }
            }
            .font(JikoniFont.archivo(12, weight: .extrabold))
            .foregroundStyle(JikoniColor.textSecondary)
            .padding(.top, 13)
        }
        .padding(EdgeInsets(top: 14, leading: 15, bottom: 15, trailing: 15))
        .background(JikoniColor.card)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
        .jikoniShadow(.medium)
    }
}
