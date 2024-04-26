//
//  EmojiMemoryGame.swift
//  memorize
//
//  Created by Arnab Sen on 03/03/24.
//

import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    private static let vechileArray = [
        "🚗", "🚙", "🏎", "🚌", "🚎", "🚓", "🚐", "🚜",
        "🚍", "🚄", "🛺", "🚤", "✈️", "🚂", "⛵️", "🚢",
        "🛵", "🛸", "🚀", "🚃", "🚢", "🚁", "🚆", "🚖"]
    private static let emojiArray = [
        "😀", "😇", "😛", "😡", "😭", "🤓", "😨", "🤣",
        "🥶", "🤩", "😏", "😶‍🌫️", "😬", "👿", "🤯", "🤑",
        "🙄", "😸", "🥸", "😴", "😵‍💫", "🤗", "🤠", "😐"]
    private static let flagArray = [
        "🇮🇳", "🇦🇽", "🇦🇷", "🇧🇷", "🇨🇦", "🇺🇸", "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🇿🇦",
        "🇪🇸", "🇿🇦", "🇬🇧", "🇯🇵", "🇪🇺", "🇨🇮", "🇵🇾", "🇺🇳",
        "🇺🇾", "🇧🇹", "🇧🇩", "🇫🇷", "🇲🇨", "🇯🇲", "🇲🇱", "🇷🇺"]
    private static let sportsArray = [
        "⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🥏", "🎱",
        "🏓", "🏸", "🏑", "🥊"
    ]
    private static let fruitArray = [
        "🍏", "🍐", "🍊", "🍌", "🍉", "🍇", "🍓", "🍒",
    ]
    private static let fastFoodArray = [
        "🍔", "🧇", "🍕", "🌮", "🌭", "🥨", "🌯"
    ]
    
    private static let themes : [Theme] = [
        Theme(values: vechileArray, name: "Vechiles", color: .red),
        Theme(values: emojiArray, name: "Smileys", color: .orange),
        Theme(values: flagArray, name: "Flags", color: .blue),
        Theme(values: sportsArray, name: "Sports", color: .brown),
        Theme(values: fruitArray, name: "Fruits", color: .purple),
        Theme(values: fastFoodArray, name: " Fast Food", color: .teal)
    ]
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let numberOfPairs = Int.random(in: 2..<theme.values.count)
        return MemoryGame<String>(numberOfPairOfCards: numberOfPairs) { pairIndex in
            if theme.values.indices.contains(pairIndex) {
                theme.values[pairIndex]
            } else {
                nil
            }
        }
    }
    
    init() {
        let selectedIndex = Int.random(in: EmojiMemoryGame.themes.indices)
        self.theme = EmojiMemoryGame.themes[selectedIndex]
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
        let selectedIndex = Int.random(in: 0..<EmojiMemoryGame.themes.count)
        theme = EmojiMemoryGame.themes[selectedIndex]
        memoryGame = EmojiMemoryGame.createMemoryGame(theme: self.theme)
    }
    
    struct Theme {
        let values: [String]
        let name: String
        let color: Color
    }
    
}
