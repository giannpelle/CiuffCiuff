//
//  SellPrivateViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/03/23.
//

import UIKit

class PlayerSellPrivateViewController: UIViewController, Operable {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var shareCompanyIndexes: [Int] = []
    var privatesIndexes: [Int] = []
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var minMaxBuyInPricesStackView: UIStackView!
    @IBOutlet weak var privatesPopupButton: UIButton!
    @IBOutlet weak var buyerCompanyPopupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.shareCompanyIndexes = []
        
        for cmpIndex in self.gameState.getCompanyIndexes() where self.gameState.getCompanyType(atIndex: cmpIndex).canBuyPrivateCompany() {
            //let cmpBaseIdx = self.gameState.forceConvert(index: cmpIndex, backwards: true, withIndexType: .companies)

            self.shareCompanyIndexes.append(cmpIndex)
        }
        
        self.privatesIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 == self.operatingPlayerIndex && self.gameState.privatesMayBeBuyInFlags[$0.0] }.map { $0.0 }
        
        if shareCompanyIndexes.isEmpty || self.privatesIndexes.isEmpty {
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
            
            self.priceRangeLabel.text = self.gameState.getBuyInPrivatePricesText()
            
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
            
            self.setupPopupButtons()
            
            self.updateMinMaxBuyInPrices(forPrivateAtBaseIndex: self.privatesIndexes[0])
        }
        
    }
    
    func updateMinMaxBuyInPrices(forPrivateAtBaseIndex privateBaseIdx: Int) {
        let suggestionPrices = self.gameState.getBuyInPrivatePrices(forPrivateAtBaseIdx: privateBaseIdx)
        
        self.minMaxBuyInPricesStackView.backgroundColor = UIColor.secondaryAccentColor
        if let minMaxPricesButtons = self.minMaxBuyInPricesStackView.arrangedSubviews as? [UIButton] {
            for (idx, minMaxPricesButton) in minMaxPricesButtons.enumerated() {
                if idx < suggestionPrices.count {
                    minMaxPricesButton.setTitle(withText: String(Int(suggestionPrices[idx])), fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
                    minMaxPricesButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                } else {
                    minMaxPricesButton.isHidden = true
                }
            }
        }
    }
    
    func setupPopupButtons() {
        
        var privatesActions: [UIAction] = []
        for (i, privatesIdx) in self.privatesIndexes.enumerated() {
            if i == 0 {
                privatesActions.append(UIAction(title: "\(self.gameState.privatesLabels[privatesIdx]): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[privatesIdx]))", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    if let idx = self.gameState.privatesLabels.firstIndex(of: String(action.title.components(separatedBy: ": ")[0])) {
                        self.updateMinMaxBuyInPrices(forPrivateAtBaseIndex: idx)
                    }
                }))
            } else {
                privatesActions.append(UIAction(title: "\(self.gameState.privatesLabels[privatesIdx]): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[privatesIdx]))", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    if let idx = self.gameState.privatesLabels.firstIndex(of: String(action.title.components(separatedBy: ": ")[0])) {
                        self.updateMinMaxBuyInPrices(forPrivateAtBaseIndex: idx)
                    }
                }))
            }
        }
        
        if privatesActions.isEmpty {
            self.privatesPopupButton.isHidden = true
        } else {
            self.privatesPopupButton.isHidden = false
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
        
        
        
        let compsByAmounts =  self.shareCompanyIndexes.map { ($0, self.gameState.getCompanyAmount(atIndex: $0)) }.sorted(by: { $0.1 > $1.1 })
        let suggestion = compsByAmounts.first(where: { self.gameState.getSharesPortfolioForPlayer(atIndex: self.operatingPlayerIndex)[self.gameState.forceConvert(index:$0.0, backwards: true, withIndexType: .companies)] > 4 }) ?? (self.shareCompanyIndexes.first ?? 0, 0)
        
        var shareCompanyActions: [UIAction] = []
        for shareCompanyIdx in self.shareCompanyIndexes {
            if shareCompanyIdx == suggestion.0 {
                shareCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), state: .on, handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.buyerCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: idx))
                    self.buyerCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.getCompanyTextColor(atIndex: idx))
                    
                }))
            } else {
                shareCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.buyerCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: idx))
                    self.buyerCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.getCompanyTextColor(atIndex: idx))
                }))
            }
        }
        
        if shareCompanyActions.isEmpty {
            self.buyerCompanyPopupButton.isHidden = true
        } else {
            self.buyerCompanyPopupButton.isHidden = false
            if shareCompanyActions.count == 1 {
                self.buyerCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: suggestion.0))
                self.buyerCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atIndex: suggestion.0), textColor: self.gameState.getCompanyTextColor(atIndex: suggestion.0))
            } else {
                self.buyerCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: suggestion.0))
                self.buyerCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atIndex: suggestion.0), textColor: self.gameState.getCompanyTextColor(atIndex: suggestion.0))
            }
            
            self.buyerCompanyPopupButton.menu = UIMenu(children: shareCompanyActions)
            self.buyerCompanyPopupButton.showsMenuAsPrimaryAction = true
            self.buyerCompanyPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    @IBAction func buyInPriceButtonPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            self.cashTextField.text = text
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
        guard let amountStr = self.cashTextField.text else {
            return false
        }
        
        let amount = Int(amountStr) ?? 0

        if let privateBaseIdx = self.gameState.privatesLabels.firstIndex(of: String(self.privatesPopupButton.currentTitle?.components(separatedBy: ": ")[0] ?? "")) {
            let buyInValues = self.gameState.getBuyInPrivatePrices(forPrivateAtBaseIdx: privateBaseIdx)
            
            if buyInValues.count == 1 {
                if amount != Int(buyInValues[0]) {
                    return false
                } else if buyInValues.count >= 1 {
                    if let minValue = buyInValues.first, let maxValue = buyInValues.last {
                        if amount < Int(minValue) || amount > Int(maxValue) {
                            return false
                        }
                    }
                }
            }
        }

        let srcGlobalIndex: Int = self.operatingPlayerIndex
        let dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.buyerCompanyPopupButton.currentTitle!)
        
        if let privateTitle = self.privatesPopupButton.currentTitle {
            let privateLabelTextComponents = privateTitle.split(separator: ":")
            
            if !privateLabelTextComponents.isEmpty {
                if let privateBaseIndex = self.gameState.privatesLabels.firstIndex(of: String(privateLabelTextComponents[0])) {
                    
                    var opsToBePerformed: [Operation] = []
                    
                    let operation = Operation(type: .privates, uid: nil)
                    operation.setOperationColorGlobalIndex(colorGlobalIndex: dstGlobalIndex)
                    operation.addCashDetails(sourceIndex: dstGlobalIndex, destinationIndex: srcGlobalIndex, amount: Double(amount))
                    operation.addPrivatesDetails(privateSourceGlobalIndex: srcGlobalIndex, privateDestinationGlobalIndex: dstGlobalIndex, privateCompanyBaseIndex: privateBaseIndex)
                    
                    opsToBePerformed.append(operation)
                    
                    if self.gameState.game == .g1846 && privateBaseIndex == self.gameState.privatesPrices.count - 2 {
                        let big4GlobalIdx = self.gameState.getGlobalIndex(forEntity: "Big_4")
                        let big4Amount = self.gameState.getCompanyAmount(atIndex: big4GlobalIdx)
                        
                        if big4Amount > 0 {
                            let big4Op = Operation(type: .cash, uid: operation.uid)
                            big4Op.addCashDetails(sourceIndex: big4GlobalIdx, destinationIndex: dstGlobalIndex, amount: big4Amount)
                            
                            opsToBePerformed.append(big4Op)
                        }
                    } else if self.gameState.game == .g1846 && privateBaseIndex == self.gameState.privatesPrices.count - 1 {
                        let msGlobalIdx = self.gameState.getGlobalIndex(forEntity: "MS")
                        let msAmount = self.gameState.getCompanyAmount(atIndex: msGlobalIdx)
                        
                        if msAmount > 0 {
                            let msOp = Operation(type: .cash, uid: operation.uid)
                            msOp.addCashDetails(sourceIndex: msGlobalIdx, destinationIndex: dstGlobalIndex, amount: msAmount)
                            
                            opsToBePerformed.append(msOp)
                        }
                    }
                    
                    if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                        return false
                    }
                    
                    for op in opsToBePerformed {
                        if !self.gameState.perform(operation: op) {
                            return false
                        }
                    }
                }
            }
        }
        
        return true

    }

}



