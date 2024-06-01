//
//  ThemeChooserView.swift
//  ThemedMemorize
//
//  Created by Arnab Sen on 01/06/24.
//

import SwiftUI

struct ThemeChooserView: View {
    
    @EnvironmentObject var themeStore: ThemeStore
    
    @State private var themeForEditing: Theme? = nil
    @State private var navigationTheme: Theme? = nil
    @State private var emojiMemoryGameStore = Dictionary<Theme, EmojiMemoryGame>()
    
    var body: some View {
        NavigationSplitView {
            List(themeStore.themes, selection: $navigationTheme) { theme in
                navigationItem(for: theme)
                    .tag(theme)
            }
            .navigationTitle("\(themeStore.name) Themes")
            .toolbar {
                Button {
                    themeStore.append(Theme(name: "", emojis: "", color: RGBA(color: Color.orange)))
                    themeForEditing = themeStore.themes.last
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(item: $themeForEditing, onDismiss: {
                if let lastTheme = themeStore.themes.last {
                    if (lastTheme.emojis.isEmpty || lastTheme.name.isEmpty) {
                        themeStore.themes.removeLast()
                    }
                }
            }) { theme in
                if let index = themeStore.themes.firstIndex(where: { $0.id == theme.id } ) {
                    ThemeEditor(
                        theme: $themeStore.themes[index],
                        color: Color(rgba: themeStore.themes[index].color)
                    )
                }
            }
        } detail: {
            if let navigationTheme {
                EmojiMemoryGameView(emojiMemoryGame: EmojiMemoryGame(theme: navigationTheme))
            } else {
                Text("Choose a theme!")
            }
        }
        
    }
    
    private func navigationItem(for theme: Theme) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(theme.name)
                Text(theme.emojis).lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .swipeActions(edge: .trailing) {
            if themeStore.themes.count > 1 {
                Button(role: .destructive) {
                    if let index = themeStore.themes.firstIndex(where: { $0.id == theme.id } ) {
                        themeStore.themes.remove(at: index)
                    }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .swipeActions(edge: .leading) {
            Button {
                themeForEditing = theme
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
    }
    
}


#Preview {
    ThemeChooserView()
        .environmentObject(ThemeStore(named: "Preview"))
}
