//
//  ContentView.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/8/23.
//  Copyright (c) 2023 Stanford University
//  Modified by Arnab Sen on 25/05/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    @ObservedObject var document: EmojiArtDocument
    
    let paletteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            bottomBar
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(isEmojiSelectionEmpty ? documentZoom * zoomGestureState : documentZoom)
                    .offset(documentPan + panGestureState)
                    .gesture(documentZoomGesture.simultaneously(with: documentPanGesture))
            }.dropDestination(for: Sturldata.self) { urls, location in
                return dropInCanvas(urls, at: location, in: geometry)
            }
        }
    }
        
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.backgroud)
            .position(Emoji.Position.zero.in(geometry))
            .onTapGesture {
                withAnimation {
                    selectedEmojis.removeAll()
                }
            }
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .scaleEffect(selectedEmojis.contains(emoji.id) ? zoomGestureState: 1)
                .border(selectedEmojis.contains(emoji.id) ? Color.blue: Color.clear)
                .offset(selectedEmojis.contains(emoji.id) ? emojiPanGestureState: .zero)
                .position(emoji.position.in(geometry))
                .onTapGesture {
                    withAnimation {
                        toggleEmojiState(emoji)
                    }
                }.gesture(selectedEmojis.isEmpty ? nil : panEmojiGesture(for: emoji, from: geometry))
                .id(emoji.id)
                .transition(.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
        }
    }
    
    private var bottomBar: some View {
        HStack {
            PaletteChooser()
                .padding(.horizontal)
                .scrollIndicators(.hidden)
            AnimatedActionButton(systemImage: "trash", role: .destructive) {
                deleteSelectedEmojis()
            }
            Spacer()
        }.font(.system(size: paletteEmojiSize))
    }
    
    
    private func dropInCanvas(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackgroud(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size: Int(paletteEmojiSize / documentZoom))
                return true
            default:
                break
            }
        }
        return false
    }
        
    // MARK: Select / Deselect
    
    @State private var selectedEmojis = Set<Emoji.ID>()
    
    private func toggleEmojiState(_ emoji: Emoji) {
        if selectedEmojis.contains(emoji.id) {
            selectedEmojis.remove(emoji.id)
        } else {
            selectedEmojis.insert(emoji.id)
        }
    }
    
    private var isEmojiSelectionEmpty: Bool {
        selectedEmojis.isEmpty
    }
    
    // MARK: Pan and zoom
    
    @State private var documentZoom: CGFloat = 1
    @State private var documentPan: CGOffset = .zero
        
    @GestureState private var zoomGestureState: CGFloat = 1
    @GestureState private var panGestureState: CGOffset = .zero
    

    private var documentZoomGesture: some Gesture {
        MagnifyGesture()
            .updating($zoomGestureState) { inMotionPinchScale, zoomGestureState, _ in
                zoomGestureState = inMotionPinchScale.magnification
            }
            .onEnded { endingPinchScale in
                if isEmojiSelectionEmpty {
                    documentZoom *= endingPinchScale.magnification
                } else {
                    updateSizeOfSelectedEmojis(by: endingPinchScale.magnification)
                }
            }
    }
    
    private var documentPanGesture: some Gesture {
        DragGesture()
            .updating($panGestureState) { inMotionPan, documentPanGestureState, _ in
                documentPanGestureState = inMotionPan.translation
            }
            .onEnded { endingDragGesture in
                documentPan += endingDragGesture.translation
            }
    }
    
    @GestureState private var emojiPanGestureState: CGOffset = .zero
    
    private func panEmojiGesture(for emoji: Emoji, from geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($emojiPanGestureState) { inMotionPan, emojiPanGestureState, _ in
                emojiPanGestureState = inMotionPan.translation
            }
            .onEnded { endingDragGesture in
                moveSelectedEmojis(by: endingDragGesture.translation, from: geometry, using: emoji)
            }
    }
    
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int((location.x - center.x - documentPan.width) / documentZoom),
            y: Int(-(location.y - center.y - documentPan.height) / documentZoom)
        )
    }

    private func updateSizeOfSelectedEmojis(by scale: CGFloat) {
        if isEmojiSelectionEmpty {
            return
        }
        for emoji in document.emojis {
            if selectedEmojis.contains(emoji.id) {
                document.scaleEmoji(emoji, by: scale)
            }
        }
    }
    
    private func moveSelectedEmojis(by offset: CGOffset, from geometry: GeometryProxy, using emoji: Emoji) {
        if isEmojiSelectionEmpty {
            return
        }
        for emoji in document.emojis {
            if selectedEmojis.contains(emoji.id) {
                moveEmoji(emoji, by: Emoji.Offset(x: Int(offset.width), y:  Int(-offset.height)))
            }
        }
    }
    
    private func moveEmoji(_ emoji: Emoji, by offset: Emoji.Offset) {
        document.updateEmojiPosition(emoji, by: offset)
    }
    
    private func deleteSelectedEmojis() {
        if isEmojiSelectionEmpty {
            return
        }
        for emoji in document.emojis {
            if selectedEmojis.contains(emoji.id) {
                document.deleteEmojis(emoji)
            }
        }
        selectedEmojis.removeAll()
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "preview"))
}
