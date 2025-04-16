//
//  CustomSegmentedControl.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 28/01/25.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl{
    private let segmentInset: CGFloat = 4

    override func layoutSubviews(){
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.layer.borderWidth = 3

        layer.cornerRadius = bounds.height / 2
        let foregroundIndex = numberOfSegments
        
        let imageViews = self.subviews.filter({ $0 is UIImageView }).compactMap({ $0 as? UIImageView })
        for imageView in Array(imageViews[..<self.numberOfSegments]) {
            imageView.isHidden = true
        }

        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = UIImage(color: self.selectedSegmentTintColor ?? UIColor.black)    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
        }
    }
}
