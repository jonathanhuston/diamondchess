//
//  Diamond_ChessApp.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

@main
struct Diamond_ChessApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Game())
        }
    }
}
