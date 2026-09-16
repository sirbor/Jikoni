import SwiftUI

/// Custom chrome that replaces native iOS navigation/tab chrome — the
/// Modernist canvas draws every back button, header, and tab bar by hand.

/// Lets any nested view request a switch to another tab (e.g. "Order it"
/// on a recipe card jumping to the Order tab) without native TabView's
/// selection binding being reachable across the custom shell.
struct TabSwitchAction {
    let action: (AppTab) -> Void
    func callAsFunction(_ tab: AppTab) { action(tab) }
}

private struct TabSwitchKey: EnvironmentKey {
    static let defaultValue = TabSwitchAction(action: { _ in })
}

extension EnvironmentValues {
    var switchTab: TabSwitchAction {
        get { self[TabSwitchKey.self] }
        set { self[TabSwitchKey.self] = newValue }
    }
}

enum AppTab: CaseIterable {
    case feed, order, track, you

    var label: String {
        switch self {
        case .feed: return "Feed"
        case .order: return "Order"
        case .track: return "Track"
        case .you: return "You"
        }
    }

    var icon: String {
        switch self {
        case .feed: return "house.fill"
        case .order: return "bag.fill"
        case .track: return "location.fill"
        case .you: return "person.fill"
        }
    }
}

/// The pill-highlight bottom bar — `background:#fff;border-radius:26px 26px 0 0`.
struct JikoniTabBar: View {
    @Binding var active: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                let selected = active == tab
                Button {
                    active = tab
                } label: {
                    VStack(spacing: 5) {
                        ZStack {
                            if selected {
                                Capsule().fill(JikoniColor.ground).frame(width: 46, height: 34)
                            }
                            Image(systemName: tab.icon)
                                .font(.system(size: 19))
                        }
                        Text(tab.label)
                            .font(JikoniFont.archivo(10.5, weight: .extrabold))
                    }
                    .foregroundStyle(selected ? JikoniColor.ink : JikoniColor.textSecondary)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 8)
        .padding(.horizontal, 6)
        .padding(.bottom, 2)
        .background(
            JikoniColor.card
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 26, topTrailingRadius: 26))
                .shadow(color: JikoniColor.ink.opacity(0.1), radius: 22, x: 0, y: -4)
        )
        .ignoresSafeArea(edges: .bottom)
    }
}

/// A floating 44pt circular icon button — used over photo headers for
/// back/save/favorite affordances throughout the canvas.
struct JikoniCircleButton: View {
    let systemImage: String
    var isFilled: Bool = false
    var accessibilityText: String = ""
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isFilled ? .white : JikoniColor.ink)
                .frame(width: 44, height: 44)
                .background(isFilled ? JikoniColor.accent : JikoniColor.card)
                .clipShape(Circle())
                .jikoniShadow(.small)
        }
        .accessibilityLabel(accessibilityText)
    }
}

/// A full-bleed photo hero with an overlay (back/save buttons, etc.), used on
/// every screen with a photo header (Recipe, Vendor, Item detail…).
///
/// Wraps `AsyncImage` in a `GeometryReader` and gives it an explicit numeric
/// `.frame(width:)` rather than `.frame(maxWidth: .infinity)`. Inside a
/// `ZStack`, a child is proposed its own *ideal* size, not the ZStack's
/// resolved width — so `.aspectRatio(contentMode: .fill)` on a loaded photo
/// can report its native pixel width as that ideal, dragging the whole
/// ZStack (and everything overlaid on it) far wider than the screen, which
/// then gets centered and clipped at both edges. A concrete `geo.size.width`
/// removes the ambiguity `maxWidth: .infinity` doesn't.
struct JikoniPhotoHeader<Overlay: View>: View {
    let imageUrl: String?
    var height: CGFloat = 320
    @ViewBuilder var overlay: () -> Overlay

    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geo in
                AsyncImage(url: URL(string: imageUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image): image.resizable().aspectRatio(contentMode: .fill)
                    default: Rectangle().fill(JikoniColor.placeholder)
                    }
                }
                .frame(width: geo.size.width, height: height)
                .clipped()
            }
            .frame(height: height)

            overlay()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 18)
                .padding(.top, 56)
        }
    }
}

/// A plain header row — back circle + title + optional trailing circle —
/// used on screens without a photo hero (Cart, Address, Pay, Orders…).
struct JikoniHeaderRow<Trailing: View>: View {
    let title: String
    var onBack: (() -> Void)? = nil
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        HStack(spacing: 11) {
            if let onBack {
                JikoniCircleButton(systemImage: "chevron.left", accessibilityText: "Back", action: onBack)
            }
            Text(title)
                .font(JikoniFont.archivo(19, weight: .extrabold))
                .foregroundStyle(JikoniColor.ink)
            Spacer()
            trailing()
        }
        .padding(.horizontal, 18)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}

extension JikoniHeaderRow where Trailing == EmptyView {
    init(title: String, onBack: (() -> Void)? = nil) {
        self.init(title: title, onBack: onBack) { EmptyView() }
    }
}
