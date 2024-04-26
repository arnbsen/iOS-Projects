//
//  SetGame.swift
//  Set
//
//  Created by Arnab Sen on 20/04/24.
//

import Foundation

struct SetGame {
    
    private static func generateAllCards() -> [SetCard] {
        var cards = [SetCard]()
        for numberOnCard in 1...3 {
            for cardType in SetCard.ShapeType.allCases {
                for cardFillType in SetCard.ColorFillType.allCases {
                    for cardColor in SetCard.Color.allCases {
                        cards.append(
                            SetCard(number: numberOnCard, shapeType: cardType, fillType: cardFillType, color: cardColor)
                        )
                    }
                }
            }
        }
        return cards.shuffled()
    }
    
    private(set) var cardsActiveInTheGame: [SetCard]
    private(set) var cardsNotIntheGame: [SetCard]
    private(set) var score = 0
    
    private var matchedCardsIndices: [Int] {
        cardsActiveInTheGame.indices.filter( { cardsActiveInTheGame[$0].matched } )
    }
    
    private var selectedCardsIndices: [Int] {
        cardsActiveInTheGame.indices.filter({ cardsActiveInTheGame[$0].selected })
    }
 
    init() {
        let allCards = SetGame.generateAllCards()
        cardsActiveInTheGame = allCards.prefix(upTo: 12).shuffled()
        cardsNotIntheGame = allCards.suffix(from: 12).shuffled()
    }
    
    mutating func deal3Cards() {
        var replaceCards = false
        if areSelectedCardsAMatch() && matchedCardsIndices.count == 3 {
            replaceCards = true
        }
        if (cardsNotIntheGame.count >= 3) {
            var cardsToAdd = cardsNotIntheGame.prefix(upTo: 3).shuffled()
            if (replaceCards) {
                matchedCardsIndices.forEach {
                    cardsActiveInTheGame[$0] = cardsToAdd.remove(at: 0)
                }
            } else {
                cardsActiveInTheGame += cardsToAdd
            }
        }
        cardsActiveInTheGame.removeAll(where: { $0.matched })
        if (!cardsNotIntheGame.isEmpty) {
            cardsNotIntheGame = cardsNotIntheGame.suffix(from: 3).shuffled()
        }
    }
    
    mutating func selectCard(_ card: SetCard) {
        if (card.isPartOfSet) {
            return
        }
        if let cardIndex = cardsActiveInTheGame.firstIndex(of: card) {
            if cardsActiveInTheGame[cardIndex].selected {
                cardsActiveInTheGame[cardIndex].selected = false
            } else {
                selectCard(card, cardIndex)
            }
        }
    }
    
    private mutating func selectCard(_ card: SetCard, _ index: Int) {
        if selectedCardsIndices.count == 3 {
            if (areSelectedCardsAMatch()) {
                deal3Cards()
            } else {
                selectedCardsIndices.forEach { index in
                    if (!cardsActiveInTheGame[index].matched) {
                        cardsActiveInTheGame[index].matched = false
                        cardsActiveInTheGame[index].isPartOfSet = false
                        cardsActiveInTheGame[index].selected = false
                    }
                }
            }
        }
        if let reevaluatedSelectedIndex = cardsActiveInTheGame.firstIndex(of: card) {
            cardsActiveInTheGame[reevaluatedSelectedIndex].selected = true
        }
        if (selectedCardsIndices.count == 3) {
            let areSelectedCardsAMatch = areSelectedCardsAMatch()
            selectedCardsIndices.forEach {
                cardsActiveInTheGame[$0].isPartOfSet = true
                cardsActiveInTheGame[$0].matched = areSelectedCardsAMatch
                cardsActiveInTheGame[$0].isPartOfSet = true
            }
            if (areSelectedCardsAMatch) {
                score += 3
            } else {
                score -= 1
            }
        }
    }
    
    private func areSelectedCardsAMatch() -> Bool {
        let selectedCards = cardsActiveInTheGame.filter({ $0.selected })
        if selectedCards.count < 3 {
            return false
        }
        let numbersCondition = evaluateSetCondition(selectedCards.map { $0.number })
        let colorsCondition = evaluateSetCondition(selectedCards.map { $0.color })
        let fillTypesCondition = evaluateSetCondition(selectedCards.map { $0.fillType })
        let shapeTypesCondition = evaluateSetCondition(selectedCards.map { $0.shapeType })
        return numbersCondition && colorsCondition && fillTypesCondition && shapeTypesCondition
    }
    
    private func evaluateSetCondition(_ values: [some Equatable]) -> Bool {
        // Works because for all card elements conforms to Equatable protocol
        if values.count < 3 {
            return false
        }
        let allAreAMatch = values[0] == values[1] && values[1] == values[2] && values[0] == values[2]
        let allAreNotAMatch = values[0] != values[1] && values[1] != values[2] && values[0] != values[2]
        return allAreAMatch || allAreNotAMatch
    }
}
