//
//  ContentView.swift
//  Shared
//
//  Created by Jonathan Huston on 4/6/21.
//

import SwiftUI

struct ContentView {
}

extension ContentView: View {
    var body: some View {
        VStack {
            ForEach(Int(0)...Int(7), id:\.self) { rank in
                HStack {
                    ForEach(Int(0)...Int(7), id:\.self) { file in
                        ZStack {
                            if (rank % 2 == 0 && file % 2 == 0) || (rank % 2 == 1 && file % 2 == 1) {
                                Image("White Empty")
                                    .resizable()
                                    .frame(width: 110, height: 110)
                            } else {
                                Image("Black Empty")
                                    .resizable()
                                    .frame(width: 110, height: 110)
                            }
                            if newBoard[rank][file] != "Empty" {
                                Image(newBoard[rank][file])
                                    .resizable()
                                    .frame(width: 80, height: 105)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
