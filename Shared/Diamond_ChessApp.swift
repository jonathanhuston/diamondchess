//
//  Diamond_ChessApp.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

@main
struct Diamond_ChessApp: App {
    @State var computerPlayer: Player? = nil
    
    var body: some Scene {
        WindowGroup {
            ContentView(computerPlayer: $computerPlayer)
                .environmentObject(Game())
        }
        .commands {
            AppCommands(computerPlayer: $computerPlayer)
        }
    }
}
