//
//  Company1849BondViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 15/10/24.
//

import UIKit

class Company1849BondViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var payInterestsButton: UIButton!
    @IBOutlet weak var issueBondButton: UIButton!
    @IBOutlet weak var repayBondButton: UIButton!
    @IBOutlet weak var repayBondEmergencyButton: UIButton!
    @IBOutlet weak var repayBondEmergencyStackView: UIStackView!
    @IBOutlet weak var emergencyPopupButton: UIButton!
    
    var playerIndexes: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
    
        self.payInterestsButton.setTitle(withText: "Pay L. 50 interests", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.payInterestsButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
        self.issueBondButton.setTitle(withText: "Issue BOND", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.issueBondButton.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)
        self.repayBondButton.setTitle(withText: "Repay BOND", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.repayBondButton.setBackgroundColor(UIColor.greenORColor, isRectangularShape: true)
        self.repayBondEmergencyButton.setTitle(withText: "Repay BOND emergency", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.repayBondEmergencyButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)

        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        self.playerIndexes = Array<Int>(self.gameState.getPlayerIndexes())
        
        if let bondAmount = self.gameState.bonds?[self.operatingCompanyIndex], bondAmount == 0 {
            self.payInterestsButton.isHidden = true
            self.repayBondButton.isHidden = true
            self.repayBondEmergencyButton.isHidden = true
            self.repayBondEmergencyStackView.isHidden = true
            
            self.issueBondButton.isHidden = false
        } else {
            self.payInterestsButton.isHidden = false
            if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) >= 500 {
                self.repayBondButton.isHidden = false
                
                self.repayBondEmergencyButton.isHidden = true
                self.repayBondEmergencyStackView.isHidden = true
            } else {
                self.repayBondButton.isHidden = true
                
                self.repayBondEmergencyButton.isHidden = false
                self.repayBondEmergencyStackView.isHidden = false
                
                self.setupPopupButtons()
            }
            
            self.issueBondButton.isHidden = true
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
    
    static func payBondInterests(forCompanyAtIndex cmpIdx: Int, andGameState gameState: GameState) -> Bool {
        
        let interestOp = Operation(type: .interests, uid: nil)
        interestOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
        interestOp.addCashDetails(sourceIndex: cmpIdx, destinationIndex: BankIndex.bank.rawValue, amount: 50.0)
        
        if !gameState.isOperationLegit(operation: interestOp, reverted: false) {
            return false
        }
        
        return gameState.perform(operation: interestOp)
    }

    @IBAction func payInterestsButtonPressed(sender: UIButton) {
        if Self.payBondInterests(forCompanyAtIndex: self.operatingCompanyIndex, andGameState: self.gameState) {
            parentVC.doneButtonPressed(sender: UIButton())
        }
    }
    
    @IBAction func issueBondButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let issueBondOp = Operation(type: .bond, uid: nil)
        issueBondOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        issueBondOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: 500.0)
        issueBondOp.addBondDetails(bondsSourceGlobalIndex: BankIndex.bank.rawValue, bondsDestinationGlobalIndex: self.operatingCompanyIndex, bondsAmount: 1)

        opsToBePerformed.append(issueBondOp)
        
        if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .left, count: 1), withUid: issueBondOp.uid) {
            opsToBePerformed.append(marketOp)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
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
        }
        
        parentVC.doneButtonPressed(sender: UIButton())
    }
    
    @IBAction func repayBondButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let repayBondOp = Operation(type: .bond, uid: nil)
        repayBondOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        repayBondOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: 500.0)
        repayBondOp.addBondDetails(bondsSourceGlobalIndex: self.operatingCompanyIndex, bondsDestinationGlobalIndex: BankIndex.bank.rawValue, bondsAmount: 1)

        opsToBePerformed.append(repayBondOp)
        
        if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 1), withUid: repayBondOp.uid) {
            opsToBePerformed.append(marketOp)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return
        }
        
        for op in opsToBePerformed {
            if !self.gameState.perform(operation: op) {
                return
            }
        }
        
        parentVC.doneButtonPressed(sender: UIButton())
        
    }
    
    @IBAction func repayBondEmergencyButtonPressed(sender: UIButton) {
        let repayOpUid = Operation.generateUid()
        
        let amountToPay = 500.0
            
        let compAmount = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)
        let playerAmount = amountToPay - compAmount
        
        let emergencyPlayerIdx = self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.emergencyPopupButton.currentTitle!)
        
        var opsToBePerformed: [Operation] = []
        
        if compAmount > 0 {
            let compOp = Operation(type: .bond, uid: repayOpUid)
            compOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            compOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: Double(compAmount))
            
            opsToBePerformed.append(compOp)
        }
        
        let playerOp = Operation(type: .bond, uid: repayOpUid)
        playerOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        playerOp.addCashDetails(sourceIndex: emergencyPlayerIdx, destinationIndex: BankIndex.bank.rawValue, amount: playerAmount, isEmergencyEnabled: true)
        playerOp.addBondDetails(bondsSourceGlobalIndex: self.operatingCompanyIndex, bondsDestinationGlobalIndex: BankIndex.bank.rawValue, bondsAmount: 1)
        
        opsToBePerformed.append(playerOp)
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
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
    
    func commitButtonPressed() -> Bool? {
        return true
    }

}
