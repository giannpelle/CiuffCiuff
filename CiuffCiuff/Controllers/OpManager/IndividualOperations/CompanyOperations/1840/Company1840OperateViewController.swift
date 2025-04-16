//
//  OperationViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 03/01/23.
//

import UIKit

class Company1840OperateViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
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
    
    var shareholderCountLabelAttributedTexts: [NSMutableAttributedString] = []
    var profitPreviewLabelTexts: [String] = []
    var totalPreviewLabelTexts: [String] = []
    
    var playerIndexes: [Int] = []
    var totalRevenue: Int = 0
    var payoutAmount: Int = 0
    var withholdAmount: Int = 0
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var totalRevenueLabel: UILabel!
    @IBOutlet weak var operationSlider: UISlider!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var payoutSplitStackView: UIStackView!
    @IBOutlet weak var payoutAmountLabel: UILabel!
    @IBOutlet weak var withholdAmountLabel: UILabel!
    
    @IBOutlet var modifierButtons: [UIButton]!
    
    @IBOutlet weak var payouSchemaBackgroundView: UIView!
    @IBOutlet weak var payoutSchemaStackView: UIStackView!
    @IBOutlet weak var emergencyStackView: UIStackView!
    @IBOutlet weak var emergencyPopupButton: UIButton!
    
    @IBOutlet weak var shareholdersCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.payouSchemaBackgroundView.layer.cornerRadius = 8
        self.payouSchemaBackgroundView.layer.borderWidth = 3
        self.payouSchemaBackgroundView.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.payouSchemaBackgroundView.clipsToBounds = true
        
        self.payoutSplitStackView.layer.borderWidth = 3
        self.payoutSplitStackView.layer.borderColor = UIColor.primaryAccentColor.cgColor
        
        for btn in self.modifierButtons {
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 8
            
            if let title = btn.currentTitle {
                if title.contains("-") {
                    btn.setBackgroundColor(UIColor.redAccentColor)
                } else if title.contains("+") {
                    btn.setBackgroundColor(UIColor.primaryAccentColor)
                }
            }
        }
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        let shareholdersGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: self.operatingCompanyBaseIndex)
        self.shareholdersGlobalIndexesCollectionView = shareholdersGlobalIndexes.filter { !self.gameState.getBankEntityIndexes().contains($0) && $0 != self.operatingCompanyIndex }
        
        self.shareholdersGlobalIndexesCollectionView.insert(self.operatingCompanyIndex, at: 0)
        
        if let totalRevenue = self.gameState.g1840LinesRevenue?.enumerated().filter({ self.gameState.g1840LinesOwnerGlobalIndexes?[$0.0] == self.operatingCompanyIndex }).map({ $0.1 }).flatMap({ $0 }).reduce(0, +), totalRevenue == 0 {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
            return
        }
        
        self.parentVC.emptyLabel.isHidden = true
        self.view.isHidden = false
        
        self.shareholderLabelsCollectionView = self.shareholdersGlobalIndexesCollectionView.map { self.gameState.labels[$0] }
        self.shareholdersColorsCollectionView = self.shareholdersGlobalIndexesCollectionView.map { self.gameState.colors[$0].uiColor }
        
        self.updateTotalLineRevueTextField()
        
        self.operationSlider.minimumValue = 0.0
        self.operationSlider.maximumValue = 1.0
        self.operationSlider.tintColor = UIColor.primaryAccentColor
        self.operationSlider.thumbTintColor = UIColor.primaryAccentColor
        
        let leftModifiers = ["-50", "-30", "-10"]
        for (i, view) in self.leftStackView.arrangedSubviews.enumerated() {
            if let btn = view as? UIButton {
                btn.setTitle(withText: leftModifiers[i], fontSize: 19.0, fontWeight: .semibold, textColor: .white)
            }
        }
        
        let rightModifiers = ["+10", "+30", "+50"]
        for (i, view) in self.rightStackView.arrangedSubviews.enumerated() {
            if let btn = view as? UIButton {
                btn.setTitle(withText: rightModifiers[i], fontSize: 19.0, fontWeight: .semibold, textColor: .white)
            }
        }
        
        self.shareholdersCollectionView.delegate = self
        self.shareholdersCollectionView.dataSource = self
        self.shareholdersCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0)
        self.shareholdersCollectionView.backgroundColor = UIColor.secondaryAccentColor
        
        self.playerIndexes = Array<Int>(self.gameState.getPlayerIndexes())
        self.setupPopupButtons()
        
    }
    
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
    
    func updateTotalLineRevueTextField() {
        let totalLinesRevenue = self.gameState.g1840LinesRevenue?.enumerated().filter({ self.gameState.g1840LinesOwnerGlobalIndexes?[$0.0] == self.operatingCompanyIndex }).map({ $0.1 }).flatMap({ $0 }).reduce(0, +) ?? 0
        
        if totalLinesRevenue == 0 {
            self.totalRevenueLabel.text = "Total revenue: 0 $"
        } else {
            self.totalRevenueLabel.text = "Total revenue: \(totalLinesRevenue)"
        }
        self.totalRevenue = totalLinesRevenue
        
        if totalLinesRevenue > 0 {
            self.operationSlider.isEnabled = true
            self.payoutAmountLabel.isEnabled = true
            self.withholdAmountLabel.isEnabled = true
            self.leftStackView.isHidden = false
            self.rightStackView.isHidden = false
            self.shareholdersCollectionView.isHidden = false
            
            self.operationSlider.value = 1.0
            self.payoutAmount = totalLinesRevenue
            self.payoutAmountLabel.text = "Payout: \(totalLinesRevenue)"
            self.withholdAmount = 0
            self.withholdAmountLabel.text = "Withhold: 0"
            
        } else {
            self.operationSlider.isEnabled = false
            self.payoutAmountLabel.isEnabled = false
            self.withholdAmountLabel.isEnabled = false
            self.leftStackView.isHidden = true
            self.rightStackView.isHidden = true
            self.shareholdersCollectionView.isHidden = true
            
            self.operationSlider.value = 0.5
            self.payoutAmount = 0
            self.payoutAmountLabel.text = "Payout: 0"
            self.withholdAmount = 0
            self.withholdAmountLabel.text = "Withhold: 0"
        }
        
        if totalLinesRevenue >= 0 {
            self.payoutSchemaStackView.isHidden = false
            self.payouSchemaBackgroundView.isHidden = false
            self.emergencyStackView.isHidden = true
        } else {
            self.payoutSchemaStackView.isHidden = true
            self.payouSchemaBackgroundView.isHidden = true
            self.emergencyStackView.isHidden = false
        }
        
        self.updatePayoutPreviewDisplayData()
        self.shareholdersCollectionView.reloadData()
    }
    
    func updatePayoutPreviewDisplayData() {
        
        self.shareholderCountLabelAttributedTexts.removeAll()
        self.profitPreviewLabelTexts.removeAll()
        self.totalPreviewLabelTexts.removeAll()
        
        for currentShareholderGlobalIndex in self.shareholdersGlobalIndexesCollectionView {
            
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
                }
                
                let attributedText = NSMutableAttributedString()
                
                let littleLineSpacingParagraphStyle = NSMutableParagraphStyle()
                littleLineSpacingParagraphStyle.lineSpacing = 5.0
                littleLineSpacingParagraphStyle.alignment = .center
                
                attributedText.append(NSAttributedString(string: sharesStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21.0, weight: .medium)]))
                attributedText.addAttribute(.paragraphStyle, value: littleLineSpacingParagraphStyle, range: NSRange(location: 0, length: attributedText.length))
                
                self.shareholderCountLabelAttributedTexts.append(attributedText)
                
            } else {
                let sharesAmount = self.gameState.shares[currentShareholderGlobalIndex][self.operatingCompanyBaseIndex]
                self.shareholderCountLabelAttributedTexts.append(NSMutableAttributedString(string: (sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) + " shares", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21.0, weight: .medium)]))
                
                currentShareholderSharesAmount += sharesAmount
            }
            
            var profitAmount = 0.0
            
            if self.payoutAmount > 0 {
                
                var unitShareValue = Double(self.payoutAmount) / Double(self.gameState.getTotalShareNumberOfCompany(atIndex: self.operatingCompanyIndex))
                
                switch self.gameState.unitShareValuePayoutRoundPolicy {
                case .doNotRound:
                    break
                case .roundUp:
                    unitShareValue = ceil(unitShareValue)
                case .roundDown:
                    unitShareValue = floor(unitShareValue)
                }
                
                if self.gameState.isPayoutRoundedUpOnTotalValue {
                    profitAmount += ceil(unitShareValue * currentShareholderSharesAmount)
                } else {
                    profitAmount += floor(unitShareValue * currentShareholderSharesAmount)
                }
            }
            
            if currentShareholderGlobalIndex == self.operatingCompanyIndex {
                profitAmount += Double(self.withholdAmount)
            }
            
            if profitAmount > 0 {
                self.profitPreviewLabelTexts.append("Profit: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: profitAmount))
            } else {
                self.profitPreviewLabelTexts.append("no payout")
            }
            
            self.totalPreviewLabelTexts.append("Total: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.amounts[currentShareholderGlobalIndex] + profitAmount))
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let sliderValue = sender.value * Float(self.totalRevenue)
        let nearestTen = 10 * Int((sliderValue / 10.0).rounded())
        
        self.payoutAmount = nearestTen
        self.payoutAmountLabel.text = "Payout: \(self.payoutAmount)"
        self.withholdAmount = self.totalRevenue - nearestTen
        self.withholdAmountLabel.text = "Withhold: \(self.withholdAmount)"
        
        self.updatePayoutPreviewDisplayData()
        self.shareholdersCollectionView.reloadData()
    }
    
    @IBAction func adjustSliderValueButtonPressed(sender: UIButton) {
        
        if let amountStr = sender.titleLabel?.text, !amountStr.isEmpty {
            if amountStr.first! == "+" {
                if let amount = Int(amountStr.split(separator: "+").last!) {
                    if self.payoutAmount + amount > self.totalRevenue {
                        self.payoutAmount = self.totalRevenue
                        self.withholdAmount = 0
                    } else {
                        self.payoutAmount += amount
                        self.withholdAmount -= amount
                    }
                    
                    self.payoutAmountLabel.text = "Payout: \(self.payoutAmount)"
                    self.withholdAmountLabel.text = "Withhold: \(self.withholdAmount)"
                }
            } else if amountStr.first! == "-" {
                if let amount = Int(amountStr.split(separator: "-").last!) {
                    if self.payoutAmount - amount < 0 {
                        self.payoutAmount = 0
                        self.withholdAmount = self.totalRevenue
                    } else {
                        self.payoutAmount -= amount
                        self.withholdAmount += amount
                    }
                    
                    self.payoutAmountLabel.text = "Payout: \(self.payoutAmount)"
                    self.withholdAmountLabel.text = "Withhold: \(self.withholdAmount)"
                }
            }
            
            let newSliderValue = Float(self.payoutAmount) / Float(self.totalRevenue)
            self.operationSlider.value = newSliderValue

            self.updatePayoutPreviewDisplayData()
            self.shareholdersCollectionView.reloadData()
        }
    }
    
    func commitButtonPressed() -> Bool? {
        
        //handle emergency money
        if self.totalRevenue < 0 {
            
            let shortfallToPay = Double(-self.totalRevenue)
            
            let companyMoneyAmount = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)
            
            var opsToBePerformed: [Operation] = []
            
            if companyMoneyAmount >= shortfallToPay {
                
                let shortfallOp = Operation(type: .g1840Shortfall, uid: nil)
                shortfallOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                shortfallOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: shortfallToPay)
                
                opsToBePerformed.append(shortfallOp)
                
            } else {
                
                let remainingShortfall = shortfallToPay - companyMoneyAmount
                let shortfallOpUid = Operation.generateUid()
                
                let compShortfallOp = Operation(type: .g1840Shortfall, uid: shortfallOpUid)
                compShortfallOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                compShortfallOp.addCashDetails(sourceIndex: self.operatingCompanyIndex, destinationIndex: BankIndex.bank.rawValue, amount: companyMoneyAmount)
                
                opsToBePerformed.append(compShortfallOp)
                
                let emergencyPlayerIdx = self.gameState.getPlayerIndexFromPopupButtonTitle(title: self.emergencyPopupButton.currentTitle!)
                
                let playerShortfallOp = Operation(type: .g1840Shortfall, uid: shortfallOpUid)
                playerShortfallOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                playerShortfallOp.addCashDetails(sourceIndex: emergencyPlayerIdx, destinationIndex: BankIndex.bank.rawValue, amount: remainingShortfall)
                
                opsToBePerformed.append(playerShortfallOp)
            }
            
            if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: [.left]) {
                opsToBePerformed.append(marketOp)
            }
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                return false
            }
            
            for op in opsToBePerformed {
                if !self.gameState.perform(operation: op) {
                    return false
                }
            }
            
            if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
                self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
                return nil
            }
            
            return true
        }
        
        let payoutAmount = self.payoutAmount
        let withholdAmount = self.withholdAmount
        var opsToBePerformed: [Operation] = []
        let payoutOpUid = Operation.generateUid()
        
        if withholdAmount > 0 {
            opsToBePerformed += CompanyOperateViewController.generateWithholdOperations(withAmount: withholdAmount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: false, withOperationUid: payoutOpUid, isBasicStandardPayoutWiththold: false)
        }
        
        if payoutAmount > 0 {
            opsToBePerformed += CompanyOperateViewController.generatePayoutOperations(withAmount: payoutAmount, forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andGameState: self.gameState, shouldIncludeMarketOps: false, withOperationUid: payoutOpUid, isBasicStandardPayoutWiththold: false)
        }
        
        var marketOp: Operation? = nil
        
        if payoutAmount <= 0 {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: [.left], withUid: payoutOpUid)
        } else if payoutAmount <= 90 {
            marketOp = nil
        } else if payoutAmount <= 190 {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: [.right], withUid: payoutOpUid)
        } else if payoutAmount <= 390 {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 2), withUid: payoutOpUid)
        } else if payoutAmount <= 590 {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 3), withUid: payoutOpUid)
        } else if payoutAmount <= 990 {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 4), withUid: payoutOpUid)
        } else if payoutAmount <= 1490 {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 5), withUid: payoutOpUid)
        } else if payoutAmount <= 2490 {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 6), withUid: payoutOpUid)
        } else {
            marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .right, count: 7), withUid: payoutOpUid)
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
        
        if let totalRevenue = self.gameState.g1840LinesRevenue?.enumerated().filter({ self.gameState.g1840LinesOwnerGlobalIndexes?[$0.0] == self.operatingCompanyIndex }).map({ $0.1 }).flatMap({ $0 }).reduce(0, +), totalRevenue != 0 {
            self.gameState.g1840LastCompanyRevenues?[self.operatingCompanyBaseIndex] = totalRevenue
        }
        
        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
            self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
            return nil
        }
        
        return true
    }
}

