//
//  memorizeApp.swift
//  memorize
//
//  Created by Arnab Sen on 17/02/24.
//

import SwiftUI

@main
struct ThemedMemorizeApp: App {
    
    @StateObject var themeStore = ThemeStore(named: "Main")
    
    var body: some Scene {
        WindowGroup {
            ThemeChooserView()
                .environmentObject(themeStore)
        }
    }
}
