//
//  Set.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//
import Foundation
class Set {
    
    private var deck = [Card]()
    var activePlayingCards =  [Card?]()
    var selectedCards = [Card]()
    private var winningScore = 5
    var score = 0
    
    
    init() {
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    for l in 1...3 {
                        let card = Card(numberOnCard: i, colourID: j, shapeID: k, shadingID: l)
                        deck += [card]
                    }
                }
            }
        }
        
        for _ in 1...12 {
            let rand_index = deck.count.arc4random
            activePlayingCards += [deck.remove(at: rand_index)]
        }
        for _ in 1...12 {
            activePlayingCards += [nil]
        }
        var temp = activePlayingCards
        for index in activePlayingCards.indices {
            activePlayingCards[index] = temp.remove(at: temp.count.arc4random)
        }
    }
    
    func toggleCard(with index : Int){
        let card = activePlayingCards[index]
        if card != nil {
            if selectedCards.contains(card!){
                selectedCards.remove(at: selectedCards.index(of: card!)!)
            } else {
                selectedCards += [card!]
            }
        }
        if selectedCards.count == 3 {
            checkCardsForMatch()
        }
    }
    
    
    func deal3Cards() {
        var nilIndex = activePlayingCards.indices.filter {activePlayingCards[$0] == nil}
        if nilIndex.count > 0 {
            for _ in 1...3 {
                let rand_index_apc = nilIndex.remove(at: nilIndex.count.arc4random)
                if deck.count > 0 {
                    let subs = deck.remove(at: deck.count.arc4random)
                    activePlayingCards[rand_index_apc] = subs
                }
            }
        }
        if winningScore > 1 {
            winningScore -= 1
        }
    }
    
    private func checkCardsForMatch (){
        let (first, second, third) = (selectedCards[0], selectedCards[1], selectedCards[2])
        let condition =
            Card.compareColourID(first: first, second: second, third: third) &&
            Card.compareNumber(first: first, second: first, third: first) &&
            Card.compareShadingID(first: first, second: second, third: third) &&
            Card.compareColourID(first: first, second: second, third: third)
        
        if condition {
            for card in selectedCards {
                let index = activePlayingCards.index(of: card)!
                if deck.count > 0 {
                    activePlayingCards[index] = deck.remove(at: deck.count.arc4random)
                } else {
                    activePlayingCards[index] = nil
                }
            }
            score += winningScore
        } else {
            score += -3
        }
        selectedCards.removeAll()
    }
}
extension Int {
    var arc4random :Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
