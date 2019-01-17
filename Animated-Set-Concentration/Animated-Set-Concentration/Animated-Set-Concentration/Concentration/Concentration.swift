//
//  Concentration.swift
//  Concentration
//
//  Created by Arnab Sen on 31/12/18.
//  Copyright © 2018 Arnab Sen. All rights reserved.
//

import Foundation
class Concetration {
    
    var cards = [Card]()
    var oneAndOnlyFaceUpCard : Int? {
        get {
            // Array implements the protocol Collection therefore extending collections to perform the check
            // the conditions mentioned below
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex : Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    }else{
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    var flipCount = 0 // Achieved Objective 8
    var matchCount = 0
    
    init(noOfPairsOfCards: Int) {
        for _ in 1...noOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // Achieved Objective 4
        var temp_cards = cards
        for index in cards.indices {
            let rand_index = temp_cards.count.arc4random
            cards[index] = temp_cards.remove(at: rand_index)
        }
    }
    
    func chooseCard(at index: Int)  {
        assert(index >= 0, "Choosen index \(index) is negative Concetration.chooseCard")
        if !cards[index].isMatched {
            if let matchIndex = oneAndOnlyFaceUpCard, matchIndex != index {
                if cards[index].id == cards[matchIndex].id {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    flipCount += 2
                    matchCount += 1
                } else {
                    flipCount += cards[index].isSeenOnce ? -1 : 0
                    flipCount += cards[matchIndex].isSeenOnce ? -1 : 0
                }
                cards[index].isSeenOnce = true
                cards[matchIndex].isSeenOnce = true
                cards[index].isFaceUp = true
            }else{
                oneAndOnlyFaceUpCard = index
            }
        }
        
    }
}
extension Int {
    var arc4random : Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
extension Collection {
    var oneAndOnly : Element? {
        return count == 1 ? first : nil
    }
}
