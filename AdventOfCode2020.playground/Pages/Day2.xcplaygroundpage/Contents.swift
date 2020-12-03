// --- Day 2: Password Philosophy ---
// https://adventofcode.com/2020/day/2

let list =
"""
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""

struct PasswordRecord {
    struct Policy {
        let letter: Character
        let countRange: ClosedRange<Int>
        
        init(letterString: String, rangeString: String) {
            self.letter = letterString.first ?? Character("")
            
            let ranges: [Int] = rangeString
                .components(separatedBy: "-")
                .compactMap { Int($0) }
            self.countRange = ranges[0]...ranges[1]
        }
    }
    
    let password: String
    let policy: Policy
    
    init(recordString: String) {
        let components = recordString.components(separatedBy: .whitespaces)
        
        self.password = components[2]
        self.policy = Policy(
            letterString: components[1],
            rangeString: components[0]
        )
    }
}

extension PasswordRecord {
    var isValid: Bool {
        let count = password.reduce(0) { $1 == policy.letter ? $0 + 1 : $0 }
        return policy.countRange.contains(count)
    }
    
    var isValid2: Bool {
        // Assume all indices are valid
        let passwordLetters = Array(password)
        
        let letters: [Character] = [
            passwordLetters[policy.countRange.lowerBound - 1],
            passwordLetters[policy.countRange.upperBound - 1]
        ]
        
        guard letters.first != letters.last else { return false }
        
        return letters.contains(policy.letter)
    }
}

let records = list.componentsByLine.map { PasswordRecord(recordString: $0) }

// Part 1
print(records.filter { $0.isValid }.count)

// Part 2
print(records.filter { $0.isValid2 }.count)

