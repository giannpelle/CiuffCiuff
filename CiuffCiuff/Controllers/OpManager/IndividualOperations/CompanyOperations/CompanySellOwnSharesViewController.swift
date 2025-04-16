//
//  CompanySellOwnSharesViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/03/23.
//

import UIKit

class CompanySellOwnSharesViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var shareAmounts: [Double] = []
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var sharesAmountPopupButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.sellButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        let operatingCompanyBaseIndex = self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        let availableSharesAmount = self.gameState.getSharesPortfolioForCompany(atIndex: self.operatingCompanyIndex)[operatingCompanyBaseIndex]
        let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: operatingCompanyBaseIndex)
        
        if let cmpShareValue = cmpShareValue, availableSharesAmount > 0 {
            self.shareAmounts = self.gameState.predefinedShareAmounts.filter { $0 <= availableSharesAmount }
            
            self.sellButton.setTitle(withText: "SELL: \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: cmpShareValue))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
            self.sellButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
            
            self.parentVC.emptyLabel.isHidden = true
            self.view.isHidden = false
            
            self.setupPopupButtons()
        } else {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
        }
        
    }
    
    func setupPopupButtons() {
        var sharesAmountActions: [UIAction] = []
        for (i, shareAmount) in self.shareAmounts.enumerated() {
            if i == 0 {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) share", state: .on, handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesAmountActions.isEmpty {
            self.sharesAmountPopupButton.isHidden = true
        } else {
            self.sharesAmountPopupButton.isHidden = false
            if sharesAmountActions.count == 1 {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.sharesAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
            self.sharesAmountPopupButton.showsMenuAsPrimaryAction = true
            self.sharesAmountPopupButton.changesSelectionAsPrimaryAction = true
        }
    }
    
    @IBAction func sellButtonPressed(sender: UIButton) {
        let operatingCompanyBaseIndex = self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        guard let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: operatingCompanyBaseIndex) else { return }
        
        let shareAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.sharesAmountPopupButton.currentTitle!)
        
        var amount = 0.0
        
        if self.gameState.buySellRoundPolicyOnTotal == .roundUp {
            amount = floor(cmpShareValue * shareAmount)
        } else {
            amount = ceil(cmpShareValue * shareAmount)
        }
        
        if amount == 0.0 && shareAmount == 0.0 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        var sellOps: [Operation] = []
        
        let srcIndex: Int = BankIndex.bank.rawValue
        let dstIndex: Int = self.operatingCompanyIndex
        
        let shareSrcIndex: Int = self.operatingCompanyIndex
        let shareDstIndex: Int = BankIndex.bank.rawValue
        let shareCmpIndex: Int = self.operatingCompanyIndex
        let shareCmpBaseIndex: Int = self.gameState.forceConvert(index: shareCmpIndex, backwards: true, withIndexType: .companies)
                
        let operation = Operation(type: .sell, uid: nil)
        operation.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        operation.addCashDetails(sourceIndex: srcIndex, destinationIndex: dstIndex, amount: amount)
        operation.addSharesDetails(shareSourceIndex: shareSrcIndex, shareDestinationIndex: shareDstIndex, shareAmount: shareAmount, shareCompanyBaseIndex: shareCmpBaseIndex)
        
        sellOps.append(operation)
        
        sellOps += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: shareCmpBaseIndex, andSharesAmount: shareAmount, withUid: operation.uid)
        
        if !self.gameState.areOperationsLegit(operations: sellOps, reverted: false) {
            return
        }
        
        for op in sellOps {
            if !self.gameState.perform(operation: op) {
                
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                
                return
            }
        }
        
        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(shareCmpBaseIndex) {
            self.closeCompany(atBaseIndex: shareCmpBaseIndex)
            return
        }
        
        self.parentVC.doneButtonPressed(sender: UIButton())
        
    }

    func commitButtonPressed() -> Bool? {
        return true
    }

}
