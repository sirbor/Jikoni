import SwiftUI

struct JikoniButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.bold)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color(hex: "D4AF37"), Color(hex: "B8860B")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex: "F8E7B5").opacity(0.35), lineWidth: 1)
            )
            .shadow(color: Color(hex: "D4AF37").opacity(0.35), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: title)
    }
}

#Preview {
    JikoniButton("Get Started", icon: "arrow.right") {
        print("Button tapped")
    }
    .padding()
}
