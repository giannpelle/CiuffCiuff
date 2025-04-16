//
//  G1840LineCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 21/03/25.
//

import UIKit

class G1840LineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var mainCompanyLabel: PaddingLabel!
    @IBOutlet weak var lineLabel: PaddingLabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    @IBOutlet weak var revenueStackView: UIStackView!
    
    override class func awakeFromNib() {
        
    }
}
