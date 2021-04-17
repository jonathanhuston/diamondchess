//
//  SwiftUIView.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

struct BoardView: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...7, id:\.self) { rank in
                HStack(spacing: 0) {
                    ForEach(0...7, id:\.self) { file in
                        SquareView(square: Square(rank: rank, file: file))
                    }
                }
            }
        }
    }
}
