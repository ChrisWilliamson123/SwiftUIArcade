//
//  ContentView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import SwiftUI

struct ContentView: View {
    private let gridSize: Int = 20
    @StateObject var gameController = GameController()

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("Score: \(gameController.score)").font(.largeTitle).foregroundColor(.primary)
                GameBoardView(board: gameController.board, gridSize: gridSize)
                Spacer()
            }
            
            if gameController.isPaused {
                VStack(spacing: 16) {
                    Text("PAUSED").font(.largeTitle).foregroundColor(.primary)
                    Text("Press START to resume").foregroundColor(.action)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
            }
            else if gameController.gameOver {
                GameOverView(newGameAction: gameController.resetGame, finalScore: gameController.score)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
