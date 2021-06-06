//
//  Openings.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 6/5/21.
//

let openings = [
        Player.white: [
            ["e2e4", "e7e5", "g1f3", "b8c6", "f1b5", "a7a6", "b5a4", "g8f6", "e1g1"],   // Ruy-Lopez
            ["e2e4", "e7e5", "g1f3", "b8c6", "f1c4"],                                   // Italian Game
            ["e2e4", "d7d6", "g8f6", "d2d4", "b1c3"],                                   // Pirc Defense
        ],
    
        Player.black: [
            ["e2e4", "c7c5"],                                                           // Sicilian Defense
            ["e2e4", "e7e6", "d2d4", "d7d5"],                                           // French Defense
            ["e2e4", "e7e5", "g1f3", "g8f6"],                                           // Petrov Defense
            ["e2e4", "c7c6"],                                                           // Caro-Kann Defense
            ["e2e4", "d7d5", "e4d5", "d8d5", "b1c3", "d5a5"],                           // Scandinavian Defense
            
            ["d2d4", "d7d5", "c2c4", "c7c6"],                                           // Slav Defense
            ["d2d4", "g8f6", "c2c4", "g7g6"],                                           // King's Indian Defense
            ["d2d4", "g8f6", "c2c4", "e7e6", "g1f3", "b7b6"],                           // Queen's Indian Defense
            
            ["c2c4", "e7e5"],                                                           // English Opening
            
            ["g1f3", "d7d5"],                                                           // Réti Opening
            ["g1f3", "g8f6", "g2g3", "g7g6"]                                            // King's Indian Attack
        ]
    ]
