import Foundation

class GameTickGenerator {
    private var timer: Timer!
    var tickHandler: (() -> Void)! = nil
    private let timeInterval: Double = 0.0167
    
    init() {
        createTimer()
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.0167, repeats: true) { _ in self.tickHandler?() }
    }
    
    func pause() {
        timer.invalidate()
    }
    
    func restart() {
        createTimer()
    }
}
