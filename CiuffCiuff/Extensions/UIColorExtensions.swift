//
//  UIColorExtensions.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation
import UIKit

extension UIColor {
    
    static var primaryAccentColor: UIColor {
        return UIColor.fromHex("5A4D81") ?? UIColor.black
    }
    
    static var secondaryAccentColor: UIColor {
        return UIColor.fromHex("F1E5FB") ?? UIColor.black
    }
    
    static var tertiaryAccentColor: UIColor {
        return UIColor.fromHex("242B35") ?? UIColor.black
    }
    
    static var redAccentColor: UIColor {
        return UIColor.fromHex("E53935") ?? UIColor.black
    }
    
    static var yellowORColor: UIColor {
        return UIColor.fromHex("FEE700") ?? UIColor.black
    }
    
    static var greenORColor: UIColor {
        return UIColor.fromHex("71BF44") ?? UIColor.black
    }
    
    static var brownORColor: UIColor {
        return UIColor.fromHex("C97645") ?? UIColor.black
    }
    
    static var grayORColor: UIColor {
        return UIColor.fromHex("B2B3B3") ?? UIColor.black
    }
    
    static func fromHex(_ hex: String) -> UIColor? {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard hexSanitized.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func == (l: UIColor, r: UIColor) -> Bool {
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
    }

    
//    var darker: UIColor {
//        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
//
//       if self.getRed(&r, green: &g, blue: &b, alpha: &a){
//           return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
//       }
//
//        return self
//    }
    
}

func == (l: UIColor?, r: UIColor?) -> Bool {
  let l = l ?? .clear
  let r = r ?? .clear
  return l == r
}
