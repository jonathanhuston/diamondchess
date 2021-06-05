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
    var allDefenses = [Player: [Square]]()
    var inCheck: [Player: Bool] = [.white: false, .black: false]
    var kingPosition: [Player: Square] = [.white: Square(rank: 7, file: 4), .black: Square(rank: 0, file: 4)]
    var canCastleKingSide: [Player: Bool] = [.white: true, .black: true]
    var canCastleQueenSide: [Player: Bool] = [.white: true, .black: true]
    var castled: [Player: Float] = [.white: 0, .black: 0]
    var failedToCastle: [Player: Float] = [.white: 0, .black: 0]
    var captured: [Player: [String]] = [.white: [], .black: []]
    
    var endgame: Bool {
        32 - captured[.white]!.count - captured[.black]!.count <= endgamePieces
    }

    private func pawnAttacksAndDefenses(from: Square) -> (attacks: [Square], defenses: [Square]) {
        var attacks = [Square]()
        var defenses = [Square]()
        let player = color[board[from.rank][from.file]]!
        let direction = player == .white ? -1 : 1
        
        let toRank = from.rank + direction
        
        if toRank >= 0 && toRank <= 7 && board[toRank][from.file] == "Empty" {
            attacks.append(Square(rank: toRank, file: from.file))
        }
        
        for toFile in [from.file - 1, from.file + 1] {
            if toFile >= 0 && toFile <= 7 {
                let color = color[board[toRank][toFile]]
                let square = Square(rank: toRank, file: toFile)
                if color == player {
                    defenses.append(square)
                } else if color == opponent[player] {
                    attacks.append(square)
                } else if let enPassant = enPassantSquare {
                    if enPassant == square {
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
        
        return (attacks, defenses)
    }
    
    private func knightAttacksAndDefenses(from: Square) -> (attacks: [Square], defenses: [Square]) {
        var attacks = [Square]()
        var defenses = [Square]()
        let player = color[board[from.rank][from.file]]
        
        for offset in [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)] {
            let toRank = from.rank + offset.0
            let toFile = from.file + offset.1
            if toRank >= 0 && toRank <= 7 && toFile >= 0 && toFile <= 7 {
                let color = color[board[toRank][toFile]]
                let square = Square(rank: toRank, file: toFile)
                if color == player {
                    defenses.append(square)
                } else {
                    attacks.append(square)
                }
            }
        }
        
        return (attacks, defenses)
    }
    
    private func straightAttacksAndDefenses(from: Square, given offsets: [(Int, Int)]) -> (attacks: [Square], defenses: [Square]) {
        var attacks = [Square]()
        var defenses = [Square]()
        let player = color[board[from.rank][from.file]]
        
        for offset in offsets {
            var toRank = from.rank + offset.0
            var toFile = from.file + offset.1
            while toRank >= 0 && toRank <= 7 && toFile >= 0 && toFile <= 7 {
                let toSquare = board[toRank][toFile]
                
                if toSquare == "Empty" {
                    attacks.append(Square(rank: toRank, file: toFile))
                } else if player != color[board[toRank][toFile]] {
                    attacks.append(Square(rank: toRank, file: toFile))
                    break
                } else {
                    defenses.append(Square(rank: toRank, file: toFile))
                    break
                }
                
                toRank += offset.0
                toFile += offset.1
            }
        }
        
        return (attacks, defenses)
    }
    
    private func rookAttacksAndDefenses(from square: Square) -> (attacks: [Square], defenses: [Square]) {
        straightAttacksAndDefenses(from: square, given: [(-1, 0), (1, 0), (0, -1), (0, 1)])
    }
    
    private func bishopAttacksAndDefenses(from square: Square) -> (attacks: [Square], defenses: [Square]) {
        straightAttacksAndDefenses(from: square, given: [(-1, -1), (-1, 1), (1, -1), (1, 1)])
    }
    
    private func queenAttacksAndDefenses(from square: Square) -> (attacks: [Square], defenses: [Square]) {
        (rookAttacksAndDefenses(from: square).attacks + bishopAttacksAndDefenses(from: square).attacks,
         rookAttacksAndDefenses(from: square).defenses + bishopAttacksAndDefenses(from: square).defenses)
    }
    
    private func kingAttacksAndDefenses(from: Square, castling: Bool) -> (attacks: [Square], defenses: [Square]) {
        var attacks = [Square]()
        var defenses = [Square]()
        let player = color[board[from.rank][from.file]]!
        let kingRank = (player == .white) ? 7 : 0
        let king = (player == .white) ? "White King" : "Black King"
        let rook = (player == .white) ? "White Rook" : "Black Rook"
        
        for offset in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)] {
            let toRank = from.rank + offset.0
            let toFile = from.file + offset.1
            if toRank >= 0 && toRank <= 7 && toFile >= 0 && toFile <= 7 {
                let color = color[board[toRank][toFile]]
                let square = Square(rank: toRank, file: toFile)
                if color == player {
                    defenses.append(square)
                } else {
                    attacks.append(square)
                }
            }
        }
                
        if !castling || board[kingRank][4] != king || inCheck[player]! {
            return (attacks, defenses)
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
        
        return (attacks, defenses)
    }
    
    func allAttacksAndDefenses(from: Square, castling: Bool = true) -> (attacks: [Square], defenses: [Square]) {
        
        switch kind[board[from.rank][from.file]] {
        case "Pawn":
            return pawnAttacksAndDefenses(from: from)
        case "Knight":
            return knightAttacksAndDefenses(from: from)
        case "Rook":
            return rookAttacksAndDefenses(from: from)
        case "Bishop":
            return bishopAttacksAndDefenses(from: from)
        case "Queen":
            return queenAttacksAndDefenses(from: from)
        case "King":
            return kingAttacksAndDefenses(from: from, castling: castling)
        default:
            return ([], [])
        }
        
    }
    
    private func allAttacksAndDefenses(for player: Player) -> (attacks: [Square], defenses: [Square]) {
        var attacks = [Square]()
        var defenses = [Square]()
        
        for rank in 0...7 {
            for file in 0...7 {
                if color[board[rank][file]] == player {
                    let attacksAndDefenses = allAttacksAndDefenses(from: Square(rank: rank, file: file), castling: false)
                    attacks += attacksAndDefenses.attacks
                    defenses += attacksAndDefenses.defenses
                }
            }
        }
        
        return (attacks, defenses)
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
            castled[currentPlayer] = castleValue
        } else if move.to.file == move.from.file - 2 {
            board[move.from.rank][3] = rook
            board[move.from.rank][0] = "Empty"
            castled[currentPlayer] = castleValue
        } else {
            failedToCastle[currentPlayer] = failedToCastleValue
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
                
        (newBoardState.allAttacks[.white], newBoardState.allDefenses[.white]) = newBoardState.allAttacksAndDefenses(for: .white)
        (newBoardState.allAttacks[.black], newBoardState.allDefenses[.black]) = newBoardState.allAttacksAndDefenses(for: .black)
        
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
                if color[board[rank][file]] == player {
                    let from = Square(rank: rank, file: file)
                    let attacks = allAttacksAndDefenses(from: from).attacks
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
                                    promotingBoardState.allAttacks[player] = promotingBoardState.allAttacksAndDefenses(for: player).attacks
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
                if color[board[rank][file]] == player {
                    let from = Square(rank: rank, file: file)
                    let attacks = allAttacksAndDefenses(from: from).attacks
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
            return wbColor == bbColor
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
        case .empty:
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
    
    private func doubledPawns(_ player: Player) -> Float {
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
        
        return Float(counter)
    }
    
    private func centerControlScore() -> Float {
        var score: Float = 0.0

        for rank in [3, 4] {
            for file in [3, 4] {
                let color = color[board[rank][file]]
                if color == .white {
                    score += centerControlValue
                } else if color == .black {
                    score -= centerControlValue
                }
            }
        }
        
        return score
    }
    
    private func attackScore(for player: Player) -> Float {
        var score: Float = 0
        let opponent = opponent[player]!
        
        for square in allAttacks[player]! {
            let piece = board[square.rank][square.file]
            if color[piece] == opponent {
                let pieceValue = pieceValues[piece]!
                let factor = allDefenses[opponent]!.contains(square) ? defendedAttackValue : undefendedAttackValue
                
//                print(allDefenses[opponent]!)
//                print("\(piece) with factor \(factor)")
                
                score -= pieceValue * factor
            }
        }
        
        return score
    }
    
    private func materialScore () -> Float {
        var materialScore: Float = 0
        
        if winner != nil {
            return winningScore[winner!]!
        }
        
        for rank in 0...7 {
            for file in 0...7 {
                materialScore += pieceValues[board[rank][file]]!
            }
        }
        
        return materialScore
    }
    
    private func positionalScore() -> Float {
        let castleScore = castled[.white]! - castled[.black]!
        let failedToCastleScore = failedToCastle[.black]! - failedToCastle[.white]!
        let inCheckScore = inCheckScore()
        let doublePawnScore = (doubledPawns(.black) - doubledPawns(.white)) * doublePawnValue
        let centerControlScore = centerControlScore()
        let attackScore = attackScore(for: .white) + attackScore(for: .black)
        
//        print("castleScore:\t\t\(castleScore)")
//        print("failedToCastleScore:\(failedToCastleScore)")
//        print("inCheckScore:\t\t\(inCheckScore)")
//        print("doublePawnScore:\t\(doublePawnScore)")
//        print("centerControlScore:\t\(centerControlScore)")
//        print("attackScore:\t\t\(attackScore)")
        
        return castleScore + failedToCastleScore + inCheckScore + doublePawnScore + centerControlScore + attackScore
    }

    func evaluateBoardState() -> Float {
        let materialScore = materialScore()
        let positionalScore = positionalScore()
        let score = materialScore + positionalScore
        
//        print("positionalScore:\t\(positionalScore)")
//        print("materialScore:\t\t\(materialScore)")
//        print("Total score:\t\t\(score)")
//        print()
                        
        return score
    }
}

