//
//  AppCommands.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/14/21.
//

import SwiftUI

struct AppCommands {
    @Environment(\.openURL) var openURL
        
    private let baseURL = "http://diamondchess.club/"
    
    private var legalDocs = ["Privacy"]
        
    func webpage(_ menuItem: String) -> String {
        baseURL + menuItem.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)! + ".html"
    }
}

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
        
        CommandGroup(replacing: .help) {
            Button("Diamond Chess Help") {
                if let url = URL(string: baseURL) {
                    openURL(url)
                }
            }
            
            Divider()
            
            ForEach(legalDocs, id:\.self) { doc in
                Button(doc) {
                    if let url = URL(string: webpage(doc)) {
                        openURL(url)
                    }
                }
            }
        }
    }
}
