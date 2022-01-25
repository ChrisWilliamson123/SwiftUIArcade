//
//  DirectionButtonsView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import SwiftUI

struct DirectionButtonsView: View {
    let changeDirection: (Direction) -> Void
    let buttonSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 16) {
            Button { changeDirection(.up) } label: { Image(systemName: "arrow.up.circle.fill").resizable().frame(width: buttonSize, height: buttonSize) }
            HStack(spacing: 64) {
                Button { changeDirection(.left) } label: { Image(systemName: "arrow.left.circle.fill").resizable().frame(width: buttonSize, height: buttonSize) }
                Button { changeDirection(.right) } label: { Image(systemName: "arrow.right.circle.fill").resizable().frame(width: buttonSize, height: buttonSize) }
            }
            Button { changeDirection(.down) } label: { Image(systemName: "arrow.down.circle.fill").resizable().frame(width: buttonSize, height: buttonSize) }
        }
    }
}

struct DirectionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionButtonsView(changeDirection: { print("Changing direction:", $0) })
    }
}
