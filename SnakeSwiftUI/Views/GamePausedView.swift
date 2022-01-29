//
//  GamePausedView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct GamePausedView: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var isPaused: Bool
    @State var selectedSettingIndex: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("PAUSED").font(.largeTitle).foregroundColor(.primary)
            VStack {
                ForEach(Array(settings.settingsList.enumerated()), id: \.element) { index, element in
                    Text("\(index == selectedSettingIndex ? ">" : " ") \(element.name): \(element.status)")
                }
            }
            Text("Press START to resume").foregroundColor(.action)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .gamePadReceiving(receiver: self)
    }
}

extension GamePausedView: GamePadInputReceiver {
    func menuButtonPressed() {
        isPaused = false
    }
    
    func buttonBPressed() {
        isPaused = false
    }
    
    func directionalPadPressed(direction: Direction) {
        switch direction {
        case .up: selectedSettingIndex = max(selectedSettingIndex - 1, 0)
        case .down: selectedSettingIndex = min(selectedSettingIndex + 1, settings.settingsList.count - 1)
        default: break
        }
    }
    
    func buttonAPressed() {
        settings.settingsList[selectedSettingIndex].action()
    }
}

struct GamePausedView_Previews: PreviewProvider {
    static var previews: some View {
        GamePausedView(isPaused: .constant(false))
    }
}

