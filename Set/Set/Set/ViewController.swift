//
//  ViewController.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = Set()

    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    
    @IBAction func newGame(_ sender: UIButton) {
    }
   
    @IBAction func touchCard(_ sender: UIButton) {
    }
    
    @IBAction func deal3Cards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var index_array = Array(0...23)
        for _ in 1...12 {
            let rand_index = index_array.remove(at: index_array.count.arc4random)
            game.activePlayingCards[rand_index].isVisible = true
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            cardButtons[index].backgroundColor =  game.activePlayingCards[index].isVisible ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    }
}
extension Int {
    var arc4random : Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

