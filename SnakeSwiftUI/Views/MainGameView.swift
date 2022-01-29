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
    @Binding var shouldGlow: Bool
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
        guard direction != board.snake.direction && direction != board.snake.reverseDirection else { return }
        let movePerformer = MovePerformer(board: board)
        do {
            board = try movePerformer.move(direction)
        } catch {
            print("User initiated move caused error: \(error)")
        }
    }
}

struct MovePerformer {
    let board: GameBoard
    
    func move(_ direction: Direction? = nil) throws -> GameBoard {
        do {
            let newBoard = try board.movingSnake(direction ?? board.snake.direction)
            return newBoard.foodEaten ? handleFoodCollision(collidingBoard: newBoard) : newBoard
        } catch {
            throw error
        }
    }
    
    private func handleFoodCollision(collidingBoard: GameBoard) -> GameBoard {
        let newFoodLocation = collidingBoard.newFoodLocation
        return GameBoard(snake: Snake(direction: collidingBoard.snake.direction, cells: collidingBoard.snake.cells, justEaten: true), foodLocation: newFoodLocation, canWrap: board.canWrap)
    }
}

//struct MainGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainGameView(boardSize: 20, gameController: GameController())
//    }
//}
