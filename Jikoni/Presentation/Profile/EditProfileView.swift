import SwiftUI

struct EditProfileView: View {
    @Environment(HubViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var displayName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var profileImageUrl: String = ""
    @State private var profileBio: String = ""
    @State private var favoriteCuisineInput: String = ""
    @State private var favoriteCuisines: [String] = []
    @State private var preferredContact: PreferredContact = .email
    @State private var allowsPush = true
    @State private var allowsPromotions = true
    
    var body: some View {
        Form {
            Section("Public Profile") {
                TextField("Display Name", text: $displayName)
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                TextField("Profile Image URL", text: $profileImageUrl)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
                TextField("Bio", text: $profileBio, axis: .vertical)
                    .lineLimit(3...5)
            }

            Section("Food Preferences") {
                HStack {
                    TextField("Add favorite cuisine", text: $favoriteCuisineInput)
                    Button("Add") {
                        let value = favoriteCuisineInput.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !value.isEmpty, !favoriteCuisines.contains(value) else { return }
                        favoriteCuisines.append(value)
                        favoriteCuisineInput = ""
                    }
                }

                if favoriteCuisines.isEmpty {
                    Text("No favorites yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(favoriteCuisines, id: \.self) { cuisine in
                        HStack {
                            Text(cuisine)
                            Spacer()
                            Button(role: .destructive) {
                                favoriteCuisines.removeAll { $0 == cuisine }
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }

            Section("Communication") {
                Picker("Preferred Contact", selection: $preferredContact) {
                    ForEach(PreferredContact.allCases, id: \.self) { option in
                        Text(option.rawValue.capitalized).tag(option)
                    }
                }
                Toggle("Push Notifications", isOn: $allowsPush)
                Toggle("Promotional Emails", isOn: $allowsPromotions)
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
                email = user.email
                phoneNumber = user.phoneNumber ?? ""
                profileImageUrl = user.profileImageUrl ?? ""
                profileBio = user.profileBio
                favoriteCuisines = user.favoriteCuisines
                preferredContact = user.preferredContact
                allowsPush = user.allowsPushNotifications
                allowsPromotions = user.allowsPromotionalEmails
            }
        }
    }
    
    private func save() {
        guard var user = viewModel.currentUser else { return }
        user.displayName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        user.phoneNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        user.profileImageUrl = profileImageUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        user.profileBio = profileBio.trimmingCharacters(in: .whitespacesAndNewlines)
        user.favoriteCuisines = favoriteCuisines
        user.preferredContact = preferredContact
        user.allowsPushNotifications = allowsPush
        user.allowsPromotionalEmails = allowsPromotions
        
        Task {
            await viewModel.updateProfile(user)
            dismiss()
        }
    }
}
