//
//  AppCommands.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/14/21.
//

import SwiftUI

// FIX: Help menu
struct AppCommands: Commands {
    
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
    }
}
