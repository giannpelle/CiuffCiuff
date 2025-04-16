//
//  InsolventCompanyButtonCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/01/25.
//

import UIKit

class InsolventCompanyButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doItNowButton: UIButton!
    
    var parentVC: RoundTrackViewController!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func didTapDoItNowButton(sender: UIButton) {
        self.parentVC.didTapDoItNowButton(withTag: sender.tag)
    }
    
}
