//
//  UICollectionViewExtensions.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 11/08/24.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func getSizeForGrid(withRows rows: CGFloat, andCols cols: CGFloat, andIndexPath indexPath: IndexPath, isVerticalFlow: Bool, horizontalInsetReduction: CGFloat = 0.0, verticalInsetReduction: CGFloat = 0.0) -> CGSize {
        
        let originalHeight = self.bounds.height - verticalInsetReduction
        
        var height = Int(originalHeight / rows)
        let heightRemainder = Int(originalHeight) - (height * Int(rows))
        
        let originalWidth = self.bounds.width - horizontalInsetReduction
        
        var width = Int(originalWidth / cols)
        let widthRemainder = Int(originalWidth) - (width * Int(cols))
        
        if isVerticalFlow {
            if indexPath.row % Int(cols) == 0 {
                width += widthRemainder
            }
            if indexPath.row < Int(cols) {
                height += heightRemainder
            }
        } else {
            if indexPath.row < Int(rows) {
                width += widthRemainder
            }
            if indexPath.row % Int(rows) == 0 {
                height += heightRemainder
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    func getWidthForGrid(withRows rows: CGFloat, andCols cols: CGFloat, andIndexPath indexPath: IndexPath, isVerticalFlow: Bool, horizontalInsetReduction: CGFloat = 0.0) -> Int {
        
        let originalWidth = self.bounds.width - horizontalInsetReduction
        
        var width = Int(originalWidth / cols)
        let widthRemainder = Int(originalWidth) - (width * Int(cols))

        if isVerticalFlow {
            if indexPath.row % Int(cols) == 0 {
                width += widthRemainder
            }
        } else {
            if indexPath.row < Int(rows) {
                width += widthRemainder
            }
        }
        
        return width
    }
    
    func getHeightForGrid(withRows rows: CGFloat, andCols cols: CGFloat, andIndexPath indexPath: IndexPath, isVerticalFlow: Bool, verticalInsetReduction: CGFloat = 0.0) -> Int {
        
        let originalHeight = self.bounds.height - verticalInsetReduction
        
        var height = Int(originalHeight / rows)
        let heightRemainder = Int(originalHeight) - (height * Int(rows))
        
        if isVerticalFlow {
            if indexPath.row < Int(cols) {
                height += heightRemainder
            }
        } else {
            if indexPath.row % Int(rows) == 0 {
                height += heightRemainder
            }
        }
        
        return height
    }
}
