//
//  CompanyCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/12/22.
//

import UIKit

protocol CompanyCollectionViewCellProtocol: AnyObject {
    var contentView: UIView {get }
    var backgroundColor: UIColor? { get set }
    var isUserInteractionEnabled: Bool { get set }
    
    var parentVC: HomeViewController? { get set }
    var operatingCompanyIndex: Int! { get set }
    var operatingCompanyBaseIndex: Int! { get set }
    var payoutAmount: Int! { get set }
    
    var companyLogoImageView: UIImageView! { get }
    var companyAmountLabel: UILabel! { get }
    var sharesAmountLabel: PaddingLabel! { get }
    var lastPayoutButton: UIButton! { get }
    var lastPayoutLabel: UILabel! { get }
    var tickImageView: UIImageView! { get }
}

class CompanyCollectionViewCell: UICollectionViewCell, CompanyCollectionViewCellProtocol {
    
    var parentVC: HomeViewController?
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var payoutAmount: Int!
    
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
            let bankIndexes = shareholdersGlobalIndexes.filter { homeVC.gameState.getBankEntityIndexes().contains($0) }
            
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
