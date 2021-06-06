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
            
        Button(strengths[1]!) {
            game.strength = 1
        }
        .keyboardShortcut("1")
        .disabled(game.strength == 1 || game.computerPlayer == nil)

        Button(strengths[2]!) {
            game.strength = 2
        }
        .keyboardShortcut("2")
        .disabled(game.strength == 2 || game.computerPlayer == nil)

        Button(strengths[3]!) {
            game.strength = 3
        }
        .keyboardShortcut("3")
        .disabled(game.strength == 3 || game.computerPlayer == nil)

        Button(strengths[4]!) {
            game.strength = 4
        }
        .keyboardShortcut("4")
        .disabled(game.strength == 4 || game.computerPlayer == nil)
    }
}
