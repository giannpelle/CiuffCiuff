//
//  UIButtonExtensions.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 16/10/24.
//

import UIKit

extension UIButton {
    
    func setTitle(withText text: String, fontSize: Double, fontWeight: UIFont.Weight, textColor: UIColor) {
        let attributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]
        self.setAttributedTitle(NSAttributedString(string: text, attributes: attributes), for: .normal)
    }
    
    func setBackgroundColor(_ color: UIColor, isRectangularShape: Bool = false) {
        self.configuration = .plain()
        
        if self.layer.cornerRadius == 0 && !isRectangularShape {
            self.layer.cornerRadius = 4
            self.clipsToBounds = true
        }
        
        self.backgroundColor = color
    }
    
    func setPopupTitle(withText text: String, textColor: UIColor) {
        self.tintColor = textColor
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let fontSize = self.bounds.size.height > 40 ? 19.0 : 17.0
        let attributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        self.setAttributedTitle(NSAttributedString(string: text, attributes: attributes), for: .normal)
    }
    
    func setPopupTitle(withText text: String, textColor: UIColor, fontSize: Double, fontWeight: UIFont.Weight = .semibold) {
        self.tintColor = textColor
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        self.setAttributedTitle(NSAttributedString(string: text, attributes: attributes), for: .normal)
    }
    
    func forceSelectedIndex(_ index: Int) {
        guard let menu = self.menu else {
            return print("forceSelectedIndex impossible")
        }
        
        if index == 0 {
            let action = menu.children.first as? UIAction
            action?.state = .on
        } else if index > 0 && index < menu.children.count {
            let action = menu.children[index] as? UIAction
            action?.state = .on
        }
    }
}
