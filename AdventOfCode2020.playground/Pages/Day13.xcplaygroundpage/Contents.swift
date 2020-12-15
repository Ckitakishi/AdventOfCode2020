// Day 13: Shuttle Search
// https://adventofcode.com/2020/day/13

import Foundation

let memo =
"""
939
7,13,x,x,59,x,31,19
"""

struct BusManager {
    let earliestTime: Int
    let busIDs: [Int]
    
    var firstBusID: Int { busIDs.min(by: computeEarliestTime)! }
    var waitingTime: Int { computeRemider(of: firstBusID) }
    
    func computeEarliestTime(busID1: Int, busID2: Int) -> Bool {
        computeRemider(of: busID1) < computeRemider(of: busID2)
    }
    
    func reminderTheorem(allBusIDs: [Int?]) -> Int {
        var validBuses: [Int: Int] = [:]
        
        for (reminder, busID) in allBusIDs.enumerated() {
            if let id = busID {
                validBuses[id] = reminder
            }
        }
        
        var stride = 1
        var timestamp = 0
        var offset = 0
        
        while offset < allBusIDs.count {
            guard let busID = allBusIDs[offset] else {
                offset += 1
                continue
            }
            
            if (timestamp + offset) % busID == 0 {
                stride *= busID
                offset += 1
            } else {
                timestamp += stride
            }
        }
        return timestamp
    }
    
    private func computeRemider(of busID: Int) -> Int {
        Int(earliestTime / busID) * busID + busID - earliestTime
    }
}

let memoInfo = memo.componentsByLine

// Part 1
let busManagaer = BusManager(
    earliestTime: Int(memoInfo[0])!,
    busIDs: memoInfo[1].components(separatedBy: ",").filter { $0 != "x" }.compactMap { Int($0) }
)
print(busManagaer.firstBusID * busManagaer.waitingTime)

// Part 2
print(busManagaer.reminderTheorem(allBusIDs: memoInfo[1].components(separatedBy: ",").map { Int($0) }))
