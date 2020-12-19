// --- Day 16: Ticket Translation ---
// https://adventofcode.com/2020/day/16

let notes =
"""
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"""

class TicketScanner {
    let tickets: [[Int]]
    let myTicket: [Int]
    var items: [String: [ClosedRange<Int>]] = [:]
    var validTickets: [[Int]] = []
    
    var errorRate: Int {
        let ranges = allRanges
        return tickets.reduceCount { ticket in
            for number in ticket where !ranges.contains(where: { $0.contains(number) }) {
                return number
            }
            return 0
        }
    }

    
    // Assume
    var productOfSixValue: Int {
        scanItems()
        return fieldIndices.reduceMultiply { itemKey, index in
            if itemKey.contains("departure") {
                return myTicket[index]
            }
            return 1
        }
    }
    
    private var fieldIndices: [String: Int] = [:]
    
    private var allRanges: [ClosedRange<Int>] { items.values.flatMap { $0 } }
    
    init(notes: String) {
        let components = notes.componentsByGroup
        
        self.myTicket = components[1]
            .componentsByLine[1]
            .components(separatedBy: ",")
            .compactMap { Int($0) }
        
        self.tickets = components[2]
            .componentsByLine
            .dropFirst()
            .map { $0.components(separatedBy: ",").compactMap { Int($0) } }
        
        components[0].componentsByLine
            .forEach { item in
                let itemInfo = item.components(separatedBy: ": ")
                let ranges = itemInfo[1].components(separatedBy: " or ")
                    .map { range -> ClosedRange<Int> in
                        let bounds = range.components(separatedBy: "-").compactMap { Int($0) }
                        guard bounds.count >= 2 else { fatalError("oops!") }
                        return bounds[0]...bounds[1]
                    }
                self.items[itemInfo[0]] = ranges
            }
        
        self.validTickets = {
            let ranges = allRanges
            return tickets.filter { ticket in
                for number in ticket where !ranges.contains(where: { $0.contains(number) }) {
                    return false
                }
                return true
            }
        }()
    }
    
    private func scanItems() {
        items.forEach { item in
            var validIndices: [Int] = []
            for index in 0..<myTicket.count {
                guard !fieldIndices.values.contains(index) else { continue }
                
                if validTickets.allSatisfy({ ticket in
                    item.value.contains(where: { $0.contains(ticket[index]) })
                }) {
                    validIndices.append(index)
                    if validIndices.count > 1 {
                        break
                    }
                }
            }
            if validIndices.count == 1 {
                fieldIndices[item.key] = validIndices.first!
            }
        }
        
        if fieldIndices.count < myTicket.count {
            scanItems()
        }
    }
}

let ticketScanner = TicketScanner(notes: notes)
// Part 1
print(ticketScanner.errorRate)
// Part 2
print(ticketScanner.productOfSixValue)
