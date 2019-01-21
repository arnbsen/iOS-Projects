//
//  ViewController.swift
//  Graphical-Set
//
//  Created by Arnab Sen on 08/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    lazy var game = Set()
    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            setAttributesof(button: newGameButton)
        }
    }
    @IBOutlet weak var deal3CardButton: UIButton! {
        didSet {
            setAttributesof(button: deal3CardButton)
        }
    }
    
    private func setAttributesof(button name: UIButton) {
        name.layer.cornerRadius = name.bounds.width.getCoordinateWith(ratio: 0.05)
        name.clipsToBounds = true
    }
    
    


    @IBOutlet weak var cardContainer: CardContainerView! {
        didSet {
            cardContainer.controller = self
            let rotationGuesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureHandler(sender:)))

            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizer(sender:)))
            swipeGesture.direction = .down
            cardContainer.addGestureRecognizer(swipeGesture)
            cardContainer.addGestureRecognizer(rotationGuesture)
            cardContainer.activePlayingCards.append(contentsOf: game.activePlayingCards)
            cardContainer.updateSubviewsFromModel(with: game.activePlayingCards)
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

    func selectCard(with card: SetCard) {
        if game.toggleCard(with: card) {
            updateViewFromModel()
        }
    }

    private func updateViewFromModel() {
        scoreLabel.text = "Score: \(game.score)"
        cardContainer.updateSubviewsFromModel(with: game.activePlayingCards)
    }
}
