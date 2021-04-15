//
//  Game.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

class Game: ObservableObject {
    @Published var boardState = BoardState()
    @Published var computerPlayer: Player? = nil
    @Published var launch = false
    @Published var over = false
    @Published var flip = false
    @Published var flipped = false
    @Published var touched: Square? = nil
    @Published var dragging = false
}

extension Game {
    func newGame() {
        boardState = BoardState()
        launch = false
        over = false
        flipped = computerPlayer == .white
        touched = nil
        dragging = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.boardState.currentPlayer == self.computerPlayer {
                self.computerMove()
            }
        }
    }
    
    func computerMove() {
        let moves = boardState.allValidMoves(for: boardState.currentPlayer)
        
        if moves.isEmpty {
            return
        }
        
        let move = moves.randomElement()
        let from = move!.key
        let to = move!.value.randomElement()!
        
        boardState = boardState.makeMove(from: from, to: to)!
    }
}
