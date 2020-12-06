// --- Day 5: Binary Boarding ---
// https://adventofcode.com/2020/day/5

let passesList =
"""
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
"""

// FBFBBFF => 0101100 => 44
// RLR => 101 => 5
struct Pass {
    let rowCodes = ["F": "0", "B": "1"]
    let columnCodes = ["L": "0", "R": "1"]
    
    let fullPass: String
    
    var rowPart: String { String(fullPass.prefix(7)) }
    var columnPart: String { String(fullPass.suffix(3)) }
    
    var seatID: Int {
        let binaryCodes: [String] = zip(
            [rowCodes, columnCodes],
            [rowPart, columnPart]
        ).map { codes, pass in
            var processPass = pass
            codes.forEach { key, value in
                processPass = processPass.replacingOccurrences(of: key, with: value)
            }
            return processPass
        }
        
        return binaryCodes[0].decimalValue * 8 + binaryCodes[1].decimalValue
    }
}

struct MissingChecker {
    let ids: [Int]
    var minID: Int { ids.min(by: <) ?? 0 }
    
    var missingNumber: Int {
        for id in (minID...) where !ids.contains(id) {
            return id
        }
        return 0
    }
}

extension String {
    fileprivate var decimalValue: Int {
        Int(self, radix: 2) ?? 0
    }
}

let passes = passesList.componentsByLine.map { Pass(fullPass: $0) }

// Part 1
print(passes.max { $1.seatID > $0.seatID }!.seatID)

// Part 2
let checker = MissingChecker(ids: passes.map(\.seatID))
print(checker.missingNumber)

