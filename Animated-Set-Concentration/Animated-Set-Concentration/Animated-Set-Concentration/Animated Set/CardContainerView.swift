//
//  CardContainerView.swift
//  Graphical-Set
//
//  Created by Arnab Sen on 08/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class CardContainerView: UIView {
    
    lazy var animator = UIDynamicAnimator(referenceView: self.superview!)
    
    private var activePlayingCardsView = [CardView]()
    var controller : SetViewController?
    var activePlayingCards = [SetCard]()
    private var initFrame : CGRect?
    private var deal3CardsBound : CGPoint?
    private var selectedCards = [CardView]()
    private var lastFrame : CGRect?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        for view in subviews {
            if let stv = view as? UIStackView {
                bringSubviewToFront(view)
                deal3CardsBound = CGPoint(x: stv.frame.minX, y: stv.frame.minY - stv.frame.minY.getCoordinateWith(ratio: 0.025))
                initFrame = CGRect(origin: CGPoint(x: stv.frame.minX, y: stv.frame.minY), size: (stv.subviews.first?.frame.size)!)
                lastFrame = CGRect(origin: CGPoint(x: (stv.subviews.last?.frame.minX)! + stv.frame.minX, y: (stv.subviews.last?.frame.minY)!+stv.frame.minY) , size: (stv.subviews.last?.frame.size)!)
            }
        }
        
        var (nrows, ncols) = getRowAndColumns()
        let rowSpacing = deal3CardsBound!.y.getCoordinateWith(ratio: 0.005)
        let colSpacing = rect.width.getCoordinateWith(ratio: 0.005)

        if rect.width < rect.height {
            (nrows, ncols) = nrows > ncols ? (nrows, ncols) : (ncols, nrows)
        } else {
            (nrows, ncols) = nrows > ncols ? (ncols, nrows) : (nrows, ncols)
        }

        let optimumHeight = (deal3CardsBound!.y - CGFloat(nrows - 1) * rowSpacing) / CGFloat(nrows)
        let optimunWidth = (rect.width - CGFloat(ncols - 1) * colSpacing) / CGFloat(ncols)
        var (X, Y) = (CGPoint.zero.x + colSpacing, CGPoint.zero.y + rowSpacing)
        var cardIterator = 0
        if activePlayingCardsView.count == 0 {
            for _ in 0..<nrows {
                X = CGPoint.zero.x
                for _ in 0..<ncols{
                    let cardDimensions = CGRect(x: CGFloat(X), y: CGFloat(Y), width: optimunWidth, height: optimumHeight)
                    let cardView = CardView(frame: initFrame!, forCard: activePlayingCards[cardIterator])
                    activePlayingCardsView.append(cardView)
                    addSubview(cardView)
                    sendSubviewToBack(cardView)
                    X += colSpacing + optimunWidth
                    cardIterator += 1
                    let tapGuesture = UITapGestureRecognizer()
                    tapGuesture.addTarget(self, action: #selector(handleTapEvent(sender:)))
                    cardView.addGestureRecognizer(tapGuesture)
                    cardView.initAnimation(by: cardDimensions, delayedBy: 0.3 * Double(cardIterator))
                }
                Y += rowSpacing + optimumHeight
            }
        } else {
            for _ in 0..<nrows {
                X = CGPoint.zero.x
                for _ in 0..<ncols{
                    let cardDimensions = CGRect(x: CGFloat(X), y: CGFloat(Y), width: optimunWidth, height: optimumHeight)
                    if activePlayingCardsView[cardIterator].isAnimated {
                        activePlayingCardsView[cardIterator].existingCardAnimation(by: cardDimensions)
                    } else {
                        addSubview(activePlayingCardsView[cardIterator])
                        sendSubviewToBack(activePlayingCardsView[cardIterator])
                        activePlayingCardsView[cardIterator].initAnimation(by: cardDimensions, delayedBy: 0.1 * Double(cardIterator))
                    }
                    X += colSpacing + optimunWidth
                    activePlayingCardsView[cardIterator].setNeedsDisplay()
                    cardIterator += 1
                    
                }
                Y += rowSpacing + optimumHeight
            }
        }
    }
    func updateSubviewsFromModel(with cards: [SetCard]) {
        if activePlayingCards.count < cards.count {
            for card in cards {
                if !activePlayingCards.contains(card) {
                    activePlayingCards.append(card)
                    let cardView = CardView(frame: initFrame!, forCard: card)
                    activePlayingCardsView.append(cardView)
                    let tapGuesture = UITapGestureRecognizer()
                    tapGuesture.addTarget(self, action: #selector(handleTapEvent(sender:)))
                    cardView.addGestureRecognizer(tapGuesture)
                }
            }
        } else if activePlayingCards.count > cards.count {
            for cardView in activePlayingCardsView {
                if !cards.contains(cardView.card!) {
                    //Animate
                    bringSubviewToFront(cardView)
                    cardView.exitAnimation(by: self.lastFrame!)
                    activePlayingCards.remove(at: activePlayingCards.index(of: cardView.card!)!)
                }
            }
        } else {
            let notInView = activePlayingCards.indices.filter { !cards.contains(activePlayingCards[$0]) }
            let notInCards = cards.indices.filter { !activePlayingCards.contains(cards[$0]) }
            if notInView.count > 0 {
                for index in notInView.indices {
                    let card = cards[notInCards[index]]
                    activePlayingCards[notInView[index]] = card
                    //Animate
                    let oldCardView = activePlayingCardsView[notInView[index]]
                    bringSubviewToFront(oldCardView)
                    oldCardView.exitAnimation(by: self.lastFrame!)
                    let cardView = CardView(frame: initFrame!, forCard: card)
                    activePlayingCardsView[notInView[index]] = cardView
                    let tapGuesture = UITapGestureRecognizer()
                    tapGuesture.addTarget(self, action: #selector(handleTapEvent(sender:)))
                    cardView.addGestureRecognizer(tapGuesture)
                }
            } else {
                for cards in activePlayingCardsView {
                    cards.resetFillColour()
                }
            }
           
        }
        
        setNeedsDisplay()
    }
    
    private func getRowAndColumns() -> (Int, Int){
        assert(activePlayingCards.count >= 3, "Card Count not Expected: \(activePlayingCards.count)")
        // 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, ...
        var numRows = 0
        var numCols = 0
        for divisor in 3...9 {
            numRows = activePlayingCards.count % divisor == 0 ? divisor : numRows
        }
        numCols = activePlayingCards.count / numRows
        return (numRows, numCols)
    }
    
    @objc private func handleTapEvent(sender: UITapGestureRecognizer){
        if let cv = sender.view as? CardView {
            cv.handleTapEvent()
            controller!.selectCard(with:cv.card!)
        }
    }
    
    
    
}
extension CardView {
    func initAnimation(by cardDimensions: CGRect, delayedBy by: Double) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: by, options: [.allowUserInteraction], animations: { [unowned self] in
           self.frame = cardDimensions
        }, completion: { (_) in
            UIView.transition(with: self,
                              duration: 0.75,
                              options: [.transitionFlipFromRight,.allowUserInteraction],
                              animations: { [unowned self] in
                                self.initAnimation()
            },
                              completion: nil)
        })
    }
    func existingCardAnimation(by cardDimensions: CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 0.1, options: [.allowUserInteraction], animations: { [unowned self] in
            self.frame = cardDimensions
        }, completion: nil)
    }
    func exitAnimation(by cardDimensions: CGRect) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75, delay: 0.1, options: [.allowAnimatedContent], animations: { [unowned self] in
            self.frame = cardDimensions
            self.exitAnimationPrelim()
            }, completion: { (_) in
                UIView.transition(with: self,
                                  duration: 0.75,
                                  options: [.transitionFlipFromRight],
                                  animations: { [unowned self] in
                                    self.exitAnimation()
                    },
                                  completion: {(_) in
                                    self.removeFromSuperview()
                })
        })
        
    }
}
