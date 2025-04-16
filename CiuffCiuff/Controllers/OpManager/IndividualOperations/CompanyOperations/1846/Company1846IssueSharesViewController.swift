//
//  Company1846IssueSharesViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 11/04/25.
//

import UIKit

class Company1846IssueSharesViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var previousShareValue: Double = 0.0
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var buttonsContainerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        let sharesInPlayersHands = self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: self.operatingCompanyBaseIndex).filter { self.gameState.getPlayerIndexes().contains($0) }.map { self.gameState.getSharesPortfolioForPlayer(atIndex: $0)[self.operatingCompanyBaseIndex] }.reduce(0, +)
        
        let soldableSharesCount = min(sharesInPlayersHands - self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[self.operatingCompanyBaseIndex], self.gameState.getSharesPortfolioForCompany(atIndex: self.operatingCompanyIndex)[self.operatingCompanyBaseIndex])
        
        if let currentShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex) {
            if let idx = self.gameState.getDistinctShareValuesSorted().firstIndex(of: currentShareValue) {
                if idx > 1 {
                    self.previousShareValue = self.gameState.getDistinctShareValuesSorted()[idx - 1]
                }
            }
        }
        
        if soldableSharesCount <= 0 || self.previousShareValue == 0.0 {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
            return
        }
        
        self.accessoryLabel.text = "maximum #shares to be issued: \(Int(soldableSharesCount))"
        
        for (i, view) in self.buttonsContainerStackView.arrangedSubviews.enumerated() {
            if let btn = view as? UIButton {
                if i < Int(soldableSharesCount) {
                    btn.isHidden = false
                    btn.tag = i
                    
                    btn.setTitle(withText: "Issue \(i + 1)x \(i == 0 ? "share" : "shares"): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(i + 1) * self.previousShareValue))", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
                    btn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                    
                    btn.addTarget(self, action: #selector(issueShareButtonPressed(_:)), for: .touchUpInside)
                    
                } else {
                    btn.isHidden = true
                }
            }
        }
    }
    
    @objc func issueShareButtonPressed(_ sender: UIButton) {
        let issueOp = Operation(type: .sell)
        issueOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: self.previousShareValue * Double(sender.tag + 1))
        issueOp.addSharesDetails(shareSourceIndex: self.operatingCompanyIndex, shareDestinationIndex: BankIndex.bank.rawValue, shareAmount: Double(sender.tag + 1), shareCompanyBaseIndex: self.operatingCompanyBaseIndex)
        
        if self.gameState.isOperationLegit(operation: issueOp, reverted: false) {
            if self.gameState.perform(operation: issueOp) {
                self.parentVC.doneButtonPressed(sender: UIButton())
            }
        }
    }
    
    func commitButtonPressed() -> Bool? {
        return true
    }

}
