//
//  Company1856LoansViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/10/24.
//

import UIKit

class Company1856LoansViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var loansAmount: Int = 0
    var maxLoans: Int = 0
    
    var playerIndexes: [Int] = []
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var loansLabel: UILabel!
    @IBOutlet weak var issueHundredLoanButton: UIButton!
    @IBOutlet weak var issueNinentyLoanButton: UIButton!
    @IBOutlet weak var repayLoanButton: UIButton!
    @IBOutlet weak var payInterestsStackView: UIStackView!
    @IBOutlet weak var payInterestsButton: UIButton!
    @IBOutlet weak var payInterestsReducedButton: UIButton!
    @IBOutlet weak var repayExcessLoansButton: UIButton!
    @IBOutlet weak var repayAllLoansButton: UIButton!
    @IBOutlet weak var emergencyPopupButton: UIButton!
    @IBOutlet weak var emergencyStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.issueHundredLoanButton.setTitle(withText: "Issue loan 100 $", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.issueHundredLoanButton.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)
        self.issueNinentyLoanButton.setTitle(withText: "Issue loan 90 $", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.issueNinentyLoanButton.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)
        self.repayLoanButton.setTitle(withText: "Repay loan", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.repayLoanButton.setBackgroundColor(UIColor.greenORColor, isRectangularShape: true)
        self.payInterestsButton.setTitle(withText: "Pay 20 $ interests", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.payInterestsButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
        self.payInterestsReducedButton.setTitle(withText: "Pay 10 $ interests", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.payInterestsReducedButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
        self.repayAllLoansButton.setTitle(withText: "Repay ALL loans", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.repayAllLoansButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
        self.repayExcessLoansButton.setTitle(withText: "Repay loans in excess", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.repayExcessLoansButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)

        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.loansLabel.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.loansLabel.layer.borderWidth = 3
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        self.playerIndexes = Array<Int>(self.gameState.getPlayerIndexes())
        
        let shareholdersGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: self.operatingCompanyIndex)
        let maxLoans: Int = shareholdersGlobalIndexes.filter { self.gameState.getPlayerIndexes().contains($0) }.map { Int(self.gameState.getSharesPortfolioForPlayer(atIndex: $0)[operatingCompanyBaseIndex]) }.reduce(0, +)
        self.loansLabel.text = "\(self.loansAmount) loans (max \(maxLoans))"
        
        self.maxLoans = maxLoans
        
        if self.loansAmount == 0 {
            self.payInterestsStackView.isHidden = true
            self.repayLoanButton.isHidden = true
            self.repayExcessLoansButton.isHidden = true
            self.emergencyStackView.isHidden = true
            self.repayAllLoansButton.isHidden = true
        } else {
            if self.loansAmount <= maxLoans {
                self.repayExcessLoansButton.isHidden = true
            }
            
            if self.loansAmount > 1 {
                self.payInterestsReducedButton.setTitle(withText: "Pay \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(self.loansAmount - 1) * 10.0)) interests", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
            }
            
            self.payInterestsButton.setTitle(withText: "Pay \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(self.loansAmount) * 10.0)) interests", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
            
            let maxAmountToPay = Double(self.loansAmount) * 100.0
            
            if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) < maxAmountToPay {
                self.setupPopupButtons()
            } else {
                self.emergencyStackView.isHidden = true
            }
        }
        
    }
    
    func setupPopupButtons() {
        
        let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtIndex: self.operatingCompanyIndex) ?? 0
        
        var playersActions: [UIAction] = []
        for playerIdx in self.playerIndexes {
            if playerIdx == presidentPlayerIdx {
                playersActions.append(UIAction(title: self.gameState.getPlayerLabel(atIndex: playerIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getPlayerColor(atIndex: playerIdx)), state: .on, handler: { action in
                    self.emergencyPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                playersActions.append(UIAction(title: self.gameState.getPlayerLabel(atIndex: playerIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getPlayerColor(atIndex: playerIdx)), handler: { action in
                    self.emergencyPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if playersActions.isEmpty {
            self.emergencyPopupButton.isHidden = true
        } else {
            self.emergencyPopupButton.isHidden = false
            if playersActions.count == 1 {
                self.emergencyPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.emergencyPopupButton.setPopupTitle(withText: self.gameState.getPlayerLabel(atIndex: presidentPlayerIdx), textColor: UIColor.white)
            } else {
                self.emergencyPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.emergencyPopupButton.setPopupTitle(withText: self.gameState.getPlayerLabel(atIndex: presidentPlayerIdx), textColor: UIColor.white)
            }
            
            self.emergencyPopupButton.menu = UIMenu(children: playersActions)
            self.emergencyPopupButton.showsMenuAsPrimaryAction = true
            self.emergencyPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    static func payInterests(forCompanyAtIndex cmpIdx: Int, andGameState gameState: GameState) -> Double? {
        
        var amountToPay = 10.0 * Double(gameState.loans?[cmpIdx] ?? 0)
        
        if let beginningIndex = gameState.activeOperations.lastIndex(where: { op in
            OperationType.getOROperationTypes().contains(op.type)
        }) {
            
            let lastOps = gameState.activeOperations[beginningIndex...]
            
            // cmp took a 90 $ loan, pay one less interest
            if lastOps.contains(where: { op in (op.type == .loan && op.destinationGlobalIndex == cmpIdx && op.amount == 90) }) {
                amountToPay -= 10.0
            }
        }
        
        if amountToPay == 0.0 {
            return 0.0
        }
        
        if gameState.getCompanyAmount(atIndex: cmpIdx) >= amountToPay {
            
            let interestsOp = Operation(type: .interests, uid: nil)
            interestsOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
            interestsOp.addCashDetails(sourceIndex: cmpIdx, destinationIndex: BankIndex.bank.rawValue, amount: amountToPay)
            
            if !gameState.isOperationLegit(operation: interestsOp, reverted: false) {
                return nil
            }
                
            if gameState.perform(operation: interestsOp) {
                return amountToPay
            }
            
        }
        
        return nil
    }
    
    func payInterests(withAmount amountToPay: Double) {
        
        if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) >= amountToPay {
            
            let interestsOp = Operation(type: .interests, uid: nil)
            interestsOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            interestsOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: amountToPay)
            
            if !self.gameState.isOperationLegit(operation: interestsOp, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong while paying interests")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
                
            if self.gameState.perform(operation: interestsOp) {
                parentVC.doneButtonPressed(sender: UIButton())
            }
            
        } else {
            
            let opUid = Operation.generateUid()
            
            let compAmount: Int = (Int(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) / 10) * 10
            let playerAmount = amountToPay - Double(compAmount)
            
            let emergencyPlayerIdx = self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.emergencyPopupButton.currentTitle!)
            
            var opsToBePerformed: [Operation] = []
            
            let compOp = Operation(type: .interests, uid: opUid)
            compOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            compOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: Double(compAmount))
            
            let playerOp = Operation(type: .interests, uid: opUid)
            playerOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            playerOp.addCashDetails(sourceIndex: emergencyPlayerIdx, destinationIndex: BankIndex.bank.rawValue, amount: playerAmount)
            
            opsToBePerformed.append(compOp)
            opsToBePerformed.append(playerOp)
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong while paying interests")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
                                   
            for op in opsToBePerformed {
                let _ = self.gameState.perform(operation: op)
            }
            
            parentVC.doneButtonPressed(sender: UIButton())
            
        }
    }
    
    @IBAction func payInterestsReducedButtonPressed(sender: UIButton) {
        
        let amountToPay = 10.0 * Double(self.loansAmount - 1)
        self.payInterests(withAmount: amountToPay)
    }
    
    @IBAction func payInterestsButtonPressed(sender: UIButton) {
        
        let amountToPay = 10.0 * Double(self.loansAmount)
        self.payInterests(withAmount: amountToPay)
    }
    
    @IBAction func issueHundredLoanButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let issueLoanOp = Operation(type: .loan, uid: nil)
        issueLoanOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        issueLoanOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: 100.0)
        issueLoanOp.addLoanDetails(loansSourceGlobalIndex: BankIndex.bank.rawValue, loansDestinationGlobalIndex: self.operatingCompanyIndex, loansAmount: 1)

        opsToBePerformed.append(issueLoanOp)
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Not enough money in Bank to issue loan")
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
        
        parentVC.doneButtonPressed(sender: UIButton())
    }
    
    @IBAction func issueNinentyLoanButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let issueLoanOp = Operation(type: .loan, uid: nil)
        issueLoanOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        issueLoanOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: 90.0)
        issueLoanOp.addLoanDetails(loansSourceGlobalIndex: BankIndex.bank.rawValue, loansDestinationGlobalIndex: self.operatingCompanyIndex, loansAmount: 1)

        opsToBePerformed.append(issueLoanOp)
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Not enough money in Bank to issue loan")
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
        
        parentVC.doneButtonPressed(sender: UIButton())
    }
    
    @IBAction func repayLoanButtonPressed(sender: UIButton) {
        let redeemOpUid = Operation.generateUid()
        
        let repayLoanOp = Operation(type: .loan, uid: redeemOpUid)
        repayLoanOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        repayLoanOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: 100.0)
        repayLoanOp.addLoanDetails(loansSourceGlobalIndex: self.operatingCompanyIndex, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: 1)
        
        if !self.gameState.isOperationLegit(operation: repayLoanOp, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Not enough money to repay loan")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
            
        if self.gameState.perform(operation: repayLoanOp) {
            parentVC.doneButtonPressed(sender: UIButton())
        }
    }
    
    @IBAction func repayALLLoansButtonPressed(sender: UIButton) {
        let redeemOpUid = Operation.generateUid()
        
        let amountToPay = 100.0 * Double(self.loansAmount)
        
        let compMoneyAmount = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)
        
        if compMoneyAmount >= amountToPay {
            
            let repayALLLoansOp = Operation(type: .loan, uid: redeemOpUid)
            repayALLLoansOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            repayALLLoansOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: amountToPay)
            repayALLLoansOp.addLoanDetails(loansSourceGlobalIndex: self.operatingCompanyIndex, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: self.loansAmount)
            
            if !self.gameState.isOperationLegit(operation: repayALLLoansOp, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong while repaying loan")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
                
            if self.gameState.perform(operation: repayALLLoansOp) {
                parentVC.doneButtonPressed(sender: UIButton())
            }
            
        } else {
            
            let emergencyPlayerIdx = self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.emergencyPopupButton.currentTitle!)
            let presidentMoneyAmount = self.gameState.getPlayerAmount(atIndex: emergencyPlayerIdx)
            
            if (compMoneyAmount + presidentMoneyAmount) >= amountToPay {
                
                let playerAmount = amountToPay - Double((Int(compMoneyAmount) / 100) * 100)
                
                var opsToBePerformed: [Operation] = []
                
                let compOp = Operation(type: .loan, uid: redeemOpUid)
                compOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                compOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: Double(compMoneyAmount))
                
                let playerOp = Operation(type: .loan, uid: redeemOpUid)
                playerOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                playerOp.addCashDetails(sourceIndex: emergencyPlayerIdx, destinationIndex: BankIndex.bank.rawValue, amount: playerAmount)
                playerOp.addLoanDetails(loansSourceGlobalIndex: self.operatingCompanyIndex, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: self.loansAmount)
                
                opsToBePerformed.append(compOp)
                opsToBePerformed.append(playerOp)
                
                if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong while repaying loan")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                    return
                }
                
                for op in opsToBePerformed {
                    let _ = self.gameState.perform(operation: op)
                }
                
                parentVC.doneButtonPressed(sender: UIButton())
                
            } else {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Not enough money to repay all loans (emergency not allowed)")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func repayLoansInExcessButtonPressed(sender: UIButton) {
        if self.loansAmount <= self.maxLoans {
            return
        }
        
        let redeemOpUid = Operation.generateUid()
        
        let loansAmountToBeRepaid = self.loansAmount - self.maxLoans
        let amountToPay = 100.0 * Double(loansAmountToBeRepaid)
        
        if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) >= amountToPay {
            
            let repayExcessLoansOp = Operation(type: .loan, uid: redeemOpUid)
            repayExcessLoansOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            repayExcessLoansOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: amountToPay)
            repayExcessLoansOp.addLoanDetails(loansSourceGlobalIndex: self.operatingCompanyIndex, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: self.loansAmount - self.maxLoans)
            
            if !self.gameState.isOperationLegit(operation: repayExcessLoansOp, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong while repaying loan")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
                
            if self.gameState.perform(operation: repayExcessLoansOp) {
                parentVC.doneButtonPressed(sender: UIButton())
            }
        } else {
            
            let compAmount: Int = (Int(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) / 100) * 100
            let playerAmount = amountToPay - Double(compAmount)
            
            let emergencyPlayerIdx = self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.emergencyPopupButton.currentTitle!)
            
            var opsToBePerformed: [Operation] = []
            
            if compAmount > 0 {
                let compOp = Operation(type: .loan, uid: redeemOpUid)
                compOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                compOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: Double(compAmount))
                
                opsToBePerformed.append(compOp)
            }
            
            let playerOp = Operation(type: .loan, uid: redeemOpUid)
            playerOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            playerOp.addCashDetails(sourceIndex: emergencyPlayerIdx, destinationIndex: BankIndex.bank.rawValue, amount: playerAmount)
            playerOp.addLoanDetails(loansSourceGlobalIndex: self.operatingCompanyIndex, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: loansAmountToBeRepaid)
            
            opsToBePerformed.append(playerOp)
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong while repaying loan")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
                                   
            for op in opsToBePerformed {
                let _ = self.gameState.perform(operation: op)
            }
            
            parentVC.doneButtonPressed(sender: UIButton())
            
        }
        
    }

    func commitButtonPressed() -> Bool? {
        return true
    }
}
