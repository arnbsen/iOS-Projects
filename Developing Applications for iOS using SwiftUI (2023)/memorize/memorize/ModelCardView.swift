//
//  CardView.swift
//  memorize
//
//  Created by Arnab Sen on 03/03/24.
//

import SwiftUI
/**
 * This class varies from CadView in one aspect, it gets rid of the individual vars in favour of
 * MemoryGame#Card
 */
struct ModelCardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill().foregroundColor(.white)
                base.strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(contentMode: .fit)
            }.opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }.opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

