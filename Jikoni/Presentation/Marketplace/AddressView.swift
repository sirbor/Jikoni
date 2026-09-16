import SwiftUI

/// Nairobi delivery fails on the last fifty metres, so gate, floor, door
/// and the rider note are first-class fields — not a free-text afterthought.
struct AddressView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var addressType = "Flat"
    @State private var line1 = ""
    @State private var line2 = ""
    @State private var city = ""
    @State private var deliveryNotes = ""

    private let addressTypes: [(name: String, icon: String)] = [
        ("Flat", "building.2"),
        ("House", "house"),
        ("Office", "briefcase"),
        ("Other", "mappin.and.ellipse")
    ]

    var body: some View {
        VStack(spacing: 0) {
            JikoniHeaderRow(title: "Delivery address", onBack: { dismiss() }) {
                JikoniCircleButton(systemImage: "location.fill", accessibilityText: "Locate me") {}
            }

            ScrollView {
                VStack(spacing: 16) {
                    abstractMap

                    ForEach(hubViewModel.currentUser?.addresses ?? []) { address in
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(JikoniColor.ink)
                                .font(.title3)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(address.label).font(JikoniFont.archivo(13.5, weight: .extrabold)).foregroundStyle(JikoniColor.ink)
                                Text("\(address.line1), \(address.city)")
                                    .font(JikoniFont.archivo(11.5))
                                    .foregroundStyle(JikoniColor.textSecondary)
                            }
                            Spacer()
                            if address.isDefault {
                                Text("Default")
                                    .font(JikoniFont.archivo(9.5, weight: .extrabold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(JikoniColor.accent)
                                    .clipShape(Capsule())
                            } else {
                                Button("Set default") {
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
                                .font(JikoniFont.archivo(11, weight: .extrabold))
                            }
                            Button {
                                Task {
                                    await hubViewModel.updateCurrentUser { user in
                                        user.addresses.removeAll { $0.id == address.id }
                                    }
                                }
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red.opacity(0.7))
                            }
                        }
                        .padding(14)
                        .background(JikoniColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                        .jikoniShadow(.small)
                    }

                    Text("Address type")
                        .font(JikoniFont.archivo(16, weight: .extrabold))
                        .foregroundStyle(JikoniColor.ink)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 9) {
                        ForEach(addressTypes, id: \.name) { type in
                            let selected = addressType == type.name
                            Button {
                                addressType = type.name
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: type.icon).font(.system(size: 18))
                                    Text(type.name).font(JikoniFont.archivo(10, weight: .extrabold))
                                }
                                .frame(maxWidth: .infinity, minHeight: 70)
                                .background(selected ? JikoniColor.ink : JikoniColor.card)
                                .foregroundStyle(selected ? JikoniColor.ground : JikoniColor.ink)
                                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                                .jikoniShadow(.small)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("BUILDING / HOUSE")
                                .font(JikoniFont.archivo(10, weight: .extrabold))
                                .tracking(1)
                                .foregroundStyle(JikoniColor.textSecondary)
                            TextField("e.g. Riverside Apartments, Block A", text: $line1)
                                .font(JikoniFont.archivo(14, weight: .extrabold))
                                .foregroundStyle(JikoniColor.ink)
                        }

                        Divider().opacity(0.35)

                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FLOOR")
                                    .font(JikoniFont.archivo(10, weight: .extrabold))
                                    .tracking(1)
                                    .foregroundStyle(JikoniColor.textSecondary)
                                TextField("4", text: $line2)
                                    .font(JikoniFont.archivo(14, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("CITY / AREA")
                                    .font(JikoniFont.archivo(10, weight: .extrabold))
                                    .tracking(1)
                                    .foregroundStyle(JikoniColor.textSecondary)
                                TextField("Kilimani", text: $city)
                                    .font(JikoniFont.archivo(14, weight: .extrabold))
                                    .foregroundStyle(JikoniColor.ink)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Divider().opacity(0.35)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("NOTE FOR THE RIDER")
                                .font(JikoniFont.archivo(10, weight: .extrabold))
                                .tracking(1)
                                .foregroundStyle(JikoniColor.textSecondary)
                            TextField("Tell the askari it is for 4B. Do not call, baby asleep.", text: $deliveryNotes, axis: .vertical)
                                .font(JikoniFont.archivo(13))
                                .foregroundStyle(JikoniColor.ink)
                                .lineLimit(2...3)
                        }
                    }
                    .padding(18)
                    .background(JikoniColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
                    .jikoniShadow(.small)

                    Button {
                        let trimmedLine1 = line1.trimmingCharacters(in: .whitespacesAndNewlines)
                        let resolvedLine1 = trimmedLine1.isEmpty ? "Riverside Apartments, Block A" : trimmedLine1
                        let resolvedCity = city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Kilimani" : city

                        let newAddress = SavedAddress(
                            id: UUID().uuidString,
                            label: addressType,
                            line1: resolvedLine1,
                            line2: line2.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Floor 4, 4B" : line2,
                            city: resolvedCity,
                            deliveryNotes: deliveryNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Tell the askari it is for 4B." : deliveryNotes,
                            isDefault: true
                        )

                        Task {
                            await hubViewModel.updateCurrentUser { user in
                                user.addresses = user.addresses.map {
                                    var copy = $0
                                    copy.isDefault = false
                                    return copy
                                }
                                user.addresses.append(newAddress)
                            }
                            dismiss()
                        }
                    } label: {
                        Text("Save and continue")
                            .font(JikoniFont.archivo(14, weight: .extrabold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(JikoniColor.ink)
                            .foregroundColor(JikoniColor.ground)
                            .clipShape(Capsule())
                    }
                }
                .padding(18)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
    }

    private var abstractMap: some View {
        ZStack {
            JikoniColor.surface
            GeometryReader { geo in
                Path { path in
                    let step: CGFloat = 30
                    var x: CGFloat = 0
                    while x < geo.size.width {
                        path.move(to: CGPoint(x: x, y: 0)); path.addLine(to: CGPoint(x: x, y: geo.size.height)); x += step
                    }
                    var y: CGFloat = 0
                    while y < geo.size.height {
                        path.move(to: CGPoint(x: 0, y: y)); path.addLine(to: CGPoint(x: geo.size.width, y: y)); y += step
                    }
                }
                .stroke(JikoniColor.ink.opacity(0.08), lineWidth: 1)
            }
            Circle().fill(JikoniColor.accent.opacity(0.35)).frame(width: 52, height: 52)
            Circle().fill(JikoniColor.accent).frame(width: 24, height: 24)
                .overlay(Circle().stroke(.white, lineWidth: 4))
                .jikoniShadow(.small)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.card))
    }
}
