//
//  SalePreviewCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 03/08/24.
//

import UIKit

class SalePreviewCollectionViewCell: UICollectionViewCell {
    
    var parentVC: OpeningPreviewViewController?
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var indexPath: IndexPath!
    
    @IBOutlet weak var companyBackgroundView: UIView!
    @IBOutlet weak var backgroundAccessoryView: UIView!
    @IBOutlet weak var compImageView: UIImageView!
    @IBOutlet weak var compImageBackgroundView: UIView!
    @IBOutlet weak var compShareValueLabel: UILabel!
    @IBOutlet weak var shareValueStepper: UIStepper!
    @IBOutlet weak var shareAmountLabel: UILabel!
    @IBOutlet weak var shareAmountStepper: UIStepper!
    @IBOutlet weak var maxShareAmountLabel: UILabel!
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func shareValueStepperValueChanged(sender: UIStepper) {
        
        if self.gameState.getCompanyType(atIndex: self.operatingCompanyIndex).isShareValueTokenOnBoard() {
            
            let shareValue = self.gameState.getDistinctShareValuesSorted()[Int(sender.value)]
            self.compShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: shareValue)
            
            if let parentVC = self.parentVC {
                parentVC.previewAmountsByComp[self.indexPath.row] = Int(shareValue * self.shareAmountStepper.value)
                parentVC.refreshTitleLabel()
            }
        } else {
            
            let shareValue = sender.value
            self.compShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: shareValue)
            
            if let parentVC = self.parentVC {
                parentVC.previewAmountsByComp[self.indexPath.row] = Int(shareValue * self.shareAmountStepper.value)
                parentVC.refreshTitleLabel()
            }
        }
        
    }
    
    @IBAction func shareAmountStepperValueChanged(sender: UIStepper) {
        self.shareAmountLabel.text = "SELL: \(Int(sender.value))"
        
        if let parentVC = self.parentVC {
            let shareValue = self.gameState.getDistinctShareValuesSorted()[Int(self.shareValueStepper.value)]
            
            parentVC.previewShareAmountsByComp[self.indexPath.row] = Int(sender.value)
            parentVC.previewAmountsByComp[self.indexPath.row] = Int(shareValue * sender.value)
            parentVC.refreshTitleLabel()
        }
    }
    
}
