import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) private var colorScheme
    let viewModel: HubViewModel
    @State private var profileName = ""
    @State private var selectedLanguage = "English"
    @State private var showProfileSetup = false
    @State private var isSigningIn = false
    @State private var showEmailSignIn = false
    @State private var email = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color.black.opacity(0.92), Color(hex: "1B1B1B"), Color(hex: "2A2112")]
                    : [Color(hex: "FFF8EC"), Color.white, Color(hex: "F6EAD1")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Jikoni")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "F8E7B5"), Color(hex: "D4AF37")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text("Find food near you")
                        .font(.subheadline)
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.75) : .secondary)
                }
                
                VStack(spacing: 10) {
                    Text("Continue with")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? .white.opacity(0.75) : .secondary)

                    premiumSignInButton(
                        title: "Sign in with Apple",
                        provider: .apple,
                        accent: .black
                    ) {
                        Task { await signInWithApple() }
                    }

                    premiumSignInButton(
                        title: "Sign in with Google",
                        provider: .google,
                        accent: Color(hex: "DB4437")
                    ) {
                        Task { await signInWithGoogle() }
                    }

                    premiumSignInButton(
                        title: "Sign in with Email",
                        provider: .email,
                        accent: Color(hex: "D4AF37")
                    ) {
                        showEmailSignIn = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 18)
                .background(.ultraThinMaterial.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "D4AF37").opacity(0.35), lineWidth: 1)
                )
                
                Spacer()
            }
        }
        .sheet(isPresented: $showProfileSetup) {
            NavigationStack {
                Form {
                    Section("Profile setup") {
                        TextField("Display Name", text: $profileName)
                        Picker("Language", selection: $selectedLanguage) {
                            Text("English").tag("English")
                            Text("Swahili").tag("Swahili")
                        }
                        .pickerStyle(.segmented)
                    }
                    Button("Finish and Continue") {
                        Task {
                            await viewModel.updateCurrentUser { user in
                                user.displayName = profileName.isEmpty ? "Jikoni Customer" : profileName
                            }
                            showProfileSetup = false
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .navigationTitle("Profile Setup")
            }
        }
        .sheet(isPresented: $showEmailSignIn) {
            NavigationStack {
                Form {
                    Section("Email Sign In") {
                        TextField("Email address", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                    }

                    Button("Continue") {
                        Task {
                            await signInWithEmail()
                            showEmailSignIn = false
                        }
                    }
                    .disabled(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .navigationTitle("Email Sign In")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") {
                            showEmailSignIn = false
                        }
                    }
                }
            }
        }
    }

    private func signInWithApple() async {
        isSigningIn = true
        await viewModel.signIn(email: "apple.user@jikoni.app")
        await viewModel.updateCurrentUser { user in
            user.displayName = user.displayName ?? "Apple User"
        }
        showProfileSetup = true
        isSigningIn = false
    }

    private func signInWithGoogle() async {
        isSigningIn = true
        await viewModel.signIn(email: "google.user@jikoni.app")
        await viewModel.updateCurrentUser { user in
            user.displayName = user.displayName ?? "Google User"
        }
        showProfileSetup = true
        isSigningIn = false
    }

    private func signInWithEmail() async {
        isSigningIn = true
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        await viewModel.signIn(email: trimmedEmail)
        await viewModel.updateCurrentUser { user in
            if user.displayName == nil || user.displayName?.isEmpty == true {
                user.displayName = trimmedEmail.components(separatedBy: "@").first?.capitalized ?? "Email User"
            }
        }
        email = ""
        showProfileSetup = true
        isSigningIn = false
    }

    private func premiumSignInButton(title: String, provider: SignInProvider, accent: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                providerIcon(provider)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(colorScheme == .dark ? .white.opacity(0.10) : .white.opacity(0.9))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(accent.opacity(0.45), lineWidth: 1)
            )
            .foregroundStyle(colorScheme == .dark ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func providerIcon(_ provider: SignInProvider) -> some View {
        switch provider {
        case .apple:
            Image(systemName: "apple.logo")
                .font(.system(size: 18, weight: .semibold))
        case .email:
            Image(systemName: "envelope.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(hex: "D4AF37"))
        case .google:
            ZStack {
                Circle()
                    .fill(.white)
                Text("G")
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(hex: "4285F4"),
                                Color(hex: "34A853"),
                                Color(hex: "FBBC05"),
                                Color(hex: "EA4335")
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
    }
}

enum SignInProvider {
    case apple
    case google
    case email
}

struct AuthButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    var isSecondary: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSecondary ? Color.gray.opacity(0.1) : Color.primary)
            .foregroundStyle(isSecondary ? Color.primary : Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
        }
    }
}

#Preview {
    LoginView(viewModel: HubViewModel(authRepository: MockAuthRepository(), orderRepository: MockOrderRepository()))
}

