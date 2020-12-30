// --- Day 22: Crab Combat ---
// https://adventofcode.com/2020/day/22

let input =
"""
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
"""

class Game {
    enum Player {
        case player1
        case player2
    }
    
    var player1Deck: [Int]
    var player2Deck: [Int]
    
    init(player1Data: String, player2Data: String) {
        func initDeck(by data: String) -> [Int] {
            let cards = data.componentsByLine.dropFirst()
            return cards.compactMap { Int($0) }
        }
        self.player1Deck = initDeck(by: player1Data)
        self.player2Deck = initDeck(by: player2Data)
    }
    
    var maxPoint: Int {
        let winnerDeck = player1Deck.isEmpty ? player2Deck : player1Deck
        return winnerDeck.reversed().enumerated().reduceCount { ($0 + 1) * $1 }
    }
    
    func start() {
        while [player1Deck, player2Deck].allSatisfy({ !$0.isEmpty }) {
            let card1 = player1Deck.removeFirst()
            let card2 = player2Deck.removeFirst()
            
            if card1 > card2 {
                player1Deck.append(contentsOf: [card1, card2])
            } else {
                player2Deck.append(contentsOf: [card2, card1])
            }
        }
    }
    
    func start2(deck1: [Int]?, deck2: [Int]?) -> Player {
        var curDeck1 = deck1 ?? player1Deck
        var curDeck2 = deck2 ?? player2Deck
        
        var winner: Player = .player1
        var playedDecks: Set<[[Int]]> = []

        while [curDeck1, curDeck2].allSatisfy({ !$0.isEmpty }) {
            let curDecks = [curDeck1, curDeck2]
            
            // if there was a previous round in **this game** that had exactly the same cards.
            guard !playedDecks.contains(curDecks) else {
                return .player1
            }
            
            playedDecks.insert(curDecks)
            
            let card1 = curDeck1.removeFirst()
            let card2 = curDeck2.removeFirst()
            
            let deck1Count = curDeck1.count
            let deck2Count = curDeck2.count
            
            if card1 <= deck1Count, card2 <= deck2Count {
                winner = start2(
                    deck1: Array(curDeck1[..<card1]),
                    deck2: Array(curDeck2[..<card2])
                )
            } else {
                winner = card1 > card2 ? .player1 : .player2
            }
            
            if winner == .player1 {
                curDeck1.append(contentsOf: [card1, card2])
            } else {
                curDeck2.append(contentsOf: [card2, card1])
            }
        }
        
        player1Deck = curDeck1
        player2Deck = curDeck2
        
        return winner
    }
}

let gameData = input.componentsByGroup

// Part 1
let game1 = Game(player1Data: gameData[0], player2Data: gameData[1])
game1.start()
print(game1.maxPoint)

// Part 2
let game2 = Game(player1Data: gameData[0], player2Data: gameData[1])
_ = game2.start2(deck1: nil, deck2: nil)
print(game2.maxPoint)
