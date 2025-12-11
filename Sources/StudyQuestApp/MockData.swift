import Foundation
import SwiftUI

enum MockData {
    static let subjects: [Subject] = [
        Subject(id: UUID(), name: "Math", color: .init(primary: "#76E0C2", accent: "#3A9ED9")),
        Subject(id: UUID(), name: "History", color: .init(primary: "#FFD166", accent: "#EF476F")),
        Subject(id: UUID(), name: "Biology", color: .init(primary: "#9EF01A", accent: "#0A9396"))
    ]

    static let techniques: [Technique] = [
        Technique(id: UUID(), name: "Pomodoro", description: "25/5 cadence with restorative long breaks."),
        Technique(id: UUID(), name: "Deep Work", description: "Long focus blocks, ideal for essays."),
        Technique(id: UUID(), name: "Spaced Repetition", description: "Flashcard-first retention work.")
    ]

    static let quests: [Quest] = [
        Quest(id: UUID(), title: "Daily Focus", requiredMinutes: 50, rewardXP: 100, rewardCoins: 20, progressMinutes: 25, frequency: .daily, claimed: false),
        Quest(id: UUID(), title: "Weekly Momentum", requiredMinutes: 300, rewardXP: 400, rewardCoins: 80, progressMinutes: 120, frequency: .weekly, claimed: false)
    ]

    static let customRewards: [CustomReward] = [
        CustomReward(id: UUID(), title: "Matcha Run", icon: "🥤", requiredMinutes: 120, rewardXP: 120, rewardCoins: 25, claimed: false),
        CustomReward(id: UUID(), title: "Game Break", icon: "🎮", requiredMinutes: 200, rewardXP: 200, rewardCoins: 40, claimed: false)
    ]

    static let badges: [Badge] = [
        Badge(id: UUID(), name: "Spark", description: "First session logged", icon: "⚡️", achieved: true),
        Badge(id: UUID(), name: "Streak Master", description: "10-day streak", icon: "🔥", achieved: false),
        Badge(id: UUID(), name: "Focus Pro", description: "500 total minutes", icon: "🎯", achieved: true)
    ]

    static let themes: [Theme] = [
        Theme(id: UUID(), name: "Cyberpunk", background: "#050505", surface: "#0F111A", primary: "#8A2BE2", accent: "#0FF", glow: "#0FF", extras: ["scanline": "true"], price: 0, unlocked: true),
        Theme(id: UUID(), name: "Space", background: "#050816", surface: "#0B1024", primary: "#9DCEFF", accent: "#F72585", glow: "#9DCEFF", extras: ["stars": "true"], price: 150, unlocked: false),
        Theme(id: UUID(), name: "Chiikawa", background: "#FFF5F8", surface: "#FFE9F0", primary: "#FF9EAA", accent: "#8AC926", glow: nil, extras: ["cute": "true"], price: 200, unlocked: false),
        Theme(id: UUID(), name: "Retro Terminal", background: "#001100", surface: "#002200", primary: "#39FF14", accent: "#32CD32", glow: "#39FF14", extras: ["crt": "true"], price: 120, unlocked: false),
        Theme(id: UUID(), name: "Light", background: "#F5F5F7", surface: "#FFFFFF", primary: "#0A84FF", accent: "#30D158", glow: nil, extras: [:], price: 0, unlocked: true)
    ]

    static var themeStore: [ThemeStoreItem] {
        themes.map { ThemeStoreItem(id: UUID(), theme: $0, price: $0.price, unlocked: $0.unlocked) }
    }

    static func sessions(subjects: [Subject], techniques: [Technique]) -> [StudySession] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<7).map { offset in
            StudySession(
                id: UUID(),
                subject: subjects.randomElement()!,
                technique: techniques.randomElement()!,
                duration: Double.random(in: 20...60) * 60,
                date: calendar.date(byAdding: .day, value: -offset, to: today) ?? today,
                earnedXP: Int.random(in: 30...90),
                earnedCoins: Int.random(in: 5...25)
            )
        }
    }

    static func tasks(subjects: [Subject]) -> [Task] {
        [
            Task(id: UUID(), title: "Review derivatives", subject: subjects[0], expectedMinutes: 30, completed: false, rewardXP: 60),
            Task(id: UUID(), title: "Outline history essay", subject: subjects[1], expectedMinutes: 45, completed: true, rewardXP: 90),
            Task(id: UUID(), title: "Flashcards: plants", subject: subjects[2], expectedMinutes: 20, completed: false, rewardXP: 40)
        ]
    }
}
