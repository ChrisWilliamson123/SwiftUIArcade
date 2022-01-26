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
            MainGameView(score: gameController.score, board: gameController.board, boardSize: boardSize)
            
            if gameController.isPaused {
                GamePausedView()
            }
            else if gameController.gameOver {
                GameOverView(newGameAction: gameController.resetGame, finalScore: gameController.score)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
