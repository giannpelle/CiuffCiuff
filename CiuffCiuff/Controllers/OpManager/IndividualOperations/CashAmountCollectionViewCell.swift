//
//  PayoutAmountCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 28/02/25.
//

import UIKit

class CashAmountCollectionViewCell: UICollectionViewCell {
    
    var parentVC: CashViewController?
    var indexPathRow: Int!
    
    @IBOutlet weak var entityLabel: PaddingLabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var modifierButtonsStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        for view in self.modifierButtonsStackView.arrangedSubviews {
            if let btn = view as? UIButton, let btnText = btn.titleLabel?.text {
                btn.backgroundColor = btnText.contains("-") ? UIColor.redAccentColor : UIColor.primaryAccentColor
                btn.setTitle(withText: btnText, fontSize: 18.0, fontWeight: .bold, textColor: .white)
                
                btn.clipsToBounds = true
                btn.layer.cornerRadius = 6.0
            }
        }
        
    }
    
    @IBAction func modifierButtonPressed(sender: UIButton) {
        
        if sender.titleLabel?.text == "-5" {
            self.parentVC?.entityAmounts[self.indexPathRow] -= 5
        } else if sender.titleLabel?.text == "-1" {
            self.parentVC?.entityAmounts[self.indexPathRow] -= 1
        } else if sender.titleLabel?.text == "+1" {
            self.parentVC?.entityAmounts[self.indexPathRow] += 1
        } else if sender.titleLabel?.text == "+5" {
            self.parentVC?.entityAmounts[self.indexPathRow] += 5
        }
        
        self.parentVC?.cashAmountCollectionViewCell.reloadData()
    }

}
