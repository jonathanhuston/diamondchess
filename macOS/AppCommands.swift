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
            Button("Play white against computer") {
                game.computerPlayer = .black
                game.launch = true
            }
            .keyboardShortcut("W", modifiers: [.shift, .command])
            Button("Play black against computer") {
                game.computerPlayer = .white
                game.launch = true
            }
            .keyboardShortcut("B", modifiers: [.shift, .command])
            Button("Human vs. Human") {
                game.computerPlayer = nil
                game.launch = true
            }
            .keyboardShortcut("H", modifiers: [.shift, .command])
            
            Divider()
            
            Button("Flip board") {
                game.flip = !game.flip
            }
            .keyboardShortcut("F", modifiers: [.shift, .command])
            
        }
    }
}
