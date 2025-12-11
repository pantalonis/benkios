import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var selectedSubject: Subject?
    @State private var range: Int = 7

    var filteredSessions: [StudySession] {
        store.sessions.filter { session in
            guard let subject = selectedSubject else { return true }
            return session.subject.id == subject.id
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                filters
                barChart
                lineChart
                heatmap
                sessionHistory
            }
            .padding()
        }
        .navigationTitle("Analytics")
    }

    private var filters: some View {
        VStack(alignment: .leading) {
            Picker("Subject", selection: $selectedSubject) {
                Text("All Subjects").tag(Optional<Subject>(nil))
                ForEach(store.subjects) { subject in
                    Text(subject.name).tag(Optional(subject))
                }
            }
            .pickerStyle(.menu)
            Stepper("Range: \(range) days", value: $range, in: 7...30)
        }
        .glassSurface()
    }

    private var barChart: some View {
        VStack(alignment: .leading) {
            Text("Focus minutes")
                .font(.headline)
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(filteredSessions.prefix(range), id: \.id) { session in
                    Rectangle()
                        .fill(LinearGradient(colors: [.cyan, .purple], startPoint: .top, endPoint: .bottom))
                        .frame(width: 12, height: CGFloat(session.duration / 5))
                        .accessibilityLabel("\(Int(session.duration/60)) minutes")
                }
            }
        }
        .glassSurface()
    }

    private var lineChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("XP trend")
                .font(.headline)
            GeometryReader { proxy in
                Path { path in
                    let data = filteredSessions.prefix(range)
                    guard let first = data.first else { return }
                    let start = CGPoint(x: 0, y: proxy.size.height - CGFloat(first.earnedXP))
                    path.move(to: start)
                    for (index, session) in data.enumerated() {
                        let x = CGFloat(index) / CGFloat(max(data.count - 1, 1)) * proxy.size.width
                        let y = proxy.size.height - CGFloat(session.earnedXP)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(LinearGradient(colors: [.mint, .blue], startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
            .frame(height: 120)
        }
        .glassSurface()
    }

    private var heatmap: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Streak heatmap")
                .font(.headline)
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(24), spacing: 4), count: 7), spacing: 4) {
                ForEach(0..<range, id: \.self) { index in
                    let active = index < store.profile.currentStreak
                    Rectangle()
                        .fill(active ? Color.green : Color.gray.opacity(0.4))
                        .frame(height: 18)
                        .cornerRadius(4)
                }
            }
        }
        .glassSurface()
    }

    private var sessionHistory: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Sessions")
                .font(.headline)
            ForEach(filteredSessions.prefix(5)) { session in
                HStack {
                    Text(session.subject.name)
                    Spacer()
                    Text("\(Int(session.duration/60)) min • XP \(session.earnedXP)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .glassSurface()
    }
}
