//
//  MainGameView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct MainGameView: View {
//    let score: Int
//    let board: GameBoard
    let boardSize: Int
//    @Binding var isPaused: Bool
    @ObservedObject var gameController: GameController

    var body: some View {
        VStack(spacing: 32) {
            Text("Score: \(gameController.score)").font(.largeTitle).foregroundColor(.primary)
            GameBoardView(board: gameController.board, gridSize: boardSize)
            Spacer()
        }
    }
}

extension MainGameView: GamePadInputReceiver {
    func menuButtonPressed() {
        print("Menu button pressed in main game view")
        gameController.isPaused = true
    }
    
    func directionalPadPressed(direction: Direction) {
        gameController.handleDirectionChange(direction)
    }
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView(boardSize: 20, gameController: GameController())
    }
}
