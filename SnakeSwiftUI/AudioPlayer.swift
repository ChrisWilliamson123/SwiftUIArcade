import AVFoundation

class AudioPlayer {
    private let audioPlayer: AVAudioPlayer

    init(sound: Sound, fileType: String = "wav") {
        let path = Bundle.main.path(forResource: sound.rawValue, ofType: fileType)!
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        audioPlayer.prepareToPlay()
    }
    
    func playSound() {
        if audioPlayer.isPlaying { audioPlayer.stop() }
        audioPlayer.play()
    }
    
    enum Sound: String {
        case menuNavigate = "menu_navigate"
        case menuSelect = "menu_select"
    }
}
