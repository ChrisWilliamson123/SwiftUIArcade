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
    
    @State private var gameOver: Bool = false
    @State private var board = GameBoard.getStartingBoard()
    
    init() {
        tickGenerator = GameTickGenerator()
    }

    var body: some View {
        ZStack {
            MainGameView(board: $board, shouldGlow: .constant(true))
                .padding()

//            if gameController.isPaused {
//                GamePausedView(settings: gameController.settings, isPaused: $gameController.isPaused)
//            }
//            else if gameController.gameIsOver {
//                GameOverView(newGameAction: gameController.reset, finalScore: gameController.score)
//            }
        }
        .background(Image("background").centerCropped().ignoresSafeArea())
        .onAppear(perform: { tickGenerator.tickHandler = performTimedMove })
    }
}

extension ContentView {
    func performTimedMove() {
        let currentTimeInterval = Date().timeIntervalSince1970
        if currentTimeInterval - latestMoveTime > gameSpeed {
            latestMoveTime = currentTimeInterval
            do {
                board = try MovePerformer(board: board).move()
            } catch {
                print("Automatic move caused error: \(error)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
