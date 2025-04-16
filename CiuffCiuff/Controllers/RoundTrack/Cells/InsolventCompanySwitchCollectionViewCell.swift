//
//  InsolventCompanyCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 23/12/24.
//

import UIKit

class InsolventCompanySwitchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var insolvenceSwitch: UISwitch!
    
    var parentVC: RoundTrackViewController!
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func insolvenceSwitchValueChanged(_ sender: UISwitch) {
        self.parentVC.callToSwitchStates[sender.tag] = sender.isOn
    }
}
