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
    let shouldGlow: Bool
    
    var body: some View {
        GeometryReader { geo in
            // Wrapping in a ZStack to ensure centering of inner views.
            ZStack {
                VStack(spacing: 0) {
                    ForEach(0..<gridSize) { rowIndex in
                        HStack(spacing: 0) {
                            ForEach(0..<gridSize) { colIndex in
                                getCellFill(cellCoord: .init(colIndex, rowIndex))
                            }
                        }
                    }
                }
                .background(.ultraThinMaterial)
                .border(Color.primary)
                .clipped()
                .if(shouldGlow) { $0.glow() }
                .frame(width: min(geo.size.height, geo.size.width), height: min(geo.size.height, geo.size.width))
            }
            .frame(minWidth: geo.size.width)
        }
    }
    
    private func getCellFill(cellCoord: Coordinate) -> some View {
        if board.snake.head == cellCoord { return AnyView(Image(systemName: "play.fill").resizable().padding(twoPixelPadding).foregroundColor(.primary).rotationEffect(.degrees(board.snake.direction.snakeHeadRotation))) }
        if board.snake.cells.contains(cellCoord) { return AnyView(Image(systemName: "stop.fill").resizable().padding(twoPixelPadding).foregroundColor(.primary)) }
        if cellCoord == board.foodLocation { return AnyView(Image(systemName: "ant.fill").resizable().foregroundColor(Color(UIColor.systemRed))) }
        return AnyView(Rectangle().fill(.clear))
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            GameBoardView(board: GameBoard.getStartingBoard(using: GameSettings()), gridSize: 20, shouldGlow: true)
            Spacer()
        }
    }
}
extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }
}
