//
//  LayoutView.swift
//  Diamond Chess (iOS)
//
//  Created by Slatescript on 08.06.21.
//

import SwiftUI

struct LayoutView {
    @Binding var orientation: UIDeviceOrientation
}

extension LayoutView: View {
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
        }
        .ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
    }
}
