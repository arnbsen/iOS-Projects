//
//  SetGameViewModel.swift
//  Set
//
//  Created by Arnab Sen on 20/04/24.
//

import Foundation

class SetGameViewModel: ObservableObject {
    
    @Published private var setGame: SetGame
    
    init() {
        setGame = SetGame()
    }
    
    var cardsActiveInTheGame: [SetCard] {
        setGame.cardsActiveInTheGame
    }
    
    var cardNotIntheGame: [SetCard] {
        setGame.cardsNotIntheGame
    }
    
    var cardsAlreadyPlayed: [SetCard] {
        setGame.matchedCards
    }
    
    var disableDeal3Cards: Bool {
        setGame.cardsNotIntheGame.isEmpty
    }
    
    var score: Int {
        setGame.score
    }
    
    func newGame() {
        setGame = SetGame()
    }
    
    func deal3Cards() {
        setGame.deal3Cards()
    }
    
    func selectCard(_ card: SetCard) {
        setGame.selectCard(card)
    }
    
    func shuffle() {
        setGame.shuffle()
    }
}
