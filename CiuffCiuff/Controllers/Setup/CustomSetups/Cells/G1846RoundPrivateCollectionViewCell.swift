//
//  G1846RoundPrivateCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 26/03/25.
//

import UIKit

class G1846RoundPrivateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accessoryView: UIView!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    var parentVC: G1846SetupViewController!
    var indexPathRow: Int!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        self.parentVC.showPrivateDetails(forPrivateAtBaseIndex: self.indexPathRow)
    }
    
}
