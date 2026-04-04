import SwiftUI

struct JikoniLogo: View {
    var size: CGFloat = 40
    var showText: Bool = true
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                // Background to ensure no transparency gaps
                Circle()
                    .fill(.black) // Matches the black background of your ornate logo
                
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size * 0.95, height: size * 0.95) // Slightly smaller than container to show stroke
                    .clipShape(Circle())
            }
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "D4AF37"), Color(hex: "FFDF00"), Color(hex: "CFB53B")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: size * 0.06
                    )
            )
            .shadow(color: Color(hex: "D4AF37").opacity(0.4), radius: size/8)
            
            if showText {
                Text("Jikoni")
                    .font(.custom("Georgia-Bold", size: size * 0.7)) // Serif font to match ornate logo
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "D4AF37"), Color(hex: "CFB53B")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
