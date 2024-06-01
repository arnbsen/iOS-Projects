//
//  Theme.swift
//  ThemedMemorize
//
//  Created by Arnab Sen on 01/06/24.
//

import Foundation


struct Theme: Identifiable, Hashable, Codable {
    
    var name: String
    var emojis: String
    var color: RGBA
    var id = UUID()
    
    static let builtins: [Theme] = [
        Theme(
            name: "Vechiles",
            emojis: "🚗🚙🏎🚌🚎🚓🚐🚜🚍🚄🛺🚤✈️🚂⛵️🚢🛵🛸🚀🚃🚢🚁🚆🚖",
            color: RGBA(red: 100, green: 0, blue: 0, alpha: 100)
        ),
        Theme(
            name: "Smileys",
            emojis: "😀😇😛😡😭🤓😨🤣🥶🤩😏😶‍🌫️😬👿🤯🤑🙄😸🥸😴😵‍💫🤗🤠😐",
            color: RGBA(red: 0, green: 100, blue: 0, alpha: 100)
        ),
        Theme(
            name: "Flags",
            emojis: "🇮🇳🇦🇽🇦🇷🇧🇷🇨🇦🇺🇸🏴󠁧󠁢󠁥󠁮󠁧󠁿🇿🇦🇪🇸🇿🇦🇬🇧🇯🇵🇪🇺🇨🇮🇵🇾🇺🇳🇺🇾🇧🇹🇧🇩🇫🇷🇲🇨🇯🇲🇲🇱🇷🇺",
            color: RGBA(red: 0, green: 0, blue: 100, alpha: 100)
        )
    ]
    
    mutating func setColor(_ color: RGBA) {
        self.color = color
    }
}

struct RGBA: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

