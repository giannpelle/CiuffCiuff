//
//  RoundTypeClassicLastCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 18/03/25.
//

import UIKit

class RoundTypeClassicLastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var roundTypeButton: UIButton!
    
    var parentVC: HomeViewController!
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func roundTrackButtonPressed(sender: UIButton) {
        self.parentVC.roundTrackButtonPressed(sender: sender)
    }
    
}
