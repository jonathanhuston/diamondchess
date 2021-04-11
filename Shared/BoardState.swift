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
    var kingPosition: [Player: Square] = [.white: Square(rank: 7, file: 4), .black: Square(rank: 0, file: 4)]
    var kingSideCastle: [Player: Bool] = [.white: true, .black: true]
    var queenSideCastle: [Player: Bool] = [.white: true, .black: true]

    private func pawnMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: board[from.rank][from.file])
        let direction = player == .white ? -1 : 1
        
        let toRank = from.rank + direction
        
        if 0...7 ~= toRank && board[toRank][from.file] == "Empty" {
            moves.append(Square(rank: toRank, file: from.file))
        }
        
        for toFile in [from.file - 1, from.file + 1] {
            if 0...7 ~= toFile {
                if color(of: board[toRank][toFile]) == opponent[player] {
                    moves.append(Square(rank: toRank, file: toFile))
                } else if let enPassant = enPassantSquare {
                    if enPassant == Square(rank: toRank, file: toFile) {
                        moves.append(enPassant)
                    }
                }
            }
        }
        
        if from.rank == (player == .white ? 6 : 1) {
            let twoRank = toRank + direction
            
            if 0...7 ~= twoRank && board[twoRank][from.file] == "Empty" && board[toRank][from.file] == "Empty" {
                moves.append(Square(rank: twoRank, file: from.file))
            }
        }
        
        return moves
    }
    
    private func knightMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: board[from.rank][from.file])
        
        for rankOffset in [-2, -1, 1, 2] {
            for fileOffset in [-2, -1, 1, 2] {
                if abs(fileOffset) != abs(rankOffset) {
                    let toRank = from.rank + rankOffset
                    let toFile = from.file + fileOffset
                    if 0...7 ~= toRank && 0...7 ~= toFile && player != color(of: board[toRank][toFile]) {
                        moves.append(Square(rank: toRank, file: toFile))
                    }
                }
            }
        }
        
        return moves
    }
    
    private func rookMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: board[from.rank][from.file])
        
        for offset in 1...7 {
            let toFile = from.file - offset
            if !(0...7 ~= toFile) {
                break
            }
            
            let toSquare = board[from.rank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: from.rank, file: toFile))
            } else if player != color(of: board[from.rank][toFile]) {
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
            
            let toSquare = board[from.rank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: from.rank, file: toFile))
            } else if player != color(of: board[from.rank][toFile]) {
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
            
            let toSquare = board[toRank][from.file]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: from.file))
            } else if player != color(of: board[toRank][from.file]) {
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
            
            let toSquare = board[toRank][from.file]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: from.file))
            } else if player != color(of: board[toRank][from.file]) {
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
        let player = color(of: board[from.rank][from.file])
        
        for offset in 1...7 {
            let toRank = from.rank - offset
            let toFile = from.file - offset
            if !(0...7 ~= toFile) || !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
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
            
            let toSquare = board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
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
            
            let toSquare = board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
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
            
            let toSquare = board[toRank][toFile]
            
            if toSquare == "Empty" {
                moves.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
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
    
    // TODO: check if castling allowed
    private func kingMoves(from: Square) -> [Square] {
        var moves = [Square]()
        let player = color(of: board[from.rank][from.file])
        let kingRank = (player == .white) ? 7 : 0
        let king = (player == .white) ? "White King" : "Black King"
        let rook = (player == .white) ? "White Rook" : "Black Rook"
        
        for rankOffset in -1...1 {
            for fileOffset in -1...1 {
                if (rankOffset != 0 || fileOffset != 0) {
                    let toRank = from.rank + rankOffset
                    let toFile = from.file + fileOffset
                    if 0...7 ~= toRank && 0...7 ~= toFile && player != color(of: board[toRank][toFile]) {
                        moves.append(Square(rank: toRank, file: toFile))
                    }
                }
            }
        }
        
        if board[kingRank][4] == king && board[kingRank][7] == rook && kingSideCastle[player]! && !inCheck(player) {
            var canCastle = true
            for file in 5...6 {
                if board[kingRank][file] != "Empty" {
                    canCastle = false
                }
            }
            if canCastle {
                moves.append(Square(rank: kingRank, file: 6))
            }
        }
        
        if board[kingRank][4] == king && board[kingRank][0] == rook && queenSideCastle[player]! && !inCheck(player) {
            var canCastle = true
            for file in 1...3 {
                if board[kingRank][file] != "Empty" {
                    canCastle = false
                }
            }
            if canCastle {
                moves.append(Square(rank: kingRank, file: 2))
            }
        }
        
        return moves
    }
    
    private func allMoves(from: Square, includeKing: Bool = true) -> [Square] {
        let piece = board[from.rank][from.file]
        
        if piece.contains("Pawn") {
            return pawnMoves(from: from)
        } else if piece.contains("Knight") {
            return knightMoves(from: from)
        } else if piece.contains("Rook") {
            return rookMoves(from: from)
        } else if piece.contains("Bishop") {
            return bishopMoves(from: from)
        } else if piece.contains("Queen") {
            return queenMoves(from: from)
        }
        
        if includeKing {
            return kingMoves(from: from)
        } else {
            return []
        }
    }
    
    private func allMoves(for player: Player, includeKing: Bool = true) -> [Square] {
        var moves = [Square]()
        
        for rank in 0...7 {
            for file in 0...7 {
                if color(of: board[rank][file]) == player {
                    moves += allMoves(from: Square(rank: rank, file: file), includeKing: includeKing)
                }
            }
        }
        
        return moves
    }
    
    private func canMove(from: Square, to: Square) -> Bool {
        return allMoves(from: from).contains(to)
    }
    
    private func inCheck(_ player: Player) -> Bool {
        let moves = allMoves(for: opponent[player]!, includeKing: false)
        
        return moves.contains(kingPosition[player]!)
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
    
    private func castleRook(for piece: String, from: Square, to: Square) -> BoardState {
        if !piece.contains("King") {
            return self
        }
        
        var newBoardState = self
        let rook = (color(of: board[from.rank][from.file]) == .white) ? "White Rook" : "Black Rook"
        
        if to.file == from.file + 2 {
            newBoardState.board[from.rank][5] = rook
            newBoardState.board[from.rank][7] = "Empty"
        } else if to.file == from.file - 2 {
            newBoardState.board[from.rank][3] = rook
            newBoardState.board[from.rank][0] = "Empty"
        }
        
        return newBoardState
    }
    
    // TODO: promote to other pieces
    private func promote(_ piece: String, to: Square) -> String {
        if !piece.contains("Pawn") {
            return piece
        }
                
        if to.rank == 0 {
            return "White Queen"
        }
        
        if to.rank == 7 {
            return "Black Queen"
        }
        
        return piece
    }
    
    func isValidMove(for piece: String, from: Square, to: Square) -> BoardState? {
        if !canMove(from: from, to: to) {
            return nil
        }
                
        var newBoardState = self
            .removeEnPassantPawn(for: piece, from: from, to: to)
            .castleRook(for: piece, from: from, to: to)
        
        let piece = promote(piece, to: to)
        let player = color(of: piece)

        newBoardState.board[from.rank][from.file] = "Empty"
        newBoardState.board[to.rank][to.file] = piece
        
        if piece.contains("King") {
            newBoardState.kingPosition[player] = to
            newBoardState.kingSideCastle[player] = false
            newBoardState.queenSideCastle[player] = false
        }

        if newBoardState.inCheck(player) {
            return nil
        }
        
        if piece.contains("Rook") {
            if from.file == 7 {
                newBoardState.kingSideCastle[player] = false
            }
            if from.file == 0 {
                newBoardState.queenSideCastle[player] = false
            }
        }
        
        newBoardState.enPassantSquare = enPassantSquare(for: piece, from: from, to: to)
        newBoardState.currentPlayer = opponent[currentPlayer]!
                
        return newBoardState
    }
}
