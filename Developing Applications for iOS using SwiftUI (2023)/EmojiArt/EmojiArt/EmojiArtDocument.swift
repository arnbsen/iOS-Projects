//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/8/23.
//  Copyright (c) 2023 Stanford University
//  Modified by Arnab Sen on 25/05/24.
//
import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt()
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var deletedEmojis: [Emoji] {
        emojiArt.deletedEmojis
    }
    
    var backgroud: URL? {
        emojiArt.backgroud
    }
    
    // MARK: Intents
    
    func setBackgroud(_ url: URL?) {
        emojiArt.backgroud = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        emojiArt.addEmoji(emoji, at: position, size: size)
    }
    
    func updateEmojiPosition(_ emoji: Emoji, by offset: Emoji.Offset) {
        emojiArt.updateEmojiPosition(emoji, by: offset)
    }
    
    func deleteEmojis(_ emoji: Emoji) {
        emojiArt.deleteEmoji(emoji)
    }
    
    func scaleEmoji(_ emoji: Emoji, by scale: CGFloat) {
        emojiArt.scaleEmoji(emoji, by: Float(scale))
    }
}

extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}

