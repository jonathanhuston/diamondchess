//
//  ContentView.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

struct ContentView {
    let board = [["Black Rook", "Black Knight", "Black Bishop", "Black Queen", "Black King", "Black Bishop", "Black Knight", "Black Rook"],
                 ["Black Pawn", "Black Pawn","Black Pawn","Black Pawn","Black Pawn","Black Pawn","Black Pawn","Black Pawn"],
                 ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                 ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                 ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                 ["Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"],
                 ["White Pawn", "White Pawn","White Pawn","White Pawn","White Pawn","White Pawn","White Pawn","White Pawn"],
                 ["White Rook", "White Knight", "White Bishop", "White Queen", "White King", "White Bishop", "White Knight", "White Rook"]]
}

extension ContentView: View {
    var body: some View {
        VStack {
            ForEach(Int(0)...Int(7), id:\.self) { rank in
                HStack {
                    ForEach(Int(0)...Int(7), id:\.self) { file in
                        ZStack {
                            if (rank % 2 == 0 && file % 2 == 0) || (rank % 2 == 1 && file % 2 == 1) {
                                Image("White Empty")
                                    .resizable()
                                    .frame(width: 120)
                            } else {
                                Image("Black Empty")
                                    .resizable()
                                    .frame(width: 120)
                            }
                            if board[rank][file] != "Empty" {
                                Image(board[rank][file])
                                    .resizable()
                                    .frame(width: 80, height: 100)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
