//
//  GameBoardView.swift
//  SnakeSwiftUI
//
//  Created by Chris on 23/01/2022.
//

import SwiftUI

struct GameBoardView: View {
    let board: GameBoard
    let gridSize: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gridSize) { rowIndex in
                HStack(spacing: 0) {
                    ForEach(0..<gridSize) { colIndex in
                        getCellFill(cellCoord: .init(colIndex, rowIndex))
                    }
                }
            }
        }.background(.black)
    }
    
    private func getCellFill(cellCoord: Coordinate) -> some View {
        if board.snake.head == cellCoord { return AnyView(Image(systemName: "play.fill").foregroundColor(.white).rotationEffect(.degrees(board.snake.direction.snakeHeadRotation))) }
        if board.snake.cells.contains(cellCoord) { return AnyView(Image(systemName: "stop.fill").foregroundColor(.white)) }
        if cellCoord == board.foodLocation { return AnyView(Image(systemName: "ant.fill").foregroundColor(.red)) }
        return AnyView(Rectangle().fill(.clear))
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            GameBoardView(board: GameBoard.startingBoad, gridSize: 20)
            Spacer()
        }
    }
}
