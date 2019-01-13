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
            cardContainer.controller = self
            let rotationGuesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureHandler(sender:)))
            
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizer(sender:)))
            swipeGesture.direction = .down
            cardContainer.addGestureRecognizer(swipeGesture)
            cardContainer.addGestureRecognizer(rotationGuesture)
            cardContainer.game = game
        }
    }

    @objc private func rotationGestureHandler(sender: UIRotationGestureRecognizer){
        if sender.state == .ended {
            game.shuffleCards()
            updateViewFromModel()
        }
    }
    
    @objc private func swipeGestureRecognizer(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            game.deal3Cards()
            updateViewFromModel()
        }
    }
    
    
    @IBAction private func deal3Cards(_ sender: UIButton) {
        game.deal3Cards()
        updateViewFromModel()
    }
    @IBOutlet private weak var scoreLabel: UILabel!
    
    func changeScoreLabel () {
        scoreLabel.text = "Score: \(game.score)"
    }
 
    func selectCard(with card: Card) {
        if game.toggleCard(with: card){
            updateViewFromModel()
        }
    }
    
    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        cardContainer.activePlayingCards.removeAll()
        cardContainer.activePlayingCards.append(contentsOf: game.activePlayingCards)
        cardContainer.setNeedsDisplay()
    }
}

