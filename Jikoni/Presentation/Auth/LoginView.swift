import SwiftUI

struct LoginView: View {
    let viewModel: HubViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange.opacity(0.1), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Jikoni")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                    Text("Your Global Culinary Passport")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                NavigationLink {
                    RegistrationView(viewModel: viewModel)
                } label: {
                    HStack {
                        Image(systemName: "person.badge.plus")
                        Text("Create Account")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.orange)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .orange.opacity(0.3), radius: 10, y: 5)
                }
                .padding(.horizontal, 24)
                
                Button {
                    Task { await viewModel.signIn() }
                } label: {
                    Text("Already have an account? Sign In")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
        }
    }
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
