import SwiftUI

struct GamePadReceivingViewModifier: ViewModifier {
    var identifier: String
    var receiver: GamePadInputReceiver
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: { GamePadHandler.default.receivers.append((identifier, receiver)) })
            .onDisappear(perform: { GamePadHandler.default.receivers.removeAll(where: { $0.id == identifier }) })
    }
}
