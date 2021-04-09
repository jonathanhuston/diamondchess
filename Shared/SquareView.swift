//
//  SquareView.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

struct SquareView {
    let rank, file: Int
}

extension SquareView: View {
    var body: some View {
        Image(rank % 2 == file % 2 ? "White Empty" : "Black Empty")
            .resizable()
            .frame(width: squareSize, height: squareSize)
    }
}
