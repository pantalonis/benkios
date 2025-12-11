import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showConfig = false
    @State private var focusMode = false
    @State private var soundOn = true

    let tips = [
        SmartTip(message: "Switch to pomodoro for sprints.", icon: "⏱️"),
        SmartTip(message: "Long break every 4 rounds keeps your brain fresh.", icon: "🧠"),
        SmartTip(message: "Blink break? Toggle eye to pause distractions.", icon: "👁️")
    ]

    var body: some View {
        VStack(spacing: 16) {
            modeToggle
            timerDisplay
            controls
            SmartTipsView(tips: tips)
                .padding(.horizontal)
            Button("Edit Pomodoro") { showConfig.toggle() }
                .padding(.top, 8)
                .sheet(isPresented: $showConfig) { PomodoroConfigView(configuration: store.pomodoroConfiguration) }
        }
        .padding()
        .background(LinearGradient(colors: [.purple.opacity(0.35), .black], startPoint: .top, endPoint: .bottom).ignoresSafeArea())
        .navigationTitle("Timer")
    }

    private var modeToggle: some View {
        Picker("Mode", selection: $store.timerMode) {
            ForEach(TimerMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .glassSurface()
    }

    private var timerDisplay: some View {
        VStack(spacing: 12) {
            Text(store.timerMode.rawValue)
                .font(.headline)
            Text(timeString(store.activeSecondsRemaining))
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .trailing))
            ProgressView(value: progress)
                .tint(.cyan)
            HStack {
                Button(action: { focusMode.toggle(); UIImpactFeedbackGenerator(style: .rigid).impactOccurred() }) {
                    Image(systemName: focusMode ? "eye.slash.fill" : "eye.fill")
                }
                .accessibilityLabel("Focus mode toggle")

                Button(action: { soundOn.toggle() }) {
                    Image(systemName: soundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                }
                .accessibilityLabel("Sound toggle")

                Spacer()
                Button(action: { store.startTimer(mode: store.timerMode); UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }) {
                    Image(systemName: store.isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                }
                Button(action: { store.stopTimer() }) { Image(systemName: "stop.circle.fill") }
            }
        }
        .padding()
        .glassSurface()
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button("Pause") { store.pauseTimer() }
                .buttonStyle(.borderedProminent)
            Button("Resume") { store.resumeTimer() }
                .buttonStyle(.bordered)
            Spacer()
            Button("Log Session") {
                let session = StudySession(
                    id: UUID(),
                    subject: store.subjects.first ?? MockData.subjects.first!,
                    technique: store.techniques.first ?? MockData.techniques.first!,
                    duration: 25 * 60,
                    date: Date(),
                    earnedXP: 60,
                    earnedCoins: 12)
                store.sessions.append(session)
                store.gainXP(session.earnedXP)
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal)
    }

    private var progress: Double {
        let maxSeconds: Double = store.timerMode == .pomodoro ? Double(store.pomodoroConfiguration.focusMinutes * 60) : 50 * 60
        return max(0, min(1, 1 - store.activeSecondsRemaining / maxSeconds))
    }

    private func timeString(_ time: TimeInterval) -> String {
        let totalSeconds = max(0, Int(time))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct PomodoroConfigView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State var configuration: PomodoroConfiguration

    var body: some View {
        NavigationStack {
            Form {
                Stepper("Focus: \(configuration.focusMinutes) min", value: $configuration.focusMinutes, in: 5...90)
                Stepper("Short break: \(configuration.shortBreakMinutes) min", value: $configuration.shortBreakMinutes, in: 3...30)
                Stepper("Long break: \(configuration.longBreakMinutes) min", value: $configuration.longBreakMinutes, in: 10...60)
                Stepper("Rounds before long break: \(configuration.roundsBeforeLongBreak)", value: $configuration.roundsBeforeLongBreak, in: 2...8)
            }
            .navigationTitle("Pomodoro")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { store.updatePomodoro(configuration); dismiss() }
                }
            }
        }
    }
}
