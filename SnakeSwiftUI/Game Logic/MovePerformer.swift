struct MovePerformer {
    let scoreManager: ScoreManager

    func move(_ board: GameBoard, _ direction: Direction? = nil, canWrap: Bool) throws -> GameBoard {
        do {
            let newBoard = try board.movingSnake(direction ?? board.snake.direction, canWrap: canWrap)
            return newBoard.foodEaten ? handleFoodCollision(collidingBoard: newBoard) : newBoard
        } catch {
            throw error
        }
    }
    
    private func handleFoodCollision(collidingBoard: GameBoard) -> GameBoard {
        scoreManager.score += 1
        let newFoodLocation = collidingBoard.newFoodLocation
        return GameBoard(snake: Snake(direction: collidingBoard.snake.direction, cells: collidingBoard.snake.cells, justEaten: true), foodLocation: newFoodLocation)
    }
}
