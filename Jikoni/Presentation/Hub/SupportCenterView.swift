import SwiftUI

struct SupportCenterView: View {
    @Environment(\.openURL) private var openURL
    @State private var faqs = [
        FAQ(question: "How do I track my order?", answer: "Go to the 'Tracking' tab to see your order on a live map."),
        FAQ(question: "Can I cancel my order?", answer: "Orders can be canceled within 5 minutes of placement."),
        FAQ(question: "How do I earn rewards?", answer: "Earn points for every recipe you share and every ingredient you purchase.")
    ]
    @State private var showChatSheet = false
    @State private var supportMessage = ""
    @State private var showIssueSheet = false
    @State private var issueText = ""
    
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
                            .glassCard(cornerRadius: 20)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Need more help?")
                        .font(.headline)
                        .padding(.horizontal, 4)
                    
                    VStack(spacing: 12) {
                        Button {
                            showChatSheet = true
                        } label: {
                            Label("Chat with Us", systemImage: "bubble.left.and.bubble.right.fill")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(16)
                        }
                        
                        Button {
                            if let emailURL = URL(string: "mailto:support@jikoni.app?subject=Jikoni%20Support%20Request") {
                                openURL(emailURL)
                            }
                        } label: {
                            Label("Contact Support", systemImage: "envelope.fill")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.orange.opacity(0.1))
                                .foregroundColor(.orange)
                                .cornerRadius(16)
                        }

                        Button {
                            showIssueSheet = true
                        } label: {
                            Label("Report Disputed Order", systemImage: "exclamationmark.bubble.fill")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding()
                .glassCard(cornerRadius: 20)
            }
            .padding()
        }
        .navigationTitle("Support Center")
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showChatSheet) {
            NavigationStack {
                VStack(spacing: 16) {
                    Text("Live Support Chat")
                        .font(.headline)
                    Text("Describe your issue and our team will reach out shortly.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    TextEditor(text: $supportMessage)
                        .frame(minHeight: 180)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary.opacity(0.25))
                        )
                    Button("Send Message") {
                        supportMessage = ""
                        showChatSheet = false
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(supportMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    Spacer()
                }
                .padding()
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") {
                            showChatSheet = false
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showIssueSheet) {
            NavigationStack {
                VStack(spacing: 14) {
                    Text("Describe the issue with your order")
                        .font(.headline)
                    TextEditor(text: $issueText)
                        .frame(minHeight: 220)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray.opacity(0.2)))
                    Button("Submit Issue") {
                        issueText = ""
                        showIssueSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .disabled(issueText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    Spacer()
                }
                .padding()
                .navigationTitle("Issue Reporting")
            }
        }
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
