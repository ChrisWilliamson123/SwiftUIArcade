import XCTest
@testable import SnakeSwiftUI

class DirectionTests: XCTestCase {

    func testAdjustment_givenUp_returnsZeroXMinusOneY() {
        let adjustment = Direction.up.adjustment
        XCTAssertEqual(adjustment.0, 0)
        XCTAssertEqual(adjustment.1, -1)
    }
    
    func testAdjustment_givenRight_returnsOneXZeroY() {
        let adjustment = Direction.right.adjustment
        XCTAssertEqual(adjustment.0, 1)
        XCTAssertEqual(adjustment.1, 0)
    }
    
    func testAdjustment_givenLeft_returnsMinusOneXZeroY() {
        let adjustment = Direction.left.adjustment
        XCTAssertEqual(adjustment.0, -1)
        XCTAssertEqual(adjustment.1, 0)
    }
    
    func testAdjustment_givenDown_returnsZeroXOneY() {
        let adjustment = Direction.down.adjustment
        XCTAssertEqual(adjustment.0, 0)
        XCTAssertEqual(adjustment.1, 1)
    }
    
    func testReverseDirection_givenUp_returnsDown() {
        XCTAssertEqual(Direction.up.reverseDirection, .down)
    }
    
    func testReverseDirection_givenDown_returnsUp() {
        XCTAssertEqual(Direction.down.reverseDirection, .up)
    }
    
    func testReverseDirection_givenLeft_returnsRight() {
        XCTAssertEqual(Direction.left.reverseDirection, .right)
    }
    
    func testReverseDirection_givenRight_returnsLeft() {
        XCTAssertEqual(Direction.right.reverseDirection, .left)
    }
    
    func testSnakeHeadRotation_givenUp_returns270() {
        XCTAssertEqual(Direction.up.snakeHeadRotation, 270)
    }
    
    func testSnakeHeadRotation_givenRight_returns0() {
        XCTAssertEqual(Direction.right.snakeHeadRotation, 0)
    }
    
    func testSnakeHeadRotation_givenLeft_returns270() {
        XCTAssertEqual(Direction.left.snakeHeadRotation, 180)
    }
    
    func testSnakeHeadRotation_givenDown_returns90() {
        XCTAssertEqual(Direction.down.snakeHeadRotation, 90)
    }
}
