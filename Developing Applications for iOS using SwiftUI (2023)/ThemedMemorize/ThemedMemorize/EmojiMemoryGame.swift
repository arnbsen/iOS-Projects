//
//  EmojiMemoryGame.swift
//  memorize
//
//  Created by Arnab Sen on 03/03/24.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let numberOfPairs = Int.random(in: 2..<theme.emojis.count)
        let emojiArray = theme.emojis.uniqued.map(String.init)
        return MemoryGame<String>(numberOfPairOfCards: numberOfPairs) { pairIndex in
            if emojiArray.indices.contains(pairIndex) {
                emojiArray[pairIndex]
            } else {
                nil
            }
        }
    }
    
    init(theme: Theme) {
        self.theme = theme
        self.memoryGame = EmojiMemoryGame.createMemoryGame(theme: self.theme)
    }

    @Published private var memoryGame: MemoryGame<String>
    private(set) var theme: Theme
    
    var cards: [MemoryGame<String>.Card] {
        memoryGame.cards
    }
    
    var score: Int {
        memoryGame.score
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        memoryGame.chooseCard(card)
    }
    
    func newGame() {
        memoryGame = EmojiMemoryGame.createMemoryGame(theme: self.theme)
    }
    
    
}
