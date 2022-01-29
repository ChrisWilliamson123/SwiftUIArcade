//
//  ContentView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import SwiftUI

struct ContentView: View {
    // TIMING
    private let tickGenerator: GameTickGenerator
    private var gameSpeed: Double = 0.2
    @State private var latestMoveTime: Double = Date().timeIntervalSince1970
    
    
    // GAME
    @State private var board = GameBoard.getStartingBoard()
    @StateObject private var scoreManager = ScoreManager()
    @StateObject private var settings: GameSettings = GameSettings()
    @State private var gameOver: Bool = false
    @State private var paused: Bool = false
    
    init() {
        tickGenerator = GameTickGenerator()
    }

    var body: some View {
        ZStack {
            MainGameView(board: $board, gameOver: $gameOver, paused: $paused, scoreManager: scoreManager)
                .padding()

            if paused {
                GamePausedView(isPaused: $paused)
            }
            else if gameOver {
                GameOverView(newGameAction: resetGame, finalScore: scoreManager.score)
            }
        }
        .background(Image("background").centerCropped().ignoresSafeArea())
        .onAppear(perform: { tickGenerator.tickHandler = performTimedMove })
        .onChange(of: gameOver, perform: { if $0 { tickGenerator.pause()} })
        .onChange(of: paused, perform: { $0 ? tickGenerator.pause() : tickGenerator.restart() })
        .environmentObject(settings)
    }
    
    private func resetGame() {
        latestMoveTime = Date().timeIntervalSince1970
        scoreManager.score = 0
        board = GameBoard.getStartingBoard()
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
                board = try MovePerformer(scoreManager: scoreManager).move(board, canWrap: settings.canWrap)
            } catch {
                gameOver = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
