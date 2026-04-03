import SwiftUI

struct AddressVaultView: View {
    @State private var addresses = [
        "Home: 123 Chef Street, Nairobi",
        "Work: Jikoni HQ, Westlands"
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(addresses, id: \.self) { address in
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.orange)
                            .font(.title3)
                        Text(address)
                            .font(.body)
                        Spacer()
                        
                        Button(action: {
                            if let index = addresses.firstIndex(of: address) {
                                addresses.remove(at: index)
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red.opacity(0.7))
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                
                Button {
                    addresses.append("New Address \(addresses.count + 1)")
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
