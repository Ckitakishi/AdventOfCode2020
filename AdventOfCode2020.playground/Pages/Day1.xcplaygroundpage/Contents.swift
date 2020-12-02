// --- Day 1: Report Repair ---
// https://adventofcode.com/2020/day/1

let expensesString =
"""
1721
979
366
299
675
1456
"""

class Report {
    let expenses: [Int]
    let sum: Int

    var checkedExpenses: Set<Int> = []

    init(expenses: [Int] = expensesString.intArray, sum: Int = 2020) {
        self.expenses = expenses
        self.sum = sum
    }

    func findTwoEntries() -> [Int] {
        for expense in expenses {
            let expectation = sum - expense

            guard checkedExpenses.contains(expectation) else {
                checkedExpenses.insert(expense)
                continue
            }

            return [expense, expectation]
        }
        return []
    }

    func findThreeEntries() -> [Int] {
        for expense in expenses {
            let tempReport = Report(
                expenses: Array(expenses.dropFirst()),
                sum: sum - expense
            )

            let twoEntries = tempReport.findTwoEntries()

            if !twoEntries.isEmpty {
                return twoEntries + [expense]
            }
        }
        return []
    }
}

extension Array where Element == Int {
    func multiply() -> Int {
        self.reduce(1, *)
    }
}

// Part 1
print(Report().findTwoEntries().multiply())

// Part 2
print(Report().findThreeEntries().multiply())

