//
//  Game.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

class Game: ObservableObject {
    @Published var boardState = BoardState()
    @Published var computerPlayer: Player? = nil
    @Published var launch = false
    @Published var over = false
    @Published var touched: Square? = nil
    @Published var dragging = false
}

extension Game {
    func newGame() {
        boardState = BoardState()
        launch = false
        over = false
        touched = nil
        dragging = false
    }
}
