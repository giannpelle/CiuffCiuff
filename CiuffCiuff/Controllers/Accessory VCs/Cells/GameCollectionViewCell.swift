//
//  GameCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 07/01/25.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var publisherImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playersLabel: PaddingLabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
