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

let groupAnswers = batchFile.componentsByGroup
    .map { GroupAnswer(answers: $0.components(separatedBy: .newlines)) }

// Part 1
print(groupAnswers.reduceCount { $0.count1 })

// Part 2
print(groupAnswers.reduceCount { $1.count2 })
