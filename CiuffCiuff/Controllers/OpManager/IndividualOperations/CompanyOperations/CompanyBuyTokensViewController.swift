//
//  TokensViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/03/23.
//

import UIKit

class CompanyBuyTokensViewController: UIViewController, Operable {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var g1840OperatingLineBaseIndex: Int? = nil
    var operatingCompanyIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tokenPricesStackView: UIStackView!
    @IBOutlet weak var bottomAccessoryStackView: UIStackView!
    
    // 1840 lines
    var availableLinesIndexes: [Int]? = nil
    var selectedLineBaseIndex: Int? = nil
    
    // 1849 companies
    var stationTokenCompsPopupButton: UIButton? = nil
    var stationTokensOwnersGlobalIndexes: [Int] = []
    
    // 1882 custom buttons
    var nwrIncomeLabel: UILabel? = nil
    var nwrIncomeStepper: UIStepper? = nil
    var bridgeIncomeLabel: UILabel? = nil
    var bridgeIncomeStepper: UIStepper? = nil
    var bridgeOwnerGlobalIndex: Int = BankIndex.bank.rawValue
    var bridgeOwnerPopupButton: UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.plusButton.setTitle(withText: "+", fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
        self.plusButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        if self.gameState.game == .g1840 && self.g1840OperatingLineBaseIndex == nil {
            if self.gameState.g1840LinesOwnerGlobalIndexes?.filter({ $0 == self.operatingCompanyIndex }).count ?? 0 < 3 {
                
                self.selectedLineBaseIndex = -1
                
                self.availableLinesIndexes = self.gameState.g1840LinesOwnerGlobalIndexes?.enumerated().filter { $0.1 == BankIndex.bank.rawValue }.map { $0.0 }
                
                let accessoryLabel = UILabel()
                accessoryLabel.text = "Buying a new line?"
                accessoryLabel.font = UIFont.systemFont(ofSize: 23.0, weight: .regular)
                
                let linesPickerView = UIPickerView()
                linesPickerView.delegate = self
                linesPickerView.dataSource = self
                
                linesPickerView.heightAnchor.constraint(equalToConstant: 180.0).isActive = true
                linesPickerView.widthAnchor.constraint(equalToConstant: 240.0).isActive = true
                
                let buyLineStackView = UIStackView()
                buyLineStackView.axis = .horizontal
                buyLineStackView.spacing = 30
                buyLineStackView.distribution = .fill
                buyLineStackView.alignment = .center
                
                buyLineStackView.addArrangedSubview(accessoryLabel)
                buyLineStackView.addArrangedSubview(linesPickerView)
                
                self.bottomAccessoryStackView.isHidden = false
                self.bottomAccessoryStackView.addArrangedSubview(buyLineStackView)
            }
        }
        
        if self.gameState.game == .g1849 {
            let popupButton = UIButton(type: .custom)
            popupButton.configuration = .filled()
            
            self.stationTokensOwnersGlobalIndexes = [BankIndex.bank.rawValue] + self.gameState.getCompanyIndexes()
            
            var actions: [UIAction] = []
            for (i, stationTokensOwnerGlobalIdx) in self.stationTokensOwnersGlobalIndexes.enumerated() {
                if i == 0 {
                    actions.append(UIAction(title: self.gameState.labels[stationTokensOwnerGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[stationTokensOwnerGlobalIdx].uiColor), state: .on, handler: { action in
                        if let popupButton = self.stationTokenCompsPopupButton {
                            let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                            popupButton.setBackgroundColor(self.gameState.colors[idx].uiColor)
                            popupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                        }
                    }))
                } else {
                    actions.append(UIAction(title: self.gameState.labels[stationTokensOwnerGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[stationTokensOwnerGlobalIdx].uiColor), handler: { action in
                        if let popupButton = self.stationTokenCompsPopupButton {
                            let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                            popupButton.setBackgroundColor(self.gameState.colors[idx].uiColor)
                            popupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                        }
                    }))
                }
            }
            
            if actions.isEmpty {
                popupButton.isHidden = true
            } else {
                popupButton.isHidden = false
                if actions.count == 1 {
                    popupButton.setBackgroundColor(self.gameState.colors[self.stationTokensOwnersGlobalIndexes[0]].uiColor)
                    popupButton.setPopupTitle(withText: self.gameState.labels[0], textColor: self.gameState.textColors[self.stationTokensOwnersGlobalIndexes[0]].uiColor)
                } else {
                    popupButton.setBackgroundColor(self.gameState.colors[self.stationTokensOwnersGlobalIndexes[0]].uiColor)
                    popupButton.setPopupTitle(withText: self.gameState.labels[0], textColor: self.gameState.textColors[self.stationTokensOwnersGlobalIndexes[0]].uiColor)
                }
                
                popupButton.menu = UIMenu(children: actions)
                popupButton.showsMenuAsPrimaryAction = true
                popupButton.changesSelectionAsPrimaryAction = true
            }
            
            popupButton.widthAnchor.constraint(equalToConstant: 140.0).isActive = true
            popupButton.heightAnchor.constraint(equalToConstant: 50.0 ).isActive = true
            
            self.stationTokenCompsPopupButton = popupButton
            
            let buyStationStackView = UIStackView()
            buyStationStackView.axis = .horizontal
            buyStationStackView.spacing = 30
            buyStationStackView.distribution = .fill
            buyStationStackView.alignment = .center
            
            let accessoryLabel = UILabel()
            accessoryLabel.text = "Buy station token from:"
            accessoryLabel.font = UIFont.systemFont(ofSize: 26.0)
            
            buyStationStackView.addArrangedSubview(accessoryLabel)
            buyStationStackView.addArrangedSubview(popupButton)
            
            self.bottomAccessoryStackView.isHidden = false
            self.bottomAccessoryStackView.addArrangedSubview(buyStationStackView)
            
        }
        
        if self.gameState.game == .g1882 {
            
            let nwrStackView = UIStackView()
            nwrStackView.axis = .vertical
            nwrStackView.spacing = 25
            nwrStackView.distribution = .fill
            nwrStackView.alignment = .center
            
            let nwrIncomeLabel = UILabel()
            nwrIncomeLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            nwrIncomeLabel.text = "NWR income:  \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 0.0))"
            
            let nwrIncomeStepper = UIStepper()
            nwrIncomeStepper.minimumValue = 0
            nwrIncomeStepper.maximumValue = 10
            nwrIncomeStepper.value = 0
            
            nwrIncomeStepper.addTarget(self, action: #selector(nwrIncomeStepperValueChanged), for: .valueChanged)
            
            nwrStackView.addArrangedSubview(nwrIncomeLabel)
            nwrStackView.addArrangedSubview(nwrIncomeStepper)
            
            self.nwrIncomeLabel = nwrIncomeLabel
            self.nwrIncomeStepper = nwrIncomeStepper
            
            self.bottomAccessoryStackView.isHidden = false
            self.bottomAccessoryStackView.addArrangedSubview(nwrStackView)
            
            let p4Index = 3
            if self.gameState.privatesOwnerGlobalIndexes[p4Index] != BankIndex.bank.rawValue {
                
                let outerBridgeStackView = UIStackView()
                outerBridgeStackView.axis = .horizontal
                outerBridgeStackView.spacing = 40.0
                outerBridgeStackView.alignment = .center
                outerBridgeStackView.distribution = .fill
                
                let bridgeStackView = UIStackView()
                bridgeStackView.axis = .vertical
                bridgeStackView.spacing = 25
                bridgeStackView.distribution = .fill
                bridgeStackView.alignment = .center
                
                let bridgeIncomeLabel = UILabel()
                bridgeIncomeLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
                bridgeIncomeLabel.text = "Bridge income:  \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 0.0))"
                
                let bridgeIncomeStepper = UIStepper()
                bridgeIncomeStepper.minimumValue = 0
                bridgeIncomeStepper.maximumValue = 10
                bridgeIncomeStepper.value = 0
                
                bridgeIncomeStepper.addTarget(self, action: #selector(bridgeIncomeStepperValueChanged), for: .valueChanged)
                
                self.bridgeOwnerGlobalIndex = self.gameState.privatesOwnerGlobalIndexes[p4Index]
                
                let bridgeOwnerPopupButton = UIButton(type: .custom)
                
                let action = UIAction(title: self.gameState.labels[self.bridgeOwnerGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[self.bridgeOwnerGlobalIndex].uiColor), state: .on, handler: { action in
                    bridgeOwnerPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                })
                
                bridgeOwnerPopupButton.menu = UIMenu(children: [action])
                bridgeOwnerPopupButton.showsMenuAsPrimaryAction = true
                bridgeOwnerPopupButton.changesSelectionAsPrimaryAction = true
                bridgeOwnerPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                bridgeOwnerPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                
                bridgeOwnerPopupButton.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
                bridgeOwnerPopupButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                
                bridgeStackView.addArrangedSubview(bridgeIncomeLabel)
                bridgeStackView.addArrangedSubview(bridgeIncomeStepper)
                
                outerBridgeStackView.addArrangedSubview(bridgeStackView)
                outerBridgeStackView.addArrangedSubview(bridgeOwnerPopupButton)
                
                self.bridgeIncomeLabel = bridgeIncomeLabel
                self.bridgeIncomeStepper = bridgeIncomeStepper
                self.bridgeOwnerPopupButton = bridgeOwnerPopupButton
                
                self.bottomAccessoryStackView.addArrangedSubview(outerBridgeStackView)
            }
            
        }
        
        let tokenPrices: [Int] = self.gameState.tileTokensPriceSuggestions
        
        self.tokenPricesStackView.backgroundColor = UIColor.secondaryAccentColor
        if let tokenPricesButtons = self.tokenPricesStackView.arrangedSubviews as? [UIButton] {
            for (idx, tokenPricesButton) in tokenPricesButtons.enumerated() {
                if idx < tokenPrices.count {
                    tokenPricesButton.setTitle(withText: String(tokenPrices[idx]), fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
                    tokenPricesButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                } else {
                    tokenPricesButton.isHidden = true
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
    
    @objc func nwrIncomeStepperValueChanged(sender: UIStepper) {
        if let nwrIncomeLabel = self.nwrIncomeLabel {
            nwrIncomeLabel.text = "NWR income:  \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 20.0 * sender.value))"
        }
    }
    
    @objc func bridgeIncomeStepperValueChanged(sender: UIStepper) {
        if let bridgeIncomeLabel = self.bridgeIncomeLabel {
            bridgeIncomeLabel.text = "Bridge income:  \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 10.0 * sender.value))"
        }
    }
    
    @IBAction func tokenPriceButtonPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if let textFieldText = self.cashTextField.text {
                if let lastChar = textFieldText.last {
                    if lastChar.isNumber {
                        self.cashTextField.text = textFieldText + " + \(text)"
                    } else {
                        self.cashTextField.text = textFieldText + " \(text)"
                    }
                } else {
                    self.cashTextField.text = textFieldText + text
                }
            }
        }
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if let textFieldText = self.cashTextField.text {
                if text == "+" {
                    self.cashTextField.text = textFieldText + " \(text)"
                } else {
                    if let lastChar = textFieldText.last {
                        if lastChar.isNumber {
                            self.cashTextField.text = textFieldText + text
                        } else {
                            self.cashTextField.text = textFieldText + " \(text)"
                        }
                    } else {
                        self.cashTextField.text = textFieldText + text
                    }
                }
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
        
        let components = amountStr.split(separator: " ")
        var values: [Int] = []
    
        var isTxtLegal = true
        for (i, component) in components.enumerated() {
            if i % 2 == 0 {
                if let value = Int(component) {
                    values.append(value)
                } else {
                    isTxtLegal = false
                }
            } else {
                if !(component == "+") {
                    isTxtLegal = false
                }
            }
        }
        
        if !isTxtLegal {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Invalid input in amount")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return false
        }
        
        var amount = 0
        
        if !values.isEmpty {
            for val in values {
                amount += val
            }
        }
        
        var opsToBePerformed: [Operation] = []
        
        if self.gameState.game == .g1840 {
            
            if let selectedLineBaseIndex = self.selectedLineBaseIndex, selectedLineBaseIndex != -1 {
                if amount != 0 {
                    
                    if let lineNumberText = self.gameState.g1840LinesLabels?[selectedLineBaseIndex] {
                        
                        let srcGlobalIndex: Int = self.operatingCompanyIndex
                        let dstGlobalIndex: Int = BankIndex.bank.rawValue
                        
                        let lineOp = Operation(type: .line, uid: nil)
                        lineOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                        lineOp.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(amount))
                        lineOp.g1840AddLineDetails(lineSourceGlobalIndex: BankIndex.bank.rawValue, lineDestinationGlobalIndex: srcGlobalIndex, lineBaseIndex: selectedLineBaseIndex, lineLabel: lineNumberText)
                        
                        if !self.gameState.isOperationLegit(operation: lineOp, reverted: false) {
                            return false
                        }
                        
                        return self.gameState.perform(operation: lineOp)
                    }
                    
                } else {
                    return false
                }
            }
        }
        
        if self.gameState.game == .g1882 {
            if let nwrIncomeStepper = nwrIncomeStepper, nwrIncomeStepper.value != 0 {
                let nwrOp = Operation(type: .g1882NWR, uid: nil)
                nwrOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                nwrOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: Double(nwrIncomeStepper.value * 20))
                if self.gameState.isOperationLegit(operation: nwrOp, reverted: false) {
                    opsToBePerformed.append(nwrOp)
                }
            }
            
            if let bridgeIncomeStepper = bridgeIncomeStepper, bridgeIncomeStepper.value != 0 && self.bridgeOwnerGlobalIndex != BankIndex.bank.rawValue {
                if let bridgeOwnerPopupButton = self.bridgeOwnerPopupButton {
                    let dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: bridgeOwnerPopupButton.currentTitle!)

                    let bridgeOp = Operation(type: .g1882Bridge, uid: nil)
                    bridgeOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    bridgeOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: dstGlobalIndex, amount: Double(bridgeIncomeStepper.value * 10))
                    if self.gameState.isOperationLegit(operation: bridgeOp, reverted: false) {
                        opsToBePerformed.append(bridgeOp)
                    }
                }
            }
        }

        if amount != 0 {
            
            let srcGlobalIndex: Int = self.operatingCompanyIndex
            var dstGlobalIndex: Int = BankIndex.bank.rawValue
            
            if let stationTokenCompsPopupButton = self.stationTokenCompsPopupButton {
                dstGlobalIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: stationTokenCompsPopupButton.currentTitle!)
            }
            
            for val in values {
                let op = Operation(type: .tokens, uid: nil)
                op.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                op.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(val))
                
                opsToBePerformed.append(op)
            }
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                return false
            }
            
        }
        
        for op in opsToBePerformed {
            _ = self.gameState.perform(operation: op)
        }
        
        return true
    }

}

extension CompanyBuyTokensViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let availableLinesIndexes = self.availableLinesIndexes {
            return availableLinesIndexes.count + 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "ignore"
        } else if let availableLinesIndexes = self.availableLinesIndexes {
            return "\(self.gameState.g1840LinesLabels?[availableLinesIndexes[row - 1]] ?? "")"
        }
        return ""
    }
}

extension CompanyBuyTokensViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let _ = self.availableLinesIndexes {
            self.selectedLineBaseIndex = self.availableLinesIndexes?[row - 1]
        }
    }
}
