//
//  Company1846OperateViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 10/04/25.
//

import UIKit

class Company1846OperateViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
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
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var payoutSuggestionsStackView: UIStackView!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var shareholdersCollectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.operationSegmentedControl.selectedSegmentIndex = 2
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
                var halfPayoutAmount = 0.0
                let halfWithholdAmount = ((amount / 2) / 10) * 10
                
                var unitShareValue = Double(amount) / Double(self.gameState.getTotalShareNumberOfCompany(atIndex: self.operatingCompanyIndex))
                var halfUnitShareValue = Double(amount - halfWithholdAmount) / Double(self.gameState.getTotalShareNumberOfCompany(atIndex: self.operatingCompanyIndex))
                
                switch self.gameState.unitShareValuePayoutRoundPolicy {
                case .doNotRound:
                    break
                case .roundUp:
                    unitShareValue = ceil(unitShareValue)
                    halfUnitShareValue = ceil(halfUnitShareValue)
                case .roundDown:
                    unitShareValue = floor(unitShareValue)
                    halfUnitShareValue = floor(halfUnitShareValue)
                }
                
                if self.gameState.isPayoutRoundedUpOnTotalValue {
                    payoutAmount += ceil(unitShareValue * currentShareholderSharesAmount)
                    halfPayoutAmount += ceil(halfUnitShareValue * currentShareholderSharesAmount)
                } else {
                    payoutAmount += floor(unitShareValue * currentShareholderSharesAmount)
                    halfPayoutAmount += floor(halfUnitShareValue * currentShareholderSharesAmount)
                }
                
                if currentShareholderGlobalIndex == self.operatingCompanyIndex {
                    halfPayoutAmount += Double(halfWithholdAmount)
                }
                
                self.profitPreviewLabelTexts.append("Profit: +" + self.gameState.currencyType.getCurrencyStringFromAmount(amount: payoutAmount) + " (\(Int(halfPayoutAmount)))")
                self.payoutPreviewLabelTexts.append("Payout: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.amounts[currentShareholderGlobalIndex] + payoutAmount) + " (\( Int(self.gameState.amounts[currentShareholderGlobalIndex] + halfPayoutAmount)))")
                
            }
        }
        
    }
    
    @IBAction func payoutSuggestionButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = titleLabelText
            
            self.updatePayoutPreviewDisplayData()
            self.shareholdersCollectionView.reloadData()
        }
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = self.cashTextField.text! + titleLabelText
            
            self.updatePayoutPreviewDisplayData()
            self.shareholdersCollectionView.reloadData()
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
        
        self.updatePayoutPreviewDisplayData()
        self.shareholdersCollectionView.reloadData()
    }
    
    func commitButtonPressed() -> Bool? {
        
        guard let amountStr = self.cashTextField.text else {
            return false
        }
        
        let amount = Int(amountStr) ?? 0
        
        if amount == 0 || amount % 10 != 0 {
            return false
        }
        
        var withholdAmount = 0
        var payoutAmount = 0
        var opsToBePerformed: [Operation] = []
        let operationUid = Operation.generateUid()
            
        if self.operationSegmentedControl.selectedSegmentIndex == 0 {
            withholdAmount = amount
            payoutAmount = 0
            
            opsToBePerformed += CompanyOperateViewController.generateWithholdOperations(withAmount: withholdAmount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: false, withOperationUid: operationUid, isBasicStandardPayoutWiththold: false)
            
        } else if self.operationSegmentedControl.selectedSegmentIndex == 1 {
            withholdAmount = ((amount / 2) / 10) * 10
            payoutAmount = amount - withholdAmount
            
            if withholdAmount > 0 {
                opsToBePerformed += CompanyOperateViewController.generateWithholdOperations(withAmount: withholdAmount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: false, withOperationUid: operationUid, isBasicStandardPayoutWiththold: false)
            }
            
            if payoutAmount > 0 {
                opsToBePerformed += CompanyOperateViewController.generatePayoutOperations(withAmount: payoutAmount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: false, withOperationUid: operationUid, isBasicStandardPayoutWiththold: false)
            }
            
        } else {
            payoutAmount = amount
            withholdAmount = 0
            
            opsToBePerformed += CompanyOperateViewController.generatePayoutOperations(withAmount: payoutAmount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: false, withOperationUid: operationUid, isBasicStandardPayoutWiththold: false)
        }
        
        // add custom market Ops
        var marketOp: Operation? = nil
        
        if let currentShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex) {
            if Double(payoutAmount) < (currentShareValue / 2.0) {
                marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: [.left], withUid: operationUid)
            } else if Double(payoutAmount) < currentShareValue {
                marketOp = nil
            } else if Double(payoutAmount) < (currentShareValue * 2.0) {
                marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: [.right], withUid: operationUid)
            } else if Double(payoutAmount) < (currentShareValue * 3.0) || currentShareValue < 165 {
                marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 2), withUid: operationUid)
            } else {
                marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 3), withUid: operationUid)
            }
        }
        
        if let marketOp = marketOp {
            opsToBePerformed.append(marketOp)
        }
        
        if !gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return false
        }
        
        for op in opsToBePerformed {
            if !gameState.perform(operation: op) {
                return false
            }
        }
        
        if let cmpBaseIdx = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies) {
            self.gameState.lastCompPayoutValues[cmpBaseIdx] = withholdAmount
        }

        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
            self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
            return nil
        }
        
        return true
        
    }

}

extension Company1846OperateViewController: UICollectionViewDataSource {
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

extension Company1846OperateViewController: UICollectionViewDelegate {
    
}

extension Company1846OperateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols = 4.0
        let rows = 1.0
        
        if self.shareholdersGlobalIndexesCollectionView.count <= 4 {
            return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
        } else {
            
            let width = floor((collectionView.bounds.size.width - 70.0) / 4.0)
            
            return CGSize(width: Int(width), height: collectionView.getHeightForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false))
        }
        
    }
}

