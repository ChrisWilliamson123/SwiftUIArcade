import XCTest
@testable import SnakeSwiftUI

class SnakeTests: XCTestCase {

    func testHeadGetsTheEndOfTheCellsArray() {
        let snake = Snake(direction: .up, cells: [.init(0, 0), .init(0, 1)])
        XCTAssertEqual(snake.head, .init(0, 1))
    }
    
    func testTailGetsTheStartOfTheCellsArray() {
        let snake = Snake(direction: .up, cells: [.init(0, 0), .init(0, 1)])
        XCTAssertEqual(snake.tail, .init(0, 0))
    }
    
    func testMovedInDirection_givenJustEatenIsFalse_returnsASnakeOfTheSameLengthMovedInTheGivenDirection() throws {
        let snake = Snake(direction: .up, cells: [.init(0, 0), .init(0, 1)])
        let moved = try snake.movedInDirection(.down)
        XCTAssertEqual(moved, Snake(direction: .down, cells: [.init(0, 1), .init(0, 2)]))
    }
    
    func testMovedInDirection_givenJustEatenIsTrue_returnsASnakeWithTheTailKept() throws {
        let snake = Snake(direction: .up, cells: [.init(0, 0), .init(0, 1)], justEaten: true)
        let moved = try snake.movedInDirection(.down)
        XCTAssertEqual(moved, Snake(direction: .down, cells: [.init(0, 0), .init(0, 1), .init(0, 2)]))
    }
    
    func testMovedInDirection_givenSnakeMovesIntoTail_shouldNotError() throws {
        let initialCells: [Coordinate] = [
            .init(0, 0),
            .init(1, 0),
            .init(2, 0),
            .init(2, 1),
            .init(2, 2),
            .init(1, 2),
            .init(0, 2),
            .init(0, 1) // This is the head
        ]
        let snake = Snake(direction: .up, cells: initialCells)
        let moved = try snake.movedInDirection(.up)
        let expectedCells: [Coordinate] = [
            .init(1, 0),
            .init(2, 0),
            .init(2, 1),
            .init(2, 2),
            .init(1, 2),
            .init(0, 2),
            .init(0, 1),
            .init(0, 0) // This is the head
        ]
        XCTAssertEqual(moved, Snake(direction: .up, cells: expectedCells))
    }
    
    func testMovedInDirection_givenSnakeMovesIntoTailAndJustEatenIsTrue_shouldError() throws {
        let initialCells: [Coordinate] = [
            .init(0, 0),
            .init(1, 0),
            .init(2, 0),
            .init(2, 1),
            .init(2, 2),
            .init(1, 2),
            .init(0, 2),
            .init(0, 1) // This is the head
        ]
        let snake = Snake(direction: .up, cells: initialCells, justEaten: true)
        XCTAssertThrowsError(try snake.movedInDirection(.up)) {
            XCTAssertEqual($0 as? SnakeMovementError, SnakeMovementError.collision)
        }
    }
    
    func testMovedInDirection_givenSnakeMovesIntoItself_shouldError() throws {
        let initialCells: [Coordinate] = [
            .init(0, 2),
            .init(0, 1),
            .init(0, 0),
            .init(1, 0),
            .init(2, 0),
            .init(2, 1),
            .init(1, 1)
        ]
        let snake = Snake(direction: .left, cells: initialCells)
        XCTAssertThrowsError(try snake.movedInDirection(.left)) {
            XCTAssertEqual($0 as? SnakeMovementError, SnakeMovementError.collision)
        }
    }
    
    func testWrapped_shouldWrapFromUpperXToLowerX() {
        let initialCells: [Coordinate] = [.init(2, 0), .init(3, 0)]
        let snake = Snake(direction: .right, cells: initialCells)
        let wrapped = snake.wrapped(gameSize: 3)
        let expectedCells: [Coordinate] = [.init(2, 0), .init(0, 0)]
        XCTAssertEqual(wrapped, Snake(direction: .right, cells: expectedCells))
    }
    
    func testWrapped_shouldWrapFromLowerXToUpperX() {
        let initialCells: [Coordinate] = [.init(0, 0), .init(-1, 0)]
        let snake = Snake(direction: .left, cells: initialCells)
        let wrapped = snake.wrapped(gameSize: 3)
        let expectedCells: [Coordinate] = [.init(0, 0), .init(2, 0)]
        XCTAssertEqual(wrapped, Snake(direction: .left, cells: expectedCells))
    }
    
    func testWrapped_shouldWrapFromUpperYToLowerY() {
        let initialCells: [Coordinate] = [.init(0, 2), .init(0, 3)]
        let snake = Snake(direction: .down, cells: initialCells)
        let wrapped = snake.wrapped(gameSize: 3)
        let expectedCells: [Coordinate] = [.init(0, 2), .init(0, 0)]
        XCTAssertEqual(wrapped, Snake(direction: .down, cells: expectedCells))
    }
    
    func testWrapped_shouldWrapFromLowerYToUpperY() {
        let initialCells: [Coordinate] = [.init(0, 0), .init(0, -1)]
        let snake = Snake(direction: .up, cells: initialCells)
        let wrapped = snake.wrapped(gameSize: 3)
        let expectedCells: [Coordinate] = [.init(0, 0), .init(0, 2)]
        XCTAssertEqual(wrapped, Snake(direction: .up, cells: expectedCells))
    }
    
    func testReverseDirection_givenSnakeFacingUp_returnsDown() {
        let snake = Snake(direction: .up, cells: [.init(0, 0)])
        XCTAssertEqual(snake.reverseDirection, .down)
    }
}
