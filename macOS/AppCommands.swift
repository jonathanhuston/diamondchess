//
//  AppCommands.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/14/21.
//

import SwiftUI

struct AppCommands {
    @Binding var computerPlayer: Player?
}

extension AppCommands: Commands {
    
    @CommandsBuilder var body: some Commands {
        CommandMenu("Game") {
            Button("White vs. Computer") {
                computerPlayer = .black
            }
            .keyboardShortcut("W", modifiers: [.shift, .command])
            Button("Computer vs. Black") {
                computerPlayer = .white
            }
            .keyboardShortcut("B", modifiers: [.shift, .command])
            Button("Human vs. Human") {
                computerPlayer = Player.none
            }
            .keyboardShortcut("H", modifiers: [.shift, .command])
        }
    }
}
