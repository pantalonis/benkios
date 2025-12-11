import SwiftUI

struct StoreView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Theme Store")
                    .font(.title.bold())
                ForEach(store.themeStore) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.theme.name)
                                .font(.headline)
                            Text("Price: \(item.price) coins")
                                .font(.caption)
                        }
                        Spacer()
                        Button(item.unlocked ? "Owned" : "Buy") {
                            store.unlockTheme(item)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(item.unlocked)
                    }
                    .glassSurface()
                }
            }
            .padding()
        }
        .navigationTitle("Store")
    }
}
