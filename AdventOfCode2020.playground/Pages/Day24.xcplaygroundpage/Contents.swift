// --- Day 24: Lobby Layout ---
// https://adventofcode.com/2020/day/24

let input =
"""
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
"""

struct Coordinator: Hashable {
    let x: Int
    let y: Int
    
    static let zero = Coordinator(0, 0)
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    static func + (lhs: Coordinator, rhs: Coordinator) -> Coordinator {
        Coordinator(lhs.x + rhs.x, lhs.y + rhs.y)
    }
}

enum Direction: String, CaseIterable {
    case e = "1"
    case se = "2"
    case sw = "3"
    case w = "4"
    case nw = "5"
    case ne = "6"
     
    var offset: Coordinator {
        switch self {
        case .e:
            return Coordinator(2, 0)
        case .ne:
            return Coordinator(1, 1)
        case .nw:
            return Coordinator(-1, 1)
        case .w:
            return Coordinator(-2, 0)
        case .sw:
            return Coordinator(-1, -1)
        case .se:
            return Coordinator(1, -1)
        }
    }
}

class TileLayout {
    typealias Step = [Direction]
    
    var blackTilesCount: Int { blackTileCoordinators.count }
    
    private var steps: [Step] = []
    private var blackTileCoordinators: Set<Coordinator> = []
    
    private let preprocessOrder: [(String, Direction)] = [
        ("ne", .ne),
        ("nw", .nw),
        ("sw", .sw),
        ("se", .se),
        ("e", .e),
        ( "w", .w)
    ]
    
    init(stepsString: [String]) {
        self.steps = stepsString.map { steps in
            var currentSteps = steps
            preprocessOrder.forEach { str, direction in
                currentSteps = currentSteps.replacingOccurrences(of: str, with: direction.rawValue)
            }
            return currentSteps.compactMap {
                Direction(rawValue: "\($0)")
            }
        }
    }
    
    func updateLayout() {
        steps.forEach { step in
            let position: Coordinator = step.reduce(.zero) { currentPosition, direction in
                return currentPosition + direction.offset
            }
            if blackTileCoordinators.contains(position) {
                blackTileCoordinators.remove(position)
            } else {
                blackTileCoordinators.insert(position)
            }
        }
    }
    
    func flippingTiles(daysCount: Int = 100) {
        (0..<100).forEach { _ in
            let allX = blackTileCoordinators.map { $0.x }
            let allY = blackTileCoordinators.map { $0.y }
            
            let xRange = (allX.min()! - 2)...(allX.max()! + 2)
            let yRange = (allY.min()! - 1)...(allY.max()! + 1)
            
            var newBlackTileCoordinators: Set<Coordinator> = []
            
            xRange.forEach { x in
                yRange.forEach { y in
                    let currentPosition = Coordinator(x, y)
                    if shouldBeBlack(currentPosition) {
                        newBlackTileCoordinators.insert(currentPosition)
                    }
                }
            }
            
            blackTileCoordinators = newBlackTileCoordinators
        }
    }
    
    private func shouldBeBlack(_ position: Coordinator) -> Bool {
        let allOffsets = Direction.allCases.map { $0.offset }
        let blackTilesCount = allOffsets.reduceCount { offset in
            blackTileCoordinators.contains(position + offset) ? 1 : 0
        }
        
        if blackTileCoordinators.contains(position) {
            // black
            return (1...2).contains(blackTilesCount)
        } else {
            // white
            return blackTilesCount == 2
        }
    }
}

let tileLayout = TileLayout(stepsString: input.componentsByLine)

// Part 1
tileLayout.updateLayout()
print(tileLayout.blackTilesCount)

// Part 2
tileLayout.flippingTiles()
print(tileLayout.blackTilesCount)

