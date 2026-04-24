import SwiftUI

struct SettingsView: View {
    @Environment(HubViewModel.self) private var hubViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("orderReminderNotifications") private var orderReminderNotifications = true
    @AppStorage("preferredCurrencyCode") private var preferredCurrencyCode = AppCurrency.kes.rawValue
    @State private var showChangePasswordPrompt = false
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var showPasswordSuccess = false
    @State private var showDeleteAccountConfirmation = false
    @State private var showDeleteSuccess = false
    
    let languages = ["English", "Swahili", "French", "Spanish", "Chinese"]
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .tint(.orange)
            }
            
            Section(header: Text("Preferences")) {
                Toggle(
                    "Notifications",
                    isOn: Binding(
                        get: { hubViewModel.currentUser?.allowsPushNotifications ?? true },
                        set: { value in
                            Task {
                                await hubViewModel.updateCurrentUser { user in
                                    user.allowsPushNotifications = value
                                }
                            }
                        }
                    )
                )
                    .tint(.orange)

                Toggle(
                    "Promo Alerts",
                    isOn: Binding(
                        get: { hubViewModel.currentUser?.allowsPromotionalEmails ?? true },
                        set: { value in
                            Task {
                                await hubViewModel.updateCurrentUser { user in
                                    user.allowsPromotionalEmails = value
                                }
                            }
                        }
                    )
                )
                .tint(.orange)

                Toggle("Order Reminders", isOn: $orderReminderNotifications)
                    .tint(.orange)
                
                Picker("Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(.menu)

                Picker("Pricing Currency", selection: $preferredCurrencyCode) {
                    Text("KES (KSh)").tag(AppCurrency.kes.rawValue)
                    Text("USD ($)").tag(AppCurrency.usd.rawValue)
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Account")) {
                HStack {
                    Text("Preferred Contact")
                    Spacer()
                    Text(hubViewModel.currentUser?.preferredContact.rawValue.capitalized ?? "Email")
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Member Since")
                    Spacer()
                    Text((hubViewModel.currentUser?.memberSince ?? .now).formatted(date: .abbreviated, time: .omitted))
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Membership")
                    Spacer()
                    Text(hubViewModel.currentUser?.membershipTier.rawValue.capitalized ?? "Bronze")
                        .foregroundStyle(.secondary)
                }

                NavigationLink("Update Profile") {
                    EditProfileView()
                }
                .foregroundColor(.orange)
                
                Button("Change Password") {
                    showChangePasswordPrompt = true
                }
                    .foregroundColor(.orange)
                
                Button("Delete Account", role: .destructive) {
                    showDeleteAccountConfirmation = true
                }
            }
            
            Section(header: Text("About Jikoni")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0 (Final)")
                        .foregroundColor(.secondary)
                }
                
                Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                    .foregroundColor(.primary)
                
                Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    .foregroundColor(.primary)
            }
        }
        .navigationTitle("Settings")
        .alert("Change Password", isPresented: $showChangePasswordPrompt) {
            SecureField("Current password", text: $oldPassword)
            SecureField("New password", text: $newPassword)
            Button("Cancel", role: .cancel) {
                oldPassword = ""
                newPassword = ""
            }
            Button("Save") {
                // Mock flow: validates input then clears fields and confirms.
                guard !oldPassword.isEmpty, newPassword.count >= 6 else { return }
                oldPassword = ""
                newPassword = ""
                showPasswordSuccess = true
            }
            .disabled(oldPassword.isEmpty || newPassword.count < 6)
        } message: {
            Text("Enter your current password and a new password with at least 6 characters.")
        }
        .alert("Password Updated", isPresented: $showPasswordSuccess) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your password has been changed successfully.")
        }
        .alert("Delete Account?", isPresented: $showDeleteAccountConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    await hubViewModel.deleteAccountData()
                    showDeleteSuccess = true
                }
            }
        } message: {
            Text("This will remove your profile data, addresses, cards, and preferences from this app.")
        }
        .alert("Account Data Deleted", isPresented: $showDeleteSuccess) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(hubViewModel.lastSupportMessage ?? "Your account data was removed.")
        }
    }
}
