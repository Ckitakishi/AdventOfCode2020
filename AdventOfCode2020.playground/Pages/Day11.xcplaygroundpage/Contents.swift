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

struct SeatLayout {
    enum State: String {
        case floor = "."
        case empty = "L"
        case occupied = "#"
    }
    
    var seats: [[State]]
    let maxCount: (row: Int, column: Int)
    
    var occupiedCount: Int {
        seats.flatMap { $0 }.filter { $0 == .occupied }.count
    }
    
    var adjacents: [(Int, Int)] {
        [-1, 0, 1].flatMap { row in
            [-1, 0, 1].compactMap { column in
                if row == 0, column == 0 {
                    return nil
                }
                return (row, column)
            }
        }
    }
    
    init(seatInput: [[String]]) {
        self.seats = seatInput.map { input in
            input.compactMap { State(rawValue: $0) }
        }
        
        self.maxCount = (seatInput.count, seatInput.first!.count)
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
                    if let newState = stateOfSeat(row: row, column: column, transformState: state) {
                        newSeats[row][column] = newState
                    }
                default:
                    continue
                }
            }
        }
        
        seats = newSeats
    }
 
    private func stateOfSeat(row: Int, column: Int, transformState: State) -> State? {
        let curOccupiedCount = adjacents.reduceCount { offsetX, offsetY in
            let curRow = row + offsetX
            let curColumn = column + offsetY
            
            guard 0..<maxCount.row ~= curRow, 0..<maxCount.column ~= curColumn else { return 0 }
            
            switch transformState {
            case .occupied, .empty:
                return seats[curRow][curColumn] != .occupied ? 0 : 1
            default:
                return 0
            }
        }
        
        if transformState == .occupied, curOccupiedCount == 0 {
            return .occupied
        } else if transformState == .empty, curOccupiedCount >= 4 {
            return .empty
        }
        return nil
    }
}


var seatLayout = SeatLayout(seatInput: seatInput.matrix)
seatLayout.updateSeats()
print(seatLayout.occupiedCount)
