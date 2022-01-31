//
//  GamePausedView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI
import AVFoundation

struct GamePausedView: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var isPaused: Bool
    @State var selectedSettingIndex: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("PAUSED").font(.largeTitle).foregroundColor(.primary)
            VStack(alignment: .leading) {
                ForEach(Array(settings.settingsList.enumerated()), id: \.element) { index, element in
                    HStack() {
                        Image(systemName: "arrowtriangle.right.fill").foregroundColor(index == selectedSettingIndex ? .primary : .clear)
                        Text("\(element.name): \(element.status)").foregroundColor(index == selectedSettingIndex ? .primary : .gray)
                    }
                }
            }
            .offset(x: -8, y: 0)
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
        resume()
    }
    
    func buttonBPressed() {
        resume()
    }
    
    func directionalPadPressed(direction: Direction) {
        switch direction {
        case .up:
            AudioPlayer.default.play(.menuNavigate)
            selectedSettingIndex = max(selectedSettingIndex - 1, 0)
        case .down:
            AudioPlayer.default.play(.menuNavigate)
            selectedSettingIndex = min(selectedSettingIndex + 1, settings.settingsList.count - 1)
        default: break
        }
    }
    
    func buttonAPressed() {
        settings.settingsList[selectedSettingIndex].action()
        AudioPlayer.default.play(.menuSelect)
    }
}

extension GamePausedView {
    func resume() {
        isPaused = false
        AudioPlayer.default.play(.pauseOut)
    }
}

struct GamePausedView_Previews: PreviewProvider {
    static var previews: some View {
        GamePausedView(isPaused: .constant(false))
    }
}

