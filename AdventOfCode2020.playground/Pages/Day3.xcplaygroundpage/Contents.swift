// --- Day 3: Toboggan Trajectory ---
// https://adventofcode.com/2020/day/3

let initialMap =
"""
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""

let steps = [
    (1, 1),
    (3, 1),
    (5, 1),
    (7, 1),
    (1, 2)
]

struct Map {
    let mapByLine: [String]
    let horizontalCount: Int
    
    init(_ mapByLine: [String]) {
        self.mapByLine = mapByLine
        self.horizontalCount = mapByLine.first?.count ?? 0
    }
    
    func traverse(step: (right: Int, bottom: Int)) -> Int {
        var treesCount = 0
        
        for (index, line) in mapByLine.enumerated() {
            guard index > 0,
                  index % step.bottom == 0
            else { continue }
            
            if line.hasTree(at: (index * step.right) / step.bottom % horizontalCount) {
                treesCount += 1
            }
        }
        return treesCount
    }
}

// MARK: - extension for tree position
extension String {
    fileprivate func hasTree(at index: Int) -> Bool {
        let strIndex = self.index(
            self.startIndex,
            offsetBy: index
        )
        return self[strIndex] == "#"
    }
}

let map = Map(initialMap.componentsByLine)

// Part 1
print(map.traverse(step: steps[1]))

// Part 2
print(steps.reduce(1) { $0 * map.traverse(step: $1) })
