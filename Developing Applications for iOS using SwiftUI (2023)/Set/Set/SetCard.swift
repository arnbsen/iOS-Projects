//
//  SetCard.swift
//  Set
//
//  Created by Arnab Sen on 05/04/24.
//

import Foundation

struct SetCard: Equatable, Identifiable {
    
    let number: Int
    let shapeType: ShapeType
    let fillType: ColorFillType
    let color: Color
    let id: String
    
    var selected: Bool
    var matched: Bool
    var isPartOfSet: Bool

    // Data only representation of shape that needs to be drawn
    enum ShapeType: String, CaseIterable {
        case DIAMOND
        case SQUIGGLE
        case ROUNDED_RECTRANGLE
    }

    // Data only respesentation of Color Fill Type
    enum ColorFillType: String, CaseIterable {
        case SOLID
        case STRIPPED
        case NONE
    }
    
    enum Color: String, CaseIterable {
        case RED
        case GREEN
        case BLUE
    }
    
    init(number: Int, shapeType: ShapeType, fillType: ColorFillType, color: Color) {
        self.number = number
        self.shapeType = shapeType
        self.fillType = fillType
        self.color = color
        self.id = "\(number):\(shapeType):\(fillType):\(color)"
        
        self.selected = false
        self.matched = false
        self.isPartOfSet = false
    }    
}
