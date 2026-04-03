import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    var isLiked: Bool = false
    let onLike: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: recipe.imageUrl)) { phase in
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
                
                Button(action: onLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(isLiked ? .red : .white)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .padding(12)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(recipe.title)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .lineLimit(1)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("4.8")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
                
                Text(recipe.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Label(recipe.author, systemImage: "person.circle")
                    Spacer()
                    Label("25 min", systemImage: "clock")
                }
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.orange)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
