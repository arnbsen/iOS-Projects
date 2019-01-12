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
    lazy var game = Set()

    @IBAction private func newGame(_ sender: UIButton) {
        game = Set()
        updateViewFromModel()
    }
    
    @IBOutlet weak var cardContainer: CardContainerView! {
        didSet {
            updateViewFromModel()
        }
    }

    @objc private func rotationGestureHandler(sender: UIRotationGestureRecognizer){
        
    }
    
    @objc private func swipeGuestureHandler(sender: UISwipeGestureRecognizer){
        if sender.direction == .down, sender.state == .ended {
            game.deal3Cards()
            updateViewFromModel()
        }
    }
    
    @IBAction private func deal3Cards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    @IBOutlet private weak var scoreLabel: UILabel!
 
    private func updateViewFromModel() {
        cardContainer.activePlayingCards.removeAll()
        cardContainer.activePlayingCards.append(contentsOf: game.activePlayingCards)
        cardContainer.setNeedsDisplay()
    }
}

