import AVFoundation

class AudioPlayer {
    static let `default`: AudioPlayer = AudioPlayer()
    
    private let players: [String: AVAudioPlayer]
    
    init() {
        print("Spinning up new audio player")
        var players: [String: AVAudioPlayer] = [:]
        Sound.allCases.forEach({
            let path = Bundle.main.path(forResource: $0.rawValue, ofType: "wav")!
            let player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.prepareToPlay()
            players[$0.rawValue] = player
        })
        self.players = players
    }

    func play(sound: Sound) {
        guard let player = players[sound.rawValue] else { return }
        DispatchQueue.global(qos: .background).async {
            player.play()
        }
    }

    enum Sound: String, CaseIterable {
        case menuNavigate = "menu_navigate"
        case menuSelect = "menu_select"
        case pauseIn = "pause_in"
        case pauseOut = "pause_out"
    }
}
