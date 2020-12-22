// --- Day 18: Operation Order ---
// https://adventofcode.com/2020/day/18

let expressionInput =
"""
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
"""

struct BatchEvaluation {
    
    enum Priority {
        case orderFirst
        case addFirst
    }
    
    enum Operator: String {
        case add = "+"
        case multiply = "*"
        
        func use(on num1: Int, and num2: Int) -> Int {
            switch self {
            case .add:
                return num1 + num2
            case .multiply:
                return num1 * num2
            }
        }
    }

    func batchEvaluate(expressions: String, priority: Priority) -> Int {
        expressions.componentsByLine.reduceCount { evaluate(expression: $0, priority: priority) }
    }
    
    private func evaluate(expression: String, priority: Priority) -> Int {
        var stack: [String] = []
        var curExpression = expression
        curExpression = curExpression.replacingOccurrences(of: "(", with: "( ")
            .replacingOccurrences(of: ")", with: " )")
        curExpression.components(separatedBy: " ").forEach { exp in
            switch exp {
            case ")":
                guard let lastOpenParenthesis = stack.lastIndex(of: "(") else { fatalError("oops!") }
                let tempStack = Array(stack[(lastOpenParenthesis + 1)...])
                stack.removeLast(stack.count - lastOpenParenthesis)
                
                if priority == .orderFirst {
                    stack.append("\(orderFirstEvaluate(stack: tempStack))")
                } else {
                    stack.append("\(addFirstEvaluate(stack: tempStack))")
                }
            default:
                stack.append(exp)
            }
        }
        
        return priority == .orderFirst ? orderFirstEvaluate(stack: stack) : addFirstEvaluate(stack: stack)
    }
    
    private func orderFirstEvaluate(stack: [String]) -> Int {
        var preNum = Int(stack[0])!
        var op: Operator?
        stack[1...].forEach { exp in
            if op == nil, let curOp = Operator(rawValue: String(exp)) {
                op = curOp
            } else if let curOp = op {
                preNum = curOp.use(on: preNum, and: Int(exp)!)
                op = nil
            }
        }
        return preNum
    }
    
    private func addFirstEvaluate(stack: [String]) -> Int {
        var preNum = Int(stack[0])
        var op: Operator?
        var multiplyOnlyStack: [Int] = []
        
        stack[1...].forEach { exp in
            if op == nil, let curOp = Operator(rawValue: String(exp)) {
                switch curOp {
                case .add:
                    op = curOp
                case .multiply:
                    multiplyOnlyStack.append(preNum!)
                    op = nil
                    preNum = nil
                }
            } else if let curOp = op {
                preNum = curOp.use(on: preNum!, and: Int(exp)!)
                op = nil
            } else {
                preNum = Int(exp)
            }
        }
        multiplyOnlyStack.append(preNum!)
        
        return multiplyOnlyStack.reduce(1, *)
    }
}

let batchEvaluation = BatchEvaluation()

// Part 1
print(batchEvaluation.batchEvaluate(expressions: expressionInput, priority: .orderFirst))

// Part 2
print(batchEvaluation.batchEvaluate(expressions: expressionInput, priority: .addFirst))
