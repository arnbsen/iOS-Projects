//
//  ViewController.swift
//  Graphical-Set
//
//  Created by Arnab Sen on 08/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    private lazy var game = Set()

    @IBAction private func newGame(_ sender: UIButton) {
        game = Set()
        updateViewFromModel()
    }
    
    @IBAction private func deal3Cards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    @IBOutlet private weak var scoreLabel: UILabel!
 
    private func updateViewFromModel() {
        
    }
}

