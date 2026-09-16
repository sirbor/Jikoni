import SwiftUI

/// Modernist East African Welcome & Authentication view for Jikoni.
/// Provides direct, frictionless Sign In, Sign Up, and Guest Explore with zero 2FA/OTP hurdles.
struct WelcomeView: View {
    let viewModel: HubViewModel

    enum EmailMode: String, CaseIterable {
        case signIn = "Sign In"
        case signUp = "Sign Up"
    }

    @State private var emailMode: EmailMode = .signIn
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var isPasswordVisible = false
    @State private var isEmailBusy = false

    // Profile Setup State for new registrations
    @State private var showProfileSetup = false
    @State private var profileName = ""
    @State private var profileSkill = "Home Cook"
    @State private var selectedGoals: Set<String> = []
    @State private var authErrorMessage: String?

    private let skillLevels = ["Home Cook", "Enthusiast", "Culinary Student", "Executive Chef"]
    private let dietaryOptions = [
        "Healthy", "Organic", "Swahili Special", "Halal", "Plant-based", "Quick Meals",
    ]

    var body: some View {
        ZStack {
            JikoniColor.ink.ignoresSafeArea()

            // Ambient background warm accent glow
            Circle()
                .fill(JikoniColor.accent.opacity(0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 80)
                .offset(y: -120)

            LinearGradient(
                colors: [
                    JikoniColor.ink.opacity(0.3),
                    JikoniColor.ink.opacity(0.85),
                    JikoniColor.ink,
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer(minLength: 28)

                    // Hero Brand Wordmark Logo in Brand Colors
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(JikoniColor.accent.opacity(0.18))
                                .frame(width: 140, height: 140)
                                .blur(radius: 24)

                            JikoniWordmarkView(
                                size: 64,
                                isDarkBackground: true,
                                showSubtitle: true,
                                subtitleText: "NAIROBI"
                            )
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)

                    Spacer(minLength: 16)

                    // Centrally placed tagline & subtitle
                    VStack(spacing: 8) {
                        Text("Cook it, Eat it")
                            .font(JikoniFont.instrumentSerif(44))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        Text("Recipes from cooks near you.")
                            .font(JikoniFont.archivo(14))
                            .foregroundStyle(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 24)

                    // Interactive Modernist Authentication Card
                    VStack(spacing: 14) {
                        // Segmented Mode Toggle (Sign In / Sign Up)
                        HStack(spacing: 4) {
                            ForEach(EmailMode.allCases, id: \.self) { mode in
                                let selected = emailMode == mode
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                                        emailMode = mode
                                        authErrorMessage = nil
                                    }
                                } label: {
                                    Text(mode.rawValue)
                                        .font(JikoniFont.archivo(13, weight: .extrabold))
                                        .frame(maxWidth: .infinity, minHeight: 42)
                                        .background(selected ? .white : Color.clear)
                                        .foregroundStyle(
                                            selected ? JikoniColor.ink : .white.opacity(0.75)
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(4)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Capsule())

                        // Form Fields
                        VStack(spacing: 10) {
                            if emailMode == .signUp {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                        .foregroundStyle(JikoniColor.textSecondary)
                                    TextField("Full Name ", text: $displayName)
                                        .font(JikoniFont.archivo(13.5))
                                        .foregroundStyle(JikoniColor.ink)
                                }
                                .padding(.horizontal, 14)
                                .frame(height: 48)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                            }

                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(JikoniColor.textSecondary)
                                TextField("Email ", text: $email)
                                    .font(JikoniFont.archivo(13.5))
                                    .foregroundStyle(JikoniColor.ink)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))

                            HStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(JikoniColor.textSecondary)

                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                        .font(JikoniFont.archivo(13.5))
                                        .foregroundStyle(JikoniColor.ink)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                } else {
                                    SecureField("Password", text: $password)
                                        .font(JikoniFont.archivo(13.5))
                                        .foregroundStyle(JikoniColor.ink)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                }

                                Button {
                                    isPasswordVisible.toggle()
                                } label: {
                                    Image(
                                        systemName: isPasswordVisible
                                            ? "eye.slash.fill" : "eye.fill"
                                    )
                                    .font(.system(size: 14))
                                    .foregroundStyle(JikoniColor.textSecondary)
                                }
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 48)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                        }

                        // Inline Error Notice
                        if let err = authErrorMessage {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12))
                                Text(err)
                                    .font(JikoniFont.archivo(12))
                            }
                            .foregroundStyle(JikoniColor.accent)
                            .padding(.horizontal, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Primary Action Button (Sign In / Create Account)
                        Button {
                            Task { await handlePasswordEmailSubmit() }
                        } label: {
                            HStack(spacing: 8) {
                                if isEmailBusy {
                                    ProgressView()
                                        .tint(JikoniColor.ink)
                                } else {
                                    Image(
                                        systemName: emailMode == .signIn
                                            ? "arrow.right.circle.fill" : "person.badge.plus.fill"
                                    )
                                    .font(.system(size: 15, weight: .bold))
                                    Text(
                                        emailMode == .signIn
                                            ? "Sign In to Jikoni" : "Create Account "
                                    )
                                    .font(JikoniFont.archivo(14, weight: .extrabold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 52)
                            .background(.white)
                            .foregroundStyle(JikoniColor.ink)
                            .clipShape(Capsule())
                        }
                        .disabled(email.isEmpty || password.isEmpty || isEmailBusy)

                        // Tertiary: Guest Explore
                        Button {
                            Task { await handleGuestSignIn() }
                        } label: {
                            Text("Explore as guest")
                                .font(JikoniFont.archivo(12))
                                .foregroundStyle(.white.opacity(0.65))
                                .underline()
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 36)
                }
            }
        }
        .alert(
            "Notice",
            isPresented: Binding(
                get: { authErrorMessage != nil },
                set: { if !$0 { authErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { authErrorMessage = nil }
        } message: {
            Text(authErrorMessage ?? "")
        }
        // Profile setup sheet for new signups
        .sheet(isPresented: $showProfileSetup) {
            profileSetupSheet
        }
    }

    // MARK: - Profile Setup Sheet
    private var profileSetupSheet: some View {
        VStack(spacing: 0) {
            JikoniHeaderRow(title: "Complete Profile") {}

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Tell us about yourself")
                        .font(JikoniFont.instrumentSerif(28))
                        .foregroundStyle(JikoniColor.ink)

                    Text("Help us tailor your recipes and kitchen recommendations.")
                        .font(JikoniFont.archivo(13))
                        .foregroundStyle(JikoniColor.textSecondary)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("DISPLAY NAME")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.textSecondary)
                        TextField("Your name or kitchen alias", text: $profileName)
                            .font(JikoniFont.archivo(14))
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(JikoniColor.card)
                            .clipShape(Capsule())
                            .jikoniShadow(.small)
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("COOKING EXPERIENCE")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.textSecondary)

                        ForEach(skillLevels, id: \.self) { level in
                            let selected = profileSkill == level
                            Button {
                                profileSkill = level
                            } label: {
                                HStack {
                                    Image(
                                        systemName: selected ? "largecircle.fill.circle" : "circle"
                                    )
                                    .foregroundStyle(
                                        selected ? JikoniColor.ink : JikoniColor.textSecondary)
                                    Text(level)
                                        .font(JikoniFont.archivo(13.5, weight: .semibold))
                                        .foregroundStyle(JikoniColor.ink)
                                    Spacer()
                                }
                                .padding(14)
                                .background(JikoniColor.card)
                                .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                                .jikoniShadow(.small)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("DIETARY GOALS")
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                            .foregroundStyle(JikoniColor.textSecondary)

                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10
                        ) {
                            ForEach(dietaryOptions, id: \.self) { opt in
                                let selected = selectedGoals.contains(opt)
                                Button {
                                    if selected {
                                        selectedGoals.remove(opt)
                                    } else {
                                        selectedGoals.insert(opt)
                                    }
                                } label: {
                                    HStack {
                                        Image(
                                            systemName: selected
                                                ? "checkmark.square.fill" : "square"
                                        )
                                        .foregroundStyle(
                                            selected
                                                ? JikoniColor.accent : JikoniColor.textSecondary)
                                        Text(opt)
                                            .font(JikoniFont.archivo(12.5, weight: .semibold))
                                            .foregroundStyle(JikoniColor.ink)
                                        Spacer()
                                    }
                                    .padding(12)
                                    .background(JikoniColor.card)
                                    .clipShape(RoundedRectangle(cornerRadius: JikoniRadius.control))
                                    .jikoniShadow(.small)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    Button {
                        Task { await finishProfileSetup() }
                    } label: {
                        sheetActionLabel("Start exploring Jikoni")
                    }
                    .padding(.top, 10)
                }
                .padding(20)
            }
        }
        .background(JikoniColor.ground.ignoresSafeArea())
        .interactiveDismissDisabled()
    }

    // MARK: - Actions
    private func sheetActionLabel(_ title: String) -> some View {
        Text(title)
            .font(JikoniFont.archivo(14, weight: .extrabold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(JikoniColor.ink)
            .foregroundStyle(JikoniColor.ground)
            .clipShape(Capsule())
    }

    private func handlePasswordEmailSubmit() async {
        isEmailBusy = true
        var success = false
        if emailMode == .signIn {
            success = await viewModel.signInWithEmail(email: email, password: password)
        } else {
            success = await viewModel.signUpWithEmail(
                email: email, password: password, displayName: displayName)
        }
        isEmailBusy = false
        if success {
            if viewModel.currentUser?.displayName == nil
                || viewModel.currentUser?.displayName?.isEmpty == true
            {
                showProfileSetup = true
            }
        } else if let err = viewModel.authErrorMessage {
            authErrorMessage = err
        }
    }

    private func handleGuestSignIn() async {
        _ = await viewModel.signInAsGuest()
    }

    private func finishProfileSetup() async {
        await viewModel.updateCurrentUser { user in
            user.displayName = profileName.isEmpty ? "Chef Jikoni" : profileName
            user.skillLevel = profileSkill
            user.dietaryGoals = Array(selectedGoals)
        }
        showProfileSetup = false
    }
}
