import Foundation
import SwiftUI

@MainActor
final class AppStore: ObservableObject {
    static let shared = AppStore()

    @Published var profile: UserProfile
    @Published var tasks: [Task]
    @Published var quests: [Quest]
    @Published var customRewards: [CustomReward]
    @Published var sessions: [StudySession]
    @Published var badges: [Badge]
    @Published var subjects: [Subject]
    @Published var techniques: [Technique]
    @Published var themes: [Theme]
    @Published var themeStore: [ThemeStoreItem]
    @Published var pomodoroConfiguration: PomodoroConfiguration
    @Published var timerMode: TimerMode = .standard
    @Published var activeSecondsRemaining: TimeInterval = 0
    @Published var isTimerRunning: Bool = false
    @Published var streakHeadline: String = "7-day streak" // placeholder from web brand

    private let persistence = Persistence()
    private var timer: Timer?
    private var backgroundStartDate: Date?

    init() {
        let data = persistence.loadState()
        self.profile = data.profile
        self.tasks = data.tasks
        self.quests = data.quests
        self.customRewards = data.customRewards
        self.sessions = data.sessions
        self.badges = data.badges
        self.subjects = data.subjects
        self.techniques = data.techniques
        self.themes = data.themes
        self.themeStore = data.themeStore
        self.pomodoroConfiguration = data.pomodoroConfiguration
        self.activeSecondsRemaining = Double(pomodoroConfiguration.focusMinutes * 60)
        self.streakHeadline = "\(profile.currentStreak)-day streak"
    }

    func save() {
        persistence.saveState(
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
    }

    func addTask(title: String, subject: Subject, expectedMinutes: Int) {
        let rewardXP = expectedMinutes / 5 * 10
        tasks.append(Task(id: UUID(), title: title, subject: subject, expectedMinutes: expectedMinutes, completed: false, rewardXP: rewardXP))
        save()
    }

    func toggleTask(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].completed.toggle()
        if tasks[index].completed {
            gainXP(tasks[index].rewardXP)
        }
        save()
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        save()
    }

    func gainXP(_ amount: Int) {
        profile.xp += amount
        profile.coins += amount / 10
        updateStreak()
        save()
    }

    func updateStreak() {
        // simplistic streak calculation using last session date
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let lastSession = sessions.last {
            let lastDate = calendar.startOfDay(for: lastSession.date)
            let days = calendar.dateComponents([.day], from: lastDate, to: today).day ?? 0
            if days == 1 {
                profile.currentStreak += 1
            } else if days > 1 {
                profile.currentStreak = 1
            }
        } else {
            profile.currentStreak = 1
        }
        profile.longestStreak = max(profile.longestStreak, profile.currentStreak)
        streakHeadline = "\(profile.currentStreak)-day streak"
    }

    func startTimer(mode: TimerMode) {
        timerMode = mode
        isTimerRunning = true
        backgroundStartDate = Date()
        configureDuration(for: mode)
        startTicker()
    }

    func pauseTimer() {
        isTimerRunning = false
        timer?.invalidate()
    }

    func resumeTimer() {
        guard !isTimerRunning else { return }
        isTimerRunning = true
        backgroundStartDate = Date()
        startTicker()
    }

    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        activeSecondsRemaining = 0
    }

    func configureDuration(for mode: TimerMode) {
        switch mode {
        case .standard:
            activeSecondsRemaining = 50 * 60
        case .pomodoro:
            activeSecondsRemaining = Double(pomodoroConfiguration.focusMinutes * 60)
        }
    }

    private func startTicker() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { await self?.tick() }
        }
    }

    func tick() async {
        guard isTimerRunning else { return }
        if let start = backgroundStartDate {
            let delta = Date().timeIntervalSince(start)
            backgroundStartDate = Date()
            activeSecondsRemaining -= delta
        } else {
            activeSecondsRemaining -= 1
        }

        if activeSecondsRemaining <= 0 {
            isTimerRunning = false
            timer?.invalidate()
            gainXP(25)
        }
    }

    func updatePomodoro(_ config: PomodoroConfiguration) {
        pomodoroConfiguration = config
        configureDuration(for: .pomodoro)
        save()
    }

    func claimQuest(_ quest: Quest) {
        guard let index = quests.firstIndex(where: { $0.id == quest.id }) else { return }
        quests[index].claimed = true
        gainXP(quest.rewardXP)
        profile.coins += quest.rewardCoins
        save()
    }

    func claimReward(_ reward: CustomReward) {
        guard let index = customRewards.firstIndex(where: { $0.id == reward.id }) else { return }
        customRewards[index].claimed = true
        gainXP(reward.rewardXP)
        profile.coins += reward.rewardCoins
        save()
    }

    func unlockTheme(_ item: ThemeStoreItem) {
        guard let index = themeStore.firstIndex(where: { $0.id == item.id }) else { return }
        guard profile.coins >= item.price else { return }
        profile.coins -= item.price
        themeStore[index].unlocked = true
        if let themeIndex = themes.firstIndex(where: { $0.id == item.theme.id }) {
            themes[themeIndex].unlocked = true
        }
        save()
    }

    func applyTheme(_ theme: Theme) {
        guard theme.unlocked else { return }
        profile.preferredThemeID = theme.id
        save()
    }
}
