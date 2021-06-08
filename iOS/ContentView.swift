//
//  ContentView.swift
//  Diamond Chess (macOS)
//
//  Created by Jonathan Huston on 6/8/21.
//

import SwiftUI

struct ContentView {
    @EnvironmentObject var game: Game
    
    @State private var orientation = UIDevice.current.orientation
    
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .makeConnectable()
            .autoconnect()
}

extension ContentView: View {
    var body: some View {
        ZStack {
            Color.black

            Group {
                if orientation.isPortrait || Device.isPortrait() {
                    VStack(spacing: 0) {
                        ZStack {
                            BoardView()
                            PiecesView()
                        }
                        .frame(width: 8 * squareSize, height: 8 * squareSize)
                        
                        HStack(spacing: 0) {
                            CapturedView(player: .white)
                                .frame(width: 4 * squareSize, height: 2.5 * squareSize)
                            CapturedView(player: .black)
                                .frame(width: 4 * squareSize, height: 2.5 * squareSize)
                        }
                    }
                } else {
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
            .onReceive(orientationChanged) { _ in
                self.orientation = UIDevice.current.orientation
            }
            .onChange(of: game.launch) { launch in
                if launch == true {
                    game.newGame()
                }
                game.launch = false
            }
            .onChange(of: game.flipNow) { _ in
                game.flipped = !game.flipped
            }

    //        .navigationTitle(navigationText())
    //        .navigationBarTitleDisplayMode(.inline)
        }
        .ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)

    }
}
