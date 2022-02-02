import UIKit

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
