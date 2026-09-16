import SwiftUI

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

enum AppCurrency: String, CaseIterable {
    case kes = "KES"
    case usd = "USD"
}

extension Double {
    func currencyString() -> String {
        let code = UserDefaults.standard.string(forKey: "preferredCurrencyCode") ?? AppCurrency.kes.rawValue
        let currency = AppCurrency(rawValue: code) ?? .kes
        switch currency {
        case .kes:
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = (self.truncatingRemainder(dividingBy: 1) == 0) ? 0 : 2
            let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? "\(Int(self.rounded()))"
            return "KSh \(formattedNumber)"
        case .usd:
            let usdAmount = self / 130.0 // Standard approx KES to USD rate
            return "$\(usdAmount.formatted(.number.precision(.fractionLength(2))))"
        }
    }
}

/// Shared visual vocabulary for the "Modernist" redesign: ink + warm-grey
/// ground, red rationed to live/liked/chosen states, Archivo for UI text,
/// Instrument Serif reserved for recipe titles, pill/soft-rect shapes only.
enum JikoniColor {
    static let ink = Color(hex: "201E1D")
    static let ground = Color(hex: "F3F2F2")
    static let surface = Color(hex: "EAE9E9")
    static let card = Color.white
    static let accent = Color(hex: "EC3013")
    static let textSecondary = Color(hex: "6B6767")
    static let textBody = Color(hex: "5A5656")
    static let placeholder = Color(hex: "CBC7C7")
    static let placeholderAlt = Color(hex: "D9D5D5")
}

enum JikoniFont {
    enum Weight {
        case regular, medium, semibold, bold, extrabold

        var postscriptName: String {
            switch self {
            case .regular: return "ArchivoRoman-Regular"
            case .medium: return "ArchivoRoman-Medium"
            case .semibold: return "ArchivoRoman-SemiBold"
            case .bold: return "ArchivoRoman-Bold"
            case .extrabold: return "ArchivoRoman-ExtraBold"
            }
        }
    }

    static func archivo(_ size: CGFloat, weight: Weight = .regular) -> Font {
        .custom(weight.postscriptName, size: size)
    }

    /// Recipe titles and the few moments that should read as a cookbook, not an app.
    static func instrumentSerif(_ size: CGFloat) -> Font {
        .custom("InstrumentSerif-Regular", size: size)
    }
}

enum JikoniRadius {
    static let pill: CGFloat = 999
    static let card: CGFloat = 24
    static let cardSmall: CGFloat = 18
    static let control: CGFloat = 20
}

enum JikoniShadowLevel {
    case none, small, medium, large
}

private struct JikoniShadowModifier: ViewModifier {
    let level: JikoniShadowLevel

    func body(content: Content) -> some View {
        switch level {
        case .none:
            content
        case .small:
            content.shadow(color: JikoniColor.ink.opacity(0.06), radius: 4, x: 0, y: 1)
        case .medium:
            content.shadow(color: JikoniColor.ink.opacity(0.08), radius: 10, x: 0, y: 2)
        case .large:
            content.shadow(color: JikoniColor.ink.opacity(0.14), radius: 20, x: 0, y: 6)
        }
    }
}

extension View {
    func jikoniShadow(_ level: JikoniShadowLevel = .medium) -> some View {
        modifier(JikoniShadowModifier(level: level))
    }
}

/// East African Modernist wordmark for Jikoni featuring signature brand typography and cayenne red accent dot.
struct JikoniWordmarkView: View {
    var size: CGFloat = 56
    var isDarkBackground: Bool = false
    var showSubtitle: Bool = true
    var subtitleText: String = "NAIROBI"

    var body: some View {
        VStack(spacing: size * 0.08) {
            HStack(alignment: .lastTextBaseline, spacing: 3) {
                Text("Jikoni")
                    .font(JikoniFont.instrumentSerif(size))
                    .foregroundStyle(isDarkBackground ? .white : JikoniColor.ink)

                Circle()
                    .fill(JikoniColor.accent)
                    .frame(width: max(6, size * 0.15), height: max(6, size * 0.15))
                    .padding(.bottom, size * 0.09)
            }

            if showSubtitle {
                HStack(spacing: 7) {
                    Circle()
                        .fill(JikoniColor.accent)
                        .frame(width: 3.5, height: 3.5)

                    Text(subtitleText)
                        .font(JikoniFont.archivo(max(9.5, size * 0.19), weight: .extrabold))
                        .tracking(3.8)
                        .foregroundStyle(isDarkBackground ? .white.opacity(0.85) : JikoniColor.ink.opacity(0.78))

                    Circle()
                        .fill(JikoniColor.accent)
                        .frame(width: 3.5, height: 3.5)
                }
            }
        }
    }
}

