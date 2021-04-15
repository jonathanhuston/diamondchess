//
//  AppCommands.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/14/21.
//

import SwiftUI

struct AppCommands {
    @ObservedObject var game: Game
}

extension AppCommands: Commands {
    
    @CommandsBuilder var body: some Commands {
        CommandMenu("Game") {
            Button("White vs. Computer") {
                game.computerPlayer = .black
                game.launch = true
            }
            .keyboardShortcut("W", modifiers: [.shift, .command])
            Button("Computer vs. Black") {
                game.computerPlayer = .white
                game.launch = true
            }
            .keyboardShortcut("B", modifiers: [.shift, .command])
            Button("Human vs. Human") {
                game.computerPlayer = Player.none
                game.launch = true
            }
            .keyboardShortcut("H", modifiers: [.shift, .command])
        }
    }
}
