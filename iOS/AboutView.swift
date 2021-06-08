//
//  AboutView.swift
//  Diamond Chess (iOS)
//
//  Created by Slatescript on 08.06.21.
//

import SwiftUI

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

struct AboutView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("Diamond Chess")
                .resizable()
                .frame(width: 64 * Device.scaling, height: 80 * Device.scaling)
            
            Text("Diamond Chess")
                .fontWeight(.bold)
                .foregroundColor(.white)
                        
            Text("Version \(UIApplication.appVersion!)")
                .foregroundColor(.white)
            
            Text("Pieces designed by Ella Huston")
                .foregroundColor(.white)
            
            Text("© 2021 Jonathan Huston")
                .foregroundColor(.white)

        }
    }
}
