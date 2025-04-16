//
//  OperationViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 03/01/23.
//

import UIKit

class CompanyOperateViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    var shareholdersGlobalIndexesCollectionView: [Int] = []
    var shareholderLabelsCollectionView: [String] = []
    var shareholdersColorsCollectionView: [UIColor] = []
    var lastPayout: Int!
    
    var shareholderCountLabelAttributedTexts: [NSMutableAttributedString] = []
    var profitPreviewLabelTexts: [String] = []
    var payoutPreviewLabelTexts: [String] = []
    var withholdPreviewLabelTexts: [String] = []
    
    var playerIndexes: [Int] = []
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var payoutSuggestionsStackView: UIStackView!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var shareholdersCollectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var g1856PayInterestsStackView: UIStackView!
    @IBOutlet weak var g1856PayInterestsLabel: UILabel!
    @IBOutlet weak var emergencyPopupButton: UIButton!
    @IBOutlet weak var emergencyStackView: UIStackView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.operationSegmentedControl.selectedSegmentIndex = 1
        self.operationSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.operationSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.operationSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.operationSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        let shareholdersGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: self.operatingCompanyBaseIndex)
        self.shareholdersGlobalIndexesCollectionView = shareholdersGlobalIndexes.filter { !self.gameState.getBankEntityIndexes().contains($0) && $0 != self.operatingCompanyIndex }
        
        var shouldAddBankCollectionViewCell: Bool = false
        
        for shareholderGlobalIdx in shareholdersGlobalIndexes {
            if shareholderGlobalIdx == BankIndex.bank.rawValue {
                if self.gameState.bankSharesPayBank {
                    shouldAddBankCollectionViewCell = true
                }
            } else if shareholderGlobalIdx == BankIndex.ipo.rawValue {
                if self.gameState.ipoSharesPayBank {
                    shouldAddBankCollectionViewCell = true
                }
            } else if shareholderGlobalIdx == BankIndex.tradeIn.rawValue {
                if self.gameState.tradeInSharesPayBank {
                    shouldAddBankCollectionViewCell = true
                }
            } else if shareholderGlobalIdx == BankIndex.aside.rawValue {
                if self.gameState.asideSharesPayBank {
                    shouldAddBankCollectionViewCell = true
                }
            } else if shareholderGlobalIdx == self.operatingCompanyIndex {
                if self.gameState.compSharesPayBank {
                    shouldAddBankCollectionViewCell = true
                }
            }
        }
        
        self.shareholdersGlobalIndexesCollectionView.insert(self.operatingCompanyIndex, at: 0)
        
        if shouldAddBankCollectionViewCell {
            self.shareholdersGlobalIndexesCollectionView.append(BankIndex.bank.rawValue)
        }
        
        if self.shareholdersGlobalIndexesCollectionView.isEmpty {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
            return
        }
        
        self.parentVC.emptyLabel.isHidden = true
        self.view.isHidden = false
        
        self.shareholderLabelsCollectionView = self.shareholdersGlobalIndexesCollectionView.map { self.gameState.labels[$0] }
        self.shareholdersColorsCollectionView = self.shareholdersGlobalIndexesCollectionView.map { self.gameState.colors[$0].uiColor }
        
        self.updatePayoutPreviewDisplayData()
        
        self.shareholdersCollectionView.delegate = self
        self.shareholdersCollectionView.dataSource = self
        self.shareholdersCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0)
        self.shareholdersCollectionView.backgroundColor = UIColor.secondaryAccentColor
        
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
        
        // todo refactoring
        if let loansAmounts = self.gameState.loans {
            self.g1856PayInterestsStackView.isHidden = false
            
            let interestsToPay = loansAmounts[self.operatingCompanyIndex] * 10
            self.g1856PayInterestsLabel.text = "Pay \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(interestsToPay))) interests"
            
            if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) > Double(interestsToPay) {
                self.emergencyStackView.isHidden = true
            } else {
                self.playerIndexes = Array<Int>(self.gameState.getPlayerIndexes())
                
                self.setupPopupButtons()
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
    
    // custom 1856 popup button
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
    
    func updatePayoutPreviewDisplayData() {
        
        self.shareholderCountLabelAttributedTexts.removeAll()
        self.profitPreviewLabelTexts.removeAll()
        self.payoutPreviewLabelTexts.removeAll()
        self.withholdPreviewLabelTexts.removeAll()
        
        for (i, currentShareholderGlobalIndex) in self.shareholdersGlobalIndexesCollectionView.enumerated() {
            
            var currentShareholderSharesAmount = 0.0
            
            if currentShareholderGlobalIndex == self.operatingCompanyIndex {
                
                var sharesStr = ""
                if !self.gameState.ipoSharesPayBank {
                    let ipoSharesAmount = self.gameState.shares[BankIndex.ipo.rawValue][self.operatingCompanyBaseIndex]
                    if ipoSharesAmount > 0 {
                        sharesStr += "IPO: \(ipoSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(ipoSharesAmount)) : String(ipoSharesAmount)) shares\n"
                        currentShareholderSharesAmount += ipoSharesAmount
                    }
                }
                if !self.gameState.bankSharesPayBank {
                    let bankSharesAmount = self.gameState.shares[BankIndex.bank.rawValue][self.operatingCompanyBaseIndex]
                    if bankSharesAmount > 0 {
                        sharesStr += "Bank: \(bankSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(bankSharesAmount)) : String(bankSharesAmount)) shares\n"
                        currentShareholderSharesAmount += bankSharesAmount
                    }
                }
                if !self.gameState.tradeInSharesPayBank {
                    let tradeInSharesAmount = self.gameState.shares[BankIndex.tradeIn.rawValue][self.operatingCompanyBaseIndex]
                    if tradeInSharesAmount > 0 {
                        sharesStr += "Trade-in: \(tradeInSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(tradeInSharesAmount)) : String(tradeInSharesAmount)) shares\n"
                        currentShareholderSharesAmount += tradeInSharesAmount
                    }
                }
                if !self.gameState.asideSharesPayBank {
                    let asideSharesAmount = self.gameState.shares[BankIndex.aside.rawValue][self.operatingCompanyBaseIndex]
                    if asideSharesAmount > 0 {
                        sharesStr += "Aside: \(asideSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(asideSharesAmount)) : String(asideSharesAmount)) shares\n"
                        currentShareholderSharesAmount += asideSharesAmount
                    }
                }
                
                if !sharesStr.isEmpty {
                    sharesStr.remove(at: sharesStr.index(before: sharesStr.endIndex))
                    
                    let attributedText = NSMutableAttributedString()
                    
                    let littleLineSpacingParagraphStyle = NSMutableParagraphStyle()
                    littleLineSpacingParagraphStyle.lineSpacing = 5.0
                    littleLineSpacingParagraphStyle.alignment = .center
                    
                    attributedText.append(NSAttributedString(string: sharesStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21.0, weight: .medium)]))
                    attributedText.addAttribute(.paragraphStyle, value: littleLineSpacingParagraphStyle, range: NSRange(location: 0, length: attributedText.length))
                    
                    self.shareholderCountLabelAttributedTexts.append(attributedText)
                } else {
                    self.shareholderCountLabelAttributedTexts.append(NSMutableAttributedString())
                }
                
            } else if currentShareholderGlobalIndex == BankIndex.bank.rawValue {
                
                var sharesStr = ""
                if self.gameState.ipoSharesPayBank {
                    let ipoSharesAmount = self.gameState.shares[BankIndex.ipo.rawValue][self.operatingCompanyBaseIndex]
                    if ipoSharesAmount > 0 {
                        sharesStr += "IPO: \(ipoSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(ipoSharesAmount)) : String(ipoSharesAmount)) shares\n"
                        currentShareholderSharesAmount += ipoSharesAmount
                    }
                }
                if self.gameState.bankSharesPayBank {
                    let bankSharesAmount = self.gameState.shares[BankIndex.bank.rawValue][self.operatingCompanyBaseIndex]
                    if bankSharesAmount > 0 {
                        sharesStr += "Bank: \(bankSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(bankSharesAmount)) : String(bankSharesAmount)) shares\n"
                        currentShareholderSharesAmount += bankSharesAmount
                    }
                }
                if self.gameState.tradeInSharesPayBank {
                    let tradeInSharesAmount = self.gameState.shares[BankIndex.tradeIn.rawValue][self.operatingCompanyBaseIndex]
                    if tradeInSharesAmount > 0 {
                        sharesStr += "Trade-in: \(tradeInSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(tradeInSharesAmount)) : String(tradeInSharesAmount)) shares\n"
                        currentShareholderSharesAmount += tradeInSharesAmount
                    }
                }
                if self.gameState.asideSharesPayBank {
                    let asideSharesAmount = self.gameState.shares[BankIndex.aside.rawValue][self.operatingCompanyBaseIndex]
                    if asideSharesAmount > 0 {
                        sharesStr += "Aside: \(asideSharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(asideSharesAmount)) : String(asideSharesAmount)) shares\n"
                        currentShareholderSharesAmount += asideSharesAmount
                    }
                }
                
                if !sharesStr.isEmpty {
                    sharesStr.remove(at: sharesStr.index(before: sharesStr.endIndex))
                    
                    let attributedText = NSMutableAttributedString()
                    
                    let littleLineSpacingParagraphStyle = NSMutableParagraphStyle()
                    littleLineSpacingParagraphStyle.lineSpacing = 5.0
                    littleLineSpacingParagraphStyle.alignment = .center
                    
                    attributedText.append(NSAttributedString(string: sharesStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21.0, weight: .medium)]))
                    attributedText.addAttribute(.paragraphStyle, value: littleLineSpacingParagraphStyle, range: NSRange(location: 0, length: attributedText.length))
                    
                    self.shareholderCountLabelAttributedTexts.append(attributedText)
                } else {
                    self.shareholderCountLabelAttributedTexts.append(NSMutableAttributedString())
                }
                
            } else {
                
                let sharesAmount = self.gameState.shares[currentShareholderGlobalIndex][self.operatingCompanyBaseIndex]
                self.shareholderCountLabelAttributedTexts.append(NSMutableAttributedString(string: (sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) + " shares", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21.0, weight: .medium)]))
                
                currentShareholderSharesAmount += sharesAmount
            }
            
            var amount = Int(self.cashTextField.text ?? "") ?? 0
            
            if let loansAmounts = self.gameState.loans {
                
                let interestsToPay = Double(loansAmounts[self.operatingCompanyIndex] * 10)
                
                let companyMoneyAmount = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)
                
                if companyMoneyAmount < Double(interestsToPay) {
                    
                    let compAmount = Double((Int(companyMoneyAmount) / 10) * 10)
                    let remainingInterests = interestsToPay - compAmount
                    
                    if Double(amount) >= remainingInterests {
                        amount -= Int(remainingInterests)
                    } else {
                        amount = 0
                    }
                }
            }
            
            if amount == 0 {
                self.profitPreviewLabelTexts.append("")
                self.payoutPreviewLabelTexts.append("no payout")
                self.withholdPreviewLabelTexts.append("")
                continue
            }
            
            if self.operatingCompanyIndex == currentShareholderGlobalIndex {
                self.withholdPreviewLabelTexts.append("Withhold: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.amounts[currentShareholderGlobalIndex] + Double(amount)))
            } else {
                self.withholdPreviewLabelTexts.append("")
            }
            
            if currentShareholderGlobalIndex == BankIndex.bank.rawValue {
                self.profitPreviewLabelTexts.append("")
                self.payoutPreviewLabelTexts.append("")
            } else {
                var payoutAmount = 0.0
                
                var unitShareValue = Double(amount) / Double(self.gameState.getTotalShareNumberOfCompany(atIndex: self.operatingCompanyIndex))
                
                switch self.gameState.unitShareValuePayoutRoundPolicy {
                case .doNotRound:
                    break
                case .roundUp:
                    unitShareValue = ceil(unitShareValue)
                case .roundDown:
                    unitShareValue = floor(unitShareValue)
                }
                
                if self.gameState.isPayoutRoundedUpOnTotalValue {
                    payoutAmount += ceil(unitShareValue * currentShareholderSharesAmount)
                } else {
                    payoutAmount += floor(unitShareValue * currentShareholderSharesAmount)
                }
                
                self.profitPreviewLabelTexts.append("Profit: +" + self.gameState.currencyType.getCurrencyStringFromAmount(amount: payoutAmount))
                self.payoutPreviewLabelTexts.append("Payout: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.amounts[currentShareholderGlobalIndex] + payoutAmount))
                
            }
        }
        
    }
    
    @IBAction func payoutSuggestionButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = titleLabelText
            
            if let loansAmounts = self.gameState.loans {
                let interestsToPay = loansAmounts[self.operatingCompanyIndex] * 10
                
                let compAmount = Double((Int(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) / 10) * 10)
                
                if compAmount + (Double(self.cashTextField.text ?? "") ?? 0.0) >= Double(interestsToPay) {
                    self.emergencyStackView.isHidden = true
                } else {
                    self.emergencyStackView.isHidden = false
                }
            }
            
            self.updatePayoutPreviewDisplayData()
            self.shareholdersCollectionView.reloadData()
        }
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = self.cashTextField.text! + titleLabelText
            
            if let loansAmounts = self.gameState.loans {
                let interestsToPay = loansAmounts[self.operatingCompanyIndex] * 10
                
                let compAmount = Double((Int(self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)) / 10) * 10)
                
                if compAmount + (Double(self.cashTextField.text ?? "") ?? 0.0) >= Double(interestsToPay) {
                    self.emergencyStackView.isHidden = true
                } else {
                    self.emergencyStackView.isHidden = false
                }
            }
            
            self.updatePayoutPreviewDisplayData()
            self.shareholdersCollectionView.reloadData()
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
        
        if let loansAmounts = self.gameState.loans {
            let interestsToPay = loansAmounts[self.operatingCompanyIndex] * 10
            
            if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) >= Double(interestsToPay) {
                self.emergencyStackView.isHidden = true
            } else {
                self.emergencyStackView.isHidden = false
            }
        }
        
        self.updatePayoutPreviewDisplayData()
        self.shareholdersCollectionView.reloadData()
    }
    
    func commitButtonPressed() -> Bool? {
        
        guard let amountStr = self.cashTextField.text else {
            return false
        }
        
        var amount = Int(amountStr) ?? 0
        
        if amount == 0 || amount % 10 != 0 {
            return false
        }
        
        var shouldSkipPayout = false
        
        if let loansAmounts = self.gameState.loans {
            
            let interestsToPay = Double(loansAmounts[self.operatingCompanyIndex] * 10)
            
            let companyMoneyAmount = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)
            
            var opsToBePerformed: [Operation] = []
            
            if companyMoneyAmount >= Double(interestsToPay) {
                
                let interestOp = Operation(type: .interests, uid: nil)
                interestOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                interestOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: interestsToPay)
                
                opsToBePerformed.append(interestOp)
                
            } else {
                
                let compAmount = Double((Int(companyMoneyAmount) / 10) * 10)
                let remainingInterests = interestsToPay - compAmount
                
                let compInterestOp = Operation(type: .interests, uid: nil)
                compInterestOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                compInterestOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: compAmount)
                
                opsToBePerformed.append(compInterestOp)
                
                if Double(amount) >= remainingInterests {
                    
                    let interestOp = Operation(type: .interests, uid: nil)
                    interestOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    interestOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: BankIndex.bank.rawValue, amount: remainingInterests)
                    
                    opsToBePerformed.append(interestOp)
                    
                    amount -= Int(remainingInterests)
                    
                } else {
                    
                    let interestsOpUid = Operation.generateUid()
                    
                    let payoutInterestOp = Operation(type: .interests, uid: interestsOpUid)
                    payoutInterestOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    payoutInterestOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: BankIndex.bank.rawValue, amount: Double(amount))
                    
                    opsToBePerformed.append(payoutInterestOp)
                    
                    let emergencyPlayerIdx = self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.emergencyPopupButton.currentTitle!)
                    
                    let playerInterestOp = Operation(type: .interests, uid: interestsOpUid)
                    playerInterestOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                    playerInterestOp.addCashDetails(sourceIndex: emergencyPlayerIdx, destinationIndex: BankIndex.bank.rawValue, amount: remainingInterests - Double(amount), isEmergencyEnabled: true)
                    
                    opsToBePerformed.append(playerInterestOp)
                    
                    amount = 0
                }
                
            }
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                return false
            }
            
            for op in opsToBePerformed {
                _ = self.gameState.perform(operation: op)
            }
            
        }
        
        shouldSkipPayout = amount == 0
        
        if !shouldSkipPayout {
            
            if self.operationSegmentedControl.selectedSegmentIndex == 0 {
                if Self.withhold(withAmount: amount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState) {
                    
                    if let cmpBaseIdx = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies) {
                        self.gameState.lastCompPayoutValues[cmpBaseIdx] = amount
                    }
                    
                    if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
                        self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
                        return nil
                    }
                }
                
                return true
            } else {
                if Self.payout(withAmount: amount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState) {
                    if let cmpBaseIdx = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies) {
                        self.gameState.lastCompPayoutValues[cmpBaseIdx] = amount
                        return true
                    }
                }
            }
        } else {
            
            if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: [.left]) {
                if self.gameState.isOperationLegit(operation: marketOp, reverted: false) {
                    if self.gameState.perform(operation: marketOp) {
                        
                        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
                            self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
                            return nil
                        }
                        
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    static func generateWithholdOperations(withAmount amount: Int, forCompanyAtBaseIndex operatingCompanyBaseIndex: Int, andGameState gameState: GameState, shouldIncludeMarketOps: Bool, withOperationUid: Int?, isBasicStandardPayoutWiththold: Bool) -> [Operation] {
        
        let operatingCompanyIndex = gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
        
        var opsToBePerformed: [Operation] = []
        
        let operation = Operation(type: .withhold, uid: withOperationUid)
        operation.setOperationColorGlobalIndex(colorGlobalIndex: operatingCompanyIndex)
        operation.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: operatingCompanyIndex, amount: Double(amount))
        operation.addWithholdDetails(withholdCompanyBaseIndex: operatingCompanyBaseIndex, payoutTotalAmount: amount, isStandardPayout: isBasicStandardPayoutWiththold)
        
        opsToBePerformed.append(operation)
        
        if shouldIncludeMarketOps {
            if let marketOp = gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: operatingCompanyBaseIndex, andMovements: [.left], withUid: operation.uid) {
                opsToBePerformed.append(marketOp)
            }
        }
        
        return opsToBePerformed
    }
    
    static func withhold(withAmount amount: Int, forCompanyAtBaseIndex operatingCompanyBaseIndex: Int, andGameState gameState: GameState) -> Bool {
        
        let opsToBePerformed = Self.generateWithholdOperations(withAmount: amount, forCompanyAtBaseIndex: operatingCompanyBaseIndex, andGameState: gameState, shouldIncludeMarketOps: true, withOperationUid: nil, isBasicStandardPayoutWiththold: true)
        
        if gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            for op in opsToBePerformed {
                if !gameState.perform(operation: op) {
                    return false
                }
            }
        } else {
            return false
        }
        
        return true
        
    }
    
    static func generatePayoutOperations(withAmount amount: Int, forCompanyAtBaseIndex operatingCompanyBaseIndex: Int, andGameState gameState: GameState, shouldIncludeMarketOps: Bool, withOperationUid: Int?, isBasicStandardPayoutWiththold: Bool) -> [Operation] {
        
        let operatingCompanyIndex = gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
        var shareholdersGlobalIndexes = gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: operatingCompanyBaseIndex)
        
        if !gameState.getCompanyType(atBaseIndex: operatingCompanyBaseIndex).hasProprietaryTreasury() {
            shareholdersGlobalIndexes = shareholdersGlobalIndexes.filter { !gameState.getBankEntityIndexes().contains($0) && $0 != operatingCompanyIndex }
        }
        
        let shareholdersAmounts = shareholdersGlobalIndexes.map { gameState.shares[$0][operatingCompanyBaseIndex] }
        
        var opsToBePerformed: [Operation] = []
        
        let payoutOpUid = withOperationUid ?? Operation.generateUid()
        
        for (i, shareholderGlobalIdx) in shareholdersGlobalIndexes.enumerated() {
            let shareAmount = shareholdersAmounts[i]
            if shareAmount > 0 {
                var payout = 0
                
                var unitShareValue = Double(amount) / Double(gameState.getTotalShareNumberOfCompany(atIndex: operatingCompanyIndex))
                
                switch gameState.unitShareValuePayoutRoundPolicy {
                case .doNotRound:
                    break
                case .roundUp:
                    unitShareValue = ceil(unitShareValue)
                case .roundDown:
                    unitShareValue = floor(unitShareValue)
                }
                
                if gameState.isPayoutRoundedUpOnTotalValue {
                    payout = Int(ceil(unitShareValue * shareAmount))
                } else {
                    payout = Int(floor(unitShareValue * shareAmount))
                }

                var dstGlobalIndex = shareholderGlobalIdx
                
                if shareholderGlobalIdx == BankIndex.bank.rawValue && !gameState.bankSharesPayBank {
                    dstGlobalIndex = operatingCompanyIndex
                } else if shareholderGlobalIdx == BankIndex.ipo.rawValue && !gameState.ipoSharesPayBank {
                    dstGlobalIndex = operatingCompanyIndex
                } else if shareholderGlobalIdx == BankIndex.aside.rawValue && !gameState.asideSharesPayBank {
                    dstGlobalIndex = operatingCompanyIndex
                } else if shareholderGlobalIdx == BankIndex.tradeIn.rawValue && !gameState.tradeInSharesPayBank {
                    dstGlobalIndex = operatingCompanyIndex
                } else if shareholderGlobalIdx == operatingCompanyIndex && gameState.compSharesPayBank {
                    dstGlobalIndex = BankIndex.bank.rawValue
                }
                
                if gameState.getBankEntityIndexes().contains(dstGlobalIndex) {
                    dstGlobalIndex = BankIndex.bank.rawValue
                }
                
                let operation = Operation(type: .payout, uid: payoutOpUid)
                operation.setOperationColorGlobalIndex(colorGlobalIndex: operatingCompanyIndex)
                operation.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: dstGlobalIndex, amount: Double(payout))
                operation.addPayoutDetails(payoutCompanyBaseIndex: operatingCompanyBaseIndex, payoutShareAmount: shareAmount, payoutTotalAmount: amount, isStandardPayout: isBasicStandardPayoutWiththold)
                
                opsToBePerformed.append(operation)
            }
        }
        
        opsToBePerformed = opsToBePerformed.filter { $0.destinationGlobalIndex != BankIndex.bank.rawValue }
        
        if shouldIncludeMarketOps {
            if gameState.game == .g1849 {
                if let cmpShareValue = gameState.getShareValue(forCompanyAtBaseIndex: operatingCompanyBaseIndex) {
                    if amount >= Int(cmpShareValue) {
                        if let marketOp = gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: operatingCompanyBaseIndex, andMovements: [.right], withUid: payoutOpUid) {
                            opsToBePerformed.append(marketOp)
                        }
                    }
                }
            } else if let marketOp = gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: operatingCompanyBaseIndex, andMovements: [.right], withUid: payoutOpUid) {
                opsToBePerformed.append(marketOp)
            }
        }
        
        return opsToBePerformed
        
    }
    
    static func payout(withAmount amount: Int, forCompanyAtBaseIndex operatingCompanyBaseIndex: Int, andGameState gameState: GameState) -> Bool {
        
        let opsToBePerformed = Self.generatePayoutOperations(withAmount: amount, forCompanyAtBaseIndex: operatingCompanyBaseIndex, andGameState: gameState, shouldIncludeMarketOps: true, withOperationUid: nil, isBasicStandardPayoutWiththold: true)
        
        if !gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return false
        }
        
        for op in opsToBePerformed {
            if !gameState.perform(operation: op) {
                return false
            }
        }
        
        return true
      
    }

}

