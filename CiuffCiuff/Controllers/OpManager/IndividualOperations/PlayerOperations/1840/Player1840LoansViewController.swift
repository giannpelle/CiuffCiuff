//
//  Player1840LoansViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/10/24.
//

import UIKit

class Player1840LoansViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var operatingPlayerBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var loansLabel: UILabel!
    @IBOutlet weak var cancelLoanButton: UIButton!
    @IBOutlet weak var issueHundredLoanButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.issueHundredLoanButton.setTitle(withText: "Issue loan 100 gulden", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.issueHundredLoanButton.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)

        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.loansLabel.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.loansLabel.layer.borderWidth = 3
        
        self.operatingPlayerBaseIndex = self.gameState.convert(index: self.operatingPlayerIndex, backwards: true, withIndexType: .players)
        
        if let playerLoans = self.gameState.loans {
            self.loansLabel.text = "\(playerLoans[self.operatingPlayerIndex]) loans"
            
            if playerLoans[self.operatingPlayerIndex] > 0 {
                self.cancelLoanButton.isHidden = false
            }
        }
        
    }
    
    @IBAction func issueLoanButtonPressed(sender: UIButton) {
        let issueLoanOp = Operation(type: .loan, uid: nil)
        issueLoanOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingPlayerIndex, amount: 100.0)
        issueLoanOp.addLoanDetails(loansSourceGlobalIndex: BankIndex.bank.rawValue, loansDestinationGlobalIndex: self.operatingPlayerIndex, loansAmount: 1)
        
        if !self.gameState.isOperationLegit(operation: issueLoanOp, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Not enough money in Bank to issue loan")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
            
        if self.gameState.perform(operation: issueLoanOp) {
            parentVC.doneButtonPressed(sender: UIButton())
        }
    }
    
    @IBAction func cancelLoanButtonPressed(sender: UIButton) {
        
        let cancelLoanOp = Operation(type: .loan, uid: nil)
        cancelLoanOp.addCashDetails(sourceIndex: self.operatingPlayerIndex, destinationIndex: BankIndex.bank.rawValue, amount: 100.0)
        cancelLoanOp.addLoanDetails(loansSourceGlobalIndex: self.operatingPlayerIndex, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: 1)
        
        if !self.gameState.isOperationLegit(operation: cancelLoanOp, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Not enough money to cancel loan")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
            
        if self.gameState.perform(operation: cancelLoanOp) {
            parentVC.doneButtonPressed(sender: UIButton())
        }
    }
    
    func commitButtonPressed() -> Bool? {
        return true
    }
}
