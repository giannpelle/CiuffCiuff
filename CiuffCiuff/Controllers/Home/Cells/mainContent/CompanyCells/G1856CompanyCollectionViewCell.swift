//
//  CompanyCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/12/22.
//

import UIKit

class G1856CompanyCollectionViewCell: UICollectionViewCell, CompanyCollectionViewCellProtocol {
    
    var parentVC: HomeViewController?
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var payoutAmount: Int!
    var companyStatus: G1856CompanyStatus!
    
    @IBOutlet weak var loansLabel: PaddingLabel!
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var companyAmountLabel: UILabel!
    @IBOutlet weak var sharesAmountLabel: PaddingLabel!
    @IBOutlet weak var lastPayoutButton: UIButton!
    @IBOutlet weak var lastPayoutLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var companyStatusPopupButton: UIButton!
    
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
    
    func setupPopupButtons(withTextColor textColor: UIColor? = nil) {
        
        var statusActions: [UIAction] = []
        for status in [G1856CompanyStatus.incrementalCapitalizationCapped, G1856CompanyStatus.incrementalCapitalization, G1856CompanyStatus.fullCapitalization] {
            if status == self.companyStatus {
                statusActions.append(UIAction(title: status.getDescriptionLabel(), image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                    let newStatus = G1856CompanyStatus.getStatusFromDescriptionLabel(label: action.title)
                    self.parentVC?.gameState.g1856CompaniesStatus?[self.operatingCompanyBaseIndex] = newStatus
                    self.companyStatus = newStatus
                    
                    if let homeVC = self.parentVC, let PARvalue = homeVC.gameState.getPARvalue(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex) {
                        if newStatus == .incrementalCapitalization {
                            let sharesInIPO = homeVC.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[self.operatingCompanyBaseIndex]
                            if sharesInIPO < 5 {
                                let amountToBePaid = (5.0 - sharesInIPO) * Double(PARvalue)
                                
                                let alert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                                alert.setup(withTitle: "Get withheld money", andMessage: "Do you want to add \(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: amountToBePaid)) in the company's treasury?")
                                alert.addCancelAction(withLabel: "Cancel")
                                alert.addConfirmAction(withLabel: "OK") {
                                    let cashOp = Operation(type: .cash, uid: nil)
                                    cashOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: amountToBePaid)
                                    
                                    _ = homeVC.gameState.perform(operation: cashOp)
                                    
                                    homeVC.refreshUI()
                                }
                                
                                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                                
                                homeVC.present(alert, animated: true)
                            }
                        }
                    }
                    
                    self.companyStatusPopupButton.setPopupTitle(withText: action.title, textColor: self.parentVC?.gameState.getCompanyTextColor(atBaseIndex: self.operatingCompanyBaseIndex) ?? UIColor.black)
                    
                }))
            } else {
                statusActions.append(UIAction(title: status.getDescriptionLabel(), image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), handler: { action in
                    let newStatus = G1856CompanyStatus.getStatusFromDescriptionLabel(label: action.title)
                    self.parentVC?.gameState.g1856CompaniesStatus?[self.operatingCompanyBaseIndex] = newStatus
                    self.companyStatus = newStatus
                    
                    if let homeVC = self.parentVC {
                        if newStatus == .incrementalCapitalization {
                            let sharesInIPO = homeVC.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[self.operatingCompanyBaseIndex]
                            if sharesInIPO < 5 {
                                let amountToBePaid = (5.0 - sharesInIPO) * Double(homeVC.gameState.getPARvalue(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex) ?? 0)
                                
                                if amountToBePaid > 0 {
                                    let alert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                                    alert.setup(withTitle: "Get withheld money", andMessage: "Do you want to add \(homeVC.gameState.currencyType.getCurrencyStringFromAmount(amount: amountToBePaid)) in the company's treasury?")
                                    alert.addCancelAction(withLabel: "Cancel")
                                    alert.addConfirmAction(withLabel: "OK") {
                                        let cashOp = Operation(type: .cash, uid: nil)
                                        cashOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: amountToBePaid)
                                        
                                        _ = homeVC.gameState.perform(operation: cashOp)
                                        
                                        homeVC.refreshUI()
                                    }
                                    
                                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                                    
                                    homeVC.present(alert, animated: true)
                                }
                            }
                        }
                    }
                    
                    self.companyStatusPopupButton.setPopupTitle(withText: action.title, textColor: self.parentVC?.gameState.getCompanyTextColor(atBaseIndex: self.operatingCompanyBaseIndex) ?? UIColor.black)
                }))
            }
        }
        
        if statusActions.isEmpty {
            self.companyStatusPopupButton.isHidden = true
        } else {
            self.companyStatusPopupButton.isHidden = false
            
            if self.companyStatus == .incrementalCapitalizationCapped {
                self.companyStatusPopupButton.setPopupTitle(withText: self.companyStatus.getDescriptionLabel(), textColor: textColor ?? self.parentVC?.gameState.getCompanyTextColor(atIndex: self.operatingCompanyIndex) ?? UIColor.black, fontSize: 16.0)
            } else {
                self.companyStatusPopupButton.setPopupTitle(withText: self.companyStatus.getDescriptionLabel(), textColor: textColor ?? self.parentVC?.gameState.getCompanyTextColor(atIndex: self.operatingCompanyIndex) ?? UIColor.black)
            }
            
            self.companyStatusPopupButton.menu = UIMenu(children: statusActions)
            self.companyStatusPopupButton.showsMenuAsPrimaryAction = true
            self.companyStatusPopupButton.changesSelectionAsPrimaryAction = true
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
