// --- Day 6: Custom Customs ---
// https://adventofcode.com/2020/day/6

let batchFile =
"""
abc

a
b
c

ab
ac

a
a
a
a

b
"""

class GroupAnswer {
    let answers: [String]
    var answerSet: Set<Character> = []
    
    init(answers: [String]) {
        self.answers = answers
    }
    
    var count1: Int {
        answers
            .flatMap { $0 }
            .forEach { answerSet.insert($0) }
        return answerSet.count
    }
    
    var count2: Int {
        answerSet = Set(answers.first ?? "")
        answers.forEach { answerSet.formIntersection(Set($0)) }
        return answerSet.count
    }
}

let groupAnswers = batchFile
    .components(separatedBy: "\n\n")
    .map { GroupAnswer(answers: $0.components(separatedBy: .newlines)) }

// Part 1
print(groupAnswers.reduce(0) { $0 + $1.count1 })

// Part 2
print(groupAnswers.reduce(0) { $0 + $1.count2 })
