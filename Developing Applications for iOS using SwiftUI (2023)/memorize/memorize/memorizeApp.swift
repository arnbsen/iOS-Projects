//
//  memorizeApp.swift
//  memorize
//
//  Created by Arnab Sen on 17/02/24.
//

import SwiftUI

@main
struct memorizeApp: App {
    
    @StateObject var emojiMemoryGame = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(emojiMemoryGame: emojiMemoryGame)
        }
    }
}
