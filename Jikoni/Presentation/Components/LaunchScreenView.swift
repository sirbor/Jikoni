import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    @State private var scale = 0.8
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                JikoniLogo(size: 100)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text("Your Global Culinary Passport")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.2)) {
                self.opacity = 1.0
                self.scale = 1.0
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
