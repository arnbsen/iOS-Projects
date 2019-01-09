//
//  CardContainerView.swift
//  Graphical-Set
//
//  Created by Arnab Sen on 08/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class CardContainerView: UIView {

   
    override func draw(_ rect: CGRect) {
        self.addSubview(CardView(frame: CGRect(x: 10.0, y: 10.0, width: 200, height: 200), forCard: Card(numberOnCard: 3, colourID: 1, shapeID: 2, shadingID: 3)))
    }
    
    private var game : Set?
    
    
    init(frame : CGRect, game: Set) {
        super.init(frame: frame)
        self.game = game
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
