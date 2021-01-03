// --- Day 25: Combo Breaker ---
// https://adventofcode.com/2020/day/25

import Foundation

let input =
"""
10212254
12577395
"""

struct EncryptionManager {
    let card: Int
    let door: Int
    
    let initialSubject = 7
    let fixedNum = 20201227
    
    init(input: [String]) {
        self.card = Int(input[0])!
        self.door = Int(input[1])!
    }
    
    func calculateEncryptionKey() -> Int {
        let cardLoopSize = calculateLoopSize(publicKey: card)
//        let doorLoopSize = calculateLoopSize(publicKey: door)

        var value = 1
        (0..<cardLoopSize).forEach { _ in
            value = (value * door) % fixedNum
        }
        
        return value
    }
    
    private func calculateLoopSize(publicKey: Int) -> Int {
        var value = 1
        var loopSize = 0
        
        while value != publicKey {
            value = (value * initialSubject) % fixedNum
            loopSize += 1
        }
        
        return loopSize
    }
}

let encryptionManager = EncryptionManager(input: input.componentsByLine)
print(encryptionManager.calculateEncryptionKey())
