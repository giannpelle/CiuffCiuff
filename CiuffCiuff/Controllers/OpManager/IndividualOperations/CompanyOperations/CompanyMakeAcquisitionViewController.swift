//
//  AcquisitionViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/12/23.
//

import UIKit

// TODO: read rules carefully and implement it

class CompanyMakeAcquisitionViewController: UIViewController {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var companyIndexes: [Int] = []
    var maxSharePrice: Int!
    var hasUserConfirmedIrreversibleOperations: Bool = false
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var maxSharePriceLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var minorCompaniesPopupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.view.isHidden = true
        self.parentVC.emptyLabel.isHidden = false
        self.parentVC.doneButton.isHidden = true
        
        return
        
        // TODO: WORK IN PROGRESS
        
//        self.companyIndexes = Array<Int>(self.gameState.getCompanyIndexes())
//        let currentCompanyTotShares = self.gameState.getTotalShareNumberOfCompany(atIndex: self.operatingCompanyIndex)
//        
//        if currentCompanyTotShares == 4 {
//            self.view.isHidden = true
//            self.parentVC.emptyLabel.isHidden = false
//            self.parentVC.doneButton.isHidden = true
//            
//        } else {
//            
//            self.parentVC.emptyLabel.isHidden = true
//            self.view.isHidden = false
//            
//            self.startingAmountLabel.text = self.startingAmountText
//            self.startingAmountLabel.textColor = self.startingAmountColor
//            self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
//        self.startingAmountLabel.font = self.startingAmountFont
//        self.startingAmountLabel.layer.cornerRadius = 25
//        self.startingAmountLabel.clipsToBounds = true
//            
//            
//            self.companyIndexes = self.companyIndexes.filter { cmpIdx in
//                return self.gameState.getTotalShareNumberOfCompany(atIndex: cmpIdx) < currentCompanyTotShares
//            }
//            
//            let compTotShares = self.gameState.getTotalShareNumberOfCompany(atIndex: self.companyIndexes[0])
//            let minorCompanySharesToBuy = compTotShares - self.gameState.getSharesPortfolioForCompany(atIndex: self.companyIndexes[0])[self.gameState.convert(index: self.companyIndexes[0], backwards: true, withIndexType: .companies)]
//            
//            let maxPrice = Int(floor((Double(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) / Double(minorCompanySharesToBuy)) * Double(minorCompanySharesToBuy)))
//            self.maxSharePrice = maxPrice
//            self.maxSharePriceLabel.text = "\(maxPrice)"
//            
//            self.setupPopupButtons()
//        }
        
    }
    
    func setupPopupButtons() {
        var companiesActions: [UIAction] = []
        for (i, companyIdx) in self.companyIndexes.enumerated() {
            if i == 0 {
                companiesActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: companyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: companyIdx)), state: .on, handler: { action in
                    let cmpIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    let cmpBaseIndex = self.gameState.forceConvert(index: cmpIndex, backwards: true, withIndexType: .companies)
                    
                    let minorCompanyTotShares = self.gameState.compTotShares[cmpBaseIndex]
                    let minorCompanySharesToBuy = minorCompanyTotShares - self.gameState.getSharesPortfolioForCompany(atIndex: cmpIndex)[cmpBaseIndex]
                    
                    let maxSharePrice = Int(floor((Double(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) / Double(minorCompanySharesToBuy)) * Double(minorCompanySharesToBuy)))
                    self.maxSharePriceLabel.text = "\(maxSharePrice)"
                    
                    self.minorCompaniesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    
                }))
            } else {
                companiesActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: companyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: companyIdx)), handler: { action in
                    let cmpIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    let cmpBaseIndex = self.gameState.forceConvert(index: cmpIndex, backwards: true, withIndexType: .companies)
                    
                    let minorCompanyTotShares = self.gameState.compTotShares[cmpBaseIndex]
                    let minorCompanySharesToBuy = minorCompanyTotShares - self.gameState.getSharesPortfolioForCompany(atIndex: cmpIndex)[cmpBaseIndex]
                    
                    let maxSharePrice = Int(floor((Double(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) / Double(minorCompanySharesToBuy)) * Double(minorCompanySharesToBuy)))
                    self.maxSharePriceLabel.text = "\(maxSharePrice)"
                    
                    self.minorCompaniesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if companiesActions.isEmpty {
            self.minorCompaniesPopupButton.isHidden = true
        } else {
            self.minorCompaniesPopupButton.isHidden = false
            if companiesActions.count == 1 {
                self.minorCompaniesPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.minorCompaniesPopupButton.setPopupTitle(withText: companiesActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.minorCompaniesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.minorCompaniesPopupButton.setPopupTitle(withText: companiesActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.minorCompaniesPopupButton.menu = UIMenu(children: companiesActions)
            self.minorCompaniesPopupButton.showsMenuAsPrimaryAction = true
            self.minorCompaniesPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = self.cashTextField.text! + titleLabelText
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
    }

    func commitButtonPressed() -> Bool? {
        if self.hasUserConfirmedIrreversibleOperations { return true }
        
        guard let amountStr = self.cashTextField.text, let popupButtonTitle = self.minorCompaniesPopupButton.currentTitle else {
            return false
        }

        let amount = Int(amountStr) ?? 0

        if amount == 0 || amount > self.maxSharePrice {
            return false
        }
        
        let minorCompanyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: popupButtonTitle)
        let minorCompanyBaseIdx = self.gameState.forceConvert(index: minorCompanyIdx, backwards: true, withIndexType: .companies)
        
        if self.gameState.getSharesPortfolioForCompany(atIndex: minorCompanyIdx)[minorCompanyBaseIdx] == self.gameState.compTotShares[minorCompanyBaseIdx] {
            return false
        }
        
        var opsToPerform: [Operation] = []
        
        for globalIdx in 0..<self.gameState.amounts.count {
            if !self.gameState.getPlayerIndexes().contains(globalIdx) {
                continue
            }
            
            let numberOfShares = self.gameState.shares[globalIdx][minorCompanyBaseIdx]
            if numberOfShares > 0 {
                let shareOp = Operation(type: .acquisition, uid: nil)
                shareOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: globalIdx, amount: Double(amount) * numberOfShares)
                shareOp.addSharesDetails(shareSourceIndex: globalIdx, shareDestinationIndex: BankIndex.bank.rawValue, shareAmount: numberOfShares, shareCompanyBaseIndex: minorCompanyBaseIdx)

                opsToPerform.append(shareOp)
            }
        }
        
        let remainingAmount = self.gameState.getCompanyAmount(atIndex: minorCompanyIdx)
        if (remainingAmount > 0) {
            let cashOp = Operation(type: .acquisition, uid: nil)
            cashOp.addCashDetails(sourceIndex: minorCompanyIdx, destinationIndex: self.operatingCompanyIndex, amount: remainingAmount)
            opsToPerform.append(cashOp)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToPerform, reverted: false) {
            return false
        }
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "ATTENTION", andMessage: "The operation cannot be undo. Do you want to proceed anyway?")
        alert.addCancelAction(withLabel: "Cancel")
        alert.addConfirmAction(withLabel: "OK") {
            for op in opsToPerform {
                let _ = self.gameState.perform(operation: op)
            }
            
            self.hasUserConfirmedIrreversibleOperations = true
            
            self.parentVC.doneButtonPressed(sender: UIButton())

        }
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
        return nil
        
    }

}
