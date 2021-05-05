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

// FIX: update menu items
// FIX: Help menu
extension AppCommands: Commands {
    
    @CommandsBuilder var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About Diamond Chess") {
                NSApplication.shared.orderFrontStandardAboutPanel(
                    options: [
                        NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                            string: "Pieces designed by Ella Huston",
                            attributes: [
                                NSAttributedString.Key.font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
                            ]
                        ),
                        NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© 2021 Jonathan Huston"
                    ]
                )
            }
        }
        
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
            
            Button("Make computer play worse") {
                if game.depth > 1 {
                    game.depth -= 1
                }
            }
            .keyboardShortcut("-")
            
            Button("Make computer play better") {
                if game.depth < maxDepth {
                    game.depth += 1
                }
            }
            .keyboardShortcut("+")
        }
    }
}
