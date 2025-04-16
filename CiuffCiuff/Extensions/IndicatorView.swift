//
//  IndicatorView.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 09/08/24.
//

import Foundation
import UIKit

class LeftIndicatorView: UIView {
    
    var indicatorColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
              
        //1
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        //2
        context.setStrokeColor(self.indicatorColor.cgColor)
        context.setLineCap(.square)
        context.setLineWidth(4.0)
        
        let lineDistance = 16
        
        // drawing left diagonal lines
        let points = Int(rect.width / CGFloat(lineDistance))
        for i in 0..<points {
            let xFromPosition = CGFloat(i * lineDistance) - (rect.height / 2.0)
            let yFromPosition = 0.0
            context.move(to: CGPoint(x: xFromPosition, y: yFromPosition))
            
            let xToPosition = CGFloat(i * lineDistance)
            let yToPosition = rect.height / 2.0
            context.addLine(to: CGPoint(x: xToPosition, y: yToPosition))
            
            let xFinalPosition = CGFloat(i * lineDistance) - (rect.height / 2.0)
            let yFinalPosition = rect.height
            context.addLine(to: CGPoint(x: xFinalPosition, y: yFinalPosition))
            
            context.strokePath()
        }
        
        //3
        context.restoreGState()
    }
    
}

class RightIndicatorView: UIView {
    
    var indicatorColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
              
        //1
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        //2
        context.setStrokeColor(self.indicatorColor.cgColor)
        context.setLineCap(.square)
        context.setLineWidth(4.0)
        
        let lineDistance = 16
        // drawing left diagonal lines
        let points = Int(rect.width / CGFloat(lineDistance))
        for i in (0..<points).reversed() {
            let xFromPosition = rect.width + (rect.height / 2.0) - CGFloat(i * lineDistance)
            let yFromPosition = 0.0
            context.move(to: CGPoint(x: xFromPosition, y: yFromPosition))
            
            let xToPosition = rect.width - CGFloat(i * lineDistance)
            let yToPosition = rect.height / 2.0
            context.addLine(to: CGPoint(x: xToPosition, y: yToPosition))
            
            let xFinalPosition = rect.width + (rect.height / 2.0) - CGFloat(i * lineDistance)
            let yFinalPosition = rect.height
            context.addLine(to: CGPoint(x: xFinalPosition, y: yFinalPosition))
            
            context.strokePath()
        }
        
        //3
        context.restoreGState()
    }
    
}
