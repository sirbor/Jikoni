import SwiftUI

struct PaymentVaultView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @State private var mpesaNumber = "+254"
    @State private var brand = ""
    @State private var lastFour = ""
    @State private var expiry = ""
    @State private var holderName = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("M-Pesa")
                        .font(.headline)
                    TextField("Saved M-Pesa Number", text: $mpesaNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                    Button("Save M-Pesa Number") {
                        Task {
                            await hubViewModel.updateCurrentUser { user in
                                user.phoneNumber = mpesaNumber.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        }
                    }
                        .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .glassCard(cornerRadius: 16)

                ForEach(hubViewModel.currentUser?.paymentMethods ?? []) { method in
                    HStack(spacing: 16) {
                        Image(systemName: "creditcard.fill")
                            .foregroundStyle(.orange.gradient)
                            .font(.title)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(method.brand) •••• \(method.lastFour)")
                                .font(.headline)
                            Text("Expires \(method.expiry)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(method.holderName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if method.isDefault {
                            Text("Primary")
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.orange.opacity(0.1))
                                .foregroundStyle(.orange)
                                .clipShape(Capsule())
                        } else {
                            Button("Set Primary") {
                                Task {
                                    await hubViewModel.updateCurrentUser { user in
                                        user.paymentMethods = user.paymentMethods.map {
                                            var copy = $0
                                            copy.isDefault = copy.id == method.id
                                            return copy
                                        }
                                    }
                                }
                            }
                            .font(.caption)
                        }

                        Button {
                            Task {
                                await hubViewModel.updateCurrentUser { user in
                                    user.paymentMethods.removeAll { $0.id == method.id }
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                    .padding()
                    .glassCard(cornerRadius: 20)
                }
                
                VStack(spacing: 10) {
                    TextField("Card Brand (Visa, Mastercard...)", text: $brand)
                    TextField("Last 4 Digits", text: $lastFour)
                        .keyboardType(.numberPad)
                    TextField("Expiry (MM/YY)", text: $expiry)
                    TextField("Card Holder Name", text: $holderName)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                .glassCard(cornerRadius: 16)

                Button {
                    let b = brand.trimmingCharacters(in: .whitespacesAndNewlines)
                    let l4 = lastFour.trimmingCharacters(in: .whitespacesAndNewlines)
                    let exp = expiry.trimmingCharacters(in: .whitespacesAndNewlines)
                    let holder = holderName.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !b.isEmpty, l4.count == 4, !exp.isEmpty, !holder.isEmpty else { return }

                    let newMethod = PaymentMethod(
                        id: UUID().uuidString,
                        brand: b,
                        lastFour: l4,
                        expiry: exp,
                        holderName: holder,
                        isDefault: hubViewModel.currentUser?.paymentMethods.isEmpty ?? true
                    )

                    Task {
                        await hubViewModel.updateCurrentUser { user in
                            if newMethod.isDefault {
                                user.paymentMethods = user.paymentMethods.map {
                                    var copy = $0
                                    copy.isDefault = false
                                    return copy
                                }
                            }
                            user.paymentMethods.append(newMethod)
                        }
                        brand = ""
                        lastFour = ""
                        expiry = ""
                        holderName = ""
                    }
                } label: {
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
        .onAppear {
            mpesaNumber = hubViewModel.currentUser?.phoneNumber ?? "+254"
        }
    }
}

#Preview {
    NavigationStack {
        PaymentVaultView()
    }
}
