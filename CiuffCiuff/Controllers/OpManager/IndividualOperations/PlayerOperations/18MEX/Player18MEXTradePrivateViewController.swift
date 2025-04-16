//
//  G18MEXTradePrivateViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 17/03/24.
//

import UIKit

class Player18MEXTradePrivateViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var playersIndexes: [Int] = []
    var privatesIndexes: [Int] = []
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var buyerPlayerPopupButton: UIButton!
    @IBOutlet weak var buyerSellerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var privatesPopupButton: UIButton!
    @IBOutlet weak var privatesStackView: UIStackView!
    @IBOutlet weak var noPrivatesToSellLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor

        self.playersIndexes = self.gameState.getPlayerIndexes().filter { $0 != self.operatingPlayerIndex }
        
        if !self.playersIndexes.isEmpty {
            self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == self.operatingPlayerIndex }.map { $0.0 }
        }
        
        if self.gameState.privatesOwnerGlobalIndexes.filter({ self.gameState.getPlayerIndexes().contains($0) }).count == 0 {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
        } else {
            self.parentVC.emptyLabel.isHidden = true
            self.view.isHidden = false
            
            self.startingAmountLabel.text = self.startingAmountText
            self.startingAmountLabel.textColor = self.startingAmountColor
            self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
            self.startingAmountLabel.font = self.startingAmountFont
            self.startingAmountLabel.layer.cornerRadius = 25
            self.startingAmountLabel.clipsToBounds = true
            
            self.resetButton.setBackgroundColor(UIColor.secondaryAccentColor)
            self.resetButton.layer.cornerRadius = 10.0
            self.resetButton.setTitle(withText: "Reset", fontSize: 24.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
            self.cashTextField.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
            self.cashTextField.clipsToBounds = true
            self.cashTextField.layer.cornerRadius = 8
            self.cashTextField.layer.borderColor = UIColor.systemGray4.cgColor
            self.cashTextField.layer.borderWidth = 2.0

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
            
            self.buyerSellerSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
            self.buyerSellerSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
            let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)]
            let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)]
            self.buyerSellerSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
            self.buyerSellerSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
            
            self.setupPopupButtons()
        }
        
    }
    
    func setupPopupButtons() {
        
        var privatesActions: [UIAction] = []
        for (i, privatesIdx) in self.privatesIndexes.enumerated() {
            if i == 0 {
                privatesActions.append(UIAction(title: "\(self.gameState.privatesLabels[privatesIdx]): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[privatesIdx]))", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                privatesActions.append(UIAction(title: "\(self.gameState.privatesLabels[privatesIdx]): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[privatesIdx]))", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if privatesActions.isEmpty {
            self.privatesStackView.isHidden = true
            self.noPrivatesToSellLabel.isHidden = false
            self.noPrivatesToSellLabel.text = "\(self.gameState.getPlayerLabel(atIndex: self.operatingPlayerIndex)) has no privates to sell"
        } else {
            self.privatesStackView.isHidden = false
            self.noPrivatesToSellLabel.isHidden = true
            
            if privatesActions.count == 1 {
                self.privatesPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.privatesPopupButton.setPopupTitle(withText: privatesActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.privatesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.privatesPopupButton.setPopupTitle(withText: privatesActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.privatesPopupButton.menu = UIMenu(children: privatesActions)
            self.privatesPopupButton.showsMenuAsPrimaryAction = true
            self.privatesPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        
        
        var playerActions: [UIAction] = []
        for (i, playerIdx) in self.playersIndexes.enumerated() {
            if i == 0 {
                playerActions.append(UIAction(title: self.gameState.getPlayerLabel(atIndex: playerIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getPlayerColor(atIndex: playerIdx)), state: .on, handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.buyerPlayerPopupButton.setBackgroundColor(self.gameState.getPlayerColor(atIndex: idx))
                    self.buyerPlayerPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.getPlayerTextColor(atIndex: idx))
                    
                    if self.buyerSellerSegmentedControl.selectedSegmentIndex == 0 {
                        self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == self.operatingPlayerIndex }.map { $0.0 }
                    } else {
                        self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == idx }.map { $0.0 }
                    }
                    self.updatePrivatesPopupButton()
                    
                }))
            } else {
                playerActions.append(UIAction(title: self.gameState.getPlayerLabel(atIndex: playerIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getPlayerColor(atIndex: playerIdx)), handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.buyerPlayerPopupButton.setBackgroundColor(self.gameState.getPlayerColor(atIndex: idx))
                    self.buyerPlayerPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.getPlayerTextColor(atIndex: idx))
                    
                    if self.buyerSellerSegmentedControl.selectedSegmentIndex == 0 {
                        self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == self.operatingPlayerIndex }.map { $0.0 }
                    } else {
                        self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == idx }.map { $0.0 }
                    }
                    self.updatePrivatesPopupButton()
                    
                }))
            }
        }
        
        if playerActions.isEmpty {
            self.buyerPlayerPopupButton.isHidden = true
        } else {
            self.buyerPlayerPopupButton.isHidden = false
            if playerActions.count == 1 {
                self.buyerPlayerPopupButton.setBackgroundColor(self.gameState.getPlayerColor(atIndex: self.playersIndexes[0]))
                self.buyerPlayerPopupButton.setPopupTitle(withText: playerActions.first?.title ?? "", textColor: self.gameState.getPlayerTextColor(atIndex: self.playersIndexes[0]))
            } else {
                self.buyerPlayerPopupButton.setBackgroundColor(self.gameState.getPlayerColor(atIndex: self.playersIndexes[0]))
                self.buyerPlayerPopupButton.setPopupTitle(withText: playerActions.first?.title ?? "", textColor: self.gameState.getPlayerTextColor(atIndex: self.playersIndexes[0]))
            }
            
            self.buyerPlayerPopupButton.menu = UIMenu(children: playerActions)
            self.buyerPlayerPopupButton.showsMenuAsPrimaryAction = true
            self.buyerPlayerPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    func updatePrivatesPopupButton() {
        
        var privatesActions: [UIAction] = []
        for (i, privatesIdx) in self.privatesIndexes.enumerated() {
            if i == 0 {
                privatesActions.append(UIAction(title: "\(self.gameState.privatesLabels[privatesIdx]): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[privatesIdx]))", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                privatesActions.append(UIAction(title: "\(self.gameState.privatesLabels[privatesIdx]): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[privatesIdx]))", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if privatesActions.isEmpty {
            self.privatesStackView.isHidden = true
            self.noPrivatesToSellLabel.isHidden = false
            self.noPrivatesToSellLabel.text = "\(self.gameState.getPlayerLabel(atIndex: self.operatingPlayerIndex)) has no privates to sell"
        } else {
            self.privatesStackView.isHidden = false
            self.noPrivatesToSellLabel.isHidden = true
            
            if privatesActions.count == 1 {
                self.privatesPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.privatesPopupButton.setPopupTitle(withText: privatesActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.privatesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.privatesPopupButton.setPopupTitle(withText: privatesActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.privatesPopupButton.menu = UIMenu(children: privatesActions)
            self.privatesPopupButton.showsMenuAsPrimaryAction = true
            self.privatesPopupButton.changesSelectionAsPrimaryAction = true
        }
    }
    
    @IBAction func buyerSellerSegmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == self.operatingPlayerIndex }.map { $0.0 }
        } else {
            let playerIdx = self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.buyerPlayerPopupButton.currentTitle!)
            self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == playerIdx }.map { $0.0 }
        }
        
        self.updatePrivatesPopupButton()
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
        
        let amount = Int(amountStr) ?? 0
        
        if amount == 0 {
            return true
        }
        
        var srcGlobalIndex: Int = 0
        var dstGlobalIndex: Int = 0
        if self.buyerSellerSegmentedControl.selectedSegmentIndex == 0 {
            srcGlobalIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.buyerPlayerPopupButton.currentTitle!)
            dstGlobalIndex = self.operatingPlayerIndex
        } else {
            dstGlobalIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.buyerPlayerPopupButton.currentTitle!)
            srcGlobalIndex = self.operatingPlayerIndex
        }
        
        let operation = Operation(type: self.buyerSellerSegmentedControl.selectedSegmentIndex == 0 ? .sellPrivate : .buyPrivate, uid: nil)
        operation.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(amount))
        if let privateTitle = self.privatesPopupButton.currentTitle?.split(separator: ":")[0] {
            if let privateBaseIndex = self.gameState.privatesLabels.firstIndex(of: String(privateTitle)) {
                operation.addPrivatesDetails(privateSourceGlobalIndex: dstGlobalIndex, privateDestinationGlobalIndex: srcGlobalIndex, privateCompanyBaseIndex: privateBaseIndex)
            }
        }
        
        if !self.gameState.isOperationLegit(operation: operation, reverted: false) {
            return false
        }
        
        return self.gameState.perform(operation: operation)
        
    }
    
}
