import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        Form {
            Section("Theme") {
                Picker("Theme", selection: Binding(get: {
                    store.profile.preferredThemeID ?? store.themes.first?.id
                }, set: { id in
                    if let id, let theme = store.themes.first(where: { $0.id == id }) {
                        store.applyTheme(theme)
                    }
                })) {
                    ForEach(store.themes) { theme in
                        Text(theme.name).tag(Optional(theme.id))
                    }
                }
            }

            Section("Focus") {
                Toggle("Focus mode", isOn: Binding(get: {
                    store.profile.focusModeEnabled
                }, set: { store.profile.focusModeEnabled = $0; store.save() }))
                Toggle("Sound", isOn: .constant(true))
                Toggle("Notifications", isOn: .constant(true))
            }

            Section("Timer Preferences") {
                Toggle("Auto-start breaks", isOn: .constant(true))
                Toggle("Haptics", isOn: .constant(true))
            }
        }
        .navigationTitle("Settings")
    }
}
