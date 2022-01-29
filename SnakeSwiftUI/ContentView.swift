//
//  ContentView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import SwiftUI

struct ContentView: View {
    private let boardSize: Int = 20
    
    // TIMING
    private let tickGenerator: GameTickGenerator
    private var gameSpeed: Double = 0.2
    @State private var latestMoveTime: Double = Date().timeIntervalSince1970
    
    @State private var board = GameBoard.getStartingBoard()
    @StateObject private var scoreManager = ScoreManager()
    @State private var gameOver: Bool = false { didSet { if gameOver { tickGenerator.pause() } } }
    
    init() {
        tickGenerator = GameTickGenerator()
    }

    var body: some View {
        ZStack {
            MainGameView(board: $board, gameOver: $gameOver, scoreManager: scoreManager, shouldGlow: .constant(true))
                .padding()

//            if gameController.isPaused {
//                GamePausedView(settings: gameController.settings, isPaused: $gameController.isPaused)
//            }
            if gameOver {
                GameOverView(newGameAction: resetGame, finalScore: scoreManager.score)
            }
        }
        .background(Image("background").centerCropped().ignoresSafeArea())
        .onAppear(perform: { tickGenerator.tickHandler = performTimedMove })
    }
    
    private func resetGame() {
        latestMoveTime = Date().timeIntervalSince1970
        scoreManager.score = 0
        board = GameBoard.getStartingBoard(canWrap: false)
        gameOver = false
        tickGenerator.restart()
    }
}

extension ContentView {
    func performTimedMove() {
        let currentTimeInterval = Date().timeIntervalSince1970
        if currentTimeInterval - latestMoveTime > gameSpeed {
            latestMoveTime = currentTimeInterval
            do {
                board = try MovePerformer(scoreManager: scoreManager).move(board)
            } catch {
                print("Automatic move caused error: \(error)")
                gameOver = true
            }
        }
    }
}

struct MovePerformer {
    let scoreManager: ScoreManager

    func move(_ board: GameBoard, _ direction: Direction? = nil) throws -> GameBoard {
        do {
            let newBoard = try board.movingSnake(direction ?? board.snake.direction)
            return newBoard.foodEaten ? handleFoodCollision(collidingBoard: newBoard) : newBoard
        } catch {
            throw error
        }
    }
    
    private func handleFoodCollision(collidingBoard: GameBoard) -> GameBoard {
        scoreManager.score += 1
        let newFoodLocation = collidingBoard.newFoodLocation
        return GameBoard(snake: Snake(direction: collidingBoard.snake.direction, cells: collidingBoard.snake.cells, justEaten: true), foodLocation: newFoodLocation, canWrap: collidingBoard.canWrap)
    }
}

final class ScoreManager: ObservableObject {
    @Published var score = 0
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
