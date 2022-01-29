import SwiftUI

extension View {
    func glow(color: Color = .purple, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
    
    func gamePadReceiving() -> some View {
        let identifier = type(of: self)
        print(identifier, GamePadHandler.default.receivers.count)
        guard let asReceiver = self as? GamePadInputReceiver else { return AnyView(self) }
        return AnyView(modifier(GamePadReceivingViewModifier(identifier: "\(identifier)", receiver: asReceiver)))
    }
}
