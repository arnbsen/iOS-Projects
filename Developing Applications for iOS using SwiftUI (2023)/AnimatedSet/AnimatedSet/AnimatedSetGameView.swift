//
//  ContentView.swift
//  AnimatedSet
//
//  Created by Arnab Sen on 12/05/24.
//

import SwiftUI

struct AnimatedSetGameView: View {
    
    @ObservedObject var setGame: SetGameViewModel
    
    private let aspectRatio: CGFloat = 2 / 3
    private let deckWidth: CGFloat = 50
    private let dealInAnimation: Animation = .easeInOut(duration: 1)
    
    @State private var showCardGrid = false
    
    var body: some View {
        VStack {
            Text("Animated Set!").font(.title)
            Divider()
            topBar
            Divider()
            cardGrid
            Divider()
            bottomBar
        }
        .padding()
        .onAppear {
            dealCards()
        }
    }
    
    @State private var currentScore = 0
    @State private var diffScore = 0
    
    private var topBar: some View {
        HStack {
            ScoreView(newScore: currentScore, diffScore: diffScore)
            Spacer()
            createGameButton(title: "New Game", icon: "plus") {
                newGame()
            }
        }
    }
    
    private var bottomBar: some View {
        HStack {
            notIntheGameCardPile.onTapGesture {
                withAnimation {
                    setGame.deal3Cards()
                }
                dealCards()
            }
            Spacer()
            createGameButton(title: "Shuffle", icon: "shuffle") {
                withAnimation {
                    setGame.shuffle()
                }
            }
            Spacer()
            discardedCardPile
        }
    }
    
    private var cardGrid: some View {
        AspectVGrid(setGame.cardsActiveInTheGame, aspectRatio: 2 / 3) { card in
            if isCardDealt(card) {
                SetCardView(card: card)
                    .cardify(isFaceUp: isCardFacedUp(card))
                    .padding(5)
                    .zIndex(card.isPartOfSet ? 100: 0)
                    .overlay {
                        if card.isPartOfSet {
                            FlyingEmoji(emoji: card.matched ? "🎉": "😞", sucess: card.matched)
                        }
                    }
                    .onTapGesture {
                        let oldScore = setGame.score
                        withAnimation {
                            setGame.selectCard(card)
                        }
                        currentScore = setGame.score
                        diffScore = currentScore - oldScore
                        dealCards()
                    }
                    .matchedGeometryEffect(id: card.id, in: dealingCardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .id(card.id + disambiguator.uuidString)
            }
        }
    }
    
    // MARK: Aninmation Section
    
    private func newGame() {
        facedUpCards.removeAll()
        dealtCards.removeAll()
        disambiguator = UUID()
        setGame.newGame()
        dealCards()
        diffScore = 0
        currentScore = 0

    }

    @Namespace private var dealingCardNamespace
    @State private var showView = true
    
    @State private var dealtCards = Set<SetCard.ID>()
    @State private var facedUpCards = Set<SetCard.ID>()
    // Another Stupid Bug: Animation System retains the state for same view tree
    @State private var disambiguator = UUID()
    
    // Stupid Bug: ForEach at Line#120 will not work with in-line implementation
    private var undealtCards: [SetCard] {
        (setGame.cardNotIntheGame + setGame.cardsActiveInTheGame).filter( { !isCardDealt($0) } )
    }
    
    private var notIntheGameCardPile: some View {
        return ZStack {
            ForEach(undealtCards) { card in
                SetCardView(card: card)
                    .cardify(isFaceUp: isCardFacedUp(card))
                    .matchedGeometryEffect(id: card.id, in: dealingCardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }.frame(width: deckWidth, height: deckWidth / aspectRatio)
    }
    
    private func isCardDealt(_ card: SetCard) -> Bool {
        dealtCards.contains(card.id)
    }
    
    private func isCardFacedUp(_ card: SetCard) -> Bool {
        facedUpCards.contains(card.id)
    }
    
    private func dealCards() {
        var delay: TimeInterval = 0
        for card in setGame.cardsActiveInTheGame {
            if !isCardDealt(card) {
                withAnimation(dealInAnimation.delay(delay)) {
                     _ = dealtCards.insert(card.id)
                }
                delay += 0.15
            }
        }
        delay += 0.75
        for card in setGame.cardsActiveInTheGame {
            if !isCardFacedUp(card) {
                withAnimation(dealInAnimation.delay(delay)) {
                     _ = facedUpCards.insert(card.id)
                }
                delay += 0.15
            }
        }
    }

    private var discardedCardPile: some View {
        ZStack {
            ForEach(setGame.cardsAlreadyPlayed) { card in
                SetCardView(card: card)
                    .cardify(isFaceUp: isCardFacedUp(card))
                    .matchedGeometryEffect(id: card.id, in: dealingCardNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
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
    AnimatedSetGameView(setGame: SetGameViewModel())
}