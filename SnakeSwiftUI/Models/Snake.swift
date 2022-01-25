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
        if cells.contains(newHead) { throw SnakeMovementError.collision }
        
        return Snake(direction: direction, cells: cells.suffix(from: justEaten ? 0 : 1) + [newHead])
    }
}

enum Direction {
    case up
    case right
    case left
    case down
    
    var adjustment: (x: Int, y: Int) {
        switch self {
        case .up: return (0, -1)
        case .right: return (1, 0)
        case .left: return (-1, 0)
        case .down: return (0, 1)
        }
    }
    
    var reverseDirection: Direction {
        switch self {
        case .up: return .down
        case .right: return .left
        case .left: return .right
        case .down: return .up
        }
    }
    
    var snakeHeadRotation: CGFloat {
        switch self {
        case .up:    return 270
        case .right: return 0
        case .left:  return 180
        case .down:  return 90
        }
    }
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}
