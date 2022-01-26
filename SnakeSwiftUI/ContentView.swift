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
    
    init() {
        
    }

    var body: some View {
        if gameController.gameOver {
            GameOverView(newGameAction: gameController.resetGame, finalScore: gameController.score)
        } else {
            VStack(spacing: 16) {
                Text("Score: \(gameController.score)").font(.largeTitle).foregroundColor(.white)
                GameBoardView(board: gameController.board, gridSize: gridSize)
                Spacer()
                DirectionButtonsView(changeDirection: gameController.handleDirectionChange)
            }
            .padding()
            .background(.black)
        }
    }
    
    private func getGameBoardViewSize(using geometry: GeometryProxy) -> CGSize {
        print(geometry.size)
        let maximumAllowedSize = min(geometry.size.width, geometry.size.height - 200)
        return CGSize(width: maximumAllowedSize, height: maximumAllowedSize)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
