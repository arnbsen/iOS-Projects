//
//  Card.swift
//  Concentration
//
//  Created by Arnab Sen on 31/12/18.
//  Copyright © 2018 Arnab Sen. All rights reserved.
//

struct Card {
    var isFaceUp = false
    var isSeenOnce = false
    var isMatched = false
    var id : Int
    
    init(identifier: Int) {
        self.id = identifier
    }
    
}
