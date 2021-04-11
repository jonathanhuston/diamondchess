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
        
        let toRank = from.rank + direction
        
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
            let twoRank = toRank + direction
            
            if 0...7 ~= twoRank && self.board[twoRank][from.file] == "Empty" && self.board[toRank][from.file] == "Empty" {
                moves.append(Square(rank: twoRank, file: from.file))
            }
        }
        
        return moves
    }
    
    private func knightMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: self.board[from.rank][from.file])
        
        for rankOffset in [-2, -1, 1, 2] {
            for fileOffset in [-2, -1, 1, 2] {
                if abs(fileOffset) != abs(rankOffset) {
                    let toRank = from.rank + rankOffset
                    let toFile = from.file + fileOffset
                    if 0...7 ~= toRank && 0...7 ~= toFile && player != color(of: self.board[toRank][toFile]) {
                        moves.append(Square(rank: toRank, file: toFile))
                    }
                }
            }
        }
        
        return moves
    }
    
    private func rookMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: self.board[from.rank][from.file])
        
        for offset in 1...7 {
            let toFile = from.file - offset
            if !(0...7 ~= toFile) {
                break
            }
            
            let toSquare = self.board[from.rank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: from.rank, file: toFile))
            } else if player != color(of: self.board[from.rank][toFile]) {
                moves.append(Square(rank: from.rank, file: toFile))
                break
            } else {
                break
            }
        }
        
        for offset in 1...7 {
            let toFile = from.file + offset
            if !(0...7 ~= toFile) {
                break
            }
            
            let toSquare = self.board[from.rank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: from.rank, file: toFile))
            } else if player != color(of: self.board[from.rank][toFile]) {
                moves.append(Square(rank: from.rank, file: toFile))
                break
            } else {
                break
            }
        }
        
        for offset in 1...7 {
            let toRank = from.rank - offset
            if !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = self.board[toRank][from.file]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: from.file))
            } else if player != color(of: self.board[toRank][from.file]) {
                moves.append(Square(rank: toRank, file: from.file))
                break
            } else {
                break
            }
        }
        
        for offset in 1...7 {
            let toRank = from.rank + offset
            if !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = self.board[toRank][from.file]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: from.file))
            } else if player != color(of: self.board[toRank][from.file]) {
                moves.append(Square(rank: toRank, file: from.file))
                break
            } else {
                break
            }
        }
        
        return moves
    }
    
    private func bishopMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: self.board[from.rank][from.file])
        
        for offset in 1...7 {
            let toRank = from.rank - offset
            let toFile = from.file - offset
            if !(0...7 ~= toFile) || !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = self.board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: self.board[from.rank][toFile]) {
                moves.append(Square(rank: toRank, file: toFile))
                break
            } else {
                break
            }
        }
        
        for offset in 1...7 {
            let toRank = from.rank - offset
            let toFile = from.file + offset
            if !(0...7 ~= toFile) || !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = self.board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: self.board[from.rank][toFile]) {
                moves.append(Square(rank: toRank, file: toFile))
                break
            } else {
                break
            }
        }
        
        for offset in 1...7 {
            let toRank = from.rank + offset
            let toFile = from.file - offset
            if !(0...7 ~= toFile) || !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = self.board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: self.board[from.rank][toFile]) {
                moves.append(Square(rank: toRank, file: toFile))
                break
            } else {
                break
            }
        }
        
        for offset in 1...7 {
            let toRank = from.rank + offset
            let toFile = from.file + offset
            if !(0...7 ~= toFile) || !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = self.board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: self.board[from.rank][toFile]) {
                moves.append(Square(rank: toRank, file: toFile))
                break
            } else {
                break
            }
        }
        
        return moves
    }
    
    private func queenMoves(from: Square) -> [Square] {
        return rookMoves(from: from) + bishopMoves(from: from)
    }
    
    // TODO: castling
    private func kingMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: self.board[from.rank][from.file])
        
        for rankOffset in -1...1 {
            for fileOffset in -1...1 {
                if (rankOffset != 0 || fileOffset != 0) {
                    let toRank = from.rank + rankOffset
                    let toFile = from.file + fileOffset
                    if 0...7 ~= toRank && 0...7 ~= toFile && player != color(of: self.board[toRank][toFile]) {
                        moves.append(Square(rank: toRank, file: toFile))
                    }
                }
            }
        }
        
        return moves
    }
    
    private func canMove(piece: String, from: Square, to: Square) -> Bool {
        if piece.contains("Pawn") {
            return pawnMoves(from: from).contains(to)
        } else if piece.contains("Knight") {
            return knightMoves(from: from).contains(to)
        } else if piece.contains("Rook") {
            return rookMoves(from: from).contains(to)
        } else if piece.contains("Bishop") {
            return bishopMoves(from: from).contains(to)
        } else if piece.contains("Queen") {
            return queenMoves(from: from).contains(to)
        } else if piece.contains("King") {
            return kingMoves(from: from).contains(to)
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
