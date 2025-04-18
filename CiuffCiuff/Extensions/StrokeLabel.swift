//
//  StrokeLabel.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 14/04/25.
//

import UIKit

@IBDesignable
class StrokeLabel: UILabel {
    @IBInspectable var strokeSize: CGFloat = 0
    @IBInspectable var strokeColor: UIColor = .clear
  
    override func drawText(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let textColor = self.textColor
        context?.setLineWidth(self.strokeSize)
        context?.setLineJoin(CGLineJoin.round)
        context?.setTextDrawingMode(CGTextDrawingMode.stroke)
        self.textColor = self.strokeColor
        super.drawText(in: rect)
        context?.setTextDrawingMode(.fill)
        self.textColor = textColor
        super.drawText(in: rect)
    }
}
