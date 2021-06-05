//
//  Openings.swift
//  Diamond Chess
//
//  Created by Jonathan Huston on 6/5/21.
//

import SwiftUI

let openings =
    [[]: "e2e4",
     ["e2e4", "e7e5"]: "g1f3",
     ["e2e4", "e7e5", "g1f3", "b8c6"]: "f1c4",  // Italian Game
     
     ["e2e4"]: "c7c5",                          // Sicilian Defense

     ["d2d4"]: "d7d5",                          // Slav Defense
     ["d2d4", "d7d5", "c2c4"]: "c7c6"
    ]
