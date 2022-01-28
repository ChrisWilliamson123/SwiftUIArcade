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
        .onAppear {
            GamePadHandler.default.receivers.append((identifier, self))
        }
        .onDisappear {
            GamePadHandler.default.receivers.removeAll(where: { $0.id == identifier })
        }
    }
}

extension GamePausedView: GamePadInputReceiver {
    func menuButtonPressed() {
        isPaused = false
    }
    
    func directionalPadPressed(direction: Direction) {
        
    }
    
    func buttonBPressed() {
        
    }
}

struct GamePausedView_Previews: PreviewProvider {
    static var previews: some View {
        GamePausedView(settings: GameSettings(), isPaused: .constant(false))
    }
}
