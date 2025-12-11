import SwiftUI

@main
struct StudyQuestApp: App {
    @StateObject private var store = AppStore.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var store: AppStore
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "flame") }
            TimerView()
                .tabItem { Label("Timer", systemImage: "hourglass") }
            TasksView()
                .tabItem { Label("Tasks", systemImage: "checkmark.circle") }
            RewardsView()
                .tabItem { Label("Rewards", systemImage: "gift") }
            AnalyticsView()
                .tabItem { Label("Analytics", systemImage: "chart.bar") }
            LeaderboardView()
                .tabItem { Label("Leaderboard", systemImage: "trophy") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
            StoreView()
                .tabItem { Label("Store", systemImage: "bag") }
        }
        .preferredColorScheme(store.profile.preferredThemeID == MockData.themes.first?.id ? .dark : nil)
    }
}
