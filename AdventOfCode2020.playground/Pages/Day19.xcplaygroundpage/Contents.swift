// --- Day 19: Monster Messages ---
// https://adventofcode.com/2020/day/19

import Foundation

let input =
"""
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
"""

struct MessageChecker {
    var baseRules: String = ""
    var messages: [String] = []
    
    var completelyMatchCount: Int {
        let pattern = "^\(makeRule(by: baseRules))$"
        
        return messages.reduceCount { message in
            if message.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil {
                return 1
            }
            return 0
        }
    }
    
    var matchCount: Int {
        let rule42 = "^(\(makeRule(by: baseRules, firstRule: "42")))+"
        let rule31 = "(\(makeRule(by: baseRules, firstRule: "31")))+$"
        
        let regex42 = try! NSRegularExpression(pattern: "^(\(rule42))+")
        let regex31 = try! NSRegularExpression(pattern: "(\(rule31))+$")
        
        let pattern = rule42 + rule31
        
        return messages.reduceCount { message in
            if message.range(of: pattern, options: .regularExpression) != nil,
               regex31.matchedLength(of: message) < regex42.matchedLength(of: message) {
                return 1
            }
            return 0
        }
    }
    
    init(baseRules: String, messageList: String) {
        self.baseRules = baseRules
        self.messages = messageList.componentsByLine
    }
    
    func makeRuleDic(by baseRules: String) -> [String: String] {
        var rulesDic: [String: String] = [:]
        baseRules.componentsByLine.forEach { baseRule in
            let ruleComponents = baseRule.components(separatedBy: ": ")
            rulesDic[ruleComponents[0]] = ruleComponents[1].replacingOccurrences(of: "\"", with: "")
        }
        return rulesDic
    }
    
    func makeRule(by baseRules: String, firstRule: String = "0") -> String {
        let rulesDic = makeRuleDic(by: baseRules)
        var currentRule = rulesDic[firstRule] ?? ""
        while currentRule.rangeOfCharacter(from: .decimalDigits) != nil {
            let newRules: [String] = currentRule.components(separatedBy: .whitespaces)
                .compactMap { component in
                    if ["|", "(", ")"].contains(component) {
                        return component
                    } else {
                        // return letter
                        guard let rule = rulesDic[component] else { return component }
                        // return rule
                        if rule.contains("|") {
                            return "( " + rule + " )"
                        } else {
                            return rule
                        }
                    }
                }
            currentRule = newRules.joined(separator: " ")
        }
        
        return currentRule.replacingOccurrences(of: " ", with: "")
    }
}

extension NSRegularExpression {
    fileprivate func matchedLength(of string: String) -> Int {
        // > Use the utf16 count to avoid problems with emoji and similar.
        rangeOfFirstMatch(
            in: string,
            range: NSRange(location: 0, length: string.utf16.count)
        ).length
    }
}

let inputLines = input.componentsByGroup

// Part 1
let messageChecker = MessageChecker(baseRules: inputLines[0], messageList: inputLines[1])
print(messageChecker.completelyMatchCount)

// Part 2
// 8 - 42 | 42 42 | 42 42 42 => (42)+
// 11 - 42 31 | 42 42 31 31 => (42+31)+
// 42 * n + 31 * (n - m)
let messageChecker2 = MessageChecker(
    baseRules: inputLines[0],
    messageList: inputLines[1]
)
print(messageChecker2.matchCount)
