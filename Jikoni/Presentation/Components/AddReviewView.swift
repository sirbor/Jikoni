import SwiftUI

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var rating: Int = 5
    @State private var comment: String = ""
    
    let onSave: (Review) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Rating") {
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .foregroundStyle(index <= rating ? Color(hex: "D4AF37") : .gray)
                                .onTapGesture {
                                    rating = index
                                }
                        }
                    }
                    .font(.title2)
                }
                
                Section("Your Feedback") {
                    TextEditor(text: $comment)
                        .frame(height: 150)
                }
                
                Section {
                    Button("Submit Review") {
                        let review = Review(author: "Current User", comment: comment, rating: rating)
                        onSave(review)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.orange)
                    .fontWeight(.bold)
                    .disabled(comment.isEmpty)
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
