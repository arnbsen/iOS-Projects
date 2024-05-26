//
//  SwiftUIView.swift
//  EmojiArt
//
//
//  Created by CS193p Instructor on 5/8/23.
//  Copyright (c) 2023 Stanford University
//  Modified by Arnab Sen on 26/05/24.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var paletteStore: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            emojiView(with: paletteStore.palettes[paletteStore.cursorIndex])
        }.clipped()
    }
    
    private var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            paletteStore.cursorIndex += 1
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                paletteStore.insert(name: "Math", emojis: "+−×÷∝∞")
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive) {
                paletteStore.palettes.remove(at: paletteStore.cursorIndex)
            }
        }
    }
    
    private func emojiView(with palette: Palette) -> some View {
        HStack {
            Text("\(palette.name):")
                .font(.system(size: 30))
            ScrollingEmoji(emojis: palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}

struct ScrollingEmoji: View {
    let emojis: [String]
    
    init(emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    PaletteChooser()
}
