//
//  GameController.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import Foundation
import Combine

class GameController: ObservableObject {
    private static let startingGameSpeed: Double = 0.25
    
    private var latestMoveTime: Double = Date().timeIntervalSince1970
    private var gameSpeed: Double = startingGameSpeed
    private var tickGenerator: GameTickGenerator!
    
    private let gamePadHandler = GamePadHandler()
    var settings: GameSettings
    
    @Published var board: GameBoard
    @Published var score: Int = 0
    @Published var gameIsOver: Bool = false
    @Published var isPaused: Bool = false { didSet { isPaused ? pause() : resume() } }
    
    private var canMove: Bool { !isPaused && !gameIsOver }
    
    init() {
        settings = GameSettings(canWrap: false)
        board = GameBoard.getStartingBoard(using: settings)
        tickGenerator = GameTickGenerator(tickHandler: handleTick)
        gamePadHandler.delegate = self
        settings.delegate = self
    }
    
    private func executeNextMove() {
        guard canMove else { return }
        move()
    }
    
    private func handleDirectionChange(_ direction: Direction) {
        // Only change direction if it's not in same direction or reverse direction
        guard direction != board.snake.direction && direction != board.snake.reverseDirection && canMove else { return }
        move(direction)
    }
    
    private func move(_ direction: Direction? = nil) {
        do {
            var newBoard = try board.movingSnake(direction ?? board.snake.direction)
            if newBoard.foodEaten {
                score += 1
                gameSpeed *= 0.9
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

extension GameController: GamePadInputDelegate {
    func menuButtonPressed() {
        if gameIsOver { reset() }
        else { isPaused.toggle() }
    }
    
    func directionalPadPressed(direction: Direction) {
        handleDirectionChange(direction)
    }
    
    func buttonBPressed() {
        settings.canWrap.toggle()
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
        
        board = GameBoard.getStartingBoard(using: settings)
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
