//
//  MainGameView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct MainGameView: View {
//    let boardSize: Int
    @Binding var board: GameBoard
    @Binding var gameOver: Bool
    @Binding var shouldGlow: Bool
    
    var canMove: Bool { !gameOver }
//    @StateObject var movementHandler: SnakeMovementHandler

    var body: some View {
        VStack(spacing: 32) {
//            Text("Score: \(gameController.score)").font(.largeTitle).foregroundColor(.primary)
            GameBoardView(board: board, shouldGlow: shouldGlow)
            Spacer()
        }
        .gamePadReceiving(receiver: self)
    }
}

extension MainGameView: GamePadInputReceiver {
//    func menuButtonPressed() {
//        print("Menu button pressed in main game view")
//        gameController.isPaused = true
//    }
    
    func directionalPadPressed(direction: Direction) {
        handleDirectionChange(direction)
    }
}

extension MainGameView {
    func handleDirectionChange(_ direction: Direction) {
        // Only change direction if it's not in same direction or reverse direction
        guard canMove && direction != board.snake.direction && direction != board.snake.reverseDirection else { return }
        do {
            board = try MovePerformer().move(board, direction)
        } catch {
            print("User initiated move caused error: \(error)")
            gameOver = true
        }
    }
}

//struct MainGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainGameView(boardSize: 20, gameController: GameController())
//    }
//}
