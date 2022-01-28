//
//  MainGameView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct MainGameView: View {
    private let identifier = "main"
    let score: Int
    let board: GameBoard
    let boardSize: Int
    @Binding var isPaused: Bool
    @ObservedObject var gameController: GameController

    var body: some View {
        VStack(spacing: 32) {
            Text("Score: \(score)").font(.largeTitle).foregroundColor(.primary)
            GameBoardView(board: board, gridSize: boardSize)
            Spacer()
        }.onAppear {
            GamePadHandler.default.receivers.append((identifier, self))
        }
    }
}

extension MainGameView: GamePadInputReceiver {
    func menuButtonPressed() {
        print("Menu button pressed in main game view")
        isPaused = true
    }
    
    func directionalPadPressed(direction: Direction) {
        gameController.handleDirectionChange(direction)
    }
    
    func buttonBPressed() {
        
    }
    
    
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView(score: 10, board: GameBoard.getStartingBoard(using: GameSettings(canWrap: false)), boardSize: 20, isPaused: .constant(false), gameController: GameController())
    }
}
