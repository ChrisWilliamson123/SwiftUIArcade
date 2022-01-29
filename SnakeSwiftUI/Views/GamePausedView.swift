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
        resume()
    }
    
    func buttonBPressed() {
        resume()
    }
    
    func directionalPadPressed(direction: Direction) {
        switch direction {
        case .up:
            AudioPlayer.default.play(sound: .menuNavigate)
            selectedSettingIndex = max(selectedSettingIndex - 1, 0)
        case .down:
            AudioPlayer.default.play(sound: .menuNavigate)
            selectedSettingIndex = min(selectedSettingIndex + 1, settings.settingsList.count - 1)
        default: break
        }
    }
    
    func buttonAPressed() {
        settings.settingsList[selectedSettingIndex].action()
        AudioPlayer.default.play(sound: .menuSelect)
    }
}

extension GamePausedView {
    func resume() {
        isPaused = false
        AudioPlayer.default.play(sound: .pauseOut)
    }
}

struct GamePausedView_Previews: PreviewProvider {
    static var previews: some View {
        GamePausedView(isPaused: .constant(false))
    }
}

