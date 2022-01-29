//
//  GamePausedView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct GamePausedView: View {
    @ObservedObject var settings: GameSettings
    @Binding var isPaused: Bool
    @State var selectedSettingIndex: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("PAUSED").font(.largeTitle).foregroundColor(.primary)
            VStack {
                ForEach(Array(settings.settingsList.enumerated()), id: \.element) { index, element in
                    Button("\(index == selectedSettingIndex ? ">" : " ") \(element.name): \(element.status)", action: element.action)
                }
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

