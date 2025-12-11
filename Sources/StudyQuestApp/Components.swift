import SwiftUI

struct GlassSurface: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial.opacity(0.8))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(LinearGradient(colors: [.white.opacity(0.4), .cyan.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.2)
            )
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.linearGradient(colors: [.white.opacity(0.08), .white.opacity(0.02)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .blur(radius: 16)
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

extension View {
    func glassSurface() -> some View { modifier(GlassSurface()) }
}

struct ProgressCard: View {
    var title: String
    var value: Double
    var subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            ProgressView(value: value)
                .tint(.cyan)
                .progressViewStyle(.linear)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .glassSurface()
    }
}

struct SmartTipsView: View {
    var tips: [SmartTip]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(tips) { tip in
                    HStack(spacing: 8) {
                        Text(tip.icon)
                        Text(tip.message)
                            .font(.caption)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                }
            }
        }
        .accessibilityLabel("Smart tips carousel")
    }
}
