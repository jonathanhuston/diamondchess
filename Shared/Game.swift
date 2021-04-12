//
//  Game.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

class Game: ObservableObject {
    @Published var boardState = BoardState()
    @Published var gameOver = false
    @Published var touched: Square? = nil
    @Published var dragging = false
}

extension Game {
}
