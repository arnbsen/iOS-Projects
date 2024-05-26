//
//  PalletteStore.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/8/23.
//  Copyright (c) 2023 Stanford University
//  Modified by Arnab Sen on 26/05/24.
//

import Foundation

class PaletteStore: ObservableObject {
    
    let name: String
    
    @Published var palettes: [Palette] {
        didSet {
            if palettes.isEmpty, !oldValue.isEmpty {
                palettes = oldValue
            }
        }
    }
    
    init(named name: String) {
        self.name = name
        palettes = Palette.builtins
        if palettes.isEmpty {
            palettes = [Palette(name: "Warning", emojis: "⚠️")]
        }
    }
    
    @Published private var _cursorIndex = 0
    
    var cursorIndex: Int {
        get { boundsCheckedIndex(_cursorIndex) }
        set { _cursorIndex = boundsCheckedIndex(newValue) }
    }
    
    private func boundsCheckedIndex(_ index: Int) -> Int {
        var index = index % palettes.count
        if index < 0 {
            index += palettes.count
        }
        return index
    }
    
    // Adder Functions
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) { // "at" default is cursorIndex
        let insertionIndex = boundsCheckedIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            palettes.replaceSubrange(insertionIndex...insertionIndex, with: [palette])
        } else {
            palettes.insert(palette, at: insertionIndex)
        }
    }
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(Palette(name: name, emojis: emojis), at: index)
    }
    
        
    private func append(_ palette: Palette) {
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes.append(palette)
            }
        } else {
            palettes.append(palette)
        }
    }
    
    func append(named name: String, with emojis: String) {
        append(Palette(name: name, emojis: emojis))
    }
}
