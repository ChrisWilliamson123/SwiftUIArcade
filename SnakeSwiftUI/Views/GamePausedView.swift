//
//  GamePausedView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct GamePausedView: View {
    private let identifier = "GamePausedView"
    @ObservedObject var settings: GameSettings
    @Binding var isPaused: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("PAUSED").font(.largeTitle).foregroundColor(.primary)
            List(settings.settingsList, id: \.self) {
                Button("\($0.name): \($0.status)", action: $0.action)
            }
            Text("Press START to resume").foregroundColor(.action)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        
    }
}

extension GamePausedView: GamePadInputReceiver {
    func menuButtonPressed() {
        isPaused = false
    }
}

struct GamePausedView_Previews: PreviewProvider {
    static var previews: some View {
        GamePausedView(settings: GameSettings(), isPaused: .constant(false))
    }
}

