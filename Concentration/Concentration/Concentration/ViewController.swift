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
    let cardBackColour = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1)]
    let backgroudColour = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.7529411765, green: 0.2235294118, blue: 0.168627451, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)]
    
    lazy var game = Concetration(noOfPairsOfCards: cardButtons.count/2)
    lazy var currentSelection = Int(arc4random_uniform(UInt32(emojiGallery.count)))
    lazy var emojiChoices = emojiGallery[currentSelection]
    lazy var currentBackgroudColour = backgroudColour[currentSelection]
    lazy var currentCardBackColour = cardBackColour[currentSelection]
    // Dictionary
    var emoji = [Int: String]()
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    override func viewDidLoad() {
        scoreLabel.textColor = currentCardBackColour
        self.view.backgroundColor = currentBackgroudColour
        newGameButton.setTitleColor(currentCardBackColour, for: UIControl.State.normal)
    }
    
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
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : currentCardBackColour
            }
        }
        scoreLabel.text = "Score: " + "\(game.flipCount)"
        if game.matchCount == cardButtons.count/2 {
            restartGame()
        }
    }
    func restartGame() {
        currentSelection = Int(arc4random_uniform(UInt32(emojiGallery.count)))
        emojiChoices = emojiGallery[currentSelection]
        game = Concetration(noOfPairsOfCards: cardButtons.count/2)
        emoji = [Int: String]()
        currentBackgroudColour = backgroudColour[currentSelection]
        currentCardBackColour = cardBackColour[currentSelection]
        scoreLabel.textColor = currentCardBackColour
        self.view.backgroundColor = currentBackgroudColour
        newGameButton.setTitleColor(currentCardBackColour, for: UIControl.State.normal)
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

