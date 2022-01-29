import GameController
import CoreHaptics

class GamePadHandler {
    static var `default`: GamePadHandler = GamePadHandler()

    var receivers: [(id: String, receiver: GamePadInputReceiver)] = []
    var receiver: GamePadInputReceiver? {
        print(receivers.count)
        for r in receivers { print(r) }
        return receivers.last?.receiver
    }

    private var hapticsEngine: CHHapticEngine?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
    }
    
    @objc private func controllerDidConnect(notification: NSNotification) {
        guard let gameController = notification.object as? GCController, let gamePad = gameController.extendedGamepad else { return }
        
        gamePad.dpad.valueChangedHandler = handleGamePadDirectionalPadInput
        gamePad.buttonMenu.valueChangedHandler = handleMenuButtonPress
        gamePad.buttonA.valueChangedHandler = handleAButtonPress
        gamePad.buttonB.valueChangedHandler = handleBButtonPress

        if let haptics = gamePad.controller?.haptics {
            hapticsEngine = haptics.createEngine(withLocality: .default)
            try? hapticsEngine!.start()
        }
    }

    private func handleMenuButtonPress(button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void {
        guard pressed else { return }
        receiver?.menuButtonPressed()
    }
    
    private func handleAButtonPress(button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void {
        guard pressed else { return }
        receiver?.buttonAPressed()
    }
    
    private func handleBButtonPress(button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void {
        guard pressed else { return }
        receiver?.buttonBPressed()
    }
    
    private func handleGamePadDirectionalPadInput(dpad: GCControllerDirectionPad, x: Float, y: Float) -> Void {
        let directionMap: [Coordinate: Direction] = [
            .init(0, 1): .up,
            .init(1, 0): .right,
            .init(0, -1): .down,
            .init(-1, 0): .left
        ]
        guard let direction = directionMap[Coordinate(Int(x), Int(y))] else { return }
        receiver?.directionalPadPressed(direction: direction)
    }
    
    private func playHapticsFile() {
        guard let path = Bundle.main.path(forResource: "Test", ofType: "ahap") else { return }
        try? hapticsEngine?.playPattern(from: URL(fileURLWithPath: path))
    }
}
