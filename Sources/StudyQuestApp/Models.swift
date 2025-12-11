import Foundation
import SwiftUI

struct StudySession: Identifiable, Codable {
    let id: UUID
    var subject: Subject
    var technique: Technique
    var duration: TimeInterval
    var date: Date
    var earnedXP: Int
    var earnedCoins: Int
}

struct Badge: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var icon: String
    var achieved: Bool
}

struct Quest: Identifiable, Codable {
    enum Frequency: String, Codable, CaseIterable { case daily, weekly }
    let id: UUID
    var title: String
    var requiredMinutes: Int
    var rewardXP: Int
    var rewardCoins: Int
    var progressMinutes: Int
    var frequency: Frequency
    var claimed: Bool
    var completed: Bool { progressMinutes >= requiredMinutes }
}

struct CustomReward: Identifiable, Codable {
    let id: UUID
    var title: String
    var icon: String
    var requiredMinutes: Int
    var rewardXP: Int
    var rewardCoins: Int
    var claimed: Bool
}

struct Subject: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var color: ColorScheme

    struct ColorScheme: Codable, Hashable {
        var primary: String
        var accent: String
    }
}

struct Technique: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var description: String
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var subject: Subject
    var expectedMinutes: Int
    var completed: Bool
    var rewardXP: Int
}

struct PomodoroConfiguration: Codable {
    var focusMinutes: Int
    var shortBreakMinutes: Int
    var longBreakMinutes: Int
    var roundsBeforeLongBreak: Int
}

struct Theme: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var background: String
    var surface: String
    var primary: String
    var accent: String
    var glow: String?
    var extras: [String: String]
    var price: Int
    var unlocked: Bool
}

struct ThemeStoreItem: Identifiable, Codable {
    let id: UUID
    var theme: Theme
    var price: Int
    var unlocked: Bool
}

struct UserProfile: Codable {
    var xp: Int
    var coins: Int
    var currentStreak: Int
    var longestStreak: Int
    var preferredThemeID: UUID?
    var focusModeEnabled: Bool
}

struct SmartTip: Identifiable {
    let id = UUID()
    var message: String
    var icon: String
}

enum TimerMode: String, CaseIterable {
    case standard = "Standard"
    case pomodoro = "Pomodoro"
}
