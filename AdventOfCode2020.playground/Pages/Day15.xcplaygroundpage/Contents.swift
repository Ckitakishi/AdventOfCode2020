// --- Day 15: Rambunctious Recitation ---
// https://adventofcode.com/2020/day/15

let input = "0,3,6"

struct MemoryGame {
    enum Status {
        case first
        case existing(turn: Int)
    }
    
    let startingNumbers: [Int]
    var numbersDic: [Int: Int] = [:]
    
    init(startingNumbers: [Int]) {
        self.startingNumbers = startingNumbers
        startingNumbers.enumerated().forEach { self.numbersDic[$1] = $0 }
    }
    
    mutating func number(at index: Int) -> Int {
        var previousStatus: Status = .first
        var currentNum = 0
        for turn in startingNumbers.count..<2020 {
            switch previousStatus {
            case .first:
                currentNum = 0
            case .existing(let turnDiff):
                currentNum = turnDiff
            }
            
            if let lastTurn = numbersDic[currentNum] {
                previousStatus = .existing(turn: turn - lastTurn)
            } else {
                previousStatus = .first
            }
            numbersDic[currentNum] = turn
        }
        return currentNum
    }
}

// Part 1
var game1 = MemoryGame(startingNumbers: input.components(separatedBy: ",").compactMap { Int($0) })
print(game1.number(at: 2020))

// Part 2
var game2 = MemoryGame(startingNumbers: input.components(separatedBy: ",").compactMap { Int($0) })
print(game2.number(at: 30_000_000))
