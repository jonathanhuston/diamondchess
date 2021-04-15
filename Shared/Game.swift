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
    
    private func bestMove(of moves: [Square: [Square]]) -> (Square, Square) {
        let move = moves.randomElement()
        let from = move!.key
        let to = move!.value.randomElement()!
        
        return (from, to)
    }
    
    func computerMove() {
        let moves = boardState.allValidMoves(for: boardState.currentPlayer)
        
        if moves.isEmpty {
            return
        }
        
        let (from, to) = bestMove(of: moves)
        
        boardState = boardState.makeMove(from: from, to: to)!
        boardState.promoting = nil
    }
}
