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
    var oneAndOnlyFaceUpCard : Int?
    var flipCount = 0 // Achieved Objective 8
    
    init(noOfPairsOfCards: Int) {
        for id in 1...noOfPairsOfCards {
            let card = Card(identifier: id)
            cards += [card, card]
        }
        // Achieved Objective 4
        var rand_count = Array(1...noOfPairsOfCards) + Array(1...noOfPairsOfCards)
        for index in cards.indices {
            let rand_index = Int(arc4random_uniform(UInt32(UInt(rand_count.count))))
            cards[index].id = rand_count.remove(at: rand_index)
        }
    }
    
    func chooseCard(at index: Int)  {
        if !cards[index].isMatched {
            if let matchIndex = oneAndOnlyFaceUpCard, matchIndex != index {
                if cards[index].id == cards[matchIndex].id {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    flipCount += 2
                } else {
                    flipCount += cards[index].isSeenOnce ? -1 : 0
                    flipCount += cards[matchIndex].isSeenOnce ? -1 : 0
                }
                cards[index].isSeenOnce = true
                cards[matchIndex].isSeenOnce = true
                cards[index].isFaceUp = true
                oneAndOnlyFaceUpCard = nil
            }else{
                for flipCrad in cards.indices {
                    cards[flipCrad].isFaceUp = false
                }
                cards[index].isFaceUp = true
                oneAndOnlyFaceUpCard = index
            }
        }
        
    }
    
    
    
}
