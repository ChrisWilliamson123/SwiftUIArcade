//
//  ControllerDisconnectedView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 29/01/2022.
//

import SwiftUI

struct ControllerDisconnectedView: View {
    @Binding var paused: Bool

    var body: some View {
        VStack {
            Text("Controller disconnected").font(.largeTitle)
            Text("Please re-connect controller to play.").font(.title)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .onAppear(perform: { paused = true })
        .onDisappear(perform: { paused = false })
    }
}

struct ControllerDisconnectedView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerDisconnectedView(paused: .constant(true))
    }
}
