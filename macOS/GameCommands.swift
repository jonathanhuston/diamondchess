//
//  PlayingStrength.swift
//  Diamond Chess (macOS)
//
//  Created by Jonathan Huston on 5/5/21.
//

import SwiftUI

struct GameCommands {
    @EnvironmentObject var game: Game
}

extension GameCommands: View {
    var body: some View {
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
            game.computerPlayer = nil
            game.launch = true
        }
        .keyboardShortcut("H", modifiers: [.shift, .command])
        
        Divider()
        
        Button("Flip board") {
            game.flipNow = !game.flipNow
        }
        .keyboardShortcut("F", modifiers: [.shift, .command])
        
        Divider()
            
        Button("Terrible") {
            game.depth = 1
        }
        .keyboardShortcut("1")
        .disabled(game.depth == 1 || game.computerPlayer == nil)
        
        Button("Novice") {
            game.depth = 2
        }
        .keyboardShortcut("2")
        .disabled(game.depth == 2 || game.computerPlayer == nil)
        
        Button("Meh") {
            game.depth = 3
        }
        .keyboardShortcut("3")
        .disabled(game.depth == 3 || game.computerPlayer == nil)
        
        Button("Decent") {
            game.depth = 4
        }
        .keyboardShortcut("4")
        .disabled(game.depth == 4 || game.computerPlayer == nil)
    }
}
