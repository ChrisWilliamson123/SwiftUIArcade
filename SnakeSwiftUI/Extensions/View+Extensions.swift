import SwiftUI

extension View {
    func glow(color: Color = .purple, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
    
    func gamePadReceiving(receiver: GamePadInputReceiver) -> some View {
        let identifier = type(of: receiver)
//        guard let asReceiver = self as? GamePadInputReceiver else { return AnyView(self) }
        return AnyView(modifier(GamePadReceivingViewModifier(identifier: "\(identifier)", receiver: receiver)))
    }
    
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}
