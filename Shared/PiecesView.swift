//
//  PiecesView.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

struct PiecesView {
    @EnvironmentObject var game: Game
}

extension PiecesView: View {
    var body: some View {
        if game.dragging {
            ForEach(0...7, id:\.self) { rank in
                ForEach(0...7, id:\.self) { file in
                    if game.touched! != Square(rank: rank, file: file) {
                        PieceView(square: Square(rank: rank, file: file))
                            .position(x: getX(file), y: getY(rank))
                    }
                }
            }
        }
        
        ForEach(0...7, id:\.self) { rank in
            ForEach(0...7, id:\.self) { file in
                if !game.dragging || game.touched == nil || game.touched! == Square(rank: rank, file: file) {
                    PieceView(square: Square(rank: rank, file: file))
                        .position(x: getX(file), y: getY(rank))
                }
            }
        }
    }
}
