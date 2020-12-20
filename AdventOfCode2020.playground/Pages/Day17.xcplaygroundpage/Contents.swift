// --- Day 17: Conway Cubes ---
// https://adventofcode.com/2020/day/17

let initialInput =
"""
.#.#.#..
..#....#
#####..#
#####..#
#####..#
###..#.#
#..##.##
#.#.####
"""

class CubeTransformer {
    struct Coordinate: Hashable {
        let x: Int
        let y: Int
        let z: Int
        let w: Int
        
        static let zero = Coordinate(x: 0, y: 0, z: 0, w: 0)
        
        static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
            Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w)
        }
    }
    
    let initialLength: Int
    let dimension: Int
    var activePoints: Set<Coordinate> = []
    
    var neighbors: [Coordinate] {
        var coordinates: [Coordinate] = []
        let normalRange = -1...1
        let wRange = dimension == 3 ? 0...0 : -1...1
        
        normalRange.forEach { x in
            normalRange.forEach { y in
                normalRange.forEach { z in
                    wRange.forEach { w in
                        coordinates.append(Coordinate(x: x, y: y, z: z, w: w))
                    }
                }
            }
        }
        coordinates.removeAll(where: { $0 == .zero })
        return coordinates
    }
    
    init(initialInput: String, dimension: Int) {
        let lines = initialInput.componentsByLine
        self.initialLength = lines.count
        self.dimension = dimension
        
        let offset = self.initialLength / 2
        
        lines.enumerated().forEach { y, line in
            line.enumerated().forEach { x, point in
                if point == "#" {
                    activePoints.insert(Coordinate(x: x - offset, y: offset - y, z: 0, w: 0))
                }
            }
        }
    }
    
    func runCycle() {
        let neighborOffsets = neighbors
        for cycle in 0..<6 {
            // 0 => 5, 1 => 7...
            let length = initialLength + (cycle + 1) * 2
            let offset = length / 2
            let range = -offset...offset
            let wRange = dimension == 3 ? 0...0 : range
            var newActivePoints: Set<Coordinate> = []
            
            range.forEach { x in
                range.forEach { y in
                    range.forEach { z in
                        wRange.forEach { w in
                            let currentPoint = Coordinate(x: x, y: y, z: z, w: w)
                            let activeCount = neighborOffsets.reduceCount { neighborOffset in
                                let currentNeightbor = currentPoint + neighborOffset
                                
                                if isActive(point: currentNeightbor) {
                                    return 1
                                }
                                return 0
                            }
                            
                            switch activeCount {
                            case 2 where isActive(point: currentPoint):
                                fallthrough
                            case 3:
                                newActivePoints.insert(currentPoint)
                            default:
                                break
                            }
                        }
                    }
                }
            }
            
            activePoints = newActivePoints
        }
    }
    
    func isActive(point: Coordinate) -> Bool {
        activePoints.contains(point)
    }
}

// Part 1
let cubeTransformer = CubeTransformer(initialInput: initialInput, dimension: 3)
cubeTransformer.runCycle()
print(cubeTransformer.activePoints.count)

// Part 2
let cubeTransformer2 = CubeTransformer(initialInput: initialInput, dimension: 4)
cubeTransformer2.runCycle()
print(cubeTransformer2.activePoints.count)
