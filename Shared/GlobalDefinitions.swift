//
//  GlobalDefinitions.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/7/21.
//

import SwiftUI

//  Search depth and weights

let maxDepth = 3

let inCheckValue: Float = 0.125
let castleValue: Float = 0.125
let failedToCastleValue: Float = 0.375
let centerControlValue: Float = 0.25
let doublePawnValue: Float = 0.25
let defendedAttackValue: Float = 0.0625
let undefendedAttackValue: Float = 0.25


//  Board and piece definitions

enum Player: CaseIterable {
    case white
    case black
    case empty
}

let pieceValues: [String: Float] =
    ["White King": 0, "White Queen": 9, "White Bishop": 3, "White Knight": 3, "White Rook": 5, "White Pawn": 1,
     "Black King": 0, "Black Queen": -9, "Black Bishop": -3, "Black Knight": -3, "Black Rook": -5, "Black Pawn": -1,
     "Empty": 0]

let color: [String: Player] =
    ["White King": .white, "White Queen": .white, "White Bishop": .white, "White Knight": .white, "White Rook": .white, "White Pawn": .white,
     "Black King": .black, "Black Queen": .black, "Black Bishop": .black, "Black Knight": .black, "Black Rook": .black, "Black Pawn": .black,
     "Empty": .empty]

let kind: [String: String] =
    ["White King": "King", "White Queen": "Queen", "White Bishop": "Bishop", "White Knight": "Knight", "White Rook": "Rook", "White Pawn": "Pawn",
     "Black King": "King", "Black Queen": "Queen", "Black Bishop": "Bishop", "Black Knight": "Knight", "Black Rook": "Rook", "Black Pawn": "Pawn",
     "Empty": "Empty"]

let opponent: [Player: Player] = [.white: .black, .black: .white, .empty: .empty]

let winningScore: [Player: Float] = [.white: Float(Int.max), .black: Float(Int.min), .empty: 0]

struct Square: Equatable, Hashable {
    var rank: Int
    var file: Int
    
    static func ==(lhs: Square, rhs: Square) -> Bool {
        return lhs.rank == rhs.rank && lhs.file == rhs.file
    }
}

struct Move: Hashable {
    var from: Square
    var to: Square
}

typealias Board = [[String]]

let newBoard: Board = [["Black Rook", "Black Knight", "Black Bishop", "Black Queen", "Black King", "Black Bishop", "Black Knight", "Black Rook"],
                       ["Black Pawn", "Black Pawn","Black Pawn","Black Pawn","Black Pawn","Black Pawn","Black Pawn","Black Pawn"],
                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                       ["White Pawn", "White Pawn","White Pawn","White Pawn","White Pawn","White Pawn","White Pawn","White Pawn"],
                       ["White Rook", "White Knight", "White Bishop", "White Queen", "White King", "White Bishop", "White Knight", "White Rook"]]

//let newBoard: Board = [["Empty", "Empty", "Empty", "Black Queen", "Black King", "Empty", "Empty", "Empty"],
//                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
//                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
//                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
//                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
//                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
//                       ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
//                       ["Empty", "Empty", "Empty", "White Queen", "White King", "Empty", "Empty", "Empty"]]

private let promotionPieces = ["White Queen", "White Knight", "White Rook", "White Bishop", "White Queen",
                               "Black Queen", "Black Knight", "Black Rook", "Black Bishop", "Black Queen"]

func nextPromotionPiece(_ piece: String) -> String {
    let index = promotionPieces.firstIndex(of: piece)!
    
    return promotionPieces[index + 1]
}


//  Visual layout
let squareSize: CGFloat = 88

func pieceWidth(_ piece: String) -> CGFloat {
    if piece.contains("Dead") {
        return 80
    }
    
    return piece.contains("Pawn") ? 40 : 64
}

func pieceHeight(_ piece: String) -> CGFloat {
    if piece.contains("Dead") {
        return 64
    }
    
    return piece.contains("Pawn") ? 64 : 80
}

func getX(_ file: Int) -> CGFloat {
    squareSize * (CGFloat(file) + 0.5)
}

func getY(_ rank: Int) -> CGFloat {
    squareSize * (CGFloat(rank) + 0.5)
}
