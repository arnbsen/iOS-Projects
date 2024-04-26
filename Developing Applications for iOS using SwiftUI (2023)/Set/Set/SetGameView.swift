//
//  ContentView.swift
//  Set
//
//  Created by Arnab Sen on 29/03/24.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var setGameViewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            Text("Set!").font(.title)
            Divider()
            HStack {
                Text("Score: \(setGameViewModel.score)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                createGameButton(title: "New Game", icon: "plus") {
                    setGameViewModel.newGame()
                }
            }
            Divider()
            cardGrid
            Divider()
            HStack {
                createGameButton(title: "Deal 3 Cards", icon: "square.and.arrow.up.on.square.fill", disabled: setGameViewModel.disableDeal3Cards) {
                    setGameViewModel.deal3Cards()
                }
            }
        }.padding()
       
    }
    
    var cardGrid: some View {
        AspectVGrid(setGameViewModel.cardsActiveInTheGame, aspectRatio: 2 / 3) { card in
            SetCardView(card: card)
                .padding(5)
                .onTapGesture {
                    setGameViewModel.selectCard(card)
                }
        }
    }
    
    private func createGameButton(title: String, icon: String, disabled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.body)
                .foregroundColor(.white)
                .padding()
        }
        .background(disabled ? Color.gray : Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .disabled(disabled)
    }
    
    
}

#Preview {
    SetGameView(setGameViewModel: SetGameViewModel())
}
