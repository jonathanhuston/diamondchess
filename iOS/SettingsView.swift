//
//  SettingsView.swift
//  Diamond Chess (iOS)
//
//  Created by Slatescript on 08.06.21.
//

import SwiftUI

struct SettingsView {
    @EnvironmentObject var game: Game
}

extension SettingsView: View {
    var body: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 20 * Device.scaling) {
                AboutView()
                    .padding(.bottom)
                
                Text("NEW GAME:")
                    .foregroundColor(.white)
                    .padding(.top)
                
                Button("White vs. Computer") {
                    game.computerPlayer = .black
                    game.launch = true
                }
                
                Button("Computer vs. Black") {
                    game.computerPlayer = .white
                    game.launch = true
                }
                
                Button("Human vs. Human") {
                    game.computerPlayer = nil
                    game.launch = true
                }
                
                Text("PLAYING STRENGTH:")
                    .foregroundColor(.white)
                    .padding(.top)
                                
                Button("Flip board") {
                    game.flipNow = !game.flipNow
                }
                
                Text("COMPUTER STRENGTH:")
                    .foregroundColor(.white)
                    .padding(.top)
                
                ForEach(1...3, id:\.self) { strength in
                    Button(strengths[strength]!) {
                        game.strength = strength
                    }
                    .disabled(game.strength == strength || game.computerPlayer == nil)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
