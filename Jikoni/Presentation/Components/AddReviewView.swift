import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var restaurantRating: Int = 5
    @State private var riderRating: Int = 5
    @State private var comment: String = ""
    @State private var photoAttachments: [String] = []
    
    let onSave: (Review) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Food Quality Rating") {
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= restaurantRating ? "star.fill" : "star")
                                .foregroundStyle(index <= restaurantRating ? Color(hex: "D4AF37") : .gray)
                                .onTapGesture {
                                    restaurantRating = index
                                }
                        }
                    }
                    .font(.title2)
                }

                Section("Rider Rating") {
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= riderRating ? "star.fill" : "star")
                                .foregroundStyle(index <= riderRating ? Color(hex: "D4AF37") : .gray)
                                .onTapGesture {
                                    riderRating = index
                                }
                        }
                    }
                    .font(.title2)
                }
                
                Section("Your Feedback") {
                    TextEditor(text: $comment)
                        .frame(height: 150)
                    Text("\(comment.count)/280")
                        .font(.caption)
                        .foregroundStyle(comment.count > 280 ? .red : .secondary)
                }

                Section("Photo Review (up to 3)") {
                    ForEach(photoAttachments, id: \.self) { attachment in
                        Text(attachment)
                    }
                    Button("Attach Sample Photo") {
                        guard photoAttachments.count < 3 else { return }
                        photoAttachments.append("food-photo-\(photoAttachments.count + 1).jpg")
                    }
                }
                
                Section {
                    Button("Submit Review") {
                        let review = Review(
                            author: "Current User",
                            comment: "\(comment)\n(Rider: \(riderRating)/5)",
                            rating: restaurantRating,
                            photoUrls: photoAttachments
                        )
                        onSave(review)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.orange)
                    .fontWeight(.bold)
                    .disabled(comment.isEmpty || comment.count > 280)
                }
            }
            .navigationTitle("Add Review")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
