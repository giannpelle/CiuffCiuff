//
//  RoundType1840LastCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 18/03/25.
//

import UIKit

class RoundType1840LastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roundTypeButton: UIButton!
    @IBOutlet weak var roundTypeLabel: UILabel!
    @IBOutlet weak var baselineLabel: UILabel!
    @IBOutlet weak var multiplierLabel: UILabel!
    
    @IBOutlet weak var roundTypeButtonCenterYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var roundTypeLabelCenterYLayoutConstraint: NSLayoutConstraint!
    
    var parentVC: HomeViewController!
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func roundTrackButtonPressed(sender: UIButton) {
        self.parentVC.roundTrackButtonPressed(sender: sender)
    }
}
