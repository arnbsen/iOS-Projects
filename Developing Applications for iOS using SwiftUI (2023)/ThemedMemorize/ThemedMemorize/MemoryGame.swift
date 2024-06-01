//
//  MemoryGame.swift
//  memorize
//
//  Created by Arnab Sen on 03/03/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private(set) var score: Int
    
    init(numberOfPairOfCards: Int, cardContentFactory: (Int) -> CardContent?) {
        cards = []
        for pairIndex in 0..<numberOfPairOfCards {
            if let cardContent = cardContentFactory(pairIndex) {
                cards.append(Card(content: cardContent, id: "\(pairIndex)a"))
                cards.append(Card(content: cardContent, id: "\(pairIndex)b"))
            }
        }
        cards.shuffle()
        score = 0
    }
    
    var indexOfTheOneAndOnlyFacedUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) }}
    }
    
    mutating func chooseCard(_ card: Card) {
        if let choosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[choosenIndex].isFaceUp && !cards[choosenIndex].isMatched {
                if let potentialMatchedIndex = indexOfTheOneAndOnlyFacedUpCard {
                    if cards[potentialMatchedIndex].content == cards[choosenIndex].content {
                        cards[potentialMatchedIndex].isMatched = true
                        cards[choosenIndex].isMatched = true
                        score += 2
                    } else if cards[choosenIndex].wasPreviouslySeen {
                        score -= 1
                    }
                } else {
                    indexOfTheOneAndOnlyFacedUpCard = nil
                }
                cards[choosenIndex].isFaceUp = true
            }
            cards[choosenIndex].wasPreviouslySeen = true
        }
     }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        
        var isFaceUp = false
        var isMatched = false
        var wasPreviouslySeen = false
        let content: CardContent
        var id: String
        var debugDescription: String {
            "Card {\(id), \(content), \(isFaceUp ? "Faced Up" : "Faced Down"), \(isMatched ? "Matched": "Unmatched")}"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
