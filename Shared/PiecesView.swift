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
            ForEach(Int(0)...Int(7), id:\.self) { rank in
                ForEach(Int(0)...Int(7), id:\.self) { file in
                    if game.touched! != Square(rank: rank, file: file) {
                        PieceView(square: Square(rank: rank, file: file))
                            .position(x: getX(file), y: getY(rank))
                    }
                }
            }
        }
        
        ForEach(Int(0)...Int(7), id:\.self) { rank in
            ForEach(Int(0)...Int(7), id:\.self) { file in
                if game.touched == nil || game.touched! == Square(rank: rank, file: file) || !game.dragging  {
                    PieceView(square: Square(rank: rank, file: file))
                        .position(x: getX(file), y: getY(rank))
                }
            }
        }
    }
}
