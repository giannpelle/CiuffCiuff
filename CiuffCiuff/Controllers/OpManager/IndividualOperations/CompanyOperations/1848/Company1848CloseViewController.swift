//
//  Company1848CloseViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 13/08/24.
//

import UIKit

class Company1848CloseViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    let initalShareValues: [Double] = [70, 80, 90, 100]
    var playerIndexes: [Int] = []
    var opsToBePerformed: [Operation] = []
    var hasUserConfirmedIrreversibleOperations: Bool = false
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var initialShareValueSegmentedControl: UISegmentedControl!
    @IBOutlet weak var playersPopupButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        self.playerIndexes = Array<Int>(self.gameState.getPlayerIndexes())

        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        let cmpBaseIdx = self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        let PARvalue = Double(self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx) ?? 0)
        if let idx = self.initalShareValues.firstIndex(of: PARvalue) {
            self.initialShareValueSegmentedControl.selectedSegmentIndex = idx
        }
        
        if !self.gameState.floatedCompanies[cmpBaseIdx] {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
            return
        }
        self.parentVC.emptyLabel.isHidden = true
        self.view.isHidden = false
        
        self.initialShareValueSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.initialShareValueSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.initialShareValueSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.initialShareValueSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        self.setupPopupButtons()
        
        self.updateDescriptionLabel()
        
    }
    
    func getPresidentGlobalIndex() -> Int {
        return self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.playersPopupButton.currentTitle!)
    }
    
    func setupPopupButtons() {
        
        let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtIndex: self.operatingCompanyIndex) ?? 0
        
        var playersActions: [UIAction] = []
        for (i, playerIdx) in self.playerIndexes.enumerated() {
            if i == presidentPlayerIdx {
                playersActions.append(UIAction(title: self.gameState.getPlayerLabel(atIndex: playerIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getPlayerColor(atIndex: playerIdx)), state: .on, handler: { action in
                    self.updateDescriptionLabel()
                    self.playersPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                playersActions.append(UIAction(title: self.gameState.getPlayerLabel(atIndex: playerIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getPlayerColor(atIndex: playerIdx)), handler: { action in
                    self.updateDescriptionLabel()
                    self.playersPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if playersActions.isEmpty {
            self.playersPopupButton.isHidden = true
        } else {
            self.playersPopupButton.isHidden = false
            if playersActions.count == 1 {
                self.playersPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.playersPopupButton.setPopupTitle(withText: self.gameState.getPlayerLabel(atBaseIndex: presidentPlayerIdx), textColor: UIColor.white)
            } else {
                self.playersPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.playersPopupButton.setPopupTitle(withText: self.gameState.getPlayerLabel(atBaseIndex: presidentPlayerIdx), textColor: UIColor.white)
            }
            
            self.playersPopupButton.menu = UIMenu(children: playersActions)
            self.playersPopupButton.showsMenuAsPrimaryAction = true
            self.playersPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    @IBAction func initialShareValueSegmentedControlValueChanged(sender: UISegmentedControl) {
        self.updateDescriptionLabel()
    }
    
    func updateDescriptionLabel() {
        
        self.opsToBePerformed = []
        
        let presidentGlobalIdx = self.getPresidentGlobalIndex()
        let initialShareValue = self.initalShareValues[self.initialShareValueSegmentedControl.selectedSegmentIndex]
        
        var opsToBePerformed: [Operation] = []
        
        var descriptionStr = ""
        var amountAssignedToCompany = 0.0
        
        for shareholderIdx in self.gameState.getShareholderGlobalIndexesForCompany(atIndex: self.operatingCompanyIndex) {
            if self.gameState.getPlayerIndexes().contains(shareholderIdx) && shareholderIdx != presidentGlobalIdx {
                let shareAmount = self.gameState.getSharesPortfolioForPlayer(atIndex: shareholderIdx)[self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)]
                let cashout = shareAmount * initialShareValue
                
                if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) - amountAssignedToCompany >= cashout {
                    
                    let op = Operation(type: .close, uid: nil)
                    op.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    op.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: shareholderIdx, amount: cashout)
                    
                    opsToBePerformed.append(op)
                    
                    descriptionStr += "\(self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex)) -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: cashout)) -> \(self.gameState.getPlayerLabel(atIndex: shareholderIdx))\n"
                    
                    amountAssignedToCompany += cashout
                    
                } else if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) != amountAssignedToCompany {
                    
                    let compQuoteAmount = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) - amountAssignedToCompany
                    let presQuoteAmount = cashout - compQuoteAmount
                    
                    let compOp = Operation(type: .close, uid: nil)
                    compOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    compOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: shareholderIdx, amount: compQuoteAmount)
                    
                    opsToBePerformed.append(compOp)
                    
                    descriptionStr += "\(self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex)) -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: compQuoteAmount)) -> \(self.gameState.getPlayerLabel(atIndex: shareholderIdx))\n"
                    
                    amountAssignedToCompany += compQuoteAmount
                    
                    let presOp = Operation(type: .close, uid: nil)
                    presOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    presOp.addCashDetails(sourceIndex: presidentGlobalIdx, destinationIndex: shareholderIdx, amount: presQuoteAmount)
                    
                    opsToBePerformed.append(presOp)
                    
                    descriptionStr += "\(self.gameState.getPlayerLabel(atIndex: presidentGlobalIdx)) -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: presQuoteAmount)) -> \(self.gameState.getPlayerLabel(atIndex: shareholderIdx))\n"
                    
                } else {
                    
                    let presOp = Operation(type: .close, uid: nil)
                    presOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    presOp.addCashDetails(sourceIndex: presidentGlobalIdx, destinationIndex: shareholderIdx, amount: cashout)
                    
                    opsToBePerformed.append(presOp)
                    
                    descriptionStr += "\(self.gameState.getPlayerLabel(atIndex: presidentGlobalIdx)) -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: cashout)) -> \(self.gameState.getPlayerLabel(atIndex: shareholderIdx))\n"
                }
            }
        }
        
        let remainingCashInCompTreasury = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) - amountAssignedToCompany
        if remainingCashInCompTreasury > 0 {
            let cashOp = Operation(type: .close, uid: nil)
            cashOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            cashOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: remainingCashInCompTreasury)
            
            opsToBePerformed.append(cashOp)
            
            descriptionStr += "\(self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex)) -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: remainingCashInCompTreasury)) -> Bank\n"
        }
        
        self.opsToBePerformed = opsToBePerformed
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        
        if descriptionStr != "\n" {
            let attributedString = NSMutableAttributedString(string: descriptionStr)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            self.descriptionLabel.attributedText = attributedString
        } else {
            let attributedString = NSMutableAttributedString(string: "No custom operation will be performed\n(no shareholders other than President)")
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            self.descriptionLabel.attributedText = attributedString
        }
        
    }
    
    func commitButtonPressed() -> Bool? {
        if self.hasUserConfirmedIrreversibleOperations { return true }
        
        if !self.gameState.areOperationsLegit(operations: self.opsToBePerformed, reverted: false) {
            return false
        }
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "ATTENTION", andMessage: "The operation cannot be undo. Do you want to proceed anyway?")
        alert.addCancelAction(withLabel: "Cancel")
        alert.addConfirmAction(withLabel: "OK") {
            for op in self.opsToBePerformed {
                let _ = self.gameState.perform(operation: op)
            }
            
            self.gameState.g1848CompaniesInReceivershipFlags?[self.operatingCompanyBaseIndex] = true
            self.gameState.g1848CompaniesInReceivershipPresidentPlayerIndexes?[self.operatingCompanyBaseIndex] = self.getPresidentGlobalIndex()
            
            self.gameState.closeCompany(atIndex: self.operatingCompanyIndex)
            
            self.hasUserConfirmedIrreversibleOperations = true
            
            self.parentVC.doneButtonPressed(sender: UIButton())
            
        }
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
        return nil
        
    }
   

}
