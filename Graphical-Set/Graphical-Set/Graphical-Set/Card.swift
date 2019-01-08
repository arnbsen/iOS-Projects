//
//  Card.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//
struct Card : Equatable {
    
    var numberOnCard : Int
    var colourID : Int
    var shapeID : Int
    var shadingID : Int
    
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        let numberCondition = lhs.numberOnCard == rhs.numberOnCard
        let colourCondition = lhs.colourID == rhs.colourID
        let shapeCondition = lhs.shapeID == rhs.shapeID
        let shadingCondition = lhs.shadingID == rhs.shadingID
        return numberCondition && colourCondition && shapeCondition && shadingCondition
    }
    
    init(numberOnCard : Int, colourID: Int, shapeID : Int, shadingID : Int) {
        self.numberOnCard = numberOnCard
        self.colourID = colourID
        self.shadingID = shadingID
        self.shapeID = shapeID
    }
    
    static func compareShapeID(first: Card, second: Card, third: Card) -> Bool {
        let condition1 = first.shapeID == second.shapeID && second.shapeID == third.shapeID && first.shapeID == third.shapeID
        let condition2 = first.shapeID != second.shapeID && second.shapeID != third.shapeID && first.shapeID != third.shapeID
        return condition1 || condition2
    }
    
    static func compareNumber(first: Card, second: Card, third: Card) -> Bool {
        let condition1 = first.numberOnCard == second.numberOnCard && second.numberOnCard == third.numberOnCard && first.numberOnCard == third.numberOnCard
        let condition2 = first.numberOnCard != second.numberOnCard && second.numberOnCard != third.numberOnCard && first.numberOnCard != third.numberOnCard
        return condition1 || condition2
    }
    
    static func compareShadingID(first: Card, second: Card, third: Card) -> Bool {
        let condition1 = first.shadingID == second.shadingID && second.shadingID == third.shadingID && first.shadingID == third.shadingID
        let condition2 = first.shadingID != second.shadingID && second.shadingID != third.shadingID && first.shadingID != third.shadingID
        return condition1 || condition2
    }
    
    static func compareColourID(first: Card, second: Card, third: Card) -> Bool {
        let condition1 = first.colourID == second.colourID && second.colourID == third.colourID && first.colourID == third.colourID
        let condition2 = first.colourID != second.colourID && second.colourID != third.colourID && first.colourID != third.colourID
        return condition1 || condition2
    }
}

