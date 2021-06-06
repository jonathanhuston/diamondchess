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
    @Published var strength = maxDepth
    
    var midgame: [Player: Bool] = [.white: false, .black: false]
    var moves = [String]()
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
        midgame = [.white: false, .black: false]
        moves = []
        
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
            boardState.winner = .empty
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
            boardState.winner = .empty
            return
        }
            
        boardState.winner = player
    }
    
    private func alphabeta(in boardState: BoardState,
                           depth: Int, _ alpha: Float = winningScore[.black]!, _ beta: Float = winningScore[.white]!) -> (score: Float, move: Move?) {
        
        var alpha = alpha
        var beta = beta
        let player = boardState.currentPlayer
        var score: Float
        var bestScore = player == .white ? winningScore[.black]! : winningScore[.white]!
        
        let outcomes = nextMoves[boardState] ?? boardState.validOutcomes(for: player)
        nextMoves[boardState] = outcomes
        
        var bestMove = outcomes[0].move
                       
        for outcome in outcomes {
            var newBoardState = outcome.newBoardState
            update(&newBoardState, with: outcome.move)
            
            if depth == 0 || newBoardState.winner != nil {
                score = scores[newBoardState] ?? newBoardState.evaluateBoardState()
                scores[newBoardState] = score
            } else {
                score = alphabeta(in: newBoardState, depth: depth - 1, alpha, beta).score
            }
                        
            if player == .white {
                if score > bestScore {
                    bestScore = score
                    bestMove = outcome.move
                }
                if bestScore > alpha {
                    alpha = bestScore
                }
            } else {
                if score < bestScore {
                    bestScore = score
                    bestMove = outcome.move
                }
                if bestScore < beta {
                    beta = bestScore
                }
            }
            
            if alpha >= beta {
                break
            }
        }
                
//        print("Best score at \(depth):\t\(bestScore)")
//        if let bestMove = bestMove {
//            print("Best move:\(bestMove.stamma)")
//        }
//        print()
                
        return (bestScore, bestMove)
    }
    
    private func suddenDeath() -> Move? {
        let player = boardState.currentPlayer
        
        let outcomes = nextMoves[boardState] ?? boardState.validOutcomes(for: player)
        nextMoves[boardState] = outcomes.shuffled()
                                
        for outcome in outcomes {
            var newBoardState = outcome.newBoardState
            update(&newBoardState, with: outcome.move)
            
            if newBoardState.winner == player {
                return outcome.move
            }
        }
                
        return nil
    }
    
    private func checkOpening(_ opening: [String]) -> String? {
        if moves.count >= opening.count {
            return nil
        }
        
        if moves.isEmpty {
            return opening[0]
        }
        
        for i in 0...moves.count-1 {
            if moves[i] != opening[i] {
                return nil
            }
        }
        
        return opening[moves.count]
    }
    
    private func findOpening() -> String? {
        if midgame[boardState.currentPlayer]! || strength == 1 {
            return nil
        }
        
        for opening in openings[boardState.currentPlayer]!.shuffled() {
            if let found = checkOpening(opening) {
                return found
            }
        }
        
        midgame[boardState.currentPlayer] = true
        return nil
    }
    
    func computerMove() {
        let move: Move
//        let time = DispatchTime.now()
        
        if let opening = findOpening() {
            move = opening.unstamma
        } else if let suddenDeath = suddenDeath() {
            move = suddenDeath
        } else {
            move = alphabeta(in: boardState, depth: boardState.endgame ? strength + 1 : strength).move!
        }
        
//        print(DispatchTime.now().distance(to: time))
        
        boardState = boardState.isValidMove(move)!
        update(&boardState, with: move)
        moves.append(move.stamma)
        
        boardState.promoting = nil
        
        if boardState.winner != nil {
            over = true
            boardState.killKings()
        }
    }
    
    func humanMove(_ move: Move) -> BoardState? {
        if !boardState.allAttacksAndDefenses(from: move.from).attacks.contains(move.to) {
            return nil
        }
        
        var newBoardState = boardState.isValidMove(move)
        
        if newBoardState == nil {
            return nil
        }
                
        update(&newBoardState!, with: move)
        moves.append(move.stamma)
        
        if newBoardState!.winner != nil {
            over = true
            newBoardState!.killKings()
        }
        
        return newBoardState
    }
}
