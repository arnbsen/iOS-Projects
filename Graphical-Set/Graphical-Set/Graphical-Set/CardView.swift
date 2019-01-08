//
//  CardView.swift
//  Graphical-Set
//
//  Created by Arnab Sen on 08/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class CardView: UIView {

   
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0)
        path.addClip()
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        path.fill()
        drawShape()
    }
    
    private var card : Card?
    private var tapGuestureRecogniser : UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, forCard : Card) {
        super.init(frame: frame)
        self.card = forCard
        self.tapGuestureRecogniser.addTarget(self, action: #selector(handleTapEvent))
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    @objc private func handleTapEvent() {
        // Check for Card present in selected List
    }
    
    private func drawShape(){
        let (startX, startY) = (bounds.maxX.computeCardX, bounds.maxY.computeCardY)
        let arrangement = [[0, 1, 0], [1, 0, 1],  [1, 1, 1]]
        func drawDiamonds () {
            
            var (cursorX, cursorY) = (startX, startY)
            let (width, height) = (bounds.maxX.computeMaxX, bounds.maxY.computeMaxY)
            let presentSelectionOfNumber = arrangement[card!.numberOnCard - 1]
            
            for row in presentSelectionOfNumber {
                if row == 1 {
                    
                    let pathLocal = UIBezierPath()
                    let boundsLocal = CGRect(x: cursorX, y: cursorY, width: width, height: height.getCoordinateWith(ratio: 0.2))
                    pathLocal.move(to: CGPoint(x: boundsLocal.midX, y: boundsLocal.minY))
                    pathLocal.addLine(to: CGPoint(x: boundsLocal.maxX, y: boundsLocal.midY))
                    pathLocal.addLine(to: CGPoint(x: boundsLocal.midX, y: boundsLocal.maxY))
                    pathLocal.addLine(to: CGPoint(x: boundsLocal.minX, y: boundsLocal.midY))
                    pathLocal.close()
                    #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1).setStroke()
                    #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1).setFill()
                    pathLocal.stroke()
                    pathLocal.fill()
                }
                cursorY += height.getCoordinateWith(ratio: 0.35)
            }
        }
        
        func drawSqiggles () {
            
        }
        func drawOvals () {
            
        }
        
        drawDiamonds()
    }
    
    
}
    

extension CGFloat {
    var computeCardX: CGFloat {
        return self * 0.15
    }
    var computeCardY : CGFloat {
        return self * 0.15
    }
    var computeMaxX : CGFloat {
        return self * 0.7
    }
    var computeMaxY : CGFloat {
        return self * 0.7
    }
    var midPoint : CGFloat {
        return self / 2.0
    }
    func getCoordinateWith(ratio of: CGFloat) -> CGFloat {
        return self * of
    }
}
