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
        for view in subviews {
            view.removeFromSuperview()
        }
        var (nrows, ncols) = getRowAndColumns()
        let rowSpacing = rect.height.getCoordinateWith(ratio: 0.005)
        let colSpacing = rect.width.getCoordinateWith(ratio: 0.005)
        
        if rect.width < rect.height {
            (nrows, ncols) = nrows > ncols ? (nrows, ncols) : (ncols, nrows)
        } else {
            (nrows, ncols) = nrows > ncols ? (ncols, nrows) : (nrows, ncols)
        }
        
        let optimumHeight = (rect.height - CGFloat(nrows - 1) * rowSpacing) / CGFloat(nrows)
        let optimunWidth = (rect.width - CGFloat(ncols - 1) * colSpacing) / CGFloat(ncols)
        var (X, Y) = (CGPoint.zero.x + colSpacing, CGPoint.zero.y + rowSpacing)
        var cardIterator = 0
        for _ in 0..<nrows {
            X = CGPoint.zero.x
            for _ in 0..<ncols{
                let cardDimensions = CGRect(x: CGFloat(X), y: CGFloat(Y), width: optimunWidth, height: optimumHeight)
                let cardView = CardView(frame: cardDimensions, forCard: activePlayingCards[cardIterator], controller: controller! )
                let tapGuesture = UITapGestureRecognizer()
                tapGuesture.addTarget(cardView, action: #selector(cardView.handleTapEvent))
                addSubview(cardView)
                cardView.addGestureRecognizer(tapGuesture)
                X += colSpacing + optimunWidth
                cardIterator += 1
            }
            Y += rowSpacing + optimumHeight
        }
       
    }
    
    private func getRowAndColumns() -> (Int, Int){
        assert(activePlayingCards.count >= 3, "Card Count not Expected")
        // 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, ...
        var numRows = 0
        var numCols = 0
        for divisor in 3...9 {
            numRows = activePlayingCards.count % divisor == 0 ? divisor : numRows
        }
        numCols = activePlayingCards.count / numRows
        return (numRows, numCols)
    }
    
    
    var activePlayingCards = [Card]()
    var game : Set?
    var controller : ViewController?
    
}

