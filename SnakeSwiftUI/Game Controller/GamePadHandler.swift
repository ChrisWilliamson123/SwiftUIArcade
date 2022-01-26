import GameController

class GamePadHandler {
    weak var delegate: GamePadInputDelegate!
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
    }
    
    @objc private func controllerDidConnect(notification: NSNotification) {
        guard let gameController = notification.object as? GCController, let gamePad = gameController.extendedGamepad else { return }
        gamePad.dpad.valueChangedHandler = handleGamePadDirectionalPadInput(dpad:x:y:)
        gamePad.buttonMenu.valueChangedHandler = handleMenuButtonPress(button:value:pressed:)
    }
    
    private func handleMenuButtonPress(button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void {
        guard pressed else { return }
        
        delegate.menuButtonPressed()
    }
    
    private func handleGamePadDirectionalPadInput(dpad: GCControllerDirectionPad, x: Float, y: Float) -> Void {
        let directionMap: [Coordinate: Direction] = [
            .init(0, 1): .up,
            .init(1, 0): .right,
            .init(0, -1): .down,
            .init(-1, 0): .left
        ]
        guard let direction = directionMap[Coordinate(Int(x), Int(y))] else { return }
        delegate.directionalPadPressed(direction: direction)
    }
}
