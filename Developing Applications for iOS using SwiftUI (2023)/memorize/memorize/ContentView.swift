//
//  ContentView.swift
//  memorize
//
//  Created by Arnab Sen on 17/02/24.
//

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
    
    let themes : [(imageName: String, buttonText: String, data: [String], themeColor: Color)] = [
        ("car.fill", "Vechiles", vechileArray, Color.red),
        ("face.smiling.fill", "Smileys", emojiArray, Color.green),
        ("flag.fill", "Flags", flagArray, Color.blue)
    ]
    
    @State var selectedThemeIndex = 0
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            cardGrid
            buttonChooserBar
        }
        .padding()
    }
    
    var buttonChooserBar : some View {
        HStack {
            Spacer()
            ForEach(themes.indices, id: \.self) { index in
                createThemeButton(themes[index].imageName, themes[index].buttonText, themes[index].themeColor)
                    .onTapGesture {
                        selectedThemeIndex = index
                    }
                Spacer()
            }
        }
    }
    
    var cardGrid: some View {
        ScrollView {
            let selectedThemeArray = doubleAndShuffle(array: themes[selectedThemeIndex].data)
            let minWidth = widthThatBestFits(cardCount: selectedThemeArray.count)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: minWidth))]) {
                let themeColor = themes[selectedThemeIndex].themeColor
                ForEach(selectedThemeArray.indices, id: \.self) { index in
                    CardView(content: selectedThemeArray[index], themeColor: themeColor).aspectRatio(2/3, contentMode: .fit)
                }
            }
        }
    }
    
    func createThemeButton(_ imageName: String, _ buttonText: String, _ color: Color) -> some View {
        VStack {
            Image(systemName: imageName).font(.largeTitle)
            Text(buttonText).font(.headline)
        }
        .foregroundColor(color)
    }
    
    func doubleAndShuffle(array arrayValue: [String]) -> [String] {
        let endIndex = Int.random(in: 1...arrayValue.count)
        let selectedArray = arrayValue[0..<endIndex]
        return (selectedArray + selectedArray).shuffled()
    }
    
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        if (cardCount < 10) {
            return 100
        } else if (cardCount >= 10 && cardCount < 16) {
            return 80
        } else if (cardCount >= 16 && cardCount < 26) {
            return 60
        } else if (cardCount >= 26 && cardCount < 36) {
            return 50
        } else {
            return 47
        }
    }
}

struct CardView: View {
    var content: String
    let themeColor: Color
    @State var isFaceUp = false
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 20)
            Group {
                base.fill().foregroundColor(.white)
                Text(content).font(.largeTitle)
                base.strokeBorder(lineWidth: 3)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
        .foregroundColor(themeColor)
    }
}

#Preview {
    ContentView()
}
