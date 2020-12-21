// --- Day 18: Operation Order ---
// https://adventofcode.com/2020/day/18

let expressionInput =
"""
1 + (2 * 3) + (4 * (5 + 6))
"""

struct BatchEvaluation {
    
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

    func batchEvaluate(expressions: String) -> Int {
        expressions.componentsByLine.reduceCount { evaluate(expression: $0) }
    }
    
    func evaluate(expression: String) -> Int {
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
                stack.append("\(simpleEvaluate(stack: tempStack))")
            default:
                stack.append(exp)
            }
        }
        
        return simpleEvaluate(stack: stack)
    }
    
    func simpleEvaluate(stack: [String]) -> Int {
        var preNum = Int("\(stack[0])")!
        var op: Operator?
        stack[1...].forEach { exp in
            if op == nil, let curOp = Operator(rawValue: String(exp)) {
                op = curOp
            } else if let curOp = op {
                preNum = curOp.use(on: preNum, and: Int("\(exp)")!)
                op = nil
            }
        }
        return preNum
    }
}

let batchEvaluation = BatchEvaluation()
print(batchEvaluation.batchEvaluate(expressions: expressionInput))
