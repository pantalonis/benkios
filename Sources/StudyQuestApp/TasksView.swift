import SwiftUI

struct TasksView: View {
    @EnvironmentObject private var store: AppStore
    @State private var newTitle = ""
    @State private var selectedSubject: Subject?
    @State private var expectedMinutes: Int = 25
    @State private var placeholderIndex = 0
    private let placeholders = ["Write essay intro", "Practice flashcards", "Solve 5 problems", "Outline chapter notes"]

    var completionRate: Double {
        guard !store.tasks.isEmpty else { return 0 }
        let completed = store.tasks.filter { $0.completed }.count
        return Double(completed) / Double(store.tasks.count)
    }

    var body: some View {
        VStack(spacing: 16) {
            ProgressCard(title: "Task Completion", value: completionRate, subtitle: "\(Int(completionRate * 100))% complete")
            addTaskField
            List {
                ForEach(store.tasks) { task in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.title)
                            Text("XP: \(task.rewardXP)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(action: { store.toggleTask(task) }) {
                            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(task.completed ? .green : .secondary)
                        }
                        Button(role: .destructive, action: { store.deleteTask(task) }) {
                            Image(systemName: "trash")
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            SmartTipsView(tips: [SmartTip(message: "Celebrate each checkbox for XP.", icon: "🎉"), SmartTip(message: "Chunk tasks by 25 minutes", icon: "📏")])
                .padding(.horizontal)
        }
        .padding()
        .onAppear { cyclePlaceholder() }
    }

    private var addTaskField: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(placeholders[placeholderIndex], text: $newTitle)
                .textFieldStyle(.roundedBorder)
                .onChange(of: newTitle) { _ in cyclePlaceholder() }
            Picker("Subject", selection: $selectedSubject) {
                ForEach(store.subjects) { subject in
                    Text(subject.name).tag(Optional(subject))
                }
            }
            .pickerStyle(.menu)
            Stepper("Minutes: \(expectedMinutes)", value: $expectedMinutes, in: 5...180, step: 5)
            Button("Add Task") {
                guard let subject = selectedSubject ?? store.subjects.first, !newTitle.isEmpty else { return }
                store.addTask(title: newTitle, subject: subject, expectedMinutes: expectedMinutes)
                newTitle = ""
            }
            .buttonStyle(.borderedProminent)
        }
        .glassSurface()
    }

    private func cyclePlaceholder() {
        placeholderIndex = (placeholderIndex + 1) % placeholders.count
    }
}
