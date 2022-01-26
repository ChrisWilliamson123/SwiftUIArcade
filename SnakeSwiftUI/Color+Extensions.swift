import SwiftUI

extension Color {
    static var background: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor.black : UIColor.white })
    }
    
    static var primary: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor.white : UIColor.black })
    }
    
    static var action: Color {
        Color(UIColor.systemBlue)
    }
}
