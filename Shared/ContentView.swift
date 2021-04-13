//
//  ContentView.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

struct ContentView {
    @EnvironmentObject var game: Game
}

extension ContentView: View {
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                BoardView()
                
                PiecesView()
            }
            .frame(width: 8 * squareSize, height: 8 * squareSize)
            
            VStack(spacing: 0) {
                CapturedView(player: .white)
                    .frame(width: 2 * squareSize, height: 4 * squareSize)

                CapturedView(player: .black)
                    .frame(width: 2 * squareSize, height: 4 * squareSize)

            }
        }
    }
}
