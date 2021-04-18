//
//  BoardState.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/10/21.
//

import Dispatch

struct BoardState: Hashable {
    var board: Board = newBoard
    var currentPlayer: Player = .white
    var enPassantSquare: Square? = nil
    var promoting: Square? = nil
    var winner: Player? = nil
    var kingPosition: [Player: Square] = [.white: Square(rank: 7, file: 4), .black: Square(rank: 0, file: 4)]
    var kingSideCastle: [Player: Bool] = [.white: true, .black: true]
    var queenSideCastle: [Player: Bool] = [.white: true, .black: true]
    var captured: [Player: [String]] = [.white: [], .black: []]

    private func pawnAttacks(from: Square) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        let direction = player == .white ? -1 : 1
        
        let toRank = from.rank + direction
        
        if 0...7 ~= toRank && board[toRank][from.file] == "Empty" {
            attacks.append(Square(rank: toRank, file: from.file))
        }
        
        for toFile in [from.file - 1, from.file + 1] {
            if 0...7 ~= toFile {
                if color(of: board[toRank][toFile]) == opponent[player] {
                    attacks.append(Square(rank: toRank, file: toFile))
                } else if let enPassant = enPassantSquare {
                    if enPassant == Square(rank: toRank, file: toFile) {
                        attacks.append(enPassant)
                    }
                }
            }
        }
        
        if from.rank == (player == .white ? 6 : 1) {
            let twoRank = toRank + direction
            
            if 0...7 ~= twoRank && board[twoRank][from.file] == "Empty" && board[toRank][from.file] == "Empty" {
                attacks.append(Square(rank: twoRank, file: from.file))
            }
        }
        
