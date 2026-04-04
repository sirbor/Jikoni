import SwiftUI

struct EditProfileView: View {
    @Environment(HubViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var displayName: String = ""
    @State private var profileImageUrl: String = ""
    
    var body: some View {
        Form {
            Section("Public Profile") {
                TextField("Display Name", text: $displayName)
                TextField("Profile Image URL", text: $profileImageUrl)
            }
            
            Section {
                Button("Save Changes") {
                    save()
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.orange)
                .fontWeight(.bold)
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear {
            if let user = viewModel.currentUser {
                displayName = user.displayName ?? ""
                profileImageUrl = user.profileImageUrl ?? ""
            }
        }
    }
    
    private func save() {
        guard var user = viewModel.currentUser else { return }
        user.displayName = displayName
        user.profileImageUrl = profileImageUrl
        
        Task {
            await viewModel.updateProfile(user)
            dismiss()
        }
    }
}
