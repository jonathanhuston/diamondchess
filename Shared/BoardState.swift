//
//  BoardState.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/10/21.
//

struct BoardState {
    var board: Board = newBoard
    var currentPlayer: Player = .white
    
    // TODO: en passant, promotion
    private func pawnMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: self.board[from.rank][from.file])
        let direction = player == .white ? -1 : 1
        
        var toRank = from.rank + direction
        
        if 0...7 ~= toRank && self.board[toRank][from.file] == "Empty" {
            moves.append(Square(rank: toRank, file: from.file))
        }
        
        for toFile in [from.file - 1, from.file + 1] {
            if 0...7 ~= toFile && color(of: self.board[toRank][toFile]) == opponent[player] {
                moves.append(Square(rank: toRank, file: toFile))
            }
        }
        
        if from.rank == (player == .white ? 6 : 1) {
            toRank = toRank + direction
            
            if 0...7 ~= toRank && self.board[toRank][from.file] == "Empty" {
                moves.append(Square(rank: toRank, file: from.file))
            }
        }
        
        return moves
    }
    
    private func canMove(piece: String, from: Square, to: Square) -> Bool {
        if piece.contains("Pawn") {
            return pawnMoves(from: from).contains(to)
        }
        
        return true
    }
    
    private func inCheck(player: Player) -> Bool {
        return false
    }
    
    func isValidMove(for piece: String, from: Square, to: Square) -> BoardState? {
        if !(0...7 ~= to.rank && 0...7 ~= to.file) {
            return nil
        }
        
        if color(of: self.board[from.rank][from.file]) == color(of: self.board[to.rank][to.file]) {
            return nil
        }
        
        if !canMove(piece: piece, from: from, to: to) {
            return nil
        }
                
        var newBoardState = self
        
        newBoardState.board[from.rank][from.file] = "Empty"
        newBoardState.board[to.rank][to.file] = piece
        
        if newBoardState.inCheck(player: color(of: piece)) {
            return nil
        }
                
        return newBoardState
    }
}
