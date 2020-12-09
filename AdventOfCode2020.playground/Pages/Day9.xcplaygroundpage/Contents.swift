// --- Day 9: Encoding Error ---
// https://adventofcode.com/2020/day/9

let numbersList =
"""
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"""

struct ErrorChecker {
    let numbers: [Int]
    let preambleSize: Int
    
    var preambleQueue: [Int] = []
    
    init(numbers: [Int], preambleSize: Int = 5) {
        self.numbers = numbers
        self.preambleSize = preambleSize
        self.preambleQueue = Array(numbers[0..<preambleSize])
    }
    
    mutating func checkInvalid() -> Int {
        func isExists(sum: Int) -> Bool {
            for preamble in preambleQueue {
                if preambleQueue.contains(sum - preamble),
                   sum - preamble != preamble {
                    return true
                }
            }
            return false
        }
        
        for num in numbers[preambleSize...] {
            guard isExists(sum: num) else { return num }
            preambleQueue.append(num)
            preambleQueue.remove(at: 0)
        }
        
        fatalError("not exists")
    }
    
    func searchenWeakness(target: Int) -> Int {
        var contiguousNumbers: [Int] = []
        var sum = 0
        
        for num in numbers {
            contiguousNumbers.append(num)
            sum += num
  
            while sum > target {
                sum -= contiguousNumbers.remove(at: 0)
            }

            if sum == target {
                return contiguousNumbers.min()! + contiguousNumbers.max()!
            }
        }
        
        fatalError("not exists")
    }
}

var errorChecker = ErrorChecker(numbers: numbersList.intArray)

// Part 1
let invalidNumber = errorChecker.checkInvalid()
print(invalidNumber)

// Part 2
print(errorChecker.searchenWeakness(target: invalidNumber))

