// --- Day 7: Handy Haversacks ---
// https://adventofcode.com/2020/day/7

let rules =
"""
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""

let extraWords = [" contain ", ", ", " bags", " bag"]

struct Bag {
    struct Content {
        let color: String
        let count: Int
        
        init?(rule: String) {
            let numericPrefix = rule.prefix(while: { "0"..."9" ~= $0 })
            
            guard !numericPrefix.isEmpty,
                  let number = Int("\(numericPrefix)") else { return nil }
            
            self.color = rule.components(separatedBy: "\(numericPrefix) ").last!
            self.count = number
        }
    }
    
    let color: String
    let contents: [Content]
    
    init(rule: String) {
        let bagRule = rule.components(separatedBy: extraWords[0])
        self.color = bagRule[0]
        
        let contentsRule = bagRule[1].components(separatedBy: extraWords[1])
        self.contents = contentsRule.compactMap { Content(rule: $0) }
    }
}

struct BagManager {
    let bags: [Bag]
    
    var validBagColors: Set<String> = []
    mutating func countBags(color: String = "shiny gold") {
        bags.filter { $0.contents.contains(where: { $0.color == color }) }
            .forEach {
                if !validBagColors.contains($0.color) {
                    validBagColors.insert($0.color)
                    countBags(color: $0.color)
                }
            }
    }
    
    func countInsideBags(color: String = "shiny gold") -> Int {
        guard let bag = bags.first(where: { $0.color == color }),
              !bag.contents.isEmpty
        else { return 0 }

        return bag.contents.reduceCount { $0.count + $0.count * countInsideBags(color: $0.color) }
    }
}

let bags = rules.componentsByLine
    .map { rule in
        var processedRules = rule
        extraWords[2...].forEach { processedRules = processedRules.replacingOccurrences(of: $0, with: "") }
        return String(processedRules.dropLast())
    }
    .map { Bag(rule: $0) }

var bagManager = BagManager(bags: bags)

// Part 1
bagManager.countBags()
print(bagManager.validBagColors.count)

// Part 2
print(bagManager.countInsideBags())
