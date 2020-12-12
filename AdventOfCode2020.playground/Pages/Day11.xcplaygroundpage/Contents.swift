// Day 11: Seating System
// https://adventofcode.com/2020/day/11

let seatInput =
"""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""

typealias Offset = (x: Int, y: Int)
typealias Matrix = (row: Int, column: Int)

struct SeatLayout {
    enum State: String {
        case floor = "."
        case empty = "L"
        case occupied = "#"
    }
    
    var seats: [[State]]
    let isOnlyAdjacent: Bool
    let maxAdjacentCount: Int
    let maxCount: Matrix
    
    var occupiedCount: Int {
        seats.flatMap { $0 }.filter { $0 == .occupied }.count
    }
    
    let adjacents: [Offset] = {
        [-1, 0, 1].flatMap { row in
            [-1, 0, 1].compactMap { column in
                if row == 0, column == 0 {
                    return nil
                }
                return (row, column)
            }
        }
    }()
    
    init(seatInput: [[String]], isOnlyAdjacent: Bool, maxAdjacentCount: Int) {
        self.seats = seatInput.map { input in
            input.compactMap { State(rawValue: $0) }
        }
        
        self.maxCount = (seatInput.count, seatInput.first!.count)
        self.isOnlyAdjacent = isOnlyAdjacent
        self.maxAdjacentCount = maxAdjacentCount
    }
    
    mutating func updateSeats() {
        var origianlSeats: [[State]] = []
        
        while origianlSeats != seats {
            origianlSeats = seats
            let transformationStates: [State] = [.occupied, .empty]
            transformationStates.forEach { transform(to: $0) }
        }
    }
    
    private mutating func transform(to state: State) {
        var newSeats: [[State]] = seats
        
        for (row, seatsInRow) in seats.enumerated() {
            for (column, seat) in seatsInRow.enumerated() {
                guard seat != .floor else { continue }
            
                switch state {
                case .occupied where seat != .occupied,
                     .empty where seat == .occupied:
                    if let newState = stateOfSeat(
                        matrix: (row, column),
                        transformState: state
                    ) {
                        newSeats[row][column] = newState
                    }
                default:
                    continue
                }
            }
        }
        
        seats = newSeats
    }
 
    private func stateOfSeat(matrix: Matrix, transformState: State) -> State? {
        let curOccupiedCount = adjacents.reduceCount { offset in
            traverse(
                matrix: matrix,
                offset: offset,
                transformState: transformState
            )
        }
        
        if transformState == .occupied, curOccupiedCount == 0 {
            return .occupied
        } else if transformState == .empty, curOccupiedCount >= maxAdjacentCount {
            return .empty
        }
        return nil
    }
    
    private func traverse(matrix: Matrix, offset: Offset, transformState: State) -> Int {
        if isOnlyAdjacent {
            let curRow = matrix.row + offset.x
            let curColumn = matrix.column + offset.y
            
            guard 0..<maxCount.row ~= curRow, 0..<maxCount.column ~= curColumn else { return 0 }
            
            switch transformState {
            case .occupied, .empty:
                return seats[curRow][curColumn] != .occupied ? 0 : 1
            default:
                fatalError("impossible case")
            }
        } else {
            var curRow = matrix.row + offset.x
            var curColumn = matrix.column + offset.y
            var isOccupied: Bool?
            
            while 0..<maxCount.row ~= curRow, 0..<maxCount.column ~= curColumn, isOccupied == nil {
                switch transformState {
                case .occupied, .empty:
                    if seats[curRow][curColumn] == .occupied {
                        isOccupied = true
                    } else if seats[curRow][curColumn] == .empty {
                        isOccupied = false
                    } else {
                        curRow += offset.x
                        curColumn += offset.y
                    }
                default:
                    fatalError("impossible case")
                }
            }
            
            return isOccupied == true ? 1 : 0
        }
    }
}

// Part 1
var seatLayout = SeatLayout(
    seatInput: seatInput.matrix,
    isOnlyAdjacent: true,
    maxAdjacentCount: 4
)
seatLayout.updateSeats()
print(seatLayout.occupiedCount)

// Part 2
var seatLayout2 = SeatLayout(
    seatInput: seatInput.matrix,
    isOnlyAdjacent: false,
    maxAdjacentCount: 5
)
seatLayout2.updateSeats()
print(seatLayout2.occupiedCount)
