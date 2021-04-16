//
//  Game.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

class Game: ObservableObject {
    @Published var boardState = BoardState()
    @Published var computerPlayer: Player? = .black
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
    
    private func bestMove(of moves: [Square: [Square]], for player: Player) -> Move {
        let comparator: (Float, Float) -> Bool = player == .white ? (<) : (>)
        var scores = [Move: Float]()
        
        for movesFrom in moves {
            let from = movesFrom.key
            for to in movesFrom.value {
                var newBoardState = boardState.makeMove(Move(from: from, to: to, specialPromote: nil))!
                scores[Move(from: from, to: to, specialPromote: nil)] = newBoardState.evaluateBoardState()
                if let square = newBoardState.promoting {
                    for _ in 1...3 {
                        let promotionPiece = nextPromotionPiece(newBoardState.board[square.rank][square.file])
                        newBoardState.board[square.rank][square.file] = promotionPiece
                        scores[Move(from: from, to: to, specialPromote: promotionPiece)] = newBoardState.evaluateBoardState()
                    }
                }
            }
        }
        
        let bestScore = scores.max { a, b in comparator(a.value, b.value) }!.value
        let bestMoves = scores.filter { $0.value == bestScore }
        
        return bestMoves.randomElement()!.key
    }
    
    func computerMove() {
        let moves = boardState.allValidMoves(for: boardState.currentPlayer)
        
        if moves.isEmpty {
            return
        }
        
        let move = bestMove(of: moves, for: boardState.currentPlayer)
        
        boardState = boardState.makeMove(move)!
        boardState.promoting = nil
    }
}
