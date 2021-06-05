//
//  ContentView.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

struct ContentView {
    @EnvironmentObject var game: Game
    
    private func navigationText() -> String {
        var text = ""
        
        text += "\(game.boardState.currentPlayer.rawValue)'s turn"
        
        if game.computerPlayer != nil {
            text += "  –  \(strenghts[game.depth]!)\t\t"
        }
        
        return text
    }
}

extension ContentView: View {
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                BoardView()
                
                PiecesView()
            }
            .frame(width: 8 * squareSize, height: 8 * squareSize)
            
            VStack(spacing: 0) {
                CapturedView(player: .white)
                    .frame(width: 2 * squareSize, height: 4 * squareSize)

                CapturedView(player: .black)
                    .frame(width: 2 * squareSize, height: 4 * squareSize)

            }
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
        .navigationTitle(navigationText())
    }
}
