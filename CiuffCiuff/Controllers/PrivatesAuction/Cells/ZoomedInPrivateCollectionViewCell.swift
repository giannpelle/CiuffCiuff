//
//  ZoomedInPrivateCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 15/03/25.
//

import UIKit

class ZoomedInPrivateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accompanyingShareLabel: PaddingLabel!
    @IBOutlet weak var bidsStackView: UIStackView!
    @IBOutlet weak var backgroundAccessoryView: UIView!
    
    var parentVC: PrivatesAuctionViewController!
    var indexPathRow: Int!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        self.parentVC.showPrivateDetails(forPrivateAtBaseIndex: self.indexPathRow)
    }
    
}
