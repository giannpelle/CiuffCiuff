//
//  G1846MarketCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/04/25.
//

import UIKit

class G1846MarketCollectionViewCell: UICollectionViewCell {
    
//    var shapeLayers: [CALayer] = []
    
    @IBOutlet weak var shareValueLabel: UILabel!
    @IBOutlet weak var companiesScrollView: UIScrollView!
    @IBOutlet weak var companiesStackView: UIStackView!
    
    override class func awakeFromNib() {
        
    }
    
//    func reset() {
//        if let sublayers = self.contentView.layer.sublayers {
//            for sublayer in sublayers {
//                if self.shapeLayers.contains(sublayer) {
//                    sublayer.removeFromSuperlayer()
//                }
//            }
//            
//            self.shapeLayers = []
//        }
//        
//    }
//    
//    func setBezierPaths(bezierPaths: [UIBezierPath], andColors colors: [UIColor]) {
//        
//        for (i, path) in bezierPaths.enumerated() {
//            
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = path.cgPath
//            shapeLayer.strokeColor = UIColor.systemGray4.cgColor
//            shapeLayer.fillColor = colors[i].cgColor
//            shapeLayer.lineWidth = 0
//            
//            self.shapeLayers.append(shapeLayer)
//            self.contentView.layer.insertSublayer(shapeLayer, below: self.shareValueLabel.layer)
//        }
//    }
}
