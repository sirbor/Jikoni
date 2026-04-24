import SwiftUI

struct AddressVaultView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @State private var label = ""
    @State private var line1 = ""
    @State private var line2 = ""
    @State private var city = ""
    @State private var deliveryNotes = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(hubViewModel.currentUser?.addresses ?? []) { address in
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.orange)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(address.label)
                                .font(.headline)
                            Text("\(address.line1), \(address.city)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if !address.deliveryNotes.isEmpty {
                                Text(address.deliveryNotes)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()

                        if address.isDefault {
                            Text("Default")
                                .font(.caption2)
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .clipShape(Capsule())
                        } else {
                            Button("Set Default") {
                                Task {
                                    await hubViewModel.updateCurrentUser { user in
                                        user.addresses = user.addresses.map {
                                            var copy = $0
                                            copy.isDefault = copy.id == address.id
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
                                    user.addresses.removeAll { $0.id == address.id }
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                    .padding()
                    .glassCard(cornerRadius: 20)
                }
                
                VStack(spacing: 10) {
                    TextField("Label (Home, Office...)", text: $label)
                    TextField("Address Line 1", text: $line1)
                    TextField("Address Line 2 (optional)", text: $line2)
                    TextField("City", text: $city)
                    TextField("Delivery Notes", text: $deliveryNotes)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                .glassCard(cornerRadius: 20)

                Button("Use Current Location (GPS Auto-fill)") {
                    line1 = "Lenana Road"
                    line2 = "Near Yaya Centre"
                    city = "Nairobi"
                    if deliveryNotes.isEmpty {
                        deliveryNotes = "Landmark: Opposite green gate"
                    }
                }
                .buttonStyle(.bordered)

                Button {
                    let trimmedLabel = label.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedLine1 = line1.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedLabel.isEmpty, !trimmedLine1.isEmpty, !trimmedCity.isEmpty else { return }

                    let newAddress = SavedAddress(
                        id: UUID().uuidString,
                        label: trimmedLabel,
                        line1: trimmedLine1,
                        line2: line2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : line2.trimmingCharacters(in: .whitespacesAndNewlines),
                        city: trimmedCity,
                        deliveryNotes: deliveryNotes.trimmingCharacters(in: .whitespacesAndNewlines),
                        isDefault: hubViewModel.currentUser?.addresses.isEmpty ?? true
                    )

                    Task {
                        await hubViewModel.updateCurrentUser { user in
                            if newAddress.isDefault {
                                user.addresses = user.addresses.map {
                                    var copy = $0
                                    copy.isDefault = false
                                    return copy
                                }
                            }
                            user.addresses.append(newAddress)
                        }
                        label = ""
                        line1 = ""
                        line2 = ""
                        city = ""
                        deliveryNotes = ""
                    }
                } label: {
                    Label("Add New Address", systemImage: "plus.circle.fill")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("Your Addresses")
        .background(Color(.systemGroupedBackground))
    }
}
