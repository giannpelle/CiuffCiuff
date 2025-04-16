//
//  IncomeCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/01/23.
//

import UIKit

class PrivateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ownerLabel: PaddingLabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var parentVC: IncomeViewController!
    var indexPath: IndexPath!
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func closePrivate(sender: UIButton) {
        self.parentVC.closePrivate(atIndexPath: self.indexPath)
    }
    
}
