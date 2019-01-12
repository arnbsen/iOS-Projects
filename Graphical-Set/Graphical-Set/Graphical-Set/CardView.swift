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
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: rect.width.getCoordinateWith(ratio: 0.10))
        path.addClip()
        drawingColour.setFill()
        path.fill()
        drawShape()
    }
    
    private var card : Card?
    private var tapGuestureRecogniser : UITapGestureRecognizer = UITapGestureRecognizer()
    
    private var drawingColour = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, forCard : Card) {
        super.init(frame: frame)
        card = forCard
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        tapGuestureRecogniser.addTarget(self, action: #selector(handleTapEvent(sender:)))
        addGestureRecognizer(tapGuestureRecogniser)
        
    }
    
    @objc private func handleTapEvent(sender: UITapGestureRecognizer) {
       if sender.state == .ended {
            if drawingColour == #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
                drawingColour = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else {
                drawingColour = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            setNeedsDisplay()
       }
    }
    
    private func drawShape(){
        let (startX, startY) = (bounds.maxX.computeCardX, bounds.maxY.computeCardY)
        let arrangement = [[0, 1, 0], [1, 0, 1],  [1, 1, 1]]
        let colourArray = [#colorLiteral(red: 0.8274509804, green: 0.3294117647, blue: 0, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.768627451, blue: 0.05882352941, alpha: 1), #colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 0.7254901961, alpha: 1)]
        
        let presentSelectionOfNumber = arrangement[card!.numberOnCard - 1]
        let presetSelectionOfColour = colourArray[card!.colourID - 1]
        let presentSelectionOfShading = card!.shadingID
        let presentSelectionOfShape = card!.shapeID
        
        func drawDiamonds () {
            
            var (cursorX, cursorY) = (startX, startY)
            let (width, height) = (bounds.maxX.computeMaxX, bounds.maxY.computeMaxY)
            
            for row in presentSelectionOfNumber {
                if row == 1 {
                    let pathLocal = UIBezierPath()
                    let boundsLocal = CGRect(x: cursorX, y: cursorY, width: width, height: height.getCoordinateWith(ratio: 0.2))
                    pathLocal.move(to: CGPoint(x: boundsLocal.midX, y: boundsLocal.minY))
                    pathLocal.addLine(to: CGPoint(x: boundsLocal.maxX, y: boundsLocal.midY))
                    pathLocal.addLine(to: CGPoint(x: boundsLocal.midX, y: boundsLocal.maxY))
                    pathLocal.addLine(to: CGPoint(x: boundsLocal.minX, y: boundsLocal.midY))
                    pathLocal.close()
                    fillShade(with: pathLocal)
                    
                }
                cursorY += height.getCoordinateWith(ratio: 0.35)
            }
        }
        
        func drawSqiggles () {
            
            var (cursorX, cursorY) = (startX, startY)
            let (width, height) = (bounds.maxX.computeMaxX, bounds.maxY.computeMaxY)
            
    
            for row in presentSelectionOfNumber {
                
                if row == 1 {
                    let pathLocal = UIBezierPath()
                    let boundsLocal = CGRect(x: cursorX, y: cursorY, width: width, height: height.getCoordinateWith(ratio: 0.2))
                    pathLocal.move(to: CGPoint(x: boundsLocal.origin.x , y: boundsLocal.origin.y))
                    pathLocal.addQuadCurve(to: CGPoint(x: boundsLocal.midX, y: boundsLocal.minY), controlPoint: CGPoint(x: boundsLocal.minX + boundsLocal.maxX / 4.0, y: boundsLocal.minY - boundsLocal.height))
                    pathLocal.addQuadCurve(to: CGPoint(x: boundsLocal.maxX, y: boundsLocal.minY), controlPoint: CGPoint(x: boundsLocal.maxX - boundsLocal.maxX / 4.0, y: boundsLocal.minY + boundsLocal.height))
                    pathLocal.addArc(withCenter: CGPoint(x: boundsLocal.maxX, y: boundsLocal.midY), radius: boundsLocal.height / 2.0 , startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
                    pathLocal.addQuadCurve(to: CGPoint(x: boundsLocal.midX, y: boundsLocal.maxY), controlPoint: CGPoint(x: boundsLocal.maxX - boundsLocal.maxX / 4.0, y: boundsLocal.minY + 2.0 * boundsLocal.height))
                    pathLocal.addQuadCurve(to: CGPoint(x: boundsLocal.minX, y: boundsLocal.maxY), controlPoint: CGPoint(x: boundsLocal.minX + boundsLocal.maxX / 4.0, y: boundsLocal.minY))
                    pathLocal.addArc(withCenter: CGPoint(x: boundsLocal.minX, y: boundsLocal.midY), radius: boundsLocal.height / 2.0 , startAngle: CGFloat.pi/2, endAngle: CGFloat.pi + CGFloat.pi / 2.0 , clockwise: true)
                    pathLocal.close()
                   fillShade(with: pathLocal)
                    
                }
                
                cursorY += height.getCoordinateWith(ratio: 0.4)
            }
        }
        func drawOvals () {
            var (topX, topY) = (bounds.origin.x + bounds.width / 2.0, bounds.height.getCoordinateWith(ratio: 0.1))
            
            for row in presentSelectionOfNumber {
                if row == 1 {
                    let pathLocal = UIBezierPath()
                    let boundsLocal = CGRect(x: topX, y: topY + bounds.height.getCoordinateWith(ratio: 0.1), width: bounds.width / 2.0 , height: bounds.height.getCoordinateWith(ratio: 0.2))
                    pathLocal.move(to: CGPoint(x: bounds.midX, y: topY))
                    pathLocal.removeAllPoints()
                    pathLocal.addArc(withCenter: CGPoint(x: bounds.midX, y: topY + boundsLocal.height / 2.0), radius: boundsLocal.height / 2.0, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
                    pathLocal.close()
                  fillShade(with: pathLocal)
                }
                topY += bounds.height.getCoordinateWith(ratio: 0.25)
            }
        }
        
        func fillShade(with path: UIBezierPath) {
            let context = UIGraphicsGetCurrentContext()
            switch presentSelectionOfShading {
                case 1:
                    presetSelectionOfColour.setStroke()
                    path.stroke()
                case 2:
                    presetSelectionOfColour.set()
                    path.fill()
                    path.stroke()
                case 3:
                    context?.saveGState()
                    presetSelectionOfColour.set()
                    let pathBounds = path.bounds
                    for multiplier in 1...3 {
                        path.move(to: CGPoint(x: pathBounds.origin.x, y: pathBounds.origin.y + CGFloat(multiplier) * pathBounds.size.height / 4.0))
                        path.addLine(to: CGPoint(x: pathBounds.maxX, y:pathBounds.origin.y + CGFloat(multiplier) * pathBounds.size.height / 4.0))
                    }
                    path.addClip()
                    path.lineWidth = pathBounds.size.height.getCoordinateWith(ratio: 0.08)
                    path.stroke()
                    context?.restoreGState()
                default:
                    break
            }
        }
        
        switch presentSelectionOfShape {
            case 1:
                drawDiamonds()
            case 2:
                drawSqiggles()
            case 3:
                drawOvals()
            default:
                break
        }
        
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
