//
//  GameController.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import Foundation
import Combine

import GameController

class GameController: ObservableObject {
    private static let startingGameSpeed: Double = 0.25
    private var timer: Timer!
    private var latestMoveTime: Double = Date().timeIntervalSince1970
    private var gameSpeed: Double = startingGameSpeed
    
    @Published var board: GameBoard = GameBoard.startingBoad
    @Published var score: Int = 0
    @Published var gameOver: Bool = false
    @Published var isPaused: Bool = false {
        didSet { isPaused ? pause() : resume() }
    }
    
    var canMove: Bool { !isPaused && !gameOver }

    init() {
        createTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
    }
    
    @objc private func controllerDidConnect(notification: NSNotification) {
        guard let gameController = notification.object as? GCController, let gamePad = gameController.extendedGamepad else { return }
        gamePad.dpad.valueChangedHandler = handleGamePadDirectionalPadInput(dpad:x:y:)
        gamePad.buttonMenu.valueChangedHandler = handleMenuButtonPress(button:value:pressed:)
    }
    
    func resetGame() {
        latestMoveTime = Date().timeIntervalSince1970
        gameSpeed = Self.startingGameSpeed
        score = 0
        board = GameBoard.startingBoad
        gameOver = false
        createTimer()
    }
    
    private func pause() {
        timer.invalidate()
    }
    
    private func resume() {
        createTimer()
    }
    
    private func handleMenuButtonPress(button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void {
        guard pressed else { return }
        
        if gameOver {
            resetGame()
            return
        }
        
        isPaused.toggle()
    }
    
    private func handleGamePadDirectionalPadInput(dpad: GCControllerDirectionPad, x: Float, y: Float) -> Void {
        let directionMap: [Coordinate: Direction] = [
            .init(0, 1): .up,
            .init(1, 0): .right,
            .init(0, -1): .down,
            .init(-1, 0): .left
        ]
        guard let direction = directionMap[Coordinate(Int(x), Int(y))] else { return }
        handleDirectionChange(direction)
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
            initiateGameOver()
        }
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.0167, repeats: true) { [weak self] _ in self?.handleTick() }
    }
    
    private func handleTick() {
        let current = Date().timeIntervalSince1970
        if current - latestMoveTime > gameSpeed {
            latestMoveTime = current
            print("Time for a timed move!", latestMoveTime)
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
            initiateGameOver()
        }
    }
    
    private func initiateGameOver() {
        gameOver = true
        timer.invalidate()
    }
}
