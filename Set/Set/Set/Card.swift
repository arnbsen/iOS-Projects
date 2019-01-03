//
//  Card.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//
struct Card : Hashable {
    
    var numberOnCard : Int
    var colourID : Int
    var shapeID : Int
    var shadingID : Int
    var isSelected : Bool = false
    var isVisible : Bool = false
    
    
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

