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
        
        Text("Computer strength: \(game.depth) / 4")
            .foregroundColor(.gray)
            
        Button("Make computer play worse") {
            game.depth -= 1
        }
        .keyboardShortcut("-")
        .disabled(game.depth <= 1 || game.computerPlayer == nil)
        
        Button("Make computer play better") {
            game.depth += 1
        }
        .keyboardShortcut("+")
        .disabled(game.depth >= 4 || game.computerPlayer == nil)
    }
}
