//
//  SetApp.swift
//  Set
//
//  Created by Arnab Sen on 29/03/24.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var setGameViewModel = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(setGameViewModel: setGameViewModel)
        }
    }
}
