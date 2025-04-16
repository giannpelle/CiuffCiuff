//
//  PlayerCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/12/22.
//

import UIKit

class PlayerCollectionViewCell: UICollectionViewCell {
    
    var parentVC: HomeViewController?
    var operatingPlayerIndex: Int!
    
    @IBOutlet weak var playerTurnOrderLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerAmountLabel: UILabel!
    @IBOutlet weak var sharesAmountLabel: PaddingLabel!
    @IBOutlet weak var certificateLimitLabel: UILabel!
    @IBOutlet weak var floatLabel: UILabel!
    @IBOutlet weak var PARButton: UIButton!
    @IBOutlet weak var totalNetWorthLabel: UILabel!
    @IBOutlet weak var leftDividerAccessoryView: UIView!
    @IBOutlet weak var rightDividerAccessoryView: UIView!
    @IBOutlet weak var loansLabel: PaddingLabel!
    @IBOutlet weak var dynamicTurnOrderPreviewLabel: UILabel!
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        if let shareAmountTxt = self.sharesAmountLabel.text {
            if shareAmountTxt == "0" {
                return
            }
        }
        
        if let homeVC = self.parentVC {
            homeVC.openSharesViewController(withShareholderGlobalIndexes: [self.operatingPlayerIndex])
        }
    }
    
    @IBAction func PARIndicatorButtonPressed(sender: UIButton) {
        
        if let homeVC = self.parentVC {
            if homeVC.gameState.getSharesPortfolioForPlayer(atIndex: self.operatingPlayerIndex).reduce(0, +) > 0 {
                homeVC.openPreviewOpeningVC(operatingPlayerIndex: self.operatingPlayerIndex)
            } else {

                let PARValues = homeVC.gameState.getGamePARValues()
                
                var parStr = ""
                if homeVC.gameState.game == .g1849 {
                    for i in 0..<PARValues.count {
                        parStr += "PAR \(PARValues[i]):\n"
                        parStr += "\(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * 2))) - "
                        parStr += "\(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * 3))) - "
                        parStr += "\(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * 4)))\n"
                    }
                } else if homeVC.gameState.game == .g1856 {
                    for i in 0..<PARValues.count {
                        let necessaryShareAmount = min(homeVC.gameState.currentTrainPriceIndex + 2, 6)
                        
                        parStr += "PAR \(PARValues[i]):\n"
                        parStr += "\(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * necessaryShareAmount))) / "
                        parStr += "\(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * (necessaryShareAmount + 1))))\n"
                    }
                } else {
                    for i in 0..<PARValues.count {
                        parStr += "PAR \(PARValues[i]): \(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(homeVC.gameState.openCompanyValues[i])))\n"
                    }
                }
                
                let alert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "\(homeVC.gameState.getPlayerLabel(atIndex: self.operatingPlayerIndex)): \(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: homeVC.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex)))", andMessage: parStr.trimmingCharacters(in: .newlines))
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                homeVC.present(alert, animated: true)
            }

        }
    }
    
}
