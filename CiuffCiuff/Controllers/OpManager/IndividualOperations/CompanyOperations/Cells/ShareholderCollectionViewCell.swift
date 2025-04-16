//
//  ShareholderCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 03/01/23.
//

import UIKit

class ShareholderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shareholderLabel: UILabel!
    @IBOutlet weak var shareholderCountLabel: UILabel!
    @IBOutlet weak var profitPreviewLabel: UILabel!
    @IBOutlet weak var payoutPreviewLabel: UILabel!
    @IBOutlet weak var withholdPreviewLabel: UILabel!
    @IBOutlet weak var accessoryBackgroundView: UIView!
    
    override class func awakeFromNib() {
        
    }
    
}
