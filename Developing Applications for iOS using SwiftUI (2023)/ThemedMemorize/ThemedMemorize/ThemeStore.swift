//
//  ThemeStore.swift
//  ThemedMemorize
//
//  Created by Arnab Sen on 01/06/24.
//

import SwiftUI

extension UserDefaults {
    
    func themes(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            return decodedThemes
        } else {
            return []
        }
    }
    
    func set(_ themes: [Theme], forKey key: String) {
        let data = try? JSONEncoder().encode(themes)
        set(data, forKey: key)
    }
}

class ThemeStore: ObservableObject, Identifiable {
    
    let name: String
    
    var id: String { name }
    
    private var userDefaultsKey: String { "ThemeStore:" + name }
    
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    init(named name: String) {
        self.name = name
        if themes.isEmpty {
            themes = Theme.builtins
            if themes.isEmpty {
                themes = [
                    Theme(name: "Warning", emojis: "⚠️", color: RGBA(color: Color.orange))
                ]
            }
        }
    }
    
    func append(_ theme: Theme) { // at end of themes
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            if themes.count == 1 {
                themes = [theme]
            } else {
                themes.remove(at: index)
                themes.append(theme)
            }
        } else {
            themes.append(theme)
        }
    }
        
    func append(name: String, emojis: String, color: Color) {
        append(Theme(name: name, emojis: emojis, color: RGBA(color: color)))
    }
}

extension Color {
    
    init(rgba: RGBA) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension RGBA {
    
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension ThemeStore: Hashable {
    static func == (lhs: ThemeStore, rhs: ThemeStore) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
