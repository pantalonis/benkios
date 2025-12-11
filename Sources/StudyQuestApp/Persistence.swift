import Foundation

struct PersistedState: Codable {
    var profile: UserProfile
    var tasks: [Task]
    var quests: [Quest]
    var customRewards: [CustomReward]
    var sessions: [StudySession]
    var badges: [Badge]
    var subjects: [Subject]
    var techniques: [Technique]
    var themes: [Theme]
    var themeStore: [ThemeStoreItem]
    var pomodoroConfiguration: PomodoroConfiguration
}

struct Persistence {
    private let fileURL: URL

    init(filename: String = "studyquest_state.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSTemporaryDirectory())
        self.fileURL = directory.appendingPathComponent(filename)
    }

    func loadState() -> PersistedState {
        guard let data = try? Data(contentsOf: fileURL) else {
            return PersistedState.defaultState
        }
        if let decoded = try? JSONDecoder().decode(PersistedState.self, from: data) {
            return decoded
        }
        return PersistedState.defaultState
    }

    func saveState(
        profile: UserProfile,
        tasks: [Task],
        quests: [Quest],
        customRewards: [CustomReward],
        sessions: [StudySession],
        badges: [Badge],
        subjects: [Subject],
        techniques: [Technique],
        themes: [Theme],
        themeStore: [ThemeStoreItem],
        pomodoroConfiguration: PomodoroConfiguration
    ) {
        let state = PersistedState(
            profile: profile,
            tasks: tasks,
            quests: quests,
            customRewards: customRewards,
            sessions: sessions,
            badges: badges,
            subjects: subjects,
            techniques: techniques,
            themes: themes,
            themeStore: themeStore,
            pomodoroConfiguration: pomodoroConfiguration
        )
        if let data = try? JSONEncoder().encode(state) {
            try? data.write(to: fileURL)
        }
    }
}

extension PersistedState {
    static var defaultState: PersistedState {
        let subjects = MockData.subjects
        let techniques = MockData.techniques
        let tasks = MockData.tasks(subjects: subjects)
        return PersistedState(
            profile: UserProfile(xp: 1200, coins: 360, currentStreak: 3, longestStreak: 10, preferredThemeID: MockData.themes.first?.id, focusModeEnabled: false),
            tasks: tasks,
            quests: MockData.quests,
            customRewards: MockData.customRewards,
            sessions: MockData.sessions(subjects: subjects, techniques: techniques),
            badges: MockData.badges,
            subjects: subjects,
            techniques: techniques,
            themes: MockData.themes,
            themeStore: MockData.themeStore,
            pomodoroConfiguration: PomodoroConfiguration(focusMinutes: 25, shortBreakMinutes: 5, longBreakMinutes: 15, roundsBeforeLongBreak: 4)
        )
    }
}
