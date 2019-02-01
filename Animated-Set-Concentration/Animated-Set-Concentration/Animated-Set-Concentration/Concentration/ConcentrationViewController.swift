//
//  ViewController.swift
//  Concentration
//
//  Created by Arnab Sen on 31/12/18.
//  Copyright © 2018 Arnab Sen. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    private let emojiGallery = [["👻", "🎃", "😸", "🦊", "🐧","🦉","👿","🍎"], ["🥎","⚽️", "🏏", "🏈", "🏃🏻‍♂️", "🏓", "🏸", "🎱"], ["😀", "😇", "😛", "😡", "😭", "🤓", "😨", "🤣"], ["?", "?", "?", "?","?","?","?","?","?"]]
    private let cardBackColour = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.5960784314, blue: 0.8588235294, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    private let backgroudColour = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.7529411765, green: 0.2235294118, blue: 0.168627451, alpha: 1), #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
    
    lazy var game = Concetration(noOfPairsOfCards: cardButtons.count/2)
    var currentSelection = 3 {
        didSet {
            if cardButtons != nil {
                if currentSelection == 3  {
                    currentSelection = 2.arc4random
                }
                updateTheme()
            }
            
        }
    }
    
    //MARK: In Case of theme is set by the master view controller
    private func updateTheme() {
        
        emojiChoices = emojiGallery[currentSelection]
        currentBackgroudColour = backgroudColour[currentSelection]
        currentCardBackColour = cardBackColour[currentSelection]
        emoji = [Int: String]()
        scoreLabel.textColor = currentCardBackColour
        newGameButton.setTitleColor(currentCardBackColour, for: UIControl.State.normal)
        self.view.backgroundColor = currentBackgroudColour
        updateViewFromModel()
    }
    
    
    lazy var emojiChoices = emojiGallery[currentSelection]
    lazy var currentBackgroudColour = backgroudColour[currentSelection]
    lazy var currentCardBackColour = cardBackColour[currentSelection]
    // Dictionary
    var emoji = [Int: String]()
    
    @IBOutlet private var cardButtons: [UIButton]! {
        didSet{
            for index in cardButtons.indices{
                cardButtons[index].backgroundColor = currentCardBackColour
            }
             updateViewFromModel()
        }
    }
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.textColor = currentCardBackColour
            scoreLabel.text = "Score: " + "\(game.flipCount)"
        }
    }
    @IBOutlet private weak var newGameButton: UIButton! {
        didSet {
            newGameButton.setTitleColor(currentCardBackColour, for: UIControl.State.normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = currentBackgroudColour
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        restartGame()
        updateTheme()
    }
    
    
    @IBAction private func flipCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("Card Not found")
        }
        
    }
    
    private func updateViewFromModel() {
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
        if scoreLabel != nil {
            scoreLabel.text = "Score: " + "\(game.flipCount)"
        }
        
        if game.matchCount == cardButtons.count/2 {
            restartGame()
        }
    }
    private func restartGame() {
        game = Concetration(noOfPairsOfCards: cardButtons.count/2)
        emoji.removeAll()
        currentSelection = emojiGallery.count.arc4random
    }
    
    
    
    
    //MARK: Getting an Emoji for Card at runtime
    private func getEmoji(for card: Card) -> String {
        // Replacement for if (condition1){ if(condition2) { } } ==> if condition1, condition {}
        if emoji[card.id] == nil, emojiChoices.count > 0 {
            let rand_index = emojiChoices.count.arc4random
            emoji[card.id] = emojiChoices.remove(at: rand_index)
        }
        // Returns if exists (shorthand for ternary operator of dictionaries)
        // if index has none nil is returned
        return emoji[card.id] ?? "?"
    }
    
    
}

