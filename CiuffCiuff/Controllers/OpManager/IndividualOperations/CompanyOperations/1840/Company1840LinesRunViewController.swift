//
//  Company1840LinesRunViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/01/25.
//

import UIKit

class Company1840LinesRunViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    
    var g1840OperatingLineBaseIndex: Int? = nil
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var hasUserConfirmedIrreversibleOperations: Bool = false

    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var lineRunLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var modifiersStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.startingAmountLabel.text = self.gameState.g1840LinesLabels?[self.g1840OperatingLineBaseIndex ?? 0]
        self.startingAmountLabel.textColor = .white
        self.startingAmountLabel.backgroundColor = .black
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        if [.g1840LR1a, .g1840LR1b, .g1840LR2a, .g1840LR2b, .g1840LR3a, .g1840LR3b, .g1840LR4a, .g1840LR4b, .g1840LR5a, .g1840LR5b, .g1840LR5c].contains(self.gameState.currentRoundOperationType) {
            self.lineRunLabel.text = "Revenue for Run \(self.gameState.currentRoundOperationType.rawValue.suffix(2)):"
        }
        
        let modifierValues: [String] = ["- 50", "- 100", "- 200"]
        
        self.modifiersStackView.backgroundColor = UIColor.secondaryAccentColor
        if let modifierButtons = self.modifiersStackView.arrangedSubviews as? [UIButton] {
            for (idx, modifierButton) in modifierButtons.enumerated() {
                if idx < modifierValues.count {
                    modifierButton.setTitle(withText: modifierValues[idx], fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
                    modifierButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                } else {
                    modifierButton.isHidden = true
                }
            }
        }
        
        self.resetButton.setBackgroundColor(UIColor.secondaryAccentColor)
        self.resetButton.layer.cornerRadius = 10.0
        self.resetButton.setTitle(withText: "Reset", fontSize: 24.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
        self.cashTextField.font = UIFont.systemFont(ofSize: 28.0, weight: .medium)
        self.cashTextField.textColor = UIColor.black
        self.cashTextField.clipsToBounds = true
        self.cashTextField.layer.cornerRadius = 8
        self.cashTextField.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.cashTextField.layer.borderWidth = 3.0
        self.cashTextField.backgroundColor = UIColor.secondaryAccentColor

        self.numberPadStackView.backgroundColor = UIColor.primaryAccentColor
        self.numberPadStackView.spacing = 3.0
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.primaryAccentColor
        self.view.insertSubview(backgroundView, belowSubview: self.numberPadStackView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.numberPadStackView.topAnchor, constant: -3).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.numberPadStackView.bottomAnchor, constant: 3).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.numberPadStackView.leadingAnchor, constant: -3).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.numberPadStackView.trailingAnchor, constant: 3).isActive = true

        if let stackViews = self.numberPadStackView.arrangedSubviews as? [UIStackView] {
            let shouldIgnoreFirstStackView = stackViews.count == 3
            for (i, stackView) in stackViews.enumerated() {
                stackView.spacing = 3.0
                
                if (i == 0 && shouldIgnoreFirstStackView) { continue }
                
                if let buttons = stackView.arrangedSubviews as? [UIButton] {
                    for (j, button) in buttons.enumerated() {
                        let btnStr = shouldIgnoreFirstStackView ? "\(((i - 1) * 5) + j)" : "\((i * 5) + j)"
                        button.setTitle(withText: btnStr, fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.primaryAccentColor)
                        button.setBackgroundColor(UIColor.secondaryAccentColor, isRectangularShape: true)
                    }
                }
            }
        }
        
    }
    
    @IBAction func modifierButtonPressed(sender: UIButton) {
        if let textFieldText = self.cashTextField.text {
            let amount = Int(textFieldText) ?? 0
            
            if sender.titleLabel?.text == "- 50" {
                self.cashTextField.text = "\(amount - 50)"
            } else if sender.titleLabel?.text == "- 100" {
                self.cashTextField.text = "\(amount - 100)"
            } else if sender.titleLabel?.text == "- 200" {
                self.cashTextField.text = "\(amount - 200)"
            }
        }
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if let textFieldText = self.cashTextField.text {
                self.cashTextField.text = textFieldText + text
            }
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
    }

    func commitButtonPressed() -> Bool? {
        if self.hasUserConfirmedIrreversibleOperations { return true }
        
        guard let amountStr = self.cashTextField.text else {
            return false
        }
        
        let amount = Int(amountStr) ?? -1
        
        if amount == -1 {
            return false
        }
        
        if amount < 0 && Int(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) < abs(amount) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "\(self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex)) funds are not enough to cover run expenses")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return nil
        }
        
        var opsToBePerformed: [Operation] = []
        var deltaForCompany = 0
        var deltaCompanyIndex = 0

        if let lineBaseIdx = self.g1840OperatingLineBaseIndex {
            
            let currentRoundChar: Character = self.gameState.currentRoundOperationType.rawValue.last ?? Character("")
            var currentRoundIdx = 0
            if currentRoundChar == "b" {
                currentRoundIdx = 1
            } else if currentRoundChar == "c" {
                currentRoundIdx = 2
            }
            
            let runOp = Operation(type: .g1840LineRun)
            runOp.g1840AddLineRunDetails(lineBaseIndex: lineBaseIdx, lineLabel: self.gameState.g1840LinesLabels?[lineBaseIdx] ?? "", lineRunAmount: Double(amount), lineRunIndex: currentRoundIdx)
            
            opsToBePerformed.append(runOp)
            
            if let currentRunValue = self.gameState.g1840LinesRevenue?[lineBaseIdx][currentRoundIdx] {
                
                if amount > currentRunValue {
                    // should refund comp expensive if it was negative
                    if currentRunValue < 0 {
                        deltaForCompany = amount >= 0 ? -currentRunValue : -(amount - currentRunValue)
                    }
                } else if amount < currentRunValue {
                    // should comp pay for negative revenue?
                    if amount < 0 {
                        deltaForCompany = currentRunValue >= 0 ? amount : (amount - currentRunValue)
                    }
                }
                
                if let cmpIdx = self.gameState.g1840LinesOwnerGlobalIndexes?[lineBaseIdx], self.gameState.getCompanyIndexes().contains(cmpIdx) {
                    if deltaForCompany != 0 {
                        
                        let adjustmentOp = Operation(type: .cash)
                        adjustmentOp.overrideUid(uid: runOp.uid)
                        
                        if deltaForCompany > 0 {
                            adjustmentOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: cmpIdx, amount: Double(deltaForCompany))
                        } else {
                            adjustmentOp.addCashDetails(sourceIndex: cmpIdx, destinationIndex: BankIndex.bank.rawValue, amount: Double(deltaForCompany))
                        }
                        
                        deltaCompanyIndex = cmpIdx
                        
                        opsToBePerformed.append(adjustmentOp)
                    }
                }
                
            } else if amount < 0 {
                let cashOp = Operation(type: .cash)
                cashOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: Double(abs(amount)))
                
                opsToBePerformed.append(cashOp)
            }
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return false
        }
        
        if opsToBePerformed.contains(where: { op in
            op.type == .cash
        }) {
            var messageStr = ""
            if deltaForCompany > 0 {
                messageStr = "\(self.gameState.getCompanyLabel(atIndex: deltaCompanyIndex)) will get a refund of \(deltaForCompany) for negative revenues paid earlier"
            } else {
                messageStr = "\(self.gameState.getCompanyLabel(atIndex: deltaCompanyIndex)) will pay a total of \(-deltaForCompany) for the updated negative revenue"
            }
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: messageStr)
            alert.addCancelAction(withLabel: "Cancel")
            alert.addConfirmAction(withLabel: "OK") {
                for op in opsToBePerformed {
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
        
        for op in opsToBePerformed {
            _ = self.gameState.perform(operation: op)
        }
        
        return true
    }

}
