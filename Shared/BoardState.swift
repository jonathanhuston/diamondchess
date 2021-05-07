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
    var allAttacks = [Player: [Square]]()
    var inCheck: [Player: Bool] = [.white: false, .black: false]
    var kingPosition: [Player: Square] = [.white: Square(rank: 7, file: 4), .black: Square(rank: 0, file: 4)]
    var canCastleKingSide: [Player: Bool] = [.white: true, .black: true]
    var canCastleQueenSide: [Player: Bool] = [.white: true, .black: true]
    var failedToCastle: [Player: Bool] = [.white: false, .black: false]
    var captured: [Player: [String]] = [.white: [], .black: []]

    private func pawnAttacks(from: Square) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        let direction = player == .white ? -1 : 1
        
        let toRank = from.rank + direction
        
        if toRank >= 0 && toRank <= 7 && board[toRank][from.file] == "Empty" {
            attacks.append(Square(rank: toRank, file: from.file))
        }
        
        for toFile in [from.file - 1, from.file + 1] {
            if toFile >= 0 && toFile <= 7 {
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
            
            if twoRank >= 0 && twoRank <= 7 && board[twoRank][from.file] == "Empty" && board[toRank][from.file] == "Empty" {
                attacks.append(Square(rank: twoRank, file: from.file))
            }
        }
        
        return attacks
    }
    
    private func knightAttacks(from: Square) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        
        for offset in [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)] {
            let toRank = from.rank + offset.0
            let toFile = from.file + offset.1
            if toRank >= 0 && toRank <= 7 && toFile >= 0 && toFile <= 7 && player != color(of: board[toRank][toFile]) {
                attacks.append(Square(rank: toRank, file: toFile))
            }
        }
        
        return attacks
    }
    
    private func straightAttacks(from: Square, given offsets: [(Int, Int)]) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        
        for offset in offsets {
            var toRank = from.rank + offset.0
            var toFile = from.file + offset.1
            while toRank >= 0 && toRank <= 7 && toFile >= 0 && toFile <= 7 {
                let toSquare = board[toRank][toFile]
                
                if toSquare == "Empty" {
                    attacks.append(Square(rank: toRank, file: toFile))
                } else if player != color(of: board[toRank][toFile]) {
                    attacks.append(Square(rank: toRank, file: toFile))
                    break
                } else {
                    break
                }
                
                toRank += offset.0
                toFile += offset.1
            }
        }
        
        return attacks
    }
    
    private func rookAttacks(from square: Square) -> [Square] {
        straightAttacks(from: square, given: [(-1, 0), (1, 0), (0, -1), (0, 1)])
    }
    
    private func bishopAttacks(from square: Square) -> [Square] {
        straightAttacks(from: square, given: [(-1, -1), (-1, 1), (1, -1), (1, 1)])
    }
    
    private func queenAttacks(from square: Square) -> [Square] {
        rookAttacks(from: square) + bishopAttacks(from: square)
    }
    
    private func kingAttacks(from: Square, castling: Bool) -> [Square] {
        var attacks = [Square]()
        let player = color(of: board[from.rank][from.file])
        let kingRank = (player == .white) ? 7 : 0
        let king = (player == .white) ? "White King" : "Black King"
        let rook = (player == .white) ? "White Rook" : "Black Rook"
        
        for offset in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)] {
            let toRank = from.rank + offset.0
            let toFile = from.file + offset.1
            if toRank >= 0 && toRank <= 7 && toFile >= 0 && toFile <= 7 && player != color(of: board[toRank][toFile]) {
                attacks.append(Square(rank: toRank, file: toFile))
            }
        }
                
        if !castling || board[kingRank][4] != king || inCheck[player]! {
            return attacks
        }
                
        if board[kingRank][7] == rook && canCastleKingSide[player]! && !overCheck(player, file: 5) {
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
        
        if board[kingRank][0] == rook && canCastleQueenSide[player]! && !overCheck(player, file: 3) {
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
    
    private func allAttacks(for player: Player) -> [Square] {
        var attacks = [Square]()
        
        for rank in 0...7 {
            for file in 0...7 {
                if color(of: board[rank][file]) == player {
                    attacks += allAttacks(from: Square(rank: rank, file: file), castling: false)
                }
            }
        }
        
        return attacks
    }
    
    private func shortRangeAttack(on square: Square, with piece: String, given offsets: [(Int, Int)]) -> Bool {
        for offset in offsets {
            let rank = square.rank + offset.0
            let file = square.file + offset.1
            if rank >= 0 && rank <= 7 && file >= 0 && file <= 7 && board[rank][file] == piece {
                return true
            }
        }
        
        return false
    }
    
    private func longRangeAttack(on square: Square, with piece: String, or queen: String, given offsets: [(Int, Int)]) -> Bool {
        for offset in offsets {
            var rank = square.rank + offset.0
            var file = square.file + offset.1
            direction: while rank >= 0 && rank <= 7 && file >= 0 && file <= 7 {
                let attacker = board[rank][file]
                
                switch attacker {
                case piece, queen:
                    return true
                case "Empty":
                    rank += offset.0
                    file += offset.1
                default:
                    break direction
                }
            }
        }
        
        return false
    }
    
    private func underAttack(square: Square, by player: Player) -> Bool {
        let king = (player == .white) ? "White King" : "Black King"
        let queen = (player == .white) ? "White Queen" : "Black Queen"
        let bishop = (player == .white) ? "White Bishop" : "Black Bishop"
        let knight = (player == .white) ? "White Knight" : "Black Knight"
        let rook = (player == .white) ? "White Rook" : "Black Rook"
        let pawn = (player == .white) ? "White Pawn" : "Black Pawn"
        
        let pawnOffsets = (player == .white) ? [(1, -1), (1, 1)] : [(-1, -1), (-1, 1)]
        
        return
            shortRangeAttack(on: square, with: pawn, given: pawnOffsets) ||
            longRangeAttack(on: square, with: rook, or: queen, given: [(-1, 0), (1, 0), (0, -1), (0, 1)]) ||
            longRangeAttack(on: square, with: bishop, or: queen, given: [(-1, -1), (-1, 1), (1, -1), (1, 1)]) ||
            shortRangeAttack(on: square, with: knight, given: [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]) ||
            shortRangeAttack(on: square, with: king, given: [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)])
    }
    
    private func inCheck(_ player: Player) -> Bool {
        guard let attacks = allAttacks[opponent[player]!] else {
            return underAttack(square: kingPosition[player]!, by: opponent[player]!)
        }

        return attacks.contains(kingPosition[player]!)
    }
    
    private func overCheck(_ player: Player, file: Int) -> Bool {
        var castlingBoardState = self
        let rank = (player == .white) ? 7 : 0
        
        castlingBoardState.board[rank][file] = board[rank][4]
        castlingBoardState.board[rank][4] = "Empty"
        
        return underAttack(square: Square(rank: rank, file: file), by: opponent[player]!)
    }
    
    func enPassantSquare(for move: Move) -> Square? {
        if abs(move.from.rank - move.to.rank) != 2 {
            return nil
        }
        
        return Square(rank: (move.from.rank + move.to.rank) / 2, file: move.from.file)
    }
    
    private mutating func removeEnPassantPawn(for move: Move) {
        if move.from.file == move.to.file || enPassantSquare == nil || enPassantSquare != move.to {
            return
        }
        
        captured[opponent[currentPlayer]!]!.append(board[move.from.rank][move.to.file])
        board[move.from.rank][move.to.file] = "Empty"
    }
    
    private func promote(_ piece: String, given move: Move) -> String {
        if piece != "White Pawn" && piece != "Black Pawn" {
            return piece
        }
                
        if move.to.rank == 0 {
            return "White Queen"
        }
        
        if move.to.rank == 7 {
            return "Black Queen"
        }
        
        return piece
    }
    
    private mutating func castle(for move: Move) {
        let rook = currentPlayer == .white ? "White Rook" : "Black Rook"
        
        if move.to.file == move.from.file + 2 {
            board[move.from.rank][5] = rook
            board[move.from.rank][7] = "Empty"
        } else if move.to.file == move.from.file - 2 {
            board[move.from.rank][3] = rook
            board[move.from.rank][0] = "Empty"
        } else {
            failedToCastle[currentPlayer] = true
        }
    }
    
    func isValidMove(_ move: Move) -> BoardState? {
        let piece = board[move.from.rank][move.from.file]
        
        var newBoardState = self
        
        if piece == "White Pawn" || piece == "Black Pawn" {
            newBoardState.removeEnPassantPawn(for: move)
        }
            
        if piece == "White King" || piece == "Black King" {
            newBoardState.kingPosition[currentPlayer] = move.to
            if canCastleKingSide[currentPlayer]! || canCastleQueenSide[currentPlayer]! {
                newBoardState.castle(for: move)
            }
        }
        
        let capturedPiece = newBoardState.board[move.to.rank][move.to.file]
        if capturedPiece != "Empty" {
            newBoardState.captured[opponent[currentPlayer]!]!.append(capturedPiece)
        }
        
        newBoardState.board[move.from.rank][move.from.file] = "Empty"
        
        let promotedPiece = promote(piece, given: move)
        newBoardState.board[move.to.rank][move.to.file] = promotedPiece
        newBoardState.promoting = piece != promotedPiece ? move.to : nil
                
        newBoardState.allAttacks[.white] = newBoardState.allAttacks(for: .white)
        newBoardState.allAttacks[.black] = newBoardState.allAttacks(for: .black)
        
        newBoardState.inCheck[currentPlayer] = newBoardState.inCheck(currentPlayer)

        if newBoardState.inCheck[currentPlayer]! {
            return nil
        }
        
        newBoardState.inCheck[opponent[currentPlayer]!] = newBoardState.inCheck(opponent[currentPlayer]!)
        
        return newBoardState
    }
    
    func validOutcomes(for player: Player) -> [(move: Move, newBoardState: BoardState)] {
        var outcomes = [(Move, BoardState)]()
                
        for rank in 0...7 {
            for file in 0...7 {
                if color(of: board[rank][file]) == player {
                    let from = Square(rank: rank, file: file)
                    let attacks = allAttacks(from: from)
                    for to in attacks {
                        let move = Move(from: from, to: to)
                        if let newBoardState = isValidMove(move) {
                            outcomes.append((move, newBoardState))
                            if let promoting = newBoardState.promoting {
                                var piece = newBoardState.board[promoting.rank][promoting.file]
                                for _ in 1...3 {
                                    var promotingBoardState = newBoardState
                                    piece = nextPromotionPiece(piece)
                                    promotingBoardState.board[promoting.rank][promoting.file] = piece
                                    promotingBoardState.allAttacks[player] = promotingBoardState.allAttacks(for: player)
                                    promotingBoardState.inCheck[opponent[player]!] = newBoardState.inCheck(opponent[player]!)
                                    outcomes.append((move, promotingBoardState))
                                }
                            }
                        }
                    }
                }
            }
        }

        return outcomes
    }
    
    func canMove(_ player: Player) -> Bool {
        for rank in 0...7 {
            for file in 0...7 {
                if color(of: board[rank][file]) == player {
                    let from = Square(rank: rank, file: file)
                    let attacks = allAttacks(from: from)
                    for to in attacks {
                        let move = Move(from: from, to: to)
                        if isValidMove(move) != nil {
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func insufficientMaterial() -> Bool {
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
    
    private func inCheckScore() -> Float {
        if inCheck[.white]! {
            return -inCheckValue
        } else if inCheck[.black]! {
            return inCheckValue
        }
        
        return 0
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
    
    private func centerControlScore() -> Float {
        var score: Float = 0.0
        
//        let whiteCounts = Dictionary(allAttacks[.white]!.map { ($0, 1) }, uniquingKeysWith: +)
//        let blackCounts = Dictionary(allAttacks[.black]!.map { ($0, 1) }, uniquingKeysWith: +)

        for rank in [3, 4] {
            for file in [3, 4] {
//                let square = Square(rank: rank, file: file)
//                score += Float((whiteCounts[square] ?? 0) - (blackCounts[square] ?? 0)) * centerControlValue / 4
                let color = color(of: board[rank][file])
                if color == .white {
                    score += centerControlValue
                } else if color == .black {
                    score -= centerControlValue
                }
            }
        }
        
        return score
    }
    
    private func positionalScore() -> Float {
        return
            inCheckScore() +
            (failedToCastle[.black]! ? failedToCastleValue : 0) - (failedToCastle[.white]! ? failedToCastleValue : 0) +
            Float((doubledPawns(.black) - doubledPawns(.white))) * doublePawnValue +
            centerControlScore() +
            Float((allAttacks[.white]!.count - allAttacks[.black]!.count)) * attackValue
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

