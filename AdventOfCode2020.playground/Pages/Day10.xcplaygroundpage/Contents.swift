// --- Day 10: Adapter Array ---
// https://adventofcode.com/2020/day/10

import Foundation

let adapterList =
"""
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"""

struct AdapterChecker {
    let adapters: [Int]
    
    func countJolt() -> Int {
        let sortedAdapters = adapters.sorted()
        
        var oneJolt = 1
        var threeJolts = 1
        
        zip(sortedAdapters[0...], sortedAdapters[1...]).forEach {
            if $1 - $0 == 3 {
                threeJolts += 1
            } else {
                oneJolt += 1
            }
        }

        return oneJolt * threeJolts
    }
    
    func countArrangement() -> Int {
        let sortedAdapters = adapters.sorted()
        let allAdapters = [0] + sortedAdapters + [sortedAdapters.last! + 3]
        
        var continuousCount = 0
        return zip(allAdapters[0...], allAdapters[1...]).reduceMultiply { first, second in
            if second - first != 1 {
                let validArragements = numberOfPath(continuousCount: continuousCount)
                continuousCount = 0
                return validArragements
            } else {
                continuousCount += 1
                return 1
            }
        }
    }
    
    private func numberOfPath(continuousCount: Int) -> Int {
        let validArragements = pow(2, max(0, continuousCount - 1))
        let pathCount = NSDecimalNumber(decimal: validArragements).intValue
        return continuousCount <= 3 ? pathCount : pathCount - 1
    }
}

let checker = AdapterChecker(adapters: adapterList.intArray)

// Part 1
print(checker.countJolt())

// Part 2
print(checker.countArrangement())
