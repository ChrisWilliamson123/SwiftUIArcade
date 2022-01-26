protocol GamePadInputDelegate: AnyObject {
    func menuButtonPressed()
    func directionalPadPressed(direction: Direction)
}
