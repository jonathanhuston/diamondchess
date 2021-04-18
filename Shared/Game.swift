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
        let time = DispatchTime.now()

        var alpha = alpha
        var beta = beta
        let player = boardState.currentPlayer
        let comparator: (Float, Float) -> Bool = player == .white ? (<) : (>)
        var score: Float
        var moves = [(score: Float, move: Move)]()
        
        let validOutcomes = boardState.validOutcomes(for: player)
        
        for outcome in validOutcomes {
            let move = outcome.move
            var newBoardState = outcome.newBoardState
            newBoardState.updateBoardState(given: move)
            
            if newBoardState.winner != nil || depth == 0 {
                score = scores[newBoardState] ?? newBoardState.evaluateBoardState()
                scores[newBoardState] = score
                moves.append((score, move))
                continue
            }
            
            score = bestMove(in: newBoardState, depth: depth - 1, alpha, beta).score
            
            if player == .white && score > alpha { alpha = score }
            if player == .black && score < beta { beta = score }
            
            if alpha > beta { break }

            moves.append((score, move))
            
//            if let square = outcome.promoting {
//                for _ in 1...3 {
//                    let promotionPiece = nextPromotionPiece(outcome.board[square.rank][square.file])
//                    outcome.board[square.rank][square.file] = promotionPiece
//                    scores[Move(from: from, to: to, specialPromote: promotionPiece)] = outcome.evaluateBoardState()
//                }
//            }
        }
        
        let bestScore = moves.max { a, b in comparator(a.score, b.score) }!.score
        
        print(DispatchTime.now().distance(to: time))

                                
        return moves.filter { $0.score == bestScore }.randomElement()!
    }
    
    func computerMove() {
        guard let move = bestMove(in: boardState).move else {
            return
        }
        
        boardState = boardState.isValidMove(move)!
        boardState.updateBoardState(given: move)
        
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
                
        newBoardState!.updateBoardState(given: move)
        
        if newBoardState!.winner != nil {
            over = true
            newBoardState!.killKings()
        }
        
        return newBoardState
    }
}
