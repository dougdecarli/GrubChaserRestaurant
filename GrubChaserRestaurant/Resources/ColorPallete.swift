//
//  ColorPallete.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import Foundation

import UIKit

class ColorPallete {
    static var defaultRed = UIColor(hexString: "#EE6A53")
    static var defaultYellow = UIColor(hexString: "#FFD60A")
    static var defaultGray = UIColor(hexString: "#F5F5F5")
    
    static var realtimeTypeColor = UIColor(hexString: "#83D9DC")
    static var ordersTypeColor = UIColor(hexString: "#F498C2")
    static var revenueTypeColor = UIColor(hexString: "#FEFFBF")
}

public extension UIColor {
    static var sixtyPercentAlphaWhite: UIColor {
        return UIColor(white: 1, alpha: 0.6)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        
        //swiftlint:disable:next identifier_name
        let a, r, g, b: UInt32
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
