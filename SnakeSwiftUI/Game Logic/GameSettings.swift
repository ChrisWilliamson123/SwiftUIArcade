import Combine

class GameSettings: ObservableObject {
    @Published var canWrap: Bool = false
    @Published var glowEnabled: Bool = true

    var settingsList: [SettingsListEntry] {
        [
            .init(name: "Wrapping", status: canWrap ? "ON" : "OFF", action: { self.canWrap.toggle() } ),
            .init(name: "Glow", status: glowEnabled ? "ON" : "OFF", action: { self.glowEnabled.toggle() } )
        ]
    }

    struct SettingsListEntry: Hashable {
        static func == (lhs: GameSettings.SettingsListEntry, rhs: GameSettings.SettingsListEntry) -> Bool {
            lhs.name == rhs.name && lhs.status == rhs.status
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(status)
        }
        
        let name: String
        let status: String
        let action: () -> Void
    }
}
