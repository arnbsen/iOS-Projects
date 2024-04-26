//
//  EmojiMemoryGameView.swift
//  memorize
//
//  Created by Arnab Sen on 03/03/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var emojiMemoryGame: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            Divider()
            Group {
                infoBar
                Divider()
                cardGrid
            }.foregroundColor(emojiMemoryGame.theme.color)
            Button("New Game") {
                emojiMemoryGame.newGame()
            }
        }
        .padding()
        
    }
    
    var infoBar: some View {
        HStack {
            Text("\(emojiMemoryGame.theme.name)")
            Spacer()
            Text("Score: \(emojiMemoryGame.score)")
        }
        .bold()
        .font(.title2)
    }
    
    var cardGrid: some View {
        ScrollView {
            let minWidth = widthThatBestFits(cardCount: emojiMemoryGame.cards.count)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: minWidth), spacing: 0)],
                      spacing: 0) {
                ForEach(emojiMemoryGame.cards) { card in
                    ModelCardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            emojiMemoryGame.choose(card)
                        }
                }
            }
            .animation(.default, value: emojiMemoryGame.cards)
        }
    }
    
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        if (cardCount < 10) {
            return 100
        } else if (cardCount >= 10 && cardCount < 16) {
            return 90
        } else if (cardCount >= 16 && cardCount < 26) {
            return 72
        } else if (cardCount >= 26 && cardCount < 36) {
            return 60
        } else {
            return 47
        }
    }
    
}

#Preview {
    EmojiMemoryGameView(emojiMemoryGame: EmojiMemoryGame())
}
