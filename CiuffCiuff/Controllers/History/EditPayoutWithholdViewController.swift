//
//  EditPayoutWithholdViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 21/02/25.
//

import UIKit

class EditPayoutWithholdViewController: UIViewController {
    
    var parentVC: HistoryViewController!
    var gameState: GameState!
    var payoutOpUid: Int!
    var initialSegmentedControlIndex: Int = 0
    var initialAmount: Int = 0
    var operatingCompanyBaseIndex: Int = 0
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var commitButton: UIButton!
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var payoutSuggestionsStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.cancelButton.setTitle(withText: "Cancel", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.cancelButton.setBackgroundColor(UIColor.redAccentColor)
        self.commitButton.setTitle(withText: "Commit", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.commitButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        if let payoutOp = self.gameState.activeOperations.first(where: { op in
            op.uid == self.payoutOpUid && op.payoutWithholdCompanyBaseIndex != nil && op.payoutTotalAmount != nil
        }) {

            self.operatingCompanyBaseIndex = payoutOp.payoutWithholdCompanyBaseIndex!
            
            self.operationSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
            self.operationSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
            let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
            let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
            self.operationSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
            self.operationSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
            self.operationSegmentedControl.selectedSegmentIndex = payoutOp.type == .withhold ? 1 : 0
            self.initialSegmentedControlIndex = payoutOp.type == .withhold ? 1 : 0
            
            self.startingAmountLabel.text = self.gameState.getCompanyLabel(atBaseIndex: self.operatingCompanyBaseIndex)
            self.startingAmountLabel.textColor = self.gameState.getCompanyTextColor(atBaseIndex: self.operatingCompanyBaseIndex)
            self.startingAmountLabel.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: self.operatingCompanyBaseIndex)
            self.startingAmountLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            self.startingAmountLabel.layer.cornerRadius = 25
            self.startingAmountLabel.clipsToBounds = true
            
            if let payout = payoutOp.payoutTotalAmount, payout != 0 {
                self.cashTextField.text = "\(payout)"
                self.initialAmount = payout
                self.payoutSuggestionsStackView.isHidden = false
                
                self.payoutSuggestionsStackView.backgroundColor = UIColor.secondaryAccentColor
                if let suggestionBtns = self.payoutSuggestionsStackView.arrangedSubviews as? [UIButton] {
                    let hints = ["- 30", "- 10", "+ 10", "+ 30"]
                    for (i, btn) in suggestionBtns.enumerated() {
                        btn.setTitle(withText: hints[i], fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
                        btn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                    }
                }
                
            } else {
                self.payoutSuggestionsStackView.isHidden = true
            }
            
            self.cashTextField.font = UIFont.systemFont(ofSize: 28.0, weight: .medium)
            self.cashTextField.textColor = UIColor.black
            self.cashTextField.clipsToBounds = true
            self.cashTextField.layer.cornerRadius = 8
            self.cashTextField.layer.borderColor = UIColor.primaryAccentColor.cgColor
            self.cashTextField.layer.borderWidth = 3.0
            self.cashTextField.backgroundColor = UIColor.secondaryAccentColor
        }
        
    }
    
    @IBAction func payoutSuggestionButtonPressed(sender: UIButton) {
        let amount = Int(self.cashTextField.text ?? "") ?? 0
        
        if sender.titleLabel?.text == "- 30" {
            self.cashTextField.text = "\(amount - 30)"
        } else if sender.titleLabel?.text == "- 10" {
            self.cashTextField.text = "\(amount - 10)"
        } else if sender.titleLabel?.text == "+ 10" {
            self.cashTextField.text = "\(amount + 10)"
        } else if sender.titleLabel?.text == "+ 30" {
            self.cashTextField.text = "\(amount + 30)"
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func commitButtonPressed(sender: UIButton) {
        guard let amount = Int(self.cashTextField.text ?? ""), amount % 10 == 0 else { return }
        
        if (amount == self.initialAmount) && (self.initialSegmentedControlIndex == self.operationSegmentedControl.selectedSegmentIndex) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "There are no changes with the data provided, if you want not to edit the operation press Cancel")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        var success = false
        var isCriticalError = false
        
        if let firstPayoutOpIdx = self.gameState.operations.firstIndex(where: { $0.uid == self.payoutOpUid }) {
            let opsToBeCancelled = self.gameState.activeOperations.filter { $0.uid == self.payoutOpUid }
            let areOnlyPayoutWithholdMarketOps = opsToBeCancelled.allSatisfy { op in
                [OperationType.payout, OperationType.withhold, OperationType.market].contains(op.type)
            }
            
            if let _ = self.gameState.getShareValue(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex), areOnlyPayoutWithholdMarketOps {
                if self.gameState.areOperationsLegit(operations: opsToBeCancelled, reverted: true) {
                    for op in opsToBeCancelled {
                        _ = self.gameState.perform(operation: op, reverted: true, save: false)
                    }
                    
                    self.gameState.operations.removeAll(where: { $0.uid == self.payoutOpUid })
                    
                    let newOps = self.operationSegmentedControl.selectedSegmentIndex == 0 ? CompanyOperateViewController.generateWithholdOperations(withAmount: amount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: true, withOperationUid: nil, isBasicStandardPayoutWiththold: true) : CompanyOperateViewController.generatePayoutOperations(withAmount: amount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: true, withOperationUid: nil, isBasicStandardPayoutWiththold: true)
                    
                    if self.gameState.areOperationsLegit(operations: newOps, reverted: false) {
                        for op in newOps {
                            op.overrideUid(uid: self.payoutOpUid)
                            _ = self.gameState.perform(operation: op, reverted: false, save: false)
                        }
                        
                        self.gameState.operations.insert(contentsOf: newOps, at: firstPayoutOpIdx)
                        success = true
                        
                    } else {
                        isCriticalError = true
                    }
                }
            }
        }
        
        if isCriticalError {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "The OLD payout/withhold operations got cancelled but the NEW operations could not be performed (please export the game state and send it to gianluigi.developer@gmail.com)")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if success {
            self.parentVC.updateTableView()
            self.dismiss(animated: true)
        } else {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
    }
}
