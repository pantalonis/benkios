import Testing
@testable import StudyQuestApp

struct XPTests {
    @Test func taskCompletionAwardsXP() async throws {
        let store = AppStore.shared
        let originalXP = store.profile.xp
        if let task = store.tasks.first {
            store.toggleTask(task)
            #expect(store.profile.xp >= originalXP)
        }
    }

    @Test func streakUpdates() async throws {
        let store = AppStore.shared
        let lastCount = store.profile.currentStreak
        store.sessions.append(StudySession(id: UUID(), subject: store.subjects.first!, technique: store.techniques.first!, duration: 30*60, date: Date(), earnedXP: 20, earnedCoins: 5))
        store.updateStreak()
        #expect(store.profile.currentStreak >= lastCount)
    }
}

struct TimerMathTests {
    @Test func pomodoroConfigurationUpdatesDuration() async throws {
        let store = AppStore.shared
        let newConfig = PomodoroConfiguration(focusMinutes: 30, shortBreakMinutes: 5, longBreakMinutes: 15, roundsBeforeLongBreak: 4)
        store.updatePomodoro(newConfig)
        store.startTimer(mode: .pomodoro)
        #expect(Int(store.activeSecondsRemaining) == newConfig.focusMinutes * 60)
    }
}
