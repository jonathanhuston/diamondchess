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
    @Published var flipNow = false
    @Published var flipped = false
    @Published var touched: Square? = nil
    @Published var dragging = false
    
    var scores = [BoardState: Float]()
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
    
    private func bestMove(in boardState: BoardState,
                          depth: Int = maxDepth, _ alpha: Float = winningScore[.black]!, _ beta: Float = winningScore[.white]!) -> (score: Float, move: Move?) {
        
        var alpha = alpha
        var beta = beta
        let player = boardState.currentPlayer
        let comparator: (Float, Float) -> Bool = player == .white ? (<) : (>)
        var score: Float
        var moves = [(score: Float, move: Move)]()
        
        let validMoves = boardState.validMoves(for: player)
        
//        if validMoves.isEmpty {
//            print(winningScore[boardState.winner!]!)
//            return (winningScore[boardState.winner!]!, nil)
//        }
        
        outerloop: for validMove in validMoves {
            let from = validMove.key
            for to in validMove.value {
                let move = Move(from: from, to: to, specialPromote: nil)
                let outcome = boardState.makeMove(move)!
                
                if outcome.winner != nil || depth == 0 {
                    score = scores[outcome] ?? outcome.evaluateBoardState()
                    scores[outcome] = score
                    moves.append((score, move))
                    continue
                }
                
                score = bestMove(in: outcome, depth: depth - 1, alpha, beta).score
                
                if player == .white && score > alpha { alpha = score }
                if player == .black && score < beta { beta = score }
                
                if alpha > beta { break outerloop }

                moves.append((score, move))
                
//                if let square = outcome.promoting {
//                    for _ in 1...3 {
//                        let promotionPiece = nextPromotionPiece(outcome.board[square.rank][square.file])
//                        outcome.board[square.rank][square.file] = promotionPiece
//                        scores[Move(from: from, to: to, specialPromote: promotionPiece)] = outcome.evaluateBoardState()
//                    }
//                }
            }
        }
        
        let bestScore = moves.max { a, b in comparator(a.score, b.score) }!.score
                                
        return moves.filter { $0.score == bestScore }.randomElement()!
    }
    
    func computerMove() {
        guard let move = bestMove(in: boardState).move else {
            return
        }
                
        boardState = boardState.makeMove(move)!
        boardState.promoting = nil
    }
}
