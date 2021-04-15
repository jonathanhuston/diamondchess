//
//  GlobalDefinitions.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/7/21.
//

import SwiftUI

enum Player: CaseIterable {
    case white
    case black
    case none
}

let opponent: [Player: Player] = [.white: .black, .black: .white]

struct Square: Equatable, Hashable {
    var rank: Int
    var file: Int
    
    static func ==(lhs: Square, rhs: Square) -> Bool {
        return lhs.rank == rhs.rank && lhs.file == rhs.file
    }
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

let pieceValues = ["White King": 1000, "White Queen": 9, "White Bishop": 3, "White Knight": 3, "White Rook": 5,
                   "Black King": -1000, "Black Queen": -9, "Black Bishop": -3, "Black Knight": -3, "Black Rook": -5,
                   "Empty": 0]

let squareSize: CGFloat = 110

func pieceWidth(_ piece: String) -> CGFloat {
    if piece.contains("Dead") {
        return 105
    }
    
    return piece.contains("Pawn") ? 50 : 80
}

func pieceHeight(_ piece: String) -> CGFloat {
    if piece.contains("Dead") {
        return 80
    }
    
    return piece.contains("Pawn") ? 80 : 105
}

func color(of piece: String) -> Player {
    if piece.contains("White") {
        return .white
    } else if piece.contains("Black") {
        return .black
    } else {
        return .none
    }
}

func getX(_ file: Int) -> CGFloat {
    squareSize * (CGFloat(file) + 0.5)
}

func getY(_ rank: Int) -> CGFloat {
    squareSize * (CGFloat(rank) + 0.5)
}
