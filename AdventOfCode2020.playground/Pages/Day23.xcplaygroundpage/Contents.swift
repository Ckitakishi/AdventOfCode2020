// --- Day 23: Crab Cups ---
// https://adventofcode.com/2020/day/23

import Foundation

let labels = "389125467"

class Cup {
    let label: Int
    var next: Cup? = nil
    
    init(label: Int) {
        self.label = label
    }
}

class CupLinkedList {
    var currentCup: Cup!
    let allLabels: Set<Int>
    
    init(labels: [Int], until number: Int? = nil) {
        var allLabels = labels
        if let number = number {
            allLabels = labels + Array(labels.count...number)
        }
        
        self.allLabels = Set(allLabels)
        
        var previousCup: Cup?
        var cup: Cup!
        
        allLabels.forEach { label in
            cup = Cup(label: label)
            
            if let previousCup = previousCup {
                previousCup.next = cup
            } else {
                self.currentCup = cup
            }
            
            previousCup = cup
        }
        
        cup.next = self.currentCup
    }
    
    func simulateMoves1() -> String {
        move(steps: 100)
        
        var nextCup = currentCup
        let labels: [Int] = (0..<allLabels.count)
            .compactMap { _ in
                nextCup = nextCup?.next
                return nextCup?.label
            }
        
        let components = labels
            .map { String($0) }
            .joined()
            .components(separatedBy: "1")
        
        return components[1] + components[0]
    }
    
    func simulateMoves2() -> Int {
        move(steps: 10_000_000)
        
        var firstCup: Cup?
        var curCup = currentCup
        while firstCup == nil {
            if curCup?.label == 1 {
                firstCup = curCup
            } else {
                curCup = curCup?.next
            }
        }
        
        return firstCup!.next!.label * firstCup!.next!.next!.label
    }
    
    private func move(steps: Int) {
        (0..<steps).enumerated().forEach { index, _ in
            // 1. Pick up 3 cups
            var nextCup = currentCup
            let pickedUpCups: [Cup] = (0..<3).compactMap { _ in
                nextCup = nextCup?.next
                return nextCup
            }
            
            // 2. Update current cup's next
            currentCup.next = nextCup?.next
            
            // 3. Find the destination label
            let pickedUpLables = Set(pickedUpCups.map { $0.label })
            let leftLabels = allLabels.subtracting(pickedUpLables)
            guard let destinationLabel = leftLabels.filter({ $0 < currentCup.label }).max()
                    ?? leftLabels.max() else {
                fatalError("?")
            }
            
            // 4. Find the destination cup
            var destinationCup: Cup?
            var curCup = currentCup
            while destinationCup == nil {
                if curCup?.label == destinationLabel {
                    destinationCup = curCup
                } else {
                    curCup = curCup?.next
                }
            }
            
            // 5. Update current cup
            currentCup = currentCup.next
            
            // 6. Insert picked up cups to list
            pickedUpCups.last?.next = destinationCup?.next
            destinationCup?.next = pickedUpCups.first
        }
    }
}

// Part 1
let cupLinkedList = CupLinkedList(labels: labels.compactMap { Int("\($0)") })
print(cupLinkedList.simulateMoves1())

// Part 2 - Performance is too bad, need refactoring
let cupLinkedList2 = CupLinkedList(labels: labels.compactMap { Int("\($0)") }, until: 1_000_000)
print(cupLinkedList2.simulateMoves2())
