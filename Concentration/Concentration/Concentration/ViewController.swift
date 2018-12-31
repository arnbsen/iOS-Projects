//
//  ViewController.swift
//  Concentration
//
//  Created by Arnab Sen on 31/12/18.
//  Copyright © 2018 Arnab Sen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let emojiGallery = [["👻", "🎃", "😸", "🦊", "🐧","🦉","👿","🍎"], ["🥎","⚽️", "🏏", "🏈", "🏃🏻‍♂️", "🏓", "🏸", "🎱"], ["😀", "😇", "😛", "😡", "😭", "🤓", "😨", "🤣"]]
    
    
    lazy var game = Concetration(noOfPairsOfCards: cardButtons.count/2)
    lazy var emojiChoices = emojiGallery[Int(arc4random_uniform(UInt32(emojiGallery.count)))]
    // Dictionary
    var emoji = [Int: String]()
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func newGame(_ sender: UIButton) {
        restartGame()
    }
    
    
    @IBAction func flipCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("Card Not found")
        }
        
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(getEmoji(for : card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        scoreLabel.text = "Score: " + "\(game.flipCount)"
        if game.matchCount == cardButtons.count/2 {
            restartGame()
        }
    }
    func restartGame() {
        emojiChoices = emojiGallery[Int(arc4random_uniform(UInt32(emojiGallery.count)))]
        game = Concetration(noOfPairsOfCards: cardButtons.count/2)
        emoji = [Int: String]()
        updateViewFromModel()
    }
    
    
    
    
    // Getting an Emoji for Card at runtime
    func getEmoji(for card: Card) -> String {
        // Replacement for if (condition1){ if(condition2) { } } ==> if condition1, condition {}
        if emoji[card.id] == nil, emojiChoices.count > 0 {
            let rand_index = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.id] = emojiChoices.remove(at: rand_index)
        }
        // Returns if exists (shorthand for ternary operator of dictionaries)
        // if index has none nil is returned
        return emoji[card.id] ?? "?"
    }
    
    
}

