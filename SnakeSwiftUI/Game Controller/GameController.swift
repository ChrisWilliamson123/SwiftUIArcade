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
    private var timer: Timer!
    private var latestMoveTime: Double = Date().timeIntervalSince1970
    private var gameSpeed: Double = startingGameSpeed
    private let gamePadHandler = GamePadHandler()
    
    @Published var board: GameBoard = GameBoard.startingBoad
    @Published var score: Int = 0
    @Published var gameIsOver: Bool = false
    @Published var isPaused: Bool = false {
        didSet { isPaused ? pause() : resume() }
    }
    
    var canMove: Bool { !isPaused && !gameIsOver }

    init() {
        createTimer()
        gamePadHandler.delegate = self
    }
    
    func handleDirectionChange(_ direction: Direction) {
        // Only change direction if it's not in same direction or reverse direction
        guard direction != board.snake.direction && direction != board.snake.reverseDirection && canMove else { return }
        do {
            var newBoard = try board.movingSnake(direction)
            if newBoard.foodEaten {
                score += 1
                gameSpeed *= 0.9
                let newFoodLocation = newBoard.newFoodLocation
                newBoard = GameBoard(snake: Snake(direction: newBoard.snake.direction, cells: newBoard.snake.cells, justEaten: true), foodLocation: newFoodLocation)
            }
            board = newBoard
        } catch {
            gameOver()
        }
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.0167, repeats: true) { [weak self] _ in self?.handleTick() }
    }
    
    private func handleTick() {
        let current = Date().timeIntervalSince1970
        if current - latestMoveTime > gameSpeed {
            latestMoveTime = current
            executeNextMove()
        }
    }
    
    private func executeNextMove() {
        guard canMove else { return }
        do {
            var newBoard = try board.movingSnake(board.snake.direction)
            if newBoard.foodEaten {
                score += 1
                gameSpeed *= 0.9
                let newFoodLocation = newBoard.newFoodLocation
                newBoard = GameBoard(snake: Snake(direction: newBoard.snake.direction, cells: newBoard.snake.cells, justEaten: true), foodLocation: newFoodLocation)
            }
            board = newBoard
        } catch {
            gameOver()
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
}

extension GameController: GameActionHandler {
    func pause() {
        timer.invalidate()
    }
    
    func resume() {
        createTimer()
    }
    
    func reset() {
        latestMoveTime = Date().timeIntervalSince1970
        gameSpeed = Self.startingGameSpeed
        score = 0
        board = GameBoard.startingBoad
        gameIsOver = false
        createTimer()
    }
    
    func gameOver() {
        gameIsOver = true
        timer.invalidate()
    }
}
