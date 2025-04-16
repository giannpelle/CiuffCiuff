
//
//  PlayerBuyViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/03/23.
//

import UIKit

class PlayerBuyCustomViewController: UIViewController, Operable {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var shareAmounts: [Double] = []
    var shareCompanyIndexes: [Int] = []
    var shareOwnersGlobalIndices: [Int] = []
    
    var legalOwnerGlobalIndexes: [Int] = []
    var soldCompaniesBaseIndexes: [Int] = []
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var sharesAmountPopupButton: UIButton!
    @IBOutlet weak var sharesCompanyPopupButton: UIButton!
    @IBOutlet weak var sharesOwnerPopupButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var soldCompaniesStackView: UIStackView!
    @IBOutlet weak var soldCompaniesLabelsStackView: UIStackView!
    @IBOutlet weak var backToSmartBuyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backToSmartBuyButton.setTitle(withText: "Back to smart BUY", fontSize: 18.0, fontWeight: .bold, textColor: UIColor.white)
        self.backToSmartBuyButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.buyButton.setTitle(withText: "BUY", fontSize: 18.0, fontWeight: .bold, textColor: UIColor.white)
        self.buyButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.legalOwnerGlobalIndexes = [] + self.gameState.getBankEntityIndexes() + self.gameState.getCompanyIndexes()
        
        self.shareAmounts = self.gameState.getPredefinedShareAmounts()
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        var opsAfterLastSR: [Operation] = []
        
        if let lastSROpIdx = self.gameState.activeOperations.lastIndex(where: { op in OperationType.getSROperationTypes().contains(op.type) }) {
            opsAfterLastSR = Array<Operation>(self.gameState.activeOperations[lastSROpIdx...])
            
            self.soldCompaniesBaseIndexes = opsAfterLastSR.filter { ($0.type == .sell) && $0.destinationGlobalIndex == self.operatingPlayerIndex }.compactMap { $0.shareCompanyBaseIndex }
        }
        
