//
//  CapturedView.swift
//  Diamond Chess
//
//  Created by Slatescript on 14.04.21.
//

import SwiftUI

struct CapturedView {
    @EnvironmentObject var game: Game

    let player: Player
    
    let columns: [GridItem] = Array(repeating: .init(.fixed(squareSize / 3)), count: 4)
}

extension CapturedView: View {
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<game.boardState.captured[player]!.count, id:\.self) { index in
                Image(game.boardState.captured[player]![index])
                    .resizable()
                    .frame(width: pieceWidth(game.boardState.captured[player]![index]) / 2,
                           height: pieceHeight(game.boardState.captured[player]![index]) / 2)
            }
        }
    }
}
