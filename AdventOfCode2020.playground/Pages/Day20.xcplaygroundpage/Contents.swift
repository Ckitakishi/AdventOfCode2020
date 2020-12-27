// --- Day 20: Jurassic Jigsaw ---
// https://adventofcode.com/2020/day/20

let input =
"""
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
"""

struct Tile {
    let id: Int
    let borders: [String]
    
    init(tileGraph: String) {
        var borderLines = tileGraph.componentsByLine
        let tileID = borderLines.removeFirst()
            .replacingOccurrences(of: ":", with: "")
            .components(separatedBy: " ")[1]
        self.id = Int(tileID)!
        
        var borders = [borderLines[0], borderLines[borderLines.count - 1]]
        borders.append(String(borderLines.compactMap { $0.first }))
        borders.append(String(borderLines.compactMap { $0.last }))
        
        let curBorders = borders
        curBorders.forEach {
            borders.append(String($0.reversed()))
        }

        self.borders = borders
    }
}

class TileAssembler {
    let tiles: [Tile]
    
    init(tiles: [Tile]) {
        self.tiles = tiles
    }
    
    var productOfCorners: Int { cornerTiles.reduceMultiply { $0.id } }
    
    var cornerTiles: [Tile] {
        tiles.enumerated().compactMap { index, tile in
            var otherTiles = tiles
            otherTiles.remove(at: index)
            
            let matchedBorderCount = tile.borders.reduceCount { border in
                if otherTiles.contains(where: { $0.borders.contains(border) }) {
                    return 1
                }
                return 0
            }
        
            return matchedBorderCount / 2 > 2 ? nil : tile
        }
    }
}

let tiles = input.componentsByGroup.map { Tile(tileGraph: $0) }
let tileAssembler = TileAssembler(tiles: tiles)
print(tileAssembler.productOfCorners)
