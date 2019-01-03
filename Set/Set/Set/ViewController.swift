//
//  ViewController.swift
//  Set
//
//  Created by Arnab Sen on 03/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var game = Set()

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    @IBAction func newGame(_ sender: UIButton) {
    }
   
    @IBAction func touchCard(_ sender: UIButton) {
    }
}
extension Int {
    var arc4random : Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

