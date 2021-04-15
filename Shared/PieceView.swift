//
//  PieceView.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/7/21.
//

import SwiftUI

struct PieceView {
    @EnvironmentObject var game: Game

    let square: Square
    
    @State private var offset = CGPoint(x: 0, y: 0)
    @GestureState private var isDragging = false
    
    private func nextPiece(_ piece: String) -> String {
        switch piece {
        case "White Queen":
            return "White Knight"
        case "White Knight":
            return "White Rook"
        case "White Rook":
            return "White Bishop"
        case "White Bishop":
            return "White Queen"
        case "Black Queen":
            return "Black Knight"
        case "Black Knight":
            return "Black Rook"
        case "Black Rook":
            return "Black Bishop"
        case "Black Bishop":
            return "Black Queen"
        default:
            return piece
        }
    }
        
    private func adjustedOffset(at position: CGPoint, for piece: String, negative: Bool = false) -> CGPoint {
        let sign: CGFloat = negative ? -1 : 1
        var adjusted = position
    
        adjusted.x = position.x + sign * pieceWidth(piece) / 2
        adjusted.y = position.y + sign * pieceHeight(piece) / 2
                
        return adjusted
    }
}

extension PieceView: View {
    var body: some View {
        let piece = game.boardState.board[square.rank][square.file]
        
        if game.boardState.promoting == square {
            Button(action: {
                game.boardState.board[square.rank][square.file] = nextPiece(piece)
            }) {
                Image(piece)
                    .resizable()
                    .position(adjustedOffset(at: offset, for: piece))
                    .frame(width: pieceWidth(piece), height: pieceHeight(piece))
            }
            .buttonStyle(PlainButtonStyle())
        } else if piece != "Empty" {
            Image(piece)
                .resizable()
                .position(adjustedOffset(at: offset, for: piece))
                .gesture(DragGesture()
                            .onChanged({ value in
                                if color(of: piece) == game.boardState.currentPlayer && !game.over {
                                    offset = adjustedOffset(at: value.location, for: piece, negative: true)
                                    game.touched = square
                                }
                            })
                            .updating($isDragging) { (value, state, transaction) in
                                state = true
                            }
                            .onEnded({ value in
                                game.dragging = false
                                let rankOffset = Int((offset.y / squareSize).rounded())
                                let fileOffset = Int((offset.x / squareSize).rounded())
                                let toRank = square.rank + (game.flipped ? -rankOffset : rankOffset)
                                let toFile = square.file + (game.flipped ? -fileOffset : fileOffset)
                                if let newBoardState = game.boardState.makeMove(for: piece, from: square, to: Square(rank: toRank, file: toFile)) {
                                    game.boardState = newBoardState
                                    game.over = newBoardState.winner != nil
                                }
                                game.touched = nil
                                offset = CGPoint(x: 0, y: 0)
                            })
                )
                .onChange(of: isDragging) { newValue in
                    if color(of: piece) == game.boardState.currentPlayer && !game.over {
                        game.dragging = newValue
                    }
                }
                .frame(width: pieceWidth(piece), height: pieceHeight(piece))
        }
    }
}
