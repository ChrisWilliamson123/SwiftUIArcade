//
//  MainGameView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 26/01/2022.
//

import SwiftUI

struct MainGameView: View {
    let score: Int
    let board: GameBoard
    let boardSize: Int

    var body: some View {
        VStack(spacing: 32) {
            Text("Score: \(score)").font(.largeTitle).foregroundColor(.primary)
            GameBoardView(board: board, gridSize: boardSize)
            Spacer()
        }
    }
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView(score: 10, board: GameBoard.getStartingBoard(using: GameSettings(canWrap: false)), boardSize: 20)
    }
}
