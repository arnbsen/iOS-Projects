//
//  FlyingEmoji.swift
//  AnimatedSet
//
//  Created by Arnab Sen on 12/05/24.
//

import SwiftUI

struct FlyingEmoji: View {
    
    let emoji: String
    let sucess: Bool
    
    @State private var offset: CGFloat = 0

    var body: some View {
        Text(emoji)
            .font(.largeTitle)
            .offset(x: 0, y: offset)
            .opacity(offset != 0 ? 0 : 1)
            .onAppear {
                withAnimation(.easeIn(duration: 1.5)) {
                    offset = sucess ? -200: 200
                }
            }
            .onDisappear {
                offset = 0
            }
    }
}


#Preview {
    FlyingEmoji(emoji: "🎉", sucess: true)
}
