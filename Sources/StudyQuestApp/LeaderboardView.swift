import SwiftUI

struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let name: String
    let xp: Int
    let level: Int
    let streak: Int
    let badge: String
}

struct LeaderboardView: View {
    @State private var tab: Int = 0
    private let tabs = ["Global", "Weekly", "Friends"]
    private let entries: [LeaderboardEntry] = [
        .init(name: "Ava", xp: 4500, level: 12, streak: 14, badge: "🔥"),
        .init(name: "Leo", xp: 3800, level: 11, streak: 10, badge: "⚡️"),
        .init(name: "Noah", xp: 3200, level: 10, streak: 7, badge: "🎯")
    ]

    var body: some View {
        VStack(spacing: 12) {
            Picker("Tab", selection: $tab) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Text(tabs[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            ForEach(entries) { entry in
                HStack {
                    VStack(alignment: .leading) {
                        Text(entry.name)
                        Text("Level \(entry.level)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(entry.badge)
                    Text("XP \(entry.xp)")
                    Text("🔥 \(entry.streak)")
                }
                .glassSurface()
            }
        }
        .padding()
        .navigationTitle("Leaderboard")
    }
}
