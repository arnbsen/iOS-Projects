//
//  SetCardView.swift
//  Set
//
//  Created by Arnab Sen on 05/04/24.
//

import SwiftUI

struct SetCardView: View {
    
    let card: SetCard
    
    var body: some View {
        GeometryReader { geometry in
            let shapeSize = calculateSizeForShape(containerSize: geometry.size)
            let strokeWidth = getStrokeWidth(containerSize: geometry.size)
            let cornerRadius = min(geometry.size.width * 0.15,  geometry.size.height * 0.15)
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
                    .stroke(color, lineWidth: strokeWidth)
                if (card.isPartOfSet) {
                    Text(card.matched ? "🎉" : "😞").font(.largeTitle)
                } else {
                    VStack {
                        ForEach(0..<card.number) { _ in
                            switch card.shapeType {
                            case .DIAMOND:
                                decorateView(
                                    with: ShapeFactory.Diamond(),
                                    size: shapeSize)
                            case .SQUIGGLE:
                                decorateView(
                                    with: ShapeFactory.Squiggle(),
                                    size: shapeSize)
                            case .ROUNDED_RECTRANGLE:
                                decorateView(
                                    with: ShapeFactory.RoundedRectrangle(),
                                    size: shapeSize)
                            }
                        }
                    }.padding(0)
                }
                
            }
        }
    }
    
    var color: Color {
        switch card.color {
        case .RED:
            Color.red
        case .GREEN:
            Color.green
        case .BLUE:
            Color.blue
        }
    }
    
    var fillColor: Color {
        if (card.isPartOfSet) {
            color
        } else if (card.selected) {
            Color.orange.opacity(0.25)
        } else {
            Color.white
        }
    }
    
    private func decorateView(with shape: some Shape, size: CGSize) -> some View {
        let strokeWidth = getStrokeWidth(containerSize: size)
        switch card.fillType {
        case .SOLID:
            return shape
                .fill(color)
                .stroke(color, lineWidth: strokeWidth)
                .frame(width: size.width, height: size.height)
        case .STRIPPED:
            return shape
                .fill(color.opacity(0.4))
                .stroke(color, lineWidth: strokeWidth)
                .frame(width: size.width, height: size.height)
        case .NONE:
            return shape
                .fill(Color.white)
                .stroke(color, lineWidth: strokeWidth)
                .frame(width: size.width, height: size.height)
        }
    }
    
    private func calculateSizeForShape(containerSize size: CGSize) -> CGSize {
        let width = size.width * 0.8
        let height = size.height * 0.2
        return CGSize(width: width, height: height)
    }
    
    private func getStrokeWidth(containerSize size: CGSize) -> CGFloat {
        return min(size.width, size.height) * 0.025
    }

}


#Preview {
    SetCardView(card: SetCard(number: 3, shapeType: .DIAMOND, fillType: .SOLID, color: .BLUE))
    
}
