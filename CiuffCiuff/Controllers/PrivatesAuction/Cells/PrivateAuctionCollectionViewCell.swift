//
//  PrivateAuctionCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 21/12/24.
//

import UIKit

class PrivateAuctionCollectionViewCell: UICollectionViewCell {
    
    var parentVC: PrivatesAuctionViewController!
    
    @IBOutlet weak var accessoryImageView: UIImageView!
    @IBOutlet weak var bidsScrollView: UIScrollView!
    @IBOutlet weak var noBidsPresentLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}
