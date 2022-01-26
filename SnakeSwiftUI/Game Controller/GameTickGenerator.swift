class GameTickGenerator {
    private var timer: Timer!
    private let tickHandler: () -> Void
    private let timeInterval: Double = 0.0167
    
    init(tickHandler: @escaping () -> Void) {
        self.tickHandler = tickHandler
        createTimer()
    }
    
    func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.0167, repeats: true) { _ in self.tickHandler() }
    }
    
    func pause() {
        timer.invalidate()
    }
    
    func restart() {
        createTimer()
    }
}
