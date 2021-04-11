//
//  BoardState.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/10/21.
//

struct BoardState {
    var board: Board = newBoard
    var currentPlayer: Player = .white
    var enPassantSquare: Square? = nil
    
    // TODO: promotion
    private func pawnMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: self.board[from.rank][from.file])
        let direction = player == .white ? -1 : 1
        
        var toRank = from.rank + direction
        
        if 0...7 ~= toRank && self.board[toRank][from.file] == "Empty" {
            moves.append(Square(rank: toRank, file: from.file))
        }
        
        for toFile in [from.file - 1, from.file + 1] {
            if 0...7 ~= toFile {
                if color(of: self.board[toRank][toFile]) == opponent[player] {
                    moves.append(Square(rank: toRank, file: toFile))
                } else if let enPassant = self.enPassantSquare {
                    if enPassant == Square(rank: toRank, file: toFile) {
                        moves.append(enPassant)
                    }
                }
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
    
    private func enPassantSquare(for piece: String, from: Square, to: Square) -> Square? {
        if !piece.contains("Pawn") {
            return nil
        }
        
        if abs(from.rank - to.rank) != 2 {
            return nil
        }
        
        return Square(rank: (from.rank + to.rank) / 2, file: from.file)
    }
    
    private func removeEnPassantPawn(for piece: String, from: Square, to: Square) -> BoardState {
        if !piece.contains("Pawn") {
            return self
        }
        
        if from.file == to.file {
            return self
        }
        
        if enPassantSquare == nil || enPassantSquare != to {
            return self
        }
        
        var newBoardState = self
        newBoardState.board[from.rank][to.file] = "Empty"
        
        return  newBoardState
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
                
        var newBoardState = self.removeEnPassantPawn(for: piece, from: from, to: to)
        
        newBoardState.board[from.rank][from.file] = "Empty"
        newBoardState.board[to.rank][to.file] = piece

        if newBoardState.inCheck(player: color(of: piece)) {
            return nil
        }
        
        newBoardState.enPassantSquare = enPassantSquare(for: piece, from: from, to: to)
        newBoardState.currentPlayer = opponent[self.currentPlayer]!
                
        return newBoardState
    }
}
