//
//  UIColor+Extension.swift
//  Argus
//
//  Created by chris on 11/10/20.
//

import Foundation

public extension UIColor {
    
    convenience init(hex str: String) {
        self.init(hex: str, alpha: 1.0)
    }
    
    convenience init(hex str: String, alpha: CGFloat) {
        var hex = str.hasPrefix("#") ? String(str.dropFirst()) : str
        guard hex.count == 3 || hex.count == 6 else {
            self.init(white: 1.0, alpha: alpha)
            return
        }
        
        if hex.count == 3 {
            for (idx, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: idx * 2))
            }
        }
        guard let intCode = Int(hex, radix: 16) else {
            self.init(white: 1.0, alpha: alpha)
            return
        }
        
        self.init(red: CGFloat((intCode >> 16) & 0xFF) / 255.0,
                  green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
                  blue: CGFloat(intCode & 0xFF) / 255.0,
                  alpha: alpha
        )
    }
}
