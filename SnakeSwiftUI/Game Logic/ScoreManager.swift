import Combine

final class ScoreManager: ObservableObject {
    @Published var score = 0 {
        didSet {
            if score > oldValue {
                AudioPlayer.default.play(.scoreUp)
            }
        }
    }
}
