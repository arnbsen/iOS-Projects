//
//  CardContainerView.swift
//  Graphical-Set
//
//  Created by Arnab Sen on 08/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class CardContainerView: UIView, UIDynamicAnimatorDelegate {
    
    lazy var animator : UIDynamicAnimator  = {
        let animator = UIDynamicAnimator(referenceView: self)
            animator.delegate = self
            return animator
        
    }()
    
    private var activePlayingCardsView = [CardView]()
    var controller : SetViewController?
    private var activePlayingCards = [SetCard]()
    private var initFrame : CGRect?
    private var deal3CardsBound : CGPoint?
    private var selectedCards = [CardView]()
    var lastFrame : CGRect?
    private var discardedCards = [CardView]()
    private var calledOnce = false
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func startGame(with cards: [SetCard]) {
        activePlayingCards.removeAll()
        activePlayingCards.append(contentsOf: cards)
        for view in subviews {
            if let cv = view as? CardView {
                cv.removeFromSuperview()
            }
        }
        activePlayingCardsView.removeAll()
        setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        for view in subviews {
            if let stv = view as? UIStackView {
                view.layer.zPosition = 5.0
                deal3CardsBound = CGPoint(x: stv.frame.minX, y: stv.frame.minY - stv.frame.minY.getCoordinateWith(ratio: 0.025))
                initFrame = CGRect(origin: CGPoint(x: stv.frame.minX, y: stv.frame.minY), size: (stv.subviews.first?.frame.size)!)
                lastFrame = CGRect(origin: CGPoint(x: (stv.subviews.last?.frame.minX)! + stv.frame.minX, y: (stv.subviews.last?.frame.minY)!+stv.frame.minY) , size: (stv.subviews.last?.frame.size)!)
            }
        }
        if let card = discardedCards.first {
            card.frame = lastFrame!
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
                    cardView.layer.zPosition = 1.0
                    addSubview(cardView)
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
            var newCardAnimatorMultiplier = 1
            for _ in 0..<nrows {
                X = CGPoint.zero.x
                for _ in 0..<ncols{
                    let cardDimensions = CGRect(x: CGFloat(X), y: CGFloat(Y), width: optimunWidth, height: optimumHeight)
                    if activePlayingCardsView[cardIterator].isAnimated {
                        activePlayingCardsView[cardIterator].existingCardAnimation(by: cardDimensions)
                    } else {
                        addSubview(activePlayingCardsView[cardIterator])
                        activePlayingCardsView[cardIterator].initAnimation(by: cardDimensions, delayedBy: 0.3 * Double(newCardAnimatorMultiplier))
                        newCardAnimatorMultiplier += 1
                    }
                    X += colSpacing + optimunWidth
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
                    cardView.layer.zPosition = 1.0
                    activePlayingCardsView.append(cardView)
                    let tapGuesture = UITapGestureRecognizer()
                    tapGuesture.addTarget(self, action: #selector(handleTapEvent(sender:)))
                    cardView.addGestureRecognizer(tapGuesture)
                }
            }
            setNeedsDisplay()
        } else if activePlayingCards.count > cards.count {
            for cardView in activePlayingCardsView {
                if !cards.contains(cardView.card!) {
                    //Animate
                    //animateOnSameNumberOfCards(with: cardView, with: self.lastFrame!)
                    discardedCards.append(cardView)
                    let myBehavior = MyBehaviour(in: self.animator)
                    myBehavior.addItem(cardView)
                    activePlayingCards.remove(at: activePlayingCards.index(of: cardView.card!)!)
                    activePlayingCardsView.remove(at: activePlayingCardsView.index(of: cardView)!)
                }
            }
            setNeedsDisplay()
        } else {
            let notInView = activePlayingCards.indices.filter { !cards.contains(activePlayingCards[$0]) }
            let notInCards = cards.indices.filter { !activePlayingCards.contains(cards[$0]) }
            if notInView.count > 0 {
                for index in notInView.indices {
                    let card = cards[notInCards[index]]
                    activePlayingCards[notInView[index]] = card
                    //Animate
                    let oldCardView = activePlayingCardsView[notInView[index]]
                    oldCardView.layer.zPosition = 2.0
                    let myBehavior = MyBehaviour(in: self.animator)
                    myBehavior.addItem(oldCardView)
                    discardedCards.append(oldCardView)
                    let cardView = CardView(frame: initFrame!, forCard: card)
                    cardView.layer.zPosition = 1.0
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
    }
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
    
        let lastLeftCard = discardedCards.first
        if calledOnce {
            calledOnce = false
            return
        } else {
            calledOnce = true
        }
        
        for index in discardedCards.indices {
            if let last = discardedCards.indices.last, last == index {
                let lastCard = discardedCards[index]
                lastCard.exitAnimation(with: CGFloat(index), onComplete: {
                    (_) in
                    self.discardedCards.removeAll()
                    self.discardedCards.append(lastCard)
                    self.controller?.changeScoreLabel()
                    animator.removeAllBehaviors()
                    self.setNeedsDisplay()
                })
            } else {
                if let card = lastLeftCard, lastLeftCard == discardedCards[index] {
                    card.removeFromSuperview()
                }
                discardedCards[index].exitAnimation(with: CGFloat(index),onComplete: {
                    (_) in
                    self.discardedCards[index].removeFromSuperview()
                })
            }
            
        }
        
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
                              duration: 1.0,
                              options: [.transitionFlipFromRight],
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
    
       
}
