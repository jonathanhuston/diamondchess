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
        let player = game.boardState.currentPlayer
        
        var text = ""
        
        switch game.boardState.winner {
        case .white:
            text += "1–O  "
        case .black:
            text += "0–1  "
        case .empty:
            text += "½–½  "
        default:
            text += "\(player.rawValue)'s turn  "
        }
        
        if game.computerPlayer != nil {
            text += "–  \(strengths[game.strength]!) "
        }
        
        if game.moves.count > 0 {
            let moveCount = (game.moves.count + 1) / 2
            let moveIndicator = player == .white ? ". ... " : ". "
            let mateIndicator = game.boardState.winner == opponent[player]! ? "#" : ""
            let checkIndicator = game.boardState.inCheck[player]! && game.boardState.winner == nil ? "+" : ""
            
            text += "(\(moveCount)\(moveIndicator)\(game.moves.last!)\(mateIndicator)\(checkIndicator))"
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
        .background(Color.black)
    }
}
