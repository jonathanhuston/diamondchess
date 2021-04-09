//
//  SwiftUIView.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

struct BoardView {
    @EnvironmentObject var game: Game
}

extension BoardView: View {
    var body: some View {
        if game.dragging {
            VStack(spacing: 0) {
                ForEach(Int(0)...Int(7), id:\.self) { rank in
                    HStack(spacing: 0) {
                        ForEach(Int(0)...Int(7), id:\.self) { file in
                            ZStack {
                                SquareView(rank: rank, file: file)
                                
                                if game.board[rank][file] != "Empty" {
                                    PieceView(piece: game.board[rank][file])
                                }
                            }
                        }
                    }
                }
            }
        }
        
        VStack(spacing: 0) {
            ForEach(Int(0)...Int(7), id:\.self) { rank in
                HStack(spacing: 0) {
                    ForEach(Int(0)...Int(7), id:\.self) { file in
                        ZStack {
                            SquareView(rank: rank, file: file)
                            
                            if game.board[rank][file] != "Empty" {
                                PieceView(piece: game.board[rank][file])
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
