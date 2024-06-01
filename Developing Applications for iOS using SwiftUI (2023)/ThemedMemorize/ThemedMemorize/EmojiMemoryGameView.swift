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
            Divider()
            topBar
            Divider()
            cardGrid
                .foregroundColor(Color(rgba: emojiMemoryGame.theme.color))
        }
       
        .padding()
        .navigationTitle(emojiMemoryGame.theme.name)
        
    }
    
    var topBar: some View {
        HStack {
            Button {
                emojiMemoryGame.newGame()
            } label: {
                Label("New Game", systemImage: "plus")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
            Text("Score: \(emojiMemoryGame.score)")
        }
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
    
    struct Preview: View {
        @State var theme = ThemeStore(named: "ThemeEditorPreview").themes.first!
        
        var body: some View {
            EmojiMemoryGameView(emojiMemoryGame: EmojiMemoryGame(theme: theme))
        }
    }
    
}

#Preview {
    EmojiMemoryGameView.Preview()
}
