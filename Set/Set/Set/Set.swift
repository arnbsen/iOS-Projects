//
//  Set.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

class Set {
    
    private var deck = [Card]()
    var activePlayingCards =  [Card]()
    
    
    var score = 0
    private var selectedCards : Int {
        get {
            let count = activePlayingCards.indices.filter {activePlayingCards[$0].isSelected}
            return count.count
        }
    }
    
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
        
        for _ in 1...24 {
            let rand_index = deck.count.arc4random
            activePlayingCards += [deck.remove(at: rand_index)]
        }
    }
    
    func toggleCard(at index: Int)  {
        activePlayingCards[index].isSelected = !activePlayingCards[index].isSelected
        if selectedCards == 3 {
            checkCardForMatch()
        }
    }
    
    
    func deal3Cards(){
        var invisible = activePlayingCards.indices.filter { !activePlayingCards[$0].isVisible }
        if invisible.count > 3 {
            for _ in 1...3 {
                let rand_index = invisible.remove(at: invisible.count.arc4random)
               activePlayingCards[rand_index].isVisible = true
            }
        } else {
            for index in invisible {
                activePlayingCards[index].isVisible = true
            }
        }
    }
    
    private func checkCardForMatch () {
        let selected = activePlayingCards.indices.filter {activePlayingCards[$0].isSelected}
        var isSet = true
        if selected.count == 3 {
            isSet = isSet && activePlayingCards[selected.first!] == activePlayingCards[selected.last!]
            isSet = isSet && activePlayingCards[selected.first!+1] == activePlayingCards[selected.last!]
            isSet = isSet && activePlayingCards[selected.first!+1] == activePlayingCards[selected.first!]
        }
        if isSet {
            for index in selected {
                activePlayingCards[index] = deck.remove(at: deck.count.arc4random)
                activePlayingCards[index].isSelected = false
                activePlayingCards[index].isVisible = true
                score += 5
            }
        }else{
            score += -3
        }
    }
    
}

