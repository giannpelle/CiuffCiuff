//
//  Company1848LoansViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 10/01/25.
//

import UIKit

class Company1848LoansViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var loansAmount: Int = 0
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var loansLabel: UILabel!
    @IBOutlet weak var issueLoanLeftTwiceButton: UIButton!
    @IBOutlet weak var issueLoanLeftThreeTimesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.issueLoanLeftTwiceButton.setTitle(withText: "Issue loan (LEFT 2x)", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.issueLoanLeftTwiceButton.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)
        self.issueLoanLeftThreeTimesButton.setTitle(withText: "Issue loan (LEFT 3x)", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.issueLoanLeftThreeTimesButton.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)

        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.loansLabel.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.loansLabel.layer.borderWidth = 3
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        let attributedString = NSMutableAttributedString()
        
        let str1 = "\(self.loansAmount) loans"
        let str2 = "\n(max 1 voluntarily per OR)\n(max 5 loans voluntarily)\nno limits if mandatory train purchase"
        
        let attr1 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: .semibold)]
        let attr2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .medium)]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 7
                
        attributedString.append(NSAttributedString(string: str1, attributes: attr1))
        attributedString.append(NSAttributedString(string: str2, attributes: attr2))

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.loansLabel.attributedText = attributedString
        
    }
    
    @IBAction func issueLoanLeftTwoButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let issueLoanOp = Operation(type: .loan, uid: nil)
        issueLoanOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        issueLoanOp.addCashDetails(sourceIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), destinationIndex: self.operatingCompanyIndex, amount: 100.0)
        issueLoanOp.addLoanDetails(loansSourceGlobalIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), loansDestinationGlobalIndex: self.operatingCompanyIndex, loansAmount: 1)

        opsToBePerformed.append(issueLoanOp)
        
        if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .left, count: 2), withUid: issueLoanOp.uid) {
            opsToBePerformed.append(marketOp)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "There are no more loans/cash available in the Bank of England")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
            
        for op in opsToBePerformed {
            if !self.gameState.perform(operation: op) {
                return
            }
        }
        
        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
            self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
            return
            
        } else {
            self.parentVC.doneButtonPressed(sender: UIButton())
        }
        
    }
    
    @IBAction func issueLoanLeftThreeButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let issueLoanOp = Operation(type: .loan, uid: nil)
        issueLoanOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        issueLoanOp.addCashDetails(sourceIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), destinationIndex: self.operatingCompanyIndex, amount: 100.0)
        issueLoanOp.addLoanDetails(loansSourceGlobalIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), loansDestinationGlobalIndex: self.operatingCompanyIndex, loansAmount: 1)

        opsToBePerformed.append(issueLoanOp)
        
        if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .left, count: 3), withUid: issueLoanOp.uid) {
            opsToBePerformed.append(marketOp)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "There are no more loans/cash available in the Bank of England")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
            
        for op in opsToBePerformed {
            if !self.gameState.perform(operation: op) {
                return
            }
        }

        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
            self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
            return
            
        } else {
            self.parentVC.doneButtonPressed(sender: UIButton())
        }
        
    }

    func commitButtonPressed() -> Bool? {
        return true
    }

}
