//
//  Openings.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 6/5/21.
//

let openings = [
        Player.white: [
            ["e2e4", "e7e5", "g1f3", "b8c6", "f1b5"],   // Ruy-Lopez
            ["e2e4", "e7e5", "g1f3", "b8c6", "f1c4"]    // Italian Game
        ],
    
        Player.black: [
            ["e2e4", "c7c5"],                           // Sicilian Defense
            ["e2e4", "e7e6", "d2d4", "d7d5"],           // French Defense
            ["d2d4", "d7d5", "c2c4", "c7c6"]            // Slav Defense
        ]
    ]
