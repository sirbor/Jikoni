import SwiftUI

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.author)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(index <= review.rating ? Color(hex: "D4AF37") : Color.gray.opacity(0.3))
                    }
                }
            }
            
            Text(review.comment)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            
            Text(review.date.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
