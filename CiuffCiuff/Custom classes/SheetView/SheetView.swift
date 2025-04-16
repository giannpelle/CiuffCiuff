//
//  SheetView.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 28/01/25.
//

import Foundation
import UIKit

class SheetView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.tertiaryAccentColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = UIColor.tertiaryAccentColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
}
