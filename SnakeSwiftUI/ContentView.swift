//
//  ContentView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import SwiftUI

struct ContentView: View {
    private let boardSize: Int = 20
    @StateObject var gameController = GameController()
    
    var body: some View {
        ZStack {
            MainGameView(boardSize: boardSize, gameController: gameController)
                .gamePadReceiving()
                .padding()
            
            if gameController.isPaused {
                GamePausedView(settings: gameController.settings, isPaused: $gameController.isPaused)
                    .gamePadReceiving()
            }
            else if gameController.gameIsOver {
                GameOverView(newGameAction: gameController.reset, finalScore: gameController.score)
                    .gamePadReceiving()
            }
        }.background(Image("background").centerCropped().ignoresSafeArea())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
