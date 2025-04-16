//
//  CreditsCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 25/03/25.
//

import UIKit

class CreditsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var creditsAccessoryLabel: UILabel!
    
    var parentVC: GameMenuViewController!
    var indexPathRow: Int!
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func openCreditsURLButtonPressed(sender: UIButton) {
        self.parentVC.openURL(forCreditsAtIndexPathRow: self.indexPathRow)
    }
    
}
