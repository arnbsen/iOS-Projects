//
//  ViewController.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let shape = ["▲", "●", "■"]
    let shadingStroke = [-2.0 ,-2.0 ,3.0]
    let shadingAlpha = [ 1.0 , 0.25, 0.0]
    let colorValues  = [(243.0/255.0, 156.0/255.0, 18.0/255.0), (192.0/255.0, 57.0/255.0, 43/255.0), (52/255.0, 152/255.0, 219/255.0)]
    
    private lazy var game = Set()
    private lazy var visibleCards = [Card?]()
    
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    
    @IBAction private func newGame(_ sender: UIButton) {
        game = Set()
        updateViewFromModel()
    }
   
    @IBAction private func touchCard(_ sender: UIButton) {
        if let index = cardButtons.index(of: sender){
            game.toggleCard(with: index)
        }
        updateViewFromModel()
    }
    
    @IBAction private func deal3Cards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for card in game.activePlayingCards {
            visibleCards += [card]
        }
        for _ in 1...12 {
            visibleCards += [nil]
        }
        var temp_array = visibleCards
        for index in visibleCards.indices {
            visibleCards[index] = temp_array.remove(at: temp_array.count.arc4random)
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            if game.activePlayingCards[index] == nil {
                cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                cardButtons[index].setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
            } else {
                let card = game.activePlayingCards[index]!
                cardButtons[index].backgroundColor = game.selectedCards.contains(card) ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                let (r, g, b) = colorValues[card.colourID - 1]
                let textColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
                let attrib : [NSAttributedString.Key : Any] = [ .strokeColor : textColor, .foregroundColor : textColor.withAlphaComponent(CGFloat(shadingAlpha[card.shadingID - 1]))   ,.strokeWidth :shadingStroke[card.shadingID - 1]]
                let text = NSAttributedString.init(string: "\(card.numberOnCard) " + shape[card.shapeID - 1], attributes: attrib)
                                cardButtons[index].setAttributedTitle(text, for: UIControl.State.normal)
            
            }
       }
        scoreLabel.text = "Score: \(game.score)"
   }
}
extension Int {
    var arc4random : Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
