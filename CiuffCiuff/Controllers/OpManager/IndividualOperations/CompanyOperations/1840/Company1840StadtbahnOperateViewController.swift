//
//  Company1840StadtbahnOperateViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/01/25.
//

import UIKit

class Company1840StadtbahnOperateViewController: UIViewController, Operable {
        
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var lastPayout: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var revenueMultiplierSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var payoutSuggestionsStackView: UIStackView!
    
    var multiplierValues: [Int] = [1, 2, 3, 10]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor

        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        let payout = self.gameState.getLastPayoutForCompany(atIndex: self.operatingCompanyIndex)
        self.lastPayout = payout
        if payout != 0 {
            self.payoutSuggestionsStackView.isHidden = false
            
            self.payoutSuggestionsStackView.backgroundColor = UIColor.secondaryAccentColor
            if let suggestionBtns = self.payoutSuggestionsStackView.arrangedSubviews as? [UIButton] {
                for (i, btn) in suggestionBtns.enumerated() {
                    btn.setTitle(withText: "\(payout + (10 * i))", fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
                    btn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                }
            }
        } else {
            self.payoutSuggestionsStackView.isHidden = true
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
        
        self.revenueMultiplierSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.revenueMultiplierSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.revenueMultiplierSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.revenueMultiplierSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        if let roundIdx = self.gameState.currentRoundOperationTypeIndex, let multiplierValue = self.gameState.g1840RoundOperationTypeCRMultipliers?[roundIdx] {
            if let idx = self.multiplierValues.firstIndex(of: multiplierValue) {
                self.revenueMultiplierSegmentedControl.selectedSegmentIndex = idx
            }
        }
        
    }
    
    @IBAction func payoutSuggestionButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = titleLabelText
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
        
        guard let amountStr = self.cashTextField.text else {
            return false
        }
        
        var amount = Int(amountStr) ?? 0
        
        if amount == 0 || amount % 10 != 0 {
            return false
        }
        
        amount *= self.multiplierValues[self.revenueMultiplierSegmentedControl.selectedSegmentIndex]
        
        if self.payout(withAmount: amount) {
            let cmpBaseIdx = self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
            self.gameState.lastCompPayoutValues[cmpBaseIdx] = amount
            return true
        }
        
        return false
    }
    
    func payout(withAmount amount: Int) -> Bool {
        
        let opsToBePerformed = CompanyOperateViewController.generatePayoutOperations(withAmount: amount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: true, withOperationUid: nil, isBasicStandardPayoutWiththold: true)
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return false
        }
        
        for op in opsToBePerformed {
            if !self.gameState.perform(operation: op) {
                return false
            }
        }
        
        return true
      
    }

}

