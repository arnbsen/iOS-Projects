//
//  Set.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//
import Foundation
import UIKit
class Set {
    
    private var deck = [SetCard]()
    var activePlayingCards =  [SetCard]()
    var selectedCards = [SetCard]()
    private var winningScore = 5
    var score = 0
    
    init() {
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    for l in 1...3 {
                        let card = SetCard(numberOnCard: i, colourID: j, shapeID: k, shadingID: l)
                        deck.append(card)
                    }
                }
            }
        }
        
        for _ in 1...12 {
            let rand_index = deck.count.arc4random
            activePlayingCards += [deck.remove(at: rand_index)]
        }
        
        var temp = activePlayingCards
        for index in activePlayingCards.indices {
            activePlayingCards[index] = temp.remove(at: temp.count.arc4random)
        }
       
    }
    
    func toggleCard(with card : SetCard) -> Bool{
        
        if selectedCards.contains(card){
            selectedCards.remove(at: selectedCards.index(of: card)!)
        } else {
            selectedCards += [card]
        }
        
        if selectedCards.count == 3 {
           return checkCardsForMatch()
        } else {
            return false
        }
    }
    
    func shuffleCards () {
        let count = activePlayingCards.count
        deck.append(contentsOf: activePlayingCards)
        activePlayingCards.removeAll()
        for _ in 1...count {
            let rand_index = deck.count.arc4random
            activePlayingCards += [deck.remove(at: rand_index)]
        }
        
    }
    
    func deal3Cards() {
        if deck.count < 3 {
            for card in deck {
                activePlayingCards.append(card)
            }
        } else {
            for _ in 1...3 {
                let rand_index = deck.count.arc4random
                activePlayingCards.append(deck.remove(at: rand_index))
            }
        }
    }
    
    private func checkCardsForMatch () -> Bool{
        let (first, second, third) = (selectedCards[0], selectedCards[1], selectedCards[2])
        let condition =
            SetCard.compareColourID(first: first, second: second, third: third) &&
            SetCard.compareNumber(first: first, second: first, third: first) &&
            SetCard.compareShadingID(first: first, second: second, third: third) &&
            SetCard.compareColourID(first: first, second: second, third: third)
        
        if condition {
            for card in selectedCards {
                let index = activePlayingCards.index(of: card)!
                if deck.count > 0 {
                    activePlayingCards[index] = deck.remove(at: deck.count.arc4random)
                }
            }
            score += winningScore
        } else {
            score += -3
        }

        selectedCards.removeAll()
        return true
    }
}

