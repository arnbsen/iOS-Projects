//
//  ThemeEditor.swift
//  ThemedMemorize
//
//  Created by Arnab Sen on 01/06/24.
//

import SwiftUI

struct ThemeEditor: View {
    
    @Binding var theme: Theme
    @State var color: Color
    
    @State var emojisToAdd = ""
    
    @FocusState private var focused: Focused?
    
    enum Focused {
        case name
        case addEmojis
    }
    
    private let emojiFont = Font.system(size: 30)
    
    var body: some View {
        Text("Swipe down to dismiss")
            .foregroundStyle(Color.blue)
            .padding()
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $theme.name)
                    .focused($focused, equals: .name)
            }
            Section(header: Text("Color")) {
                ColorPicker("Choose Color", selection: $color)
                    .onChange(of: color) {
                        theme.color = RGBA(color: color)
                    }
            }
            Section(header: Text("Emojis")) {
                TextField("Add Emojis here", text: $emojisToAdd)
                    .focused($focused, equals: .addEmojis)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd) {
                        theme.emojis = (emojisToAdd + theme.emojis).uniqued
                      }
                removeEmojis
            }
        }
        .frame(minWidth: 300, minHeight: 350)
        .onAppear {
            if theme.name.isEmpty {
                focused = .name
            } else {
                focused = .addEmojis
            }
        }
    }
    
    var removeEmojis: some View {
        VStack(alignment: .leading) {
            Text("Tap to Remove Emojis").font(.body).foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                remove(emoji: emoji)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
    
    private func remove(emoji: String) {
        if let index = theme.emojis.firstIndex(of: emoji.first!) {
            theme.emojis.remove(at: index)
        }
        if let index = emojisToAdd.firstIndex(of: emoji.first!) {
            emojisToAdd.remove(at: index)
        }
    }
    
    struct Preview: View {
        @State var theme = ThemeStore(named: "ThemeEditorPreview").themes.first!
        
        var body: some View {
            ThemeEditor(theme: $theme, color: Color(rgba: theme.color))
        }
    }
}

#Preview {
    ThemeEditor.Preview()
}
