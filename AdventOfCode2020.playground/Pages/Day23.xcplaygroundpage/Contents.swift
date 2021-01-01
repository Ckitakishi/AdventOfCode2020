// --- Day 23: Crab Cups ---
// https://adventofcode.com/2020/day/23

import Foundation

let labels = "942387615"

// Part 1

class Cup {
    let label: Int
    var next: Cup? = nil
    
    init(label: Int) {
        self.label = label
    }
}

class CupLinkedList {
    var currentCup: Cup!
    let allLabels: [Int]
    
    init(labels: [Int]) {
        self.allLabels = labels
        
        var previousCup: Cup?
        var cup: Cup!
        
        labels.forEach { label in
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
    
    private func move(steps: Int) {
        (0..<steps).forEach { _ in
            // 1. Pick up 3 cups
            var nextCup = currentCup
            let pickedUpCups: [Cup] = (0..<3).compactMap { _ in
                nextCup = nextCup?.next
                return nextCup
            }
            
            // 2. Update current cup's next
            currentCup.next = nextCup?.next
            
            // 3. Find the destination label
            let pickedUpLabels = Set(pickedUpCups.map { $0.label })
            var destinationLabel = currentCup.label - 1
            while pickedUpLabels.contains(destinationLabel) || destinationLabel == 0 {
                destinationLabel = destinationLabel - 1
                if destinationLabel < 0 {
                    destinationLabel = allLabels.count
                }
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

let cupLinkedList = CupLinkedList(labels: labels.compactMap { Int("\($0)") })
print(cupLinkedList.simulateMoves1())

// Part 2

class CupList {
    var cups: [Int: Int] = [:]
    let allLabels: [Int]
    let firstLabel: Int
    
    init(labels: [Int], until number: Int) {
        self.allLabels = labels + Array((labels.count + 1)...number)
        self.firstLabel = allLabels.first!
        
        var current = allLabels.first!
        allLabels[1...].forEach { label in
            cups[current] = label
            current = label
        }
        cups[current] = allLabels.first!
    }
    
    func simulateMoves2() -> Int {
        move(steps: 10_000_000)
        let cup1 = cups[1]!
        return cup1 * cups[cup1]!
    }
    
    func move(steps: Int) {
        var currentLabel = firstLabel
        
        (0..<steps).forEach { _ in
            // 1. Pick up 3 cups
            var nextLabel = currentLabel
            let pickedUpLabels: [Int] = (0..<3).compactMap { _ in
                nextLabel = cups[nextLabel]!
                return nextLabel
            }
            
            // 2. Update current cup's next
            // cups[currentLabel] = cups[nextLabel] is very slow..
            let next = cups[nextLabel]!
            cups[currentLabel] = next

            // 3. Find the destination label
//            let leftLabels = labelSet.subtracting(pickedUpLabels)
//            guard let destinationLabel = leftLabels.filter({ $0 < currentLabel }).max()
//                    ?? leftLabels.max() else {
//                fatalError("?")
//            }
            // the above way is very stupid, no need to know the maximum value.
            
            var destinationLabel = currentLabel - 1
            while pickedUpLabels.contains(destinationLabel) || destinationLabel == 0 {
                destinationLabel = destinationLabel - 1
                if destinationLabel < 0 {
                    destinationLabel = allLabels.count
                }
            }

            // 4. Update current cup
            currentLabel = next

            // 5. Insert picked up cups to list
            let destinationNext = cups[destinationLabel]
            cups[pickedUpLabels.last!] = destinationNext
            cups[destinationLabel] = pickedUpLabels.first!
        }
    }
}

// Part 2 - Performance is too bad, need refactoring
let cupLinkedList2 = CupList(labels: labels.compactMap { Int("\($0)") }, until: 1_000_000)
print(cupLinkedList2.simulateMoves2())
