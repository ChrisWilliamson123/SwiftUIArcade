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
        if gameController.gameOver {
            GameOverView(newGameAction: gameController.resetGame, finalScore: gameController.score)
        } else {
            GeometryReader { geo in
                VStack(spacing: 16) {
                    Text("Score: \(gameController.score)").font(.largeTitle)
                    GameBoardView(board: gameController.board, gridSize: gridSize)
                        .frame(height: geo.size.width)
                        
                    Spacer()
                    DirectionButtonsView(changeDirection: gameController.handleDirectionChange)
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
