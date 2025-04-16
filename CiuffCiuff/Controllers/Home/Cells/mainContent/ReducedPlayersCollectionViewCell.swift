//
//  ReducedPlayersCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/02/25.
//

import UIKit

class ReducedPlayersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var deltaLabel: PaddingLabel!
    @IBOutlet weak var cashLabel: PaddingLabel!
    @IBOutlet weak var portfolioLabel: PaddingLabel!
    
    override class func awakeFromNib() {
        
    }
    
}
