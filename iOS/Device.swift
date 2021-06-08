//
//  Device.swift
//  Diamond Chess (iOS)
//
//  Created by Jonathan Huston on 6/8/21.
//

import SwiftUI

struct Device {
    static func height() -> CGFloat {
        UIScreen.main.bounds.size.height
    }
    
    static func width() -> CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    static let scaling = min(width(), height()) / 750
    
    static func isPortrait() -> Bool {
        height() > width()
    }
    
    static let iOS = true
}
