//
//  ContentView.swift
//  Diamond Chess (macOS)
//
//  Created by Jonathan Huston on 6/8/21.
//

import SwiftUI

struct ContentView {
    @EnvironmentObject var game: Game
    
    @State private var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
}

extension ContentView: View {
    var body: some View {
        NavigationView {
            SettingsView()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)

            LayoutView(orientation: $orientation)
                .navigationTitle(navigationText())
                .navigationBarTitleDisplayMode(.inline)
        }
        .onReceive(orientationChanged) { _ in
            self.orientation = UIDevice.current.orientation
        }
        .onChange(of: game.launch) { launch in
            if launch == true {
                game.newGame()
            }
            game.launch = false
        }
        .onChange(of: game.flipNow) { _ in
            game.flipped = !game.flipped
        }
    }
}
