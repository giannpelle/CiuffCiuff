//
//  CompanyFloatViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 15/03/23.
//

import UIKit

class CompanyFloatViewController: UIViewController, Operable {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    var floatAmount: Int = 0
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var openingValuesStackView: UIStackView!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var floatFeesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        let operatingCompanyBaseIndex = self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        let floatModifiers = self.gameState.floatModifiers[operatingCompanyBaseIndex]
        
        if floatModifiers < 0 {
            self.floatFeesLabel.isHidden = false
            self.floatFeesLabel.text = self.startingAmountText + " will pay " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(floatModifiers)) + " in tokens / fees"
        } else if floatModifiers > 0 {
            self.floatFeesLabel.isHidden = false
            self.floatFeesLabel.text = self.startingAmountText + " will receive " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(floatModifiers)) + " in cash"
        } else {
            self.floatFeesLabel.isHidden = true
        }
        
        self.resetButton.setBackgroundColor(UIColor.secondaryAccentColor)
        self.resetButton.layer.cornerRadius = 10.0
        self.resetButton.setTitle(withText: "Reset", fontSize: 24.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
        self.cashTextField.font = UIFont.systemFont(ofSize: 28.0, weight: .medium)
        self.cashTextField.textColor = UIColor.tertiaryAccentColor
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
        
        if self.gameState.game == .g1849 {
            self.openingValuesStackView.isHidden = true
            return
        }
        
        if self.gameState.game == .g1856 {
            if self.gameState.g1856CompaniesStatus?[self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)] != .fullCapitalization {
                self.openingValuesStackView.isHidden = true
                return
            }
        }
        
        var PARValues: [Int] = []
        var floatValues: [Int] = []
        
        if let PARValue = self.gameState.getPARvalue(forCompanyAtBaseIndex: operatingCompanyBaseIndex) {
            PARValues = [PARValue]
            floatValues = [PARValue * 10]
        } else {
            PARValues = self.gameState.getGamePARValues()
            floatValues = PARValues.map { $0 * 10 }
        }
        
        var cols = 0
        var rows = 0
        
        if PARValues.count > 2 {
            let quarterRemainder = PARValues.count % 4
            let thirdRemainder = PARValues.count % 3
            
            if PARValues.count < 5 {
                cols = 2
            } else {
                if quarterRemainder > thirdRemainder {
                    cols = 4
                } else {
                    cols = 3
                }
            }
            
            rows = Int(ceil(Double(PARValues.count) / Double(cols)))
        } else {
            cols = PARValues.count
            rows = 1
        }
        
        for row in 0..<rows {
            let hStackView = UIStackView()
            hStackView.axis = .horizontal
            hStackView.distribution = .fillEqually
            hStackView.alignment = .center
            hStackView.spacing = 15.0
            
            for i in 0..<cols {
                if ((row * cols) + i) >= PARValues.count {
                    break
                }
                
                let floatBtn = UIButton(type: .custom)
                floatBtn.setTitle(withText: String(floatValues[row * cols + i]), fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                floatBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                floatBtn.layer.borderColor = UIColor.primaryAccentColor.cgColor
                floatBtn.layer.borderWidth = 3.0
                
                floatBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                floatBtn.widthAnchor.constraint(equalToConstant: min(240, self.view.bounds.size.width / CGFloat((cols * 2 + 2)))).isActive = true
                
                floatBtn.addTarget(self, action: #selector(openValueButtonPressed), for: .touchUpInside)
                
                hStackView.addArrangedSubview(floatBtn)
            }
            
            self.openingValuesStackView.addArrangedSubview(hStackView)
            
        }
        
    }
    
    @objc func openValueButtonPressed(sender: UIButton) {
        self.floatAmount = Int(sender.titleLabel?.text ?? "") ?? 0
        
        self.parentVC.doneButtonPressed(sender: UIButton())
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = self.cashTextField.text! + titleLabelText
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
    }
    
    static func generateFloatOperationsWithAmount(floatAmount: Int, forCompanyAtIndex cmpIdx: Int, andGameState gameState: GameState) -> [Operation] {
        
        var opsToBePerformed: [Operation] = []
        
        let floatOp = Operation(type: .float, uid: nil)
        floatOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
        floatOp.setAccessoryTagTitle(accessoryTagTitle: gameState.getCompanyLabel(atIndex: cmpIdx))
        floatOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: cmpIdx, amount: Double(floatAmount))
        opsToBePerformed.append(floatOp)
        
        let cmpBaseIdx = gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
        let floatModifiers = gameState.floatModifiers[cmpBaseIdx]
        
        if floatModifiers > 0 {
            let feesOp = Operation(type: .cash, uid: nil)
            feesOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
            feesOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: cmpIdx, amount: Double(floatModifiers))
            opsToBePerformed.append(feesOp)
        } else if floatModifiers < 0 {
            let feesOp = Operation(type: .tokens, uid: nil)
            feesOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
            feesOp.addCashDetails(sourceIndex: cmpIdx, destinationIndex: BankIndex.bank.rawValue, amount: Double(floatModifiers))
            opsToBePerformed.append(feesOp)
        }
        
        return opsToBePerformed
    }

    func commitButtonPressed() -> Bool? {
        guard let amountStr = self.cashTextField.text else {
            return false
        }
        
        var amount = self.floatAmount
        
        if amount == 0 {
            amount = Int(amountStr) ?? 0
        }
        
        let floatOps = Self.generateFloatOperationsWithAmount(floatAmount: amount, forCompanyAtIndex: self.operatingCompanyIndex, andGameState: self.gameState)
        
        if !gameState.areOperationsLegit(operations: floatOps, reverted: false) {
            return false
        }
        
        for op in floatOps {
            _ = gameState.perform(operation: op)
        }
        
        return true
        
    }

}
