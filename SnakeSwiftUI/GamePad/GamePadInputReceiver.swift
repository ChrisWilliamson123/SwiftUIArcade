import SwiftUI

protocol GamePadInputReceiver {
    func menuButtonPressed()
    func directionalPadPressed(direction: Direction)
    func buttonBPressed()
}

extension GamePadInputReceiver {
    func menuButtonPressed() {}
    func directionalPadPressed(direction: Direction) {}
    func buttonBPressed() {}
}
