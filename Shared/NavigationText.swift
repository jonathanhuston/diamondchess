//
//  NavitationText.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

extension ContentView {
    func navigationText() -> String {
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

