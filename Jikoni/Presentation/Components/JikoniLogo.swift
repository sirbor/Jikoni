import SwiftUI

struct JikoniLogo: View {
    var size: CGFloat = 40
    var showText: Bool = true
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.orange.gradient)
                    .frame(width: size, height: size)
                    .shadow(color: .orange.opacity(0.3), radius: size/4, x: 0, y: size/8)
                
                Image(systemName: "fork.knife")
                    .font(.system(size: size * 0.5, weight: .black))
                    .foregroundStyle(.white)
            }
            
            if showText {
                Text("Jikoni")
                    .font(.system(size: size * 0.7, weight: .black, design: .rounded))
                    .foregroundStyle(.primary)
            }
        }
    }
}