extension Company1840OperateViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.totalRevenue <= 0 {
            return 0
        }
        return self.shareholdersGlobalIndexesCollectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentShareholderGlobalIndex = self.shareholdersGlobalIndexesCollectionView[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareholder1840Cell", for: indexPath) as! Shareholder1840CollectionViewCell
        
        cell.shareholderLabel.text = self.shareholderLabelsCollectionView[indexPath.row]
        cell.shareholderLabel.textColor = self.gameState.textColors[currentShareholderGlobalIndex].uiColor
        cell.shareholderLabel.backgroundColor = self.shareholdersColorsCollectionView[indexPath.row]
        
        cell.accessoryBackgroundView.layer.borderColor = self.shareholdersColorsCollectionView[indexPath.row].cgColor
        cell.accessoryBackgroundView.layer.borderWidth = 3.0
        
        cell.shareholderCountLabel.attributedText = self.shareholderCountLabelAttributedTexts[indexPath.row]
        cell.profitPreviewLabel.text = self.profitPreviewLabelTexts[indexPath.row]
        cell.totalPreviewLabel.text = self.totalPreviewLabelTexts[indexPath.row]
        
        return cell
    }
}

extension Company1840OperateViewController: UICollectionViewDelegate {
    
}

extension Company1840OperateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols = 5.0
        let rows = 1.0
        
        if self.shareholdersGlobalIndexesCollectionView.count <= 5 {
            return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true, horizontalInsetReduction: 28.0)
        } else {
            
            let width = floor((collectionView.bounds.size.width - 40.0) / 5.0)
            
            return CGSize(width: Int(width), height: collectionView.getHeightForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true))
        }
        
    }
}

