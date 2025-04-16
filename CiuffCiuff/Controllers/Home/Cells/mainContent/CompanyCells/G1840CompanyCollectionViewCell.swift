//
//  G1840CompanyCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 06/01/25.
//

import UIKit

class G1840CompanyCollectionViewCell: UICollectionViewCell, CompanyCollectionViewCellProtocol {

    var parentVC: HomeViewController?
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var payoutAmount: Int!

    @IBOutlet weak var totalRevenueLabel: UILabel!
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var companyAmountLabel: UILabel!
    @IBOutlet weak var sharesAmountLabel: PaddingLabel!
    @IBOutlet weak var lastPayoutButton: UIButton!
    @IBOutlet weak var lastPayoutLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    
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
    
}
