//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/8/23.
//  Copyright (c) 2023 Stanford University
//  Modified by Arnab Sen on 25/05/24.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject private var emojiArtDocument = EmojiArtDocument()
    @StateObject private var mainPalette = PaletteStore(named: "main")
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: emojiArtDocument)
                .environmentObject(mainPalette)
        }
    }
}
