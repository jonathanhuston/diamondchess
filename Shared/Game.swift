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
    @Published var depth = maxDepth
    
    var scores = [BoardState: Float]()
    var nextMoves = [BoardState: [(move: Move, newBoardState: BoardState)]]()
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
    
    private func update(_ boardState: inout BoardState, with move: Move) {
        let piece = boardState.board[move.to.rank][move.to.file]
        let player = boardState.currentPlayer
        
        if piece == "White King" || piece == "Black King" {
            boardState.canCastleKingSide[player] = false
            boardState.canCastleQueenSide[player] = false
        }
        
        if piece == "White Rook" && move.from.file == 7 {
            boardState.canCastleKingSide[player] = false
        }
            
        if piece == "Black Rook" && move.from.file == 0 {
            boardState.canCastleQueenSide[player] = false
        }
        
        if piece == "White Pawn" || piece == "Black Pawn" {
            boardState.enPassantSquare = boardState.enPassantSquare(for: move)
        } else {
            boardState.enPassantSquare = nil
        }
                
        if boardState.insufficientMaterial() {
            boardState.winner = .draw
            return
        }
        
        boardState.currentPlayer = opponent[player]!
        
        if let nextMoves = nextMoves[boardState] {
            if !nextMoves.isEmpty {
                return
            }
        } else if boardState.canMove(boardState.currentPlayer) {
            return
        }
                
        if !boardState.inCheck[boardState.currentPlayer]! {
            boardState.winner = .draw
            return
        }
            
        boardState.winner = player
    }
    
    // FIX: promotion
    private func alphabeta(in boardState: BoardState,
                           depth: Int, _ alpha: Float = winningScore[.black]!, _ beta: Float = winningScore[.white]!) -> (score: Float, move: Move?) {
                
        if depth == 0 || boardState.winner != nil {
            let score = scores[boardState] ?? boardState.evaluateBoardState()
            scores[boardState] = score
            return (score, nil)
        }
        
        var alpha = alpha
        var beta = beta
        let player = boardState.currentPlayer
        let comparator: (Float, Float) -> Bool = player == .white ? (>) : (<)
        var bestScore = player == .white ? winningScore[.black]! : winningScore[.white]!
        var bestMove: Move? = nil
        
        let outcomes = nextMoves[boardState] ?? boardState.validOutcomes(for: player)
        nextMoves[boardState] = outcomes
                        
        for outcome in outcomes {
            var newBoardState = outcome.newBoardState
            update(&newBoardState, with: outcome.move)
            
            let score = alphabeta(in: newBoardState, depth: depth - 1, alpha, beta).score

            if comparator(score, bestScore) {
                bestScore = score
                bestMove = outcome.move
            }
            
            if player == .white && bestScore > alpha { alpha = bestScore }
            if player == .black && bestScore < beta { beta = bestScore }
            
            if alpha >= beta {
                break
            }
        }
        
        return (bestScore, bestMove)
    }
    
    func computerMove() {
//        let time = DispatchTime.now()

        guard let move = alphabeta(in: boardState, depth: depth).move else {
            return
        }
        
//        print(DispatchTime.now().distance(to: time))

        
        boardState = boardState.isValidMove(move)!
        update(&boardState, with: move)
        
        boardState.promoting = nil
        
        if boardState.winner != nil {
            over = true
            boardState.killKings()
        }
    }
    
    func humanMove(_ move: Move) -> BoardState? {
        if !boardState.allAttacks(from: move.from).contains(move.to) {
            return nil
        }
        
        var newBoardState = boardState.isValidMove(move)
        
        if newBoardState == nil {
            return nil
        }
                
        update(&newBoardState!, with: move)
        
        if newBoardState!.winner != nil {
            over = true
            newBoardState!.killKings()
        }
        
        return newBoardState
    }
}
