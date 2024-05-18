//
//  Cardify.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/26/23.
//  Copyright Stanford University 2023
//
//  Modified by Arnab Sen on 05/18/24.

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }

    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        Group {
            GeometryReader { geometry in
                let cornerRadius = min(geometry.size.width * 0.15,  geometry.size.height * 0.15)
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(Color.orange)
                        .opacity(isFaceUp ? 0: 1)
                    content.opacity(isFaceUp ? 1: 0)
                }
            }
        }
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}
