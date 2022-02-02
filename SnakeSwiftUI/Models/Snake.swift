import UIKit

struct Snake: Equatable {
    let direction: Direction
    let cells: [Coordinate]
    let justEaten: Bool
    
    init(direction: Direction, cells: [Coordinate], justEaten: Bool = false) {
        self.direction = direction
        self.cells = cells
        self.justEaten = justEaten
    }
    
    var reverseDirection: Direction { direction.reverseDirection }
    var head: Coordinate { cells.last! }
    var tail: Coordinate { cells.first! }
    
    func movedInDirection(_ direction: Direction) throws -> Snake {
        let adjustment = direction.adjustment
        let newHead = Coordinate(cells.last!.x + adjustment.x, cells.last!.y + adjustment.y)
        let newCellsWithoutHead = cells.suffix(from: justEaten ? 0 : 1)
        if newCellsWithoutHead.contains(newHead) { throw SnakeMovementError.collision }
        
        return Snake(direction: direction, cells: Array(newCellsWithoutHead + [newHead]))
    }
    
    func wrapped(gameSize: Int) -> Snake {
        let nonWrappedCells = self.cells
        let wrappedCells: [Coordinate] = nonWrappedCells.map({
            let x: Int
            let y: Int
            
            if $0.x < 0 { x = gameSize - 1 }
            else if $0.x == gameSize { x = 0 }
            else { x = $0.x }
            
            if $0.y < 0 { y = gameSize - 1 }
            else if $0.y == gameSize { y = 0 }
            else { y = $0.y }
            
            return Coordinate(x, y)
        })
        return Snake(direction: self.direction, cells: wrappedCells)
    }
}
