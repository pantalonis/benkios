# StudyQuest iOS (SwiftUI)

This Swift Package hosts the StudyQuest offline-first iOS SwiftUI experience with liquid glass visuals, timer/tasks/rewards parity to the web, analytics, leaderboard, and theme store.

## Building
1. Open `Package.swift` in Xcode 15+ on macOS with the iOS 17 SDK installed.
2. Select the **StudyQuestApp** scheme and run on an iOS 17 simulator or device.

## Features
- Home: streak headline, XP progress, glass CTA to start the timer.
- Timer: standard/pomodoro toggle, focus/sound controls, editable pomodoro durations, smart tips.
- Tasks: motivational placeholder input, XP-granting checklists, completion rate tracking.
- Rewards/Quests: daily/weekly quest cards, custom rewards with icon picker and claiming.
- Analytics: subject/range filters, bar/line visuals, streak heatmap, session history.
- Leaderboard: global/weekly/friends tabs with XP/streak context.
- Settings: theme switching, focus mode, sound/notification toggles, timer preferences.
- Store: purchasable themes (cyberpunk, space, chiikawa, retro terminal, light) with coin pricing.

## Persistence
State is persisted locally via JSON in the app's documents directory. `PersistedState.defaultState` seeds mock data for offline use and demos.

## Testing
Use the new Swift Testing package (`swift test`) to validate timer math, streak updates, and XP awards.
