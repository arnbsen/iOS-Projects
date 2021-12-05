//
//  ContentView.swift
//  Memorize
//
//  Created by Arnab Sen on 05/12/21.
// Assignment 1

import SwiftUI

let vechileArray = [
    "🚗", "🚙", "🏎", "🚌", "🚎", "🚓", "🚐", "🚜",
    "🚍", "🚄", "🛺", "🚤", "✈️", "🚂", "⛵️", "🚢",
    "🛵", "🛸", "🚀", "🚃", "🚢", "🚁", "🚆", "🚖"]
let emojiArray = [
    "😀", "😇", "😛", "😡", "😭", "🤓", "😨", "🤣",
    "🥶", "🤩", "😏", "😶‍🌫️", "😬", "👿", "🤯", "🤑",
    "🙄", "😸", "🥸", "😴", "😵‍💫", "🤗", "🤠", "😐"]
let flagArray = [
    "🇮🇳", "🇦🇽", "🇦🇷", "🇧🇷", "🇨🇦", "🇺🇸", "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🇿🇦",
    "🇪🇸", "🇿🇦", "🇬🇧", "🇯🇵", "🇪🇺", "🇨🇮", "🇵🇾", "🇺🇳",
    "🇺🇾", "🇧🇹", "🇧🇩", "🇫🇷", "🇲🇨", "🇯🇲", "🇲🇱", "🇷🇺"]

struct ContentView: View {
    @State var themeId = 0
    @State var contentDisplayArray: [String] =  []
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            CardView(content: "😭").aspectRatio(2/3, contentMode: .fit)
            HStack {
                Spacer()
                ThemeChooserButton(
                    sfSymbolName: "car.fill",
                    buttonText: "Vechiles") {
                    themeId = 0
                }
                Spacer()
                ThemeChooserButton(
                    sfSymbolName: "face.smiling.fill",
                    buttonText: "Emojis") {
                    themeId = 1
                }
                Spacer()
                ThemeChooserButton(
                    sfSymbolName: "flag.fill",
                    buttonText: "Flags") {
                    themeId = 2
                }
                Spacer()
            }
        }.padding(.horizontal)
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp = true
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                Text(content).font(.largeTitle)
                shape.strokeBorder(lineWidth: 6)
            } else {
                shape.fill()
            }
        }.onTapGesture {
            isFaceUp = !isFaceUp
        }
        .foregroundColor(.red)
    }
}

struct ThemeChooserButton: View {
    var sfSymbolName: String
    var buttonText: String
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            VStack {
                Image(systemName: sfSymbolName).font(.largeTitle)
                Text(buttonText)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView().preferredColorScheme(.dark)
    }
}
