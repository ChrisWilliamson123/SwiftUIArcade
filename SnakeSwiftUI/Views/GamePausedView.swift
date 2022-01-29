//
//  GamePausedView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI
import AVFoundation


var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR")
        }
    }
}

struct GamePausedView: View {
    @EnvironmentObject var settings: GameSettings
    @Binding var isPaused: Bool
    @State var selectedSettingIndex: Int = 0
    
    private let menuNavigationAudioPlayer = AudioPlayer(sound: .menuNavigate)
    private let menuSelectionAudioPlayer = AudioPlayer(sound: .menuSelect)

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
        case .up:
            menuNavigationAudioPlayer.playSound()
            selectedSettingIndex = max(selectedSettingIndex - 1, 0)
        case .down:
            menuNavigationAudioPlayer.playSound()
            selectedSettingIndex = min(selectedSettingIndex + 1, settings.settingsList.count - 1)
        default: break
        }
    }
    
    func buttonAPressed() {
        settings.settingsList[selectedSettingIndex].action()
        menuSelectionAudioPlayer.playSound()
    }
}

struct GamePausedView_Previews: PreviewProvider {
    static var previews: some View {
        GamePausedView(isPaused: .constant(false))
    }
}

