struct GameBoard {
    let size: Int = 20
    let snake: Snake
    let foodLocation: Coordinate
    let canWrap: Bool
    
    var foodEaten: Bool { snake.head == foodLocation }
    var newFoodLocation: Coordinate {
        var possibleCoordinates = Set<Coordinate>()
        for y in 0..<size {
            for x in 0..<size {
                let coordinate = Coordinate(x, y)
                if coordinate == foodLocation || snake.cells.contains(coordinate) { continue }
                possibleCoordinates.insert(coordinate)
            }
        }
        return possibleCoordinates.randomElement()!
    }
    
    static func getStartingBoard(canWrap: Bool = false) -> GameBoard {
        GameBoard(snake: Snake(direction: .right, cells: [.init(1, 1)]), foodLocation: .init(5, 3), canWrap: canWrap)
    }
    
    func movingSnake(_ direction: Direction) throws -> GameBoard {
        let newSnake = try snake.movedInDirection(direction)
        let newHead = newSnake.cells.last!
        if canWrap {
            return GameBoard(snake: newSnake.wrapped(gameSize: size), foodLocation: foodLocation, canWrap: canWrap)
        }
        guard newHead.x >= 0 && newHead.x < size && newHead.y >= 0 && newHead.y < size else { throw SnakeMovementError.outOfBounds }
        return GameBoard(snake: newSnake, foodLocation: foodLocation, canWrap: canWrap)
    }
}

enum SnakeMovementError: Error {
    case outOfBounds
    case collision
}