        if self.soldCompaniesBaseIndexes.isEmpty {
            self.soldCompaniesStackView.isHidden = true
        } else {
            self.soldCompaniesStackView.isHidden = false
            
            for cmpBaseIdx in self.soldCompaniesBaseIndexes {
                let cmpLabel = PaddingLabel()
                cmpLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .regular)
                cmpLabel.text = self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)
                cmpLabel.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: cmpBaseIdx)
                cmpLabel.textColor = self.gameState.getCompanyTextColor(atBaseIndex: cmpBaseIdx)
                
                cmpLabel.paddingTop = 8.0
                cmpLabel.paddingBottom = 8.0
                cmpLabel.paddingLeft = 10.0
                cmpLabel.paddingRight = 10.0
                
                self.soldCompaniesLabelsStackView.addArrangedSubview(cmpLabel)
            }
        }
        
        for companyIndex in self.gameState.getCompanyIndexes() where self.gameState.getCompanyType(atIndex: companyIndex).areSharesPurchasebleByPlayers() {
            let companyBaseIndex = self.gameState.forceConvert(index: companyIndex, backwards: true, withIndexType: .companies)
            
            if self.soldCompaniesBaseIndexes.contains(companyBaseIndex) { continue }
            
            let shareAvailableInBank = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[companyBaseIndex] > 0
            let shareAvailableInIpo = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[companyBaseIndex] > 0
            let shareAvailableInCmp = self.gameState.getSharesPortfolioForCompany(atIndex: companyIndex)[companyBaseIndex] > 0
            let shareAvailableInAside = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.aside.rawValue)[companyBaseIndex] > 0
            let shareAvailableInTradeIn = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.tradeIn.rawValue)[companyBaseIndex] > 0
            if shareAvailableInBank || shareAvailableInIpo || shareAvailableInCmp || shareAvailableInAside || shareAvailableInTradeIn {
                self.shareCompanyIndexes.append(companyIndex)
            }
        }
            
        self.buyButton.layer.cornerRadius = 4.0
        self.buyButton.clipsToBounds = true
            
        // setup repeat ops stack view
        if let firstCmpIndex = self.shareCompanyIndexes.first {
            self.parentVC.emptyLabel.isHidden = true
            self.view.isHidden = false
            
            self.shareOwnersGlobalIndices = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: firstCmpIndex, includePlayers: false).filter { self.legalOwnerGlobalIndexes.contains($0) }
            
            self.setupPopupButtons()
                
        } else {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
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
        self.view.insertSubview(backgroundView, at: 0)
        
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
    
    func setupPopupButtons() {
        
        var sharesAmountActions: [UIAction] = []
        
        if let _ = self.shareCompanyIndexes.first {
//            let firstCmpBaseIdx = self.gameState.convert(index: firstCmpIdx, backwards: true, withIndexType: .companies)
            
            for shareAmount in self.shareAmounts {
                if shareAmount == 1 {
                    sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) share", state: .on, handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
                } else if shareAmount == 2 {
                    sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
                } else {
                    sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
                }
            }
        }
        
        if sharesAmountActions.isEmpty {
            self.sharesAmountPopupButton.isHidden = true
        } else {
            self.sharesAmountPopupButton.isHidden = false
            if sharesAmountActions.count == 1 {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.sharesAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
            self.sharesAmountPopupButton.showsMenuAsPrimaryAction = true
            self.sharesAmountPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        var sharesCompanyActions: [UIAction] = []
        for (i, shareCompanyIdx) in self.shareCompanyIndexes.enumerated() {
            if i == 0 {
                sharesCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), state: .on, handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: idx))
                    self.sharesCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                    self.updateShareOwnerPopupButton()
                }))
            } else {
                sharesCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: idx))
                    self.sharesCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                    self.updateShareOwnerPopupButton()
                }))
            }
        }
        
        if sharesAmountActions.isEmpty {
            self.sharesCompanyPopupButton.isHidden = true
        } else {
            self.sharesCompanyPopupButton.isHidden = false
            if sharesAmountActions.count == 1 {
                self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: self.shareCompanyIndexes[0]))
                self.sharesCompanyPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyIndexes[0]].uiColor)
            } else {
                self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: self.shareCompanyIndexes[0]))
                self.sharesCompanyPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyIndexes[0]].uiColor)
            }
            
            self.sharesCompanyPopupButton.menu = UIMenu(children: sharesCompanyActions)
            self.sharesCompanyPopupButton.showsMenuAsPrimaryAction = true
            self.sharesCompanyPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        
        var sharesOwnerActions: [UIAction] = []
        for (i, shareOwnerGlobalIdx) in self.shareOwnersGlobalIndices.enumerated() {
            let sharesAmount = self.gameState.shares[shareOwnerGlobalIdx][self.gameState.forceConvert(index: self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.sharesCompanyPopupButton.currentTitle!), backwards: true, withIndexType: .companies)]
            if i == 0 {
                sharesOwnerActions.append(UIAction(title: self.gameState.labels[shareOwnerGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareOwnerGlobalIdx].uiColor), state: .on, handler: { action in
                    self.sharesOwnerPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesOwnerActions.append(UIAction(title: self.gameState.labels[shareOwnerGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareOwnerGlobalIdx].uiColor), handler: { action in
                    self.sharesOwnerPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesOwnerActions.isEmpty {
            self.sharesOwnerPopupButton.isHidden = true
        } else {
            self.sharesOwnerPopupButton.isHidden = false
            if sharesOwnerActions.count == 1 {
                self.sharesOwnerPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.sharesOwnerPopupButton.setPopupTitle(withText: sharesOwnerActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.sharesOwnerPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.sharesOwnerPopupButton.setPopupTitle(withText: sharesOwnerActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.sharesOwnerPopupButton.menu = UIMenu(children: sharesOwnerActions)
            self.sharesOwnerPopupButton.showsMenuAsPrimaryAction = true
            self.sharesOwnerPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        if let globalOwnerIdx = self.shareOwnersGlobalIndices.first, let cmpIdx = self.shareCompanyIndexes.first {
            let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
            
            if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx), globalOwnerIdx == BankIndex.bank.rawValue {
                self.cashTextField.text = "\(Int(cmpShareValue))"
            } else if let PARvalue = self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx), PARvalue != 0 && globalOwnerIdx == BankIndex.ipo.rawValue {
                self.cashTextField.text = "\(PARvalue)"
            }
        }
        
    }
    
    func updateShareOwnerPopupButton() {
        
        let cmpIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.sharesCompanyPopupButton.currentTitle!)
//        let cmpBaseIndex = self.gameState.convert(index: cmpIndex, backwards: true, withIndexType: .companies)
        
        var sharesAmountActions: [UIAction] = []
        
        for shareAmount in self.shareAmounts {
            if shareAmount == 1 {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) share", state: .on, handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else if shareAmount == 2 {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesAmountActions.isEmpty {
            self.sharesAmountPopupButton.isHidden = true
        } else {
            self.sharesAmountPopupButton.isHidden = false
            if sharesAmountActions.count == 1 {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.sharesAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
            self.sharesAmountPopupButton.showsMenuAsPrimaryAction = true
            self.sharesAmountPopupButton.changesSelectionAsPrimaryAction = true
        }

        self.shareOwnersGlobalIndices = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: cmpIndex, includePlayers: false).filter { self.legalOwnerGlobalIndexes.contains($0) }
        
        var sharesOwnerActions: [UIAction] = []
        for (i, shareOwnerGlobalIdx) in self.shareOwnersGlobalIndices.enumerated() {
            let sharesAmount = self.gameState.shares[shareOwnerGlobalIdx][self.gameState.forceConvert(index: self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.sharesCompanyPopupButton.currentTitle!), backwards: true, withIndexType: .companies)]
            if i == 0 {
                sharesOwnerActions.append(UIAction(title: self.gameState.labels[shareOwnerGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareOwnerGlobalIdx].uiColor), state: .on, handler: { action in
                    self.sharesOwnerPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesOwnerActions.append(UIAction(title: self.gameState.labels[shareOwnerGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareOwnerGlobalIdx].uiColor), handler: { action in
                    self.sharesOwnerPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesOwnerActions.isEmpty {
            self.sharesOwnerPopupButton.isHidden = true
        } else {
            self.sharesOwnerPopupButton.isHidden = false
            if sharesOwnerActions.count == 1 {
                self.sharesOwnerPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.sharesOwnerPopupButton.setPopupTitle(withText: sharesOwnerActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.sharesOwnerPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.sharesOwnerPopupButton.setPopupTitle(withText: sharesOwnerActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.sharesOwnerPopupButton.menu = UIMenu(children: sharesOwnerActions)
            self.sharesOwnerPopupButton.showsMenuAsPrimaryAction = true
            self.sharesOwnerPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    @IBAction func activeSmartBuyVC(sender: UIButton) {
        self.parentVC.loadSmartBuyVC()
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = self.cashTextField.text! + titleLabelText
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
    }

    @IBAction func buyButtonPressed(sender: UIButton) {
        guard let amountStr = self.cashTextField.text, let singleShareAmount = Double(amountStr) else {
            return
        }
        
        let shareAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.sharesAmountPopupButton.currentTitle!)
        
        var amount = 0.0
        
        if self.gameState.buySellRoundPolicyOnTotal == .roundUp {
            amount = ceil(singleShareAmount * shareAmount)
        } else {
            amount = floor(singleShareAmount * shareAmount)
        }
        
        if amount == 0.0 && shareAmount == 0.0 {
            return
        }
        
        let shareCmpIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.sharesCompanyPopupButton.currentTitle!)
        let shareCmpBaseIndex: Int = self.gameState.forceConvert(index: shareCmpIndex, backwards: true, withIndexType: .companies)

        let srcGlobalIndex: Int = self.operatingPlayerIndex
        var dstGlobalIndex: Int = BankIndex.bank.rawValue
        
        let shareSrcGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.sharesOwnerPopupButton.currentTitle!)
        let shareDstGlobalIndex: Int = self.operatingPlayerIndex
        
        if shareSrcGlobalIndex == BankIndex.ipo.rawValue && !self.gameState.buyShareFromIPOPayBank {
            dstGlobalIndex = shareCmpIndex
        } else if shareSrcGlobalIndex == BankIndex.bank.rawValue && !self.gameState.buyShareFromBankPayBank {
            dstGlobalIndex = shareCmpIndex
        } else if self.gameState.getCompanyIndexes().contains(shareSrcGlobalIndex) && !self.gameState.buyShareFromCompPayBank {
            dstGlobalIndex = shareCmpIndex
        }
        
        if let g1856companiesStatus = self.gameState.g1856CompaniesStatus {
            switch g1856companiesStatus[shareCmpBaseIndex] {
            case .incrementalCapitalizationCapped:
                if shareSrcGlobalIndex == BankIndex.ipo.rawValue && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[shareCmpBaseIndex] > 5 {
                    dstGlobalIndex = shareCmpIndex
                } else {
                    dstGlobalIndex = BankIndex.bank.rawValue
                }
                break
            case .incrementalCapitalization:
                dstGlobalIndex = shareCmpIndex
                break
            case .fullCapitalization:
                dstGlobalIndex = BankIndex.bank.rawValue
                break
            }
        }
        
        var opsToBePerformed: [Operation] = []
        
        let operation = Operation(type: .buy, uid: nil)
        operation.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: amount)
        operation.addSharesDetails(shareSourceIndex: shareSrcGlobalIndex, shareDestinationIndex: shareDstGlobalIndex, shareAmount: shareAmount, shareCompanyBaseIndex: shareCmpBaseIndex, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex))
        
        opsToBePerformed.append(operation)
        
        // should set PAR value?
        if self.gameState.getCompanyType(atBaseIndex: shareCmpBaseIndex).isShareValueTokenOnBoard() {
            if self.gameState.getShareValue(forCompanyAtBaseIndex: shareCmpBaseIndex) == nil {
                if let parIdx = self.gameState.getPARindex(fromShareValue: Double(amountStr) ?? 0.0) {
                    let op = Operation(type: .market, uid: operation.uid)
                    op.setOperationColorGlobalIndex(colorGlobalIndex: shareCmpIndex)
                    op.addMarketDetails(marketShareValueCmpBaseIndex: shareCmpBaseIndex, marketShareValueFromIndex: nil, marketShareValueToIndex: parIdx, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: shareCmpBaseIndex)) -> PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(amountStr) ?? 0.0, shouldTruncateDouble: true))")
                    
                    opsToBePerformed.append(op)
                }
            }
        }
        
        // should Float company?
        if !self.gameState.isCompanyFloated(atBaseIndex: shareCmpBaseIndex) && self.gameState.getCompanyType(atBaseIndex: shareCmpBaseIndex).canBeFloatedByPlayers() {
            let startingLocationGlobalIndex = self.gameState.shareStartingLocation.getBankIndex() ?? shareCmpIndex
            
            if shareSrcGlobalIndex == startingLocationGlobalIndex {
                if (self.gameState.getTotalShareNumberOfCompany(atBaseIndex: shareCmpBaseIndex) - (self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: startingLocationGlobalIndex)[shareCmpBaseIndex] - shareAmount)) >= Double(self.gameState.requiredNumberOfSharesToFloat) {
                    
                    let PARValues = self.gameState.getGamePARValues()
                    
                    var floatAmount: Double = 0.0
                    if (self.gameState.buyShareFromIPOPayBank && self.gameState.buyShareFromCompPayBank) {
                        // is total capitalization
                        if PARValues.contains(Int(singleShareAmount)) {
                            floatAmount = singleShareAmount * 10
                            
                        } else if let PARvalue = self.gameState.getPARvalue(forCompanyAtBaseIndex: shareCmpBaseIndex) {
                            
                            if PARValues.contains(PARvalue) {
                                floatAmount = Double(PARvalue * 10)
                            }
                        }
                    }
                    
                    if self.gameState.game == .g1846 && self.gameState.getCompanyLabel(atIndex: shareCmpIndex) == "IC" {
                        self.gameState.floatModifiers[shareCmpBaseIndex] = self.gameState.getPARvalue(forCompanyAtBaseIndex: shareCmpBaseIndex) ?? Int(singleShareAmount)
                    }
                    
                    let floatOps = CompanyFloatViewController.generateFloatOperationsWithAmount(floatAmount: Int(floatAmount), forCompanyAtIndex: shareCmpIndex, andGameState: self.gameState)
                        
                    opsToBePerformed += floatOps
                }
            }
        }
        
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
            if !self.gameState.perform(operation: op) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
        }
        
        if opsToBePerformed.contains(where: { $0.type == .float }) {
            if let buyOp = opsToBePerformed.first(where: { $0.type == .buy }), let cmpBaseIdx = buyOp.shareCompanyBaseIndex {
                var messageStr = "\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) floated"
                if opsToBePerformed.contains(where: { $0.type == .tokens }) {
                    messageStr += " (and paid float fees)"
                } else if opsToBePerformed.contains(where: { $0.type == .cash && $0.sourceGlobalIndex == BankIndex.bank.rawValue && ($0.amount ?? 0) > 0 }) {
                    messageStr += " (and received float bonus)"
                }
                
                HomeViewController.presentSnackBar(withMessage: messageStr)
            }
        }

        self.parentVC.doneButtonPressed(sender: UIButton())
        
    }
    
    func commitButtonPressed() -> Bool? {
        return true
    }

}
