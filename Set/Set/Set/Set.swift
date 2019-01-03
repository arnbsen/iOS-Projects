//
//  Set.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

class Set {
    
    var cards = [Card]()
    var score  = 0
    var selectedCards = 0 {
        didSet {
            if selectedCards == 3 {
                checkCardForMatch()
            }
        }
    }
    
    init() {
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    for l in 1...3 {
                        let card = Card(numberOnCard: i, colourID: j, shapeID: k, shadingID: l)
                        cards += [card]
                    }
                }
            }
        }
        var temp_cards = cards
        for index in cards.indices {
            let rand_index = temp_cards.count.arc4random
            cards[index] = temp_cards.remove(at: rand_index)
        }
    }
    
    
    
    
    func checkCardForMatch () {
        let selected = cards.indices.filter {cards[$0].isSelected}
        var isSet = true
        if selected.count == 3 {
            isSet = isSet && cards[selected.first!] == cards[selected.last!]
            isSet = isSet && cards[selected.first!+1] == cards[selected.last!]
            isSet = isSet && cards[selected.first!+1] == cards[selected.first!]
        }
        
    }
    
}
