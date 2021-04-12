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
    
    func adjustedOffset(at position: CGPoint, for piece: String, negative: Bool = false) -> CGPoint {
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
        
        if piece != "Empty" {
            Image(piece)
                .resizable()
                .position(adjustedOffset(at: offset, for: piece))
                .gesture(DragGesture()
                            .onChanged({ value in
                                if color(of: piece) == game.boardState.currentPlayer {
                                    offset = adjustedOffset(at: value.location, for: piece, negative: true)
                                    game.touched = square
                                }
                            })
                            .updating($isDragging) { (value, state, transaction) in
                                state = true
                            }
                            .onEnded({ value in
                                game.dragging = false
                                let toRank = square.rank + Int((offset.y / squareSize).rounded())
                                let toFile = square.file + Int((offset.x / squareSize).rounded())
                                if let newBoardState = game.boardState.makeMove(for: piece, from: square, to: Square(rank: toRank, file: toFile)) {
                                    game.boardState = newBoardState
                                    game.gameOver = newBoardState.checkmate || newBoardState.stalemate
                                }
                                game.touched = nil
                                offset = CGPoint(x: 0, y: 0)
                            })
                )
                .onChange(of: isDragging) { newValue in
                    if color(of: piece) == game.boardState.currentPlayer {
                        game.dragging = newValue
                    }
                }
                .frame(width: pieceWidth(piece), height: pieceHeight(piece))
        }
    }
}
