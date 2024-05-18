//
//  ScoreView.swift
//  AnimatedSet
//
//  Created by Arnab Sen on 18/05/24.
//

import SwiftUI

struct ScoreView: View {
    
    let oldScore: Int
    let newScore: Int
    
    @State private var opacity: Double
    @State private var currentScore: Int
    
    init(oldScore: Int, newScore: Int) {
        self.oldScore = oldScore
        self.newScore = newScore
        self.opacity = 0
        self.currentScore = oldScore
    }
    
    var body: some View {
        HStack {
            Text("Score: \(currentScore)").font(.title2)
            if oldScore != newScore {
                let diffScore = newScore - oldScore
                Text(diffScore, format: .number.sign(strategy: .always()))
                    .font(.title2)
                    .foregroundColor(diffScore < 0 ? .red : .green)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1)) {
                            opacity = 1
                        }
                        withAnimation(.easeOut(duration: 1).delay(1.5)) {
                            opacity = 0
                        }
                        withAnimation(.spring.delay(2.5)) {
                            currentScore = newScore
                        }
                        
                    }.onDisappear {
                        opacity = 0
                    }
            }
        }
    }
}

#Preview {
    ScoreView(oldScore: 3, newScore: 4)
}
