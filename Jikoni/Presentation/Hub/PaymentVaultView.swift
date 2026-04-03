import SwiftUI

struct PaymentVaultView: View {
    @State private var paymentMethods = [
        PaymentMethod(id: "1", type: "Visa", lastFour: "1234", expiry: "12/26"),
        PaymentMethod(id: "2", type: "Mastercard", lastFour: "5678", expiry: "08/25")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(paymentMethods) { method in
                    HStack(spacing: 16) {
                        Image(systemName: "creditcard.fill")
                            .foregroundStyle(.orange.gradient)
                            .font(.title)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(method.type) •••• \(method.lastFour)")
                                .font(.headline)
                            Text("Expires \(method.expiry)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if method.id == "1" {
                            Text("Primary")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.orange.opacity(0.1))
                                .foregroundStyle(.orange)
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                
                Button(action: {}) {
                    Label("Add New Payment Method", systemImage: "plus.circle.fill")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("Payment Vault")
        .background(Color(.systemGroupedBackground))
    }
    
    private func deleteMethod(at offsets: IndexSet) {
        paymentMethods.remove(atOffsets: offsets)
    }
}

struct PaymentMethod: Identifiable {
    let id: String
    let type: String
    let lastFour: String
    let expiry: String
}

#Preview {
    NavigationStack {
        PaymentVaultView()
    }
}
