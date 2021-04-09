//
//  Game.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 4/9/21.
//

import SwiftUI

class Game: ObservableObject {
    @Published var board: Board = newBoard
    @Published var dragging = false
    @Published var touched: (rank: Int, file: Int)? = nil
}
