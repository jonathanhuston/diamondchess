//
//  ContentView.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

struct ContentView {
    @EnvironmentObject var game: Game
}

extension ContentView: View {
    var body: some View {
        ZStack {
            BoardView()
            
            PiecesView()
        }
        .alert(isPresented: $game.over) {
            Alert(title: game.boardState.winner! != .none ? Text("Checkmate!") : Text("Stalemate!"))
        }
    }
}
