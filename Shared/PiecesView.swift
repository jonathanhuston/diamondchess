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
                    if game.touched! != (rank, file) {
                        PieceView(rank: rank, file: file)
                            .position(x: getX(file), y: getY(rank))
                    }
                }
            }
        }
        
        ForEach(Int(0)...Int(7), id:\.self) { rank in
            ForEach(Int(0)...Int(7), id:\.self) { file in
                if game.touched == nil || game.touched! == (rank, file) || !game.dragging  {
                    PieceView(rank: rank, file: file)
                        .position(x: getX(file), y: getY(rank))
                }
            }
        }
    }
}
