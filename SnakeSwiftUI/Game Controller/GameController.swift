//
//  GameController.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import Foundation
import Combine

class GameController: ObservableObject {
    private static let startingGameSpeed: Double = 0.15
    
    private var latestMoveTime: Double = Date().timeIntervalSince1970
    private var gameSpeed: Double = startingGameSpeed
    private var tickGenerator: GameTickGenerator!
    
    @Published var settings: GameSettings
    @Published var board: GameBoard
    @Published var score: Int = 0
    @Published var gameIsOver: Bool = false
    @Published var isPaused: Bool = false { didSet { isPaused ? pause() : resume() } }
    
    private var canMove: Bool { !isPaused && !gameIsOver }
    
    init() {
        let settings = GameSettings()
        self.settings = settings
        board = GameBoard.getStartingBoard(canWrap: false)
        tickGenerator = GameTickGenerator()
        settings.delegate = self
    }
    
    private func executeNextMove() {
        guard canMove else { return }
        move()
    }
    
    func handleDirectionChange(_ direction: Direction) {
        // Only change direction if it's not in same direction or reverse direction
        guard direction != board.snake.direction && direction != board.snake.reverseDirection && canMove else { return }
        move(direction)
    }
    
    private func move(_ direction: Direction? = nil) {
        do {
            var newBoard = try board.movingSnake(direction ?? board.snake.direction)
            if newBoard.foodEaten {
                score += 1
                let newFoodLocation = newBoard.newFoodLocation
                newBoard = GameBoard(snake: Snake(direction: newBoard.snake.direction, cells: newBoard.snake.cells, justEaten: true), foodLocation: newFoodLocation, canWrap: settings.canWrap)
            }
            board = newBoard
        } catch {
            gameOver()
        }
    }
}

// MARK: - Timing
extension GameController {
    private func handleTick() {
        let current = Date().timeIntervalSince1970
        if current - latestMoveTime > gameSpeed {
            latestMoveTime = current
            executeNextMove()
        }
    }
}

extension GameController: GameActionHandler {
    func pause() {
        tickGenerator.pause()
    }
    
    func resume() {
        tickGenerator.restart()
    }
    
    func reset() {
        latestMoveTime = Date().timeIntervalSince1970
        gameSpeed = Self.startingGameSpeed
        score = 0
        
        board = GameBoard.getStartingBoard(canWrap: false)
        gameIsOver = false
        tickGenerator.restart()
    }
    
    func gameOver() {
        gameIsOver = true
        tickGenerator.pause()
    }
}

extension GameController: GameSettingsDelegate {
    func settingDidChange() {
        board = GameBoard(snake: board.snake, foodLocation: board.foodLocation, canWrap: settings.canWrap)
    }
}
