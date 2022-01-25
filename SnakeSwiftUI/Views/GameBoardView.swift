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
    let twoPixelPadding = EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<gridSize) { rowIndex in
                HStack(spacing: 0) {
                    ForEach(0..<gridSize) { colIndex in
                        getCellFill(cellCoord: .init(colIndex, rowIndex))
                    }
                }
            }
        }
        .background(.black)
        .border(.white)
    }
    
    private func getCellFill(cellCoord: Coordinate) -> some View {
        if board.snake.head == cellCoord { return AnyView(Image(systemName: "play.fill").resizable().padding(twoPixelPadding).foregroundColor(.white).rotationEffect(.degrees(board.snake.direction.snakeHeadRotation))) }
        if board.snake.cells.contains(cellCoord) { return AnyView(Image(systemName: "stop.fill").resizable().padding(twoPixelPadding).foregroundColor(.white)) }
        if cellCoord == board.foodLocation { return AnyView(Image(systemName: "ant.fill").resizable().foregroundColor(.red)) }
//        if board.snake.cells.contains(cellCoord) { return AnyView(Rectangle().fill(.white)) }
//        if cellCoord == board.foodLocation { return Rectangle().fill(.red) }
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
