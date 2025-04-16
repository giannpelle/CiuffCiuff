//
//  Company1846RedeemSharesViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 11/04/25.
//

import UIKit

class Company1846RedeemSharesViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var followingShareValue: Double = 0.0
    
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
        
        let buyableSharesCount = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[self.operatingCompanyBaseIndex]
        
        if let currentShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex) {
            if let idx = self.gameState.getDistinctShareValuesSorted().firstIndex(of: currentShareValue) {
                if idx < self.gameState.getDistinctShareValuesSorted().count {
                    self.followingShareValue = self.gameState.getDistinctShareValuesSorted()[idx + 1]
                }
            }
        }
        
        if buyableSharesCount <= 0 {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
            return
        }
        
        self.accessoryLabel.text = "maximum #shares to be redeemed: \(Int(buyableSharesCount))"
        
        for (i, view) in self.buttonsContainerStackView.arrangedSubviews.enumerated() {
            if let btn = view as? UIButton {
                if i < Int(buyableSharesCount) {
                    btn.isHidden = false
                    btn.tag = i
                    
                    btn.setTitle(withText: "Redeem \(i + 1)x \(i == 0 ? "share" : "shares"): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(i + 1) * self.followingShareValue))", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
                    btn.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)
                    
                    btn.addTarget(self, action: #selector(redeemShareButtonPressed(_:)), for: .touchUpInside)
                    
                } else {
                    btn.isHidden = true
                }
            }
        }
    }
    
    @objc func redeemShareButtonPressed(_ sender: UIButton) {
        let redeemOp = Operation(type: .buy)
        redeemOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: self.followingShareValue * Double(sender.tag + 1))
        redeemOp.addSharesDetails(shareSourceIndex: BankIndex.bank.rawValue, shareDestinationIndex: self.operatingCompanyIndex, shareAmount: Double(sender.tag + 1), shareCompanyBaseIndex: self.operatingCompanyBaseIndex)
        
        if self.gameState.isOperationLegit(operation: redeemOp, reverted: false) {
            if self.gameState.perform(operation: redeemOp) {
                self.parentVC.doneButtonPressed(sender: UIButton())
            }
        }
    }
    
    func commitButtonPressed() -> Bool? {
        return true
    }

}
