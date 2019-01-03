//
//  Card.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//
struct Card : Hashable {
    
    private var numberOnCard : Int
    private var colourID : Int
    private var shapeID : Int
    private var shadingID : Int
    var isMatched : Bool = false
    var isSelected : Bool = false
    
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        let numberCondition = (lhs.numberOnCard == rhs.numberOnCard) || (lhs.numberOnCard != rhs.numberOnCard)
        let colourCondition = (lhs.colourID == rhs.colourID) || (lhs.colourID != rhs.colourID)
        let shapeCondition = (lhs.shapeID == rhs.shapeID) || (lhs.shapeID != rhs.shapeID)
        let shadingCondition = (lhs.shadingID == rhs.shadingID) || (lhs.shadingID != rhs.shadingID)
        return numberCondition && colourCondition && shapeCondition && shadingCondition
    }
    
    init(numberOnCard : Int, colourID: Int, shapeID : Int, shadingID : Int) {
        self.numberOnCard = numberOnCard
        self.colourID = colourID
        self.shadingID = shadingID
        self.shapeID = shapeID
    }
}

