//
//  ReducedCompaniesCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/02/25.
//

import UIKit

class ReducedCompaniesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var parLabel: PaddingLabel!
    @IBOutlet weak var payoutLabel: PaddingLabel!
    @IBOutlet weak var accessoryLabel: PaddingLabel!
    
    override class func awakeFromNib() {
        
    }
    
}
