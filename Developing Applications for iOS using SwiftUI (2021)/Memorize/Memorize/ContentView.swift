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
    @State var contentDisplayArray: [String] =  vechileArray
    @State var emojiCount = 10
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(contentDisplayArray[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            HStack {
                Spacer()
                ThemeChooserButton(
                    sfSymbolName: "car.fill",
                    buttonText: "Vechiles") {
                        contentDisplayArray = vechileArray.shuffled()
                        emojiCount = Int.random(in: 10...24)
                }
                Spacer()
                ThemeChooserButton(
                    sfSymbolName: "face.smiling.fill",
                    buttonText: "Emojis") {
                        contentDisplayArray = emojiArray.shuffled()
                        emojiCount = Int.random(in: 10...24)
                }
                Spacer()
                ThemeChooserButton(
                    sfSymbolName: "flag.fill",
                    buttonText: "Flags") {
                        contentDisplayArray = flagArray.shuffled()
                        emojiCount = Int.random(in: 10...24)
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
.previewInterfaceOrientation(.portrait)
        ContentView().preferredColorScheme(.dark)
    }
}
