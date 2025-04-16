//
//  CompanyCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/12/22.
//

import UIKit

class LoansCompanyCollectionViewCell: UICollectionViewCell, CompanyCollectionViewCellProtocol {
    
    var parentVC: HomeViewController?
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var payoutAmount: Int!
    var companyStatus: G1856CompanyStatus!
    
    @IBOutlet weak var loansLabel: PaddingLabel!
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var companyAmountLabel: UILabel!
    @IBOutlet weak var companyShareValueLabel: UILabel!
    @IBOutlet weak var sharesAmountLabel: PaddingLabel!
    @IBOutlet weak var lastPayoutButton: UIButton!
    @IBOutlet weak var lastPayoutLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
    @IBOutlet weak var centerYLayoutConstraint: NSLayoutConstraint!
    
    override class func awakeFromNib() {
    }
    
    @IBAction func showShareholdersButtonPressed(sender: UIButton) {
        
        if let homeVC = self.parentVC {
            let shareholdersGlobalIndexes = homeVC.gameState.getShareholderGlobalIndexesForCompany(atIndex: self.operatingCompanyIndex)
            let playersIndexes = shareholdersGlobalIndexes.filter { homeVC.gameState.getPlayerIndexes().contains($0) }.sorted { homeVC.gameState.shares[$0][self.operatingCompanyBaseIndex] > homeVC.gameState.shares[$1][self.operatingCompanyBaseIndex] }
            let bankIndexes = shareholdersGlobalIndexes.filter { !homeVC.gameState.getBankEntityIndexes().contains($0) }
            
            homeVC.openSharesViewController(withShareholderGlobalIndexes: (playersIndexes + bankIndexes), withFilteredCompanyIndex: self.operatingCompanyIndex)
        }
    }
    
    @IBAction func payoutButtonPressed(sender: UIButton) {
        if let homeVC = self.parentVC {
            self.lastPayoutLabel.backgroundColor = self.lastPayoutLabel.textColor
            
            _ = CompanyOperateViewController.payout(withAmount: self.payoutAmount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: homeVC.gameState)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.lastPayoutLabel.backgroundColor = UIColor.clear
                
                homeVC.refreshUI()
            }
        }
    }

    
}
