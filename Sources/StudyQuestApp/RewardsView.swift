import SwiftUI

struct RewardsView: View {
    @EnvironmentObject private var store: AppStore
    @State private var customTitle = ""
    @State private var requiredMinutes = 60
    @State private var icon = "⭐️"
    @State private var rewardXP = 80

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Quests")
                    .font(.title2.bold())
                ForEach(store.quests) { quest in
                    questCard(quest)
                }

                Text("Custom Rewards")
                    .font(.title2.bold())
                ForEach(store.customRewards) { reward in
                    customRewardCard(reward)
                }

                createRewardForm
            }
            .padding()
        }
        .navigationTitle("Rewards")
    }

    private func questCard(_ quest: Quest) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(quest.title)
                    .font(.headline)
                Spacer()
                Text(quest.frequency.rawValue.capitalized)
                    .font(.caption)
                    .padding(6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }
            ProgressView(value: Double(quest.progressMinutes) / Double(quest.requiredMinutes))
                .tint(.mint)
            Text("\(quest.progressMinutes)/\(quest.requiredMinutes) minutes")
                .font(.caption)
            HStack {
                Text("XP: \(quest.rewardXP) • Coins: \(quest.rewardCoins)")
                Spacer()
                Button(quest.claimed ? "Claimed" : "Claim") {
                    store.claimQuest(quest)
                }
                .buttonStyle(.borderedProminent)
                .disabled(quest.claimed || !quest.completed)
            }
        }
        .glassSurface()
        .opacity(quest.completed ? 1 : 0.9)
    }

    private func customRewardCard(_ reward: CustomReward) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(reward.icon) \(reward.title)")
                    .font(.headline)
                Spacer()
                if reward.claimed { Label("Claimed", systemImage: "checkmark.circle.fill").foregroundStyle(.green) }
            }
            Text("Minutes: \(reward.requiredMinutes) | XP: \(reward.rewardXP) | Coins: \(reward.rewardCoins)")
                .font(.caption)
            Button(reward.claimed ? "Claimed" : "Claim") {
                store.claimReward(reward)
            }
            .buttonStyle(.borderedProminent)
            .disabled(reward.claimed)
        }
        .glassSurface()
    }

    private var createRewardForm: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create Reward")
                .font(.headline)
            TextField("Title", text: $customTitle)
                .textFieldStyle(.roundedBorder)
            TextField("Icon", text: $icon)
                .textFieldStyle(.roundedBorder)
            Stepper("Required minutes: \(requiredMinutes)", value: $requiredMinutes, in: 10...500, step: 10)
            Stepper("Reward XP: \(rewardXP)", value: $rewardXP, in: 10...500, step: 10)
            Button("Add Reward") {
                let newReward = CustomReward(id: UUID(), title: customTitle, icon: icon, requiredMinutes: requiredMinutes, rewardXP: rewardXP, rewardCoins: rewardXP / 5, claimed: false)
                store.customRewards.append(newReward)
                customTitle = ""
            }
            .buttonStyle(.bordered)
        }
        .glassSurface()
    }
}