        return attacks
    }
    
    private func knightAttacks(from: Square) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        
        for rankOffset in [-2, -1, 1, 2] {
            for fileOffset in [-2, -1, 1, 2] {
                if abs(fileOffset) != abs(rankOffset) {
                    let toRank = from.rank + rankOffset
                    let toFile = from.file + fileOffset
                    if 0...7 ~= toRank && 0...7 ~= toFile && player != color(of: board[toRank][toFile]) {
                        attacks.append(Square(rank: toRank, file: toFile))
                    }
                }
            }
        }
        
        return attacks
    }
    
    private func rookAttacks(from: Square) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        
        for offset in 1...7 {
            let toFile = from.file - offset
            if !(0...7 ~= toFile) {
                break
            }
            
            let toSquare = board[from.rank][toFile]
            
            if toSquare == "Empty" {
                attacks.append(Square(rank: from.rank, file: toFile))
            } else if player != color(of: board[from.rank][toFile]) {
                attacks.append(Square(rank: from.rank, file: toFile))
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
                attacks.append(Square(rank: from.rank, file: toFile))
            } else if player != color(of: board[from.rank][toFile]) {
                attacks.append(Square(rank: from.rank, file: toFile))
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
                attacks.append(Square(rank: toRank, file: from.file))
            } else if player != color(of: board[toRank][from.file]) {
                attacks.append(Square(rank: toRank, file: from.file))
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
                attacks.append(Square(rank: toRank, file: from.file))
            } else if player != color(of: board[toRank][from.file]) {
                attacks.append(Square(rank: toRank, file: from.file))
                break
            } else {
                break
            }
        }
        
        return attacks
    }
    
    private func bishopAttacks(from: Square) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        
        for offset in 1...7 {
            let toRank = from.rank - offset
            let toFile = from.file - offset
            if !(0...7 ~= toFile) || !(0...7 ~= toRank) {
                break
            }
            
            let toSquare = board[toRank][toFile]
            
            if toSquare == "Empty" {
                attacks.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
                attacks.append(Square(rank: toRank, file: toFile))
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
                attacks.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
                attacks.append(Square(rank: toRank, file: toFile))
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
                attacks.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
                attacks.append(Square(rank: toRank, file: toFile))
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
                attacks.append(Square(rank: toRank, file: toFile))
            } else if player != color(of: board[toRank][toFile]) {
                attacks.append(Square(rank: toRank, file: toFile))
                break
            } else {
                break
            }
        }
        
        return attacks
    }
    
    private func queenAttacks(from: Square) -> [Square] {
        return rookAttacks(from: from) + bishopAttacks(from: from)
    }
    
    private func kingAttacks(from: Square, castling: Bool) -> [Square] {
        var attacks = [Square]()
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
                        attacks.append(Square(rank: toRank, file: toFile))
                    }
                }
            }
        }
        
        if !castling || board[kingRank][4] != king || inCheck(player) {
            return attacks
        }
        
        if board[kingRank][7] == rook && kingSideCastle[player]! && !overCheck(player, file: 5) {
            var canCastle = true
            for file in 5...6 {
                if board[kingRank][file] != "Empty" {
                    canCastle = false
                }
            }
            if canCastle {
                attacks.append(Square(rank: kingRank, file: 6))
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
                attacks.append(Square(rank: kingRank, file: 2))
            }
        }
        
        return attacks
    }
    
    func allAttacks(from: Square, castling: Bool = true) -> [Square] {
        let piece = board[from.rank][from.file]
        
        switch piece.split(separator: " ")[1] {
        case "Pawn":
            return pawnAttacks(from: from)
        case "Knight":
            return knightAttacks(from: from)
        case "Rook":
            return rookAttacks(from: from)
        case "Bishop":
            return bishopAttacks(from: from)
        case "Queen":
            return queenAttacks(from: from)
        case "King":
            return kingAttacks(from: from, castling: castling)
        default:
            return []
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
    
    private mutating func removeEnPassantPawn(for piece: String, from: Square, to: Square) {
        if !piece.contains("Pawn") {
            return
        }
        
        if from.file == to.file || enPassantSquare == nil || enPassantSquare != to {
            return
        }
        
        captured[opponent[currentPlayer]!]!.append(board[from.rank][to.file])
        board[from.rank][to.file] = "Empty"
    }
    
    private mutating func castleRook(for piece: String, from: Square, to: Square) {
        if !piece.contains("King") {
            return
        }
        
        let rook = (color(of: board[from.rank][from.file]) == .white) ? "White Rook" : "Black Rook"
        
        if to.file == from.file + 2 {
            board[from.rank][5] = rook
            board[from.rank][7] = "Empty"
        } else if to.file == from.file - 2 {
            board[from.rank][3] = rook
            board[from.rank][0] = "Empty"
        }
    }
    
    private func promote(_ piece: String, given move: Move) -> String {
        if !piece.contains("Pawn") {
            return piece
        }
                
        if move.to.rank == 0 {
            return move.specialPromote ?? "White Queen"
        }
        
        if move.to.rank == 7 {
            return move.specialPromote ?? "Black Queen"
        }
        
        return piece
    }
    
    func isValidMove(_ move: Move) -> BoardState? {
        let piece = board[move.from.rank][move.from.file]
        
        var newBoardState = self
            
        newBoardState.removeEnPassantPawn(for: piece, from: move.from, to: move.to)
        newBoardState.castleRook(for: piece, from: move.from, to: move.to)
        
        // TODO: factor out
        if newBoardState.board[move.to.rank][move.to.file] != "Empty" {
            newBoardState.captured[opponent[currentPlayer]!]!.append(newBoardState.board[move.to.rank][move.to.file])
        }
        
        newBoardState.board[move.from.rank][move.from.file] = "Empty"
        newBoardState.board[move.to.rank][move.to.file] = promote(piece, given: move)
        newBoardState.promoting = piece != promote(piece, given: move) ? move.to : nil
        
        let player = color(of: piece)
        
        if piece.contains("King") {
            newBoardState.kingPosition[player] = move.to
        }

        if newBoardState.inCheck(player) {
            return nil
        }
        
        return newBoardState
    }
    
    func validOutcomes(for player: Player) -> [(move: Move, newBoardState: BoardState)] {
        var outcomes = [(Move, BoardState)]()
                
        for rank in 0...7 {
            for file in 0...7 {
                let piece = board[rank][file]
                if color(of: piece) == player {
                    let from = Square(rank: rank, file: file)
                    let attacks = allAttacks(from: from)
                    for to in attacks {
                        let move = Move(from: from, to: to, specialPromote: nil)
                        if let newBoardState = isValidMove(move) {
                            outcomes.append((move, newBoardState))
                        }
                    }
                }
            }
        }

        return outcomes
    }
    
    private func canMove(_ player: Player) -> Bool {
        for rank in 0...7 {
            for file in 0...7 {
                let piece = board[rank][file]
                if color(of: piece) == player {
                    let from = Square(rank: rank, file: file)
                    let attacks = allAttacks(from: from)
                    for to in attacks {
                        let move = Move(from: from, to: to, specialPromote: nil)
                        if isValidMove(move) != nil {
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    private func insufficientMaterial() -> Bool {
        let pieces = self.board.flatMap { $0 }.filter { $0 != "Empty" }
        
        if pieces.count > 4 {
            return false
        }
        
        if pieces.count == 4 && pieces.contains("White Bishop") && pieces.contains("Black Bishop") {
            var wbColor = true
            var bbColor = false
            for rank in 0...7 {
                for file in 0...7 {
                    if self.board[rank][file] == "White Bishop" {
                        wbColor = rank % 2 == file % 2
                    }
                    if self.board[rank][file] == "Black Bishop" {
                        bbColor = rank % 2 == file % 2
                    }
                }
            }
            if wbColor == bbColor {
                return true
            }
        }
        
        return !(pieces.count > 3
            || pieces.contains("White Queen") || pieces.contains("White Rook") || pieces.contains("White Pawn")
            || pieces.contains("Black Queen") || pieces.contains("Black Rook") || pieces.contains("Black Pawn"))
    }
    
    private mutating func killKing(_ player: Player) {
        let square = kingPosition[player]!
        
        board[square.rank][square.file] = "Dead " + board[square.rank][square.file]
    }
    
    mutating func killKings() {
        switch winner! {
        case .black:
            killKing(.white)
        case .white:
            killKing(.black)
        case .draw:
            killKing(.white)
            killKing(.black)
        }
    }
    
    mutating func updateBoardState(given move: Move) {
        let piece = board[move.to.rank][move.to.file]
        
        if piece.contains("King") {
            kingSideCastle[currentPlayer] = false
            queenSideCastle[currentPlayer] = false
        }
        
        if piece.contains("Rook") {
            if move.from.file == 7 {
                kingSideCastle[currentPlayer] = false
            } else if move.from.file == 0 {
                queenSideCastle[currentPlayer] = false
            }
        }
        
        enPassantSquare = enPassantSquare(for: piece, from: move.from, to: move.to)
                
        if insufficientMaterial() {
            winner = .draw
            return
        }
        
        currentPlayer = opponent[currentPlayer]!
                        
        if canMove(currentPlayer) {
            return
        }
                
        if !inCheck(currentPlayer) {
            winner = .draw
            return
        }
            
        winner = opponent[currentPlayer]!
    }
    
    private func doubledPawns(_ player: Player) -> Int {
        let pawn = player == .white ? "White Pawn" : "Black Pawn"
        var counter = 0
        
        for file in 0...7 {
            var pawnFound = false
            for rank in 0...7 {
                if board[rank][file] == pawn {
                    if pawnFound {
                        counter += 1
                        break
                    } else {
                        pawnFound = true
                    }
                }
            }
        }
        
        return counter
    }
    
    private func positionalScore() -> Float {
        var score: Float = 0.0
        
        if inCheck(.white) {
            score -= inCheckValue
        }
        
        if inCheck(.black) {
            score += inCheckValue
        }
        
        score -= Float(doubledPawns(.white)) * doublePawnValue
        score += Float(doubledPawns(.black)) * doublePawnValue
        
        let whiteCounts = Dictionary(allAttacks(for: .white).map { ($0, 1) }, uniquingKeysWith: +)
        let blackCounts = Dictionary(allAttacks(for: .black).map { ($0, 1) }, uniquingKeysWith: +)
        
        for rank in [3, 4] {
            for file in [3, 4] {
                let square = Square(rank: rank, file: file)
                score += Float((whiteCounts[square] ?? 0) - (blackCounts[square] ?? 0)) * centerControlValue / 4
            }
        }
              
        return score
    }

    func evaluateBoardState() -> Float {
        var score: Float = 0
        
        if winner != nil {
            return winningScore[winner!]!
        }
        
        for rank in 0...7 {
            for file in 0...7 {
                score += Float(pieceValues[board[rank][file]]!)
            }
        }
                
        score += positionalScore()
                
        return score
    }
}


