//
//  MainGameView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct MainGameView: View {
    @EnvironmentObject var settings: GameSettings

    @Binding var board: GameBoard
    @Binding var gameOver: Bool
    @Binding var paused: Bool
    @ObservedObject var scoreManager: ScoreManager
    
    var canMove: Bool { !gameOver }
//    @StateObject var movementHandler: SnakeMovementHandler

    var body: some View {
        VStack(spacing: 32) {
            Text("Score: \(scoreManager.score)").font(.largeTitle).foregroundColor(.primary)
            GameBoardView(board: board, shouldGlow: settings.glowEnabled)
            Spacer()
        }
        .gamePadReceiving(receiver: self)
    }
}

extension MainGameView: GamePadInputReceiver {
    func menuButtonPressed() {
        paused = true
        AudioPlayer.default.play(.pauseIn)
    }
    
    func directionalPadPressed(direction: Direction) {
        handleDirectionChange(direction)
    }
}

extension MainGameView {
    func handleDirectionChange(_ direction: Direction) {
        // Only change direction if it's not in same direction or reverse direction
        guard canMove && direction != board.snake.direction && direction != board.snake.reverseDirection else { return }
        do {
            board = try MovePerformer(scoreManager: scoreManager).move(board, direction, canWrap: settings.canWrap)
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
