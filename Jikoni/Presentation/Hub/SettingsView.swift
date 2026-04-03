import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    let languages = ["English", "Swahili", "French", "Spanish", "Chinese"]
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .tint(.orange)
            }
            
            Section(header: Text("Preferences")) {
                Toggle("Notifications", isOn: $notificationsEnabled)
                    .tint(.orange)
                
                Picker("Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Account")) {
                Button("Update Profile") { }
                    .foregroundColor(.orange)
                
                Button("Change Password") { }
                    .foregroundColor(.orange)
                
                Button("Delete Account", role: .destructive) { }
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
    }
}
