import SwiftUI

struct SupportCenterView: View {
    @State private var faqs = [
        FAQ(question: "How do I track my order?", answer: "Go to the 'Tracking' tab to see your order on a live map."),
        FAQ(question: "Can I cancel my order?", answer: "Orders can be canceled within 5 minutes of placement."),
        FAQ(question: "How do I earn rewards?", answer: "Earn points for every recipe you share and every ingredient you purchase.")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Frequently Asked Questions")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    
                    VStack(spacing: 12) {
                        ForEach(faqs) { faq in
                            DisclosureGroup(faq.question) {
                                Text(faq.answer)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Need more help?")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    
                    VStack(spacing: 12) {
                        Button(action: {}) {
                            Label("Chat with Us", systemImage: "bubble.left.and.bubble.right.fill")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(16)
                        }
                        
                        Button(action: {}) {
                            Label("Contact Support", systemImage: "envelope.fill")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(16)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Support Center")
        .background(Color(.systemGroupedBackground))
    }
}

struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

#Preview {
    NavigationStack {
        SupportCenterView()
    }
}
