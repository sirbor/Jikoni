import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    var isLiked: Bool = false
    let onLike: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // Rectangular Image Holder
                AsyncImage(url: URL(string: recipe.imageUrls.first ?? "")) { phase in
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
                .frame(height: 200)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.55)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Favorite Button
                Button(action: onLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(isLiked ? .red : .white)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color(hex: "D4AF37").opacity(0.5), lineWidth: 1)
                        )
                        .padding(12)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recipe.title)
                        .font(.custom("Georgia-Bold", size: 18))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(Color(hex: "D4AF37"))
                            .font(.system(size: 12))
                        Text("4.9")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                    }
                }
                
                Text(recipe.description)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label(recipe.author, systemImage: "person.circle.fill")
                    Spacer()
                    Label("25 mins", systemImage: "clock.fill")
                }
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color(hex: "CFB53B"))
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0.95), Color(hex: "F8F5ED").opacity(0.94)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "D4AF37").opacity(0.4), .clear, Color(hex: "CFB53B").opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
