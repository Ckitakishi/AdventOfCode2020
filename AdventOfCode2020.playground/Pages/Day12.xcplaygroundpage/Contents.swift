// --- Day 12: Rain Risk ---
// https://adventofcode.com/2020/day/12

let instructionStrings =
"""
F10
N3
F7
R90
F11
"""

// Need refactoring
struct Instruction {
    enum Direction: String {
        // Direction
        case north = "N"
        case south = "S"
        case east = "E"
        case west = "W"
        case forward = "F"
        // Rotation
        case left = "L"
        case right = "R"
    
        var isVertical: Bool { self == .north || self == .south }
        var isHorizontal: Bool { self == .east || self == .west  }
        var shouldRotate: Bool { self == .left || self == .right }
        
        func rotate(to direction: Direction, relativeRotation: Int) -> Direction {
            // Assume the rotation angle will not exceed 360
            let directionsCount = Instruction.directions.count
            let curIndex = Instruction.directions.firstIndex(of: self) ?? 0
            
            let newIndex: Int = {
                switch direction {
                case .left:
                    let index = curIndex - relativeRotation
                    guard index >= 0 else { return index + directionsCount }
                    return index
                case .right:
                    let index = curIndex + relativeRotation
                    guard index < directionsCount else { return index - directionsCount }
                    return index
                default:
                    fatalError("cannot reach here")
                }
            }()
            
            return Instruction.directions[newIndex]
        }
    }
    
    static let directions: [Direction] = [.north, .east, .south, .west]
    
    let direction: Direction
    var distance: Int
    
    var relativeDistance: Int {
        if direction == .south || direction == .west {
            return -distance
        }
        return distance
    }
    
    var relativeRotation: Int { distance / 90 }
    
    init(instr: String) {
        self.direction = Direction(rawValue: String(instr.first!)) ?? .east
        let fromIndex = instr.index(instr.startIndex, offsetBy: 1)
        self.distance = Int(instr[fromIndex...]) ?? 0
    }
    
    init(direction: Direction, distance: Int) {
        self.direction = direction
        self.distance = distance
    }
    
    static func * (instr: Instruction, multiple: Int) -> Instruction {
        return Instruction(direction: instr.direction, distance: instr.distance * multiple)
    }
}

struct Position {
    let h: Int // east
    let v: Int // north
    
    static let zero = Position(h: 0, v: 0)
    
    var manhattanDistance: Int { abs(h) + abs(v) }
    
    func navigate(with instr: Instruction) -> Position {
        if instr.direction.isVertical {
            return Position(h: h, v: self.v + instr.relativeDistance)
        } else {
            return Position(h: self.h + instr.relativeDistance, v: v)
        }
    }
    
    func move(instruction: Instruction, curDirection: Instruction.Direction?) -> Position {
        self.navigate(
            with: instruction.direction == .forward ?
                Instruction(direction: curDirection!, distance: instruction.distance) :
                instruction
        )
    }
}

class FerryNavigator {
    var curDirection: Instruction.Direction = .east
    var curPosition: Position = .zero
    
    let instructions: [Instruction]
    
    init(instructions: [Instruction]) {
        self.instructions = instructions
    }
    
    func start() {
        instructions.forEach {
            if $0.direction.shouldRotate {
                curDirection = curDirection.rotate(to: $0.direction, relativeRotation: $0.relativeRotation)
            } else {
                curPosition = curPosition.move(instruction: $0, curDirection: curDirection)
            }
        }
    }
    
    // Part 2
    var curWaypoint = AbsolutePosition(
        h: Instruction(direction: .east, distance: 10),
        v: Instruction(direction: .north, distance: 1)
    )
    
    func start2() {
        instructions.forEach { instruction in
            switch instruction.direction {
            case .north, .east, .south, .west:
                curWaypoint = curWaypoint.move(instruction: instruction)
            case .left, .right:
                curWaypoint = curWaypoint.rotateWaypoint(
                    to: instruction.direction,
                    relativeRotation: instruction.relativeRotation
                )
            case .forward:
                curWaypoint.allInstructions.forEach {
                    curPosition = curPosition.move(
                        instruction: $0 * instruction.distance,
                        curDirection: nil
                    )
                }
            }
        }
    }
}

struct AbsolutePosition {
    let h: Instruction
    let v: Instruction
    
    var allInstructions: [Instruction] { [v, h] }
    
    func rotateWaypoint(to direction: Instruction.Direction, relativeRotation: Int) -> AbsolutePosition {
        let newHInstruction = Instruction(
            direction: h.direction.rotate(to: direction, relativeRotation: relativeRotation),
            distance: h.distance
        )
        let newVInstruction = Instruction(
            direction: v.direction.rotate(to: direction, relativeRotation: relativeRotation),
            distance: v.distance
        )
        
        if relativeRotation % 2 == 0 {
            return AbsolutePosition(h: newHInstruction, v: newVInstruction)
        } else {
            return AbsolutePosition(h: newVInstruction, v: newHInstruction)
        }
    }
    
    func move(instruction: Instruction) -> AbsolutePosition {
        var curV = v.direction == .north ? v.distance : -v.distance
        var curH = h.direction == .east ? h.distance : -h.distance
        
        switch instruction.direction {
        case .north, .south:
            curV += instruction.relativeDistance
        case .east, .west:
            curH += instruction.relativeDistance
        default:
            fatalError("cannot reach here")
        }

        return AbsolutePosition(
            h: Instruction(direction: curH > 0 ? .east : .west, distance: abs(curH)),
            v: Instruction(direction: curV > 0 ? .north : .south, distance: abs(curV))
        )
    }
}

// Part 1
let navigator = FerryNavigator(instructions: instructionStrings.componentsByLine.map { Instruction(instr: $0) })
navigator.start()
print(navigator.curPosition.manhattanDistance)

// Part 2
let navigator2 = FerryNavigator(instructions: instructionStrings.componentsByLine.map { Instruction(instr: $0) })
navigator2.start2()
print(navigator2.curPosition.manhattanDistance)
