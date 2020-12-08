// --- Day 8: Handheld Halting ---
// https://adventofcode.com/2020/day/8

let instructionList =
"""
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""

struct Instruction {
    enum Operation: String {
        case nop, acc, jmp
    }
    
    var operation: Operation
    let argument: Int
    
    init(_ instruction: String) {
        let instructionSet = instruction.components(separatedBy: .whitespaces)
        
        guard let operation = Operation(rawValue: instructionSet[0]),
              let arg = Int(instructionSet[1])
        else {
            self.operation = .nop
            self.argument = 0
            return
        }
        
        self.operation = operation
        self.argument = arg
    }
    
    mutating func updateOperation(_ op: Operation) {
        self.operation = op
    }
}

struct ProgramChecker {
    let instructions: [Instruction]
    let totalCount: Int
    
    var fixedInstructions: [Instruction] = []
    var processedIndex: Set<Int> = []
    var hasTerminated = false
    
    init(_ instructions: [Instruction]) {
        self.instructions = instructions
        self.totalCount = instructions.count
    }
    
    mutating func run(instrs: [Instruction], from index: Int = 0) -> Int {
        var accumulatorValue = 0
    
        for i in index..<totalCount {
            guard !processedIndex.contains(i) else { return accumulatorValue }
            
            processedIndex.insert(i)
            let arg = instrs[i].argument

            switch instrs[i].operation {
            case .acc:
                accumulatorValue += arg
            case .jmp:
                return accumulatorValue + run(instrs: instrs, from: i + arg)
            case .nop:
                continue
            }
        }
        
        hasTerminated = true
        return accumulatorValue
    }
    
    mutating func fix(from index: Int = 0) -> Int {
        func reset() {
            processedIndex = []
            hasTerminated = false
            fixedInstructions = instructions
        }
        
        for (index, instruction) in instructions.enumerated() {
            var accumulatorValue = 0
            
            switch instruction.operation {
            case .jmp:
                fixedInstructions[index].updateOperation(.nop)
                accumulatorValue = run(instrs: fixedInstructions)
            case .nop:
                fixedInstructions[index].updateOperation(.jmp)
                accumulatorValue = run(instrs: fixedInstructions)
            case .acc:
                continue
            }
                    
            if hasTerminated {
                return accumulatorValue
            }
        }
        
        return 0
    }
}


let instructions = instructionList.componentsByLine.map { Instruction($0) }
var checker = ProgramChecker(instructions)

// Part 1
print(checker.run(instrs: instructions))

// Part 2
print(checker.fix())
