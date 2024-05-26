//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/8/23.
//  Copyright (c) 2023 Stanford University
//  Modified by Arnab Sen on 25/05/24.
//

import Foundation

struct EmojiArt {
    var backgroud: URL?
    private(set) var emojis = [Emoji]()
    private(set) var deletedEmojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(string: emoji, position: position, size: size, id: uniqueEmojiId))
    }
    
    mutating func updateEmojiPosition(_ emoji: Emoji, by offset: Emoji.Offset) {
        if let index = firstIndexOf(emoji) {
            emojis[index].position += offset
        }
    }
    
    mutating func deleteEmoji(_ emoji: Emoji) {
        if let index = firstIndexOf(emoji) {
            let deletedEmoji = emojis.remove(at: index)
            deletedEmojis.append(deletedEmoji)
        }
    }
    
    mutating func scaleEmoji(_ emoji: Emoji, by scale: Float) {
        if let index = firstIndexOf(emoji) {
            emojis[index].size = Int(Float(emojis[index].size) * scale)
        }
    }
    
    private func firstIndexOf(_ emoji: Emoji) -> Int? {
        emojis.firstIndex(where: { $0.id == emoji.id } )
    }
    
    struct Emoji: Identifiable {
        typealias Offset = Position
        
        var string: String
        var position: Position
        var size: Int
        var id: Int
        
        struct Position {
            var x: Int
            var y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
}

extension EmojiArt.Emoji.Position {
    static func +(lhs: EmojiArt.Emoji.Position, rhs: EmojiArt.Emoji.Position) -> EmojiArt.Emoji.Position {
        EmojiArt.Emoji.Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func +=(lhs: inout EmojiArt.Emoji.Position, rhs: EmojiArt.Emoji.Position) {
        lhs = lhs + rhs
    }
}
