//
//  SquareView.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

struct SquareView {
    let square: Square
}

extension SquareView: View {
    var body: some View {
        Image(square.rank % 2 == square.file % 2 ? "White Empty" : "Black Empty")
            .resizable()
            .frame(width: squareSize, height: squareSize)
    }
}
