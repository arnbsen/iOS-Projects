//
//  AnimatedSetApp.swift
//  AnimatedSet
//
//  Created by Arnab Sen on 12/05/24.
//

import SwiftUI

@main
struct AnimatedSetApp: App {
    var body: some Scene {
        
        @StateObject var game = SetGameViewModel()
        WindowGroup {
            AnimatedSetGameView(setGame: game)
        }
    }
}
