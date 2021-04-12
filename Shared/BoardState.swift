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
    var checkmate = false
    var stalemate = false
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
    
    private func kingMoves(from: Square, castling: Bool) -> [Square] {
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
        
        if !castling || board[kingRank][4] != king || inCheck(player) {
            return moves
        }
        
        if board[kingRank][7] == rook && kingSideCastle[player]! && !overCheck(player, file: 5) {
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
        
        if board[kingRank][0] == rook && queenSideCastle[player]! && !overCheck(player, file: 3) {
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
    
    private func allAttacks(from: Square, castling: Bool = true) -> [Square] {
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
        } else {
            return kingMoves(from: from, castling: castling)
        }
    }
    
    private func allAttacks(for player: Player, castling: Bool = true) -> [Square] {
        var attacks = [Square]()
        
        for rank in 0...7 {
            for file in 0...7 {
                if color(of: board[rank][file]) == player {
                    attacks += allAttacks(from: Square(rank: rank, file: file), castling: castling)
                }
            }
        }
        
        return attacks
    }
    
    private func inCheck(_ player: Player) -> Bool {
        let attacks = allAttacks(for: opponent[player]!, castling: false)
        
        return attacks.contains(kingPosition[player]!)
    }
    
    private func overCheck(_ player: Player, file: Int) -> Bool {
        var castlingBoardState = self
        let rank = (player == .white) ? 7 : 0
        
        castlingBoardState.board[rank][file] = board[rank][4]
        castlingBoardState.board[rank][4] = "Empty"

        let attacks = castlingBoardState.allAttacks(for: opponent[player]!, castling: false)
        
        return attacks.contains(Square(rank: rank, file: file))
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
    
    private func isValidMove(for piece: String, from: Square, to: Square) -> BoardState? {
        var newBoardState = self
            .removeEnPassantPawn(for: piece, from: from, to: to)
            .castleRook(for: piece, from: from, to: to)
        
        let piece = promote(piece, to: to)
        let player = color(of: piece)

        newBoardState.board[from.rank][from.file] = "Empty"
        newBoardState.board[to.rank][to.file] = piece
        
        if piece.contains("King") {
            newBoardState.kingPosition[player] = to
        }

        if newBoardState.inCheck(player) {
            return nil
        }
        
        return newBoardState
    }
    
    func allValidMoves(for player: Player) -> [Square: [Square]] {
        var moves = [Square: [Square]]()
        
        for rank in 0...7 {
            for file in 0...7 {
                let piece = board[rank][file]
                if color(of: piece) == player {
                    let from = Square(rank: rank, file: file)
                    let attacks = allAttacks(from: from).filter { isValidMove(for: piece, from: from, to: $0) != nil }
                    if !attacks.isEmpty {
                        moves[from] = attacks
                    }
                }
            }
        }
        
        return moves
    }
    
    // TODO: check draws other than stalemate
    func makeMove(for piece: String, from: Square, to: Square) -> BoardState? {
        if !allAttacks(from: from).contains(to) {
            return nil
        }
        
        var newBoardState = isValidMove(for: piece, from: from, to: to)
        
        if newBoardState == nil {
            return nil
        }
                
        if piece.contains("King") {
            newBoardState!.kingSideCastle[currentPlayer] = false
            newBoardState!.queenSideCastle[currentPlayer] = false
        }
        
        if piece.contains("Rook") {
            if from.file == 7 {
                newBoardState!.kingSideCastle[currentPlayer] = false
            } else if from.file == 0 {
                newBoardState!.queenSideCastle[currentPlayer] = false
            }
        }
        
        newBoardState!.enPassantSquare = enPassantSquare(for: piece, from: from, to: to)
        newBoardState!.currentPlayer = opponent[currentPlayer]!
        
        if newBoardState!.allValidMoves(for: newBoardState!.currentPlayer).isEmpty {
            if newBoardState!.inCheck(newBoardState!.currentPlayer) {
                newBoardState!.checkmate = true
            } else {
                newBoardState!.stalemate = true
            }
        }
                
        return newBoardState!
    }
}
