import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showTimer = false

    let tips = [
        SmartTip(message: "Stack tasks by subject to compound focus.", icon: "✨"),
        SmartTip(message: "Use focus mode to silence distractions.", icon: "🙈"),
        SmartTip(message: "Claim quests daily for streak XP!", icon: "🔥")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    streakCard
                    ProgressCard(title: "XP Progress", value: min(Double(store.profile.xp % 1000) / 1000, 1), subtitle: "Level-up in \(1000 - store.profile.xp % 1000) XP")
                    Button {
                        showTimer.toggle()
                    } label: {
                        Label("Start Studying", systemImage: "play.fill")
                            .font(.title3.bold())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(colors: [.cyan.opacity(0.8), .purple.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .cyan.opacity(0.3), radius: 12, x: 0, y: 8)
                    }
                    .buttonStyle(.plain)
                    .sheet(isPresented: $showTimer) { TimerView() }

                    SmartTipsView(tips: tips)
                        .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("StudyQuest")
            .background(LinearGradient(colors: [.blue.opacity(0.25), .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea())
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Welcome back")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(store.streakHeadline)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.cyan)
                Text("Keep the flame alive")
                    .font(.subheadline)
            }
            Spacer()
            VStack {
                Text("XP")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(store.profile.xp)")
                    .font(.title2.bold())
                Text("Coins: \(store.profile.coins)")
                    .font(.caption)
            }
            .padding()
            .glassSurface()
        }
    }

    private var streakCard: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Streak")
                    .font(.headline)
                Text("\(store.profile.currentStreak) days")
                    .font(.title2.bold())
                Text("Longest: \(store.profile.longestStreak)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "flame.fill")
                .font(.largeTitle)
                .foregroundStyle(.orange)
                .padding()
                .background(.thinMaterial)
                .clipShape(Circle())
                .shadow(color: .orange.opacity(0.4), radius: 12, x: 0, y: 8)
        }
        .glassSurface()
    }
}
