//
//  Diamond_ChessApp.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

@main
struct Diamond_ChessApp: App {
    var body: some Scene {
        let game = Game()
        
        WindowGroup {
            ContentView()
                .environmentObject(game)
        }
        .commands {
            AppCommands(game: game)
        }
    }
}
