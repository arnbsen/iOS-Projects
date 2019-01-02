//
//  Card.swift
//  Concentration
//
//  Created by Arnab Sen on 31/12/18.
//  Copyright © 2018 Arnab Sen. All rights reserved.
//

struct Card : Hashable {
    var isFaceUp = false
    var isSeenOnce = false
    var isMatched = false
    private(set) var id : Int
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }

    
    private static var identifierGetter = 0
    
    private static func identifierFactory() -> Int {
        Card.identifierGetter += 1
        return Card.identifierGetter
    }
    
    init() {
        self.id = Card.identifierFactory()
    }
    
}