extension CompanyOperateViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shareholdersGlobalIndexesCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentShareholderGlobalIndex = self.shareholdersGlobalIndexesCollectionView[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareholderCell", for: indexPath) as! ShareholderCollectionViewCell
        
        cell.shareholderLabel.text = self.shareholderLabelsCollectionView[indexPath.row]
        cell.shareholderLabel.textColor = self.gameState.textColors[currentShareholderGlobalIndex].uiColor
        cell.shareholderLabel.backgroundColor = self.shareholdersColorsCollectionView[indexPath.row]
        
        cell.accessoryBackgroundView.layer.borderColor = self.shareholdersColorsCollectionView[indexPath.row].cgColor
        cell.accessoryBackgroundView.layer.borderWidth = 3.0
        
        if self.shareholderCountLabelAttributedTexts[indexPath.row].string.isEmpty {
            cell.shareholderCountLabel.isHidden = true
        } else {
            cell.shareholderCountLabel.isHidden = false
            cell.shareholderCountLabel.attributedText = self.shareholderCountLabelAttributedTexts[indexPath.row]
        }
        
        if self.profitPreviewLabelTexts[indexPath.row].isEmpty {
            cell.profitPreviewLabel.isHidden = true
        } else {
            cell.profitPreviewLabel.isHidden = false
            cell.profitPreviewLabel.text = self.profitPreviewLabelTexts[indexPath.row]
        }
        
        if self.payoutPreviewLabelTexts[indexPath.row].isEmpty {
            cell.payoutPreviewLabel.isHidden = true
        } else {
            cell.payoutPreviewLabel.isHidden = false
            cell.payoutPreviewLabel.text = self.payoutPreviewLabelTexts[indexPath.row]
        }
        
        if self.withholdPreviewLabelTexts[indexPath.row].isEmpty {
            cell.withholdPreviewLabel.isHidden = true
        } else {
            cell.withholdPreviewLabel.isHidden = false
            cell.withholdPreviewLabel.text = self.withholdPreviewLabelTexts[indexPath.row]
        }
        
        return cell
    }
}

extension CompanyOperateViewController: UICollectionViewDelegate {
    
}

extension CompanyOperateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols = 5.0
        let rows = 1.0
        
        if self.shareholdersGlobalIndexesCollectionView.count <= 5 {
            return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
        } else {
            
            let width = floor((collectionView.bounds.size.width - 70.0) / 5.0)
            
            return CGSize(width: Int(width), height: collectionView.getHeightForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false))
        }
        
    }
}

