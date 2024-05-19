//
//  ScoreView.swift
//  AnimatedSet
//
//  Created by Arnab Sen on 18/05/24.
//

import SwiftUI

struct ScoreView: View {
    
    let diffScore: Int
    let newScore: Int
    
    @State private var opacity: Double
    @State private var currentScore: Int
    
    init(newScore: Int, diffScore: Int) {
        self.newScore = newScore
        self.diffScore = diffScore
        opacity = 0
        currentScore = 0
    }
    
    var body: some View {
        HStack {
            if diffScore != 0 {
                Text("Score: \(currentScore)").font(.title2)
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
                        withAnimation(.snappy(duration: 0.15).delay(2.5)) {
                            currentScore = newScore
                        }
                    }.onDisappear {
                        opacity = 0
                    }
            } else {
                Text("Score: \(newScore)").font(.title2)
            }
        }
    }
}

#Preview {
    ScoreView(newScore: 5, diffScore: 3)
}
