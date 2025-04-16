//
//  CompanyBuyOwnSharesViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 15/03/23.
//

import UIKit

class Company1856CGRFloatCompanyViewController: UIViewController, Operable {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    @IBOutlet weak var contentViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var stackBackgroundView: UIView!
    @IBOutlet weak var outerStackView: UIStackView!
    
    var debtorCompanyBaseIndexes: [Int] = []
    var presidentBaseIndexes: [Int] = []
    var hasUserConfirmedIrreversibleOperations: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        self.stackBackgroundView.backgroundColor = UIColor.secondaryAccentColor
        
        self.mainScrollView.backgroundColor = UIColor.secondaryAccentColor
        
        if let loansAmounts = self.gameState.loans {
            
            self.presidentBaseIndexes = [-1] + Array<Int>(0..<self.gameState.playersSize)
            
            for cmpBaseIdx in 0..<self.gameState.companiesSize {
                let cmpIdx = self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                if loansAmounts[cmpIdx] > 0 {
                    self.debtorCompanyBaseIndexes.append(cmpBaseIdx)
                }
            }
            
            if self.debtorCompanyBaseIndexes.isEmpty {
                self.outerStackView.isHidden = true
                
                self.contentViewHeightLayoutConstraint.constant = 100.0
                
                let disclaimerLabel = UILabel()
                disclaimerLabel.text = "There is no company in debt,\nso CGR will not be formed"
                disclaimerLabel.textAlignment = .center
                disclaimerLabel.numberOfLines = 0
                disclaimerLabel.font = .systemFont(ofSize: 20.0)
                disclaimerLabel.textColor = .black
                
                self.view.addSubview(disclaimerLabel)
                disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
                
                disclaimerLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
                disclaimerLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
                disclaimerLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
                disclaimerLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
                
            } else {
                self.outerStackView.isHidden = false
                
                self.contentViewHeightLayoutConstraint.constant = (CGFloat(self.debtorCompanyBaseIndexes.count) * 70.0) + 20.0
                
                for (i, stackView) in self.outerStackView.arrangedSubviews.enumerated() {
                    let cmpBaseIdx = i
                    let cmpIdx = self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                    
                    if self.debtorCompanyBaseIndexes.contains(i) {
                        stackView.isHidden = false
                        
                        let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtIndex: cmpIdx) ?? -1
                        
                        if let stackView = stackView as? UIStackView {
                            if let cmpLabel = stackView.arrangedSubviews.first(where: { $0 is UILabel }) as? UILabel {
                                cmpLabel.text = "\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atBaseIndex: cmpBaseIdx))) (\(loansAmounts[cmpIdx]) loans)"
                                cmpLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
                            }
                            
                            if let presidentPopupButton = stackView.arrangedSubviews.first(where: { $0 is UIButton }) as? UIButton {
                                
                                var presidentActions: [UIAction] = []
                                if Int(self.gameState.getCompanyAmount(atIndex: cmpIdx)) >= (loansAmounts[cmpIdx] * 100) {
                                    presidentActions.append(UIAction(title: "no help", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: {_ in }))
                                } else {
                                    for (i, presidentBaseIdx) in self.presidentBaseIndexes.enumerated() {
                                        let presidentIdx = self.gameState.forceConvert(index: presidentBaseIdx, backwards: false, withIndexType: .players)
                                        
                                        if presidentPlayerIdx != -1 {
                                            if i == 0 {
                                                presidentActions.append(UIAction(title: "no help", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), handler: { action in
                                                    presidentPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                                                }))
                                            } else {
                                                presidentActions.append(UIAction(title: self.gameState.getPlayerLabel(atBaseIndex: presidentBaseIdx), image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: presidentIdx == presidentPlayerIdx ? .on : .off, handler: { action in
                                                    presidentPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                                                }))
                                            }
                                        } else {
                                            if i == 0 {
                                                presidentActions.append(UIAction(title: "no help", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                                                    presidentPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                                                }))
                                            } else {
                                                presidentActions.append(UIAction(title: self.gameState.getPlayerLabel(atBaseIndex: presidentBaseIdx), image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), handler: { action in
                                                    presidentPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                                                }))
                                            }
                                        }
                                    }
                                }
                                
                                if presidentActions.isEmpty {
                                    presidentPopupButton.isHidden = true
                                } else {
                                    presidentPopupButton.isHidden = false
                                    if presidentActions.count == 1 {
                                        presidentPopupButton.setBackgroundColor(UIColor.systemGray2)
                                        presidentPopupButton.setPopupTitle(withText: presidentActions.first?.title ?? "", textColor: UIColor.white)
                                    } else {
                                        presidentPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                                        presidentPopupButton.setPopupTitle(withText: presidentPlayerIdx != -1 ? (self.gameState.getPlayerLabel(atIndex: presidentPlayerIdx)) : "no help", textColor: UIColor.white)
                                    }
                                    
                                    presidentPopupButton.menu = UIMenu(children: presidentActions)
                                    presidentPopupButton.showsMenuAsPrimaryAction = true
                                    presidentPopupButton.changesSelectionAsPrimaryAction = true
                                }
                            }
                        }
                        
                    } else {
                        stackView.isHidden = true
                    }
                }
                
            }
        }
        
    }
    
    func performCGRFormation(opsToBePerformed: [Operation], absorbedCmpBaseIndexes: [Int]) {
            
        for op in opsToBePerformed {
            _ = self.gameState.perform(operation: op)
        }
        
        var exchangeShareOps: [Operation] = []
        
        var playersExchangeSharesAmount: [Double] = Array(repeating: 0.0, count: self.gameState.playersSize)
        var bankExchangeSharesAmount: Double = 0.0
        let bankPortfolio = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)
        
        for cmpBaseIdx in absorbedCmpBaseIndexes {
            for shareholderGlobalIdx in self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIdx) {
                if self.gameState.getPlayerIndexes().contains(shareholderGlobalIdx) {
                    playersExchangeSharesAmount[self.gameState.forceConvert(index: shareholderGlobalIdx, backwards: true, withIndexType: .players)] += self.gameState.getSharesPortfolioForPlayer(atIndex: shareholderGlobalIdx)[cmpBaseIdx]
                }
            }
            
            bankExchangeSharesAmount += bankPortfolio[cmpBaseIdx]
        }
        
        let playersTotalExchangeShares = playersExchangeSharesAmount.reduce(0, +)
        if playersTotalExchangeShares + bankExchangeSharesAmount > 20 {
            self.gameState.compTotShares[self.gameState.getBaseIndex(forEntity: "CGR")] = 20
            self.gameState.shares[BankIndex.ipo.rawValue][self.gameState.getBaseIndex(forEntity: "CGR")] += 10
        }
        
        var CGRAvailableSharesCount: Int = Int(self.gameState.compTotShares[self.gameState.getBaseIndex(forEntity: "CGR")])
        
        for (playerBaseIdx, playerExchangeSharesAmount) in playersExchangeSharesAmount.enumerated() where CGRAvailableSharesCount > 0 {
            if Int(playerExchangeSharesAmount) % 2 != 0 { bankExchangeSharesAmount += 1 }
            
            if playerExchangeSharesAmount < 2 { continue }
            
            let playerIdx = self.gameState.forceConvert(index: playerBaseIdx, backwards: false, withIndexType: .players)
            var shareAmount = Double(Int(playerExchangeSharesAmount) / 2)
            
            if shareAmount > Double(CGRAvailableSharesCount) {
                shareAmount = Double(CGRAvailableSharesCount)
            }
            
            let exchangeOp = Operation(type: .float, uid: nil)
            exchangeOp.setOperationColorGlobalIndex(colorGlobalIndex: self.gameState.getGlobalIndex(forEntity: "CGR"))
            exchangeOp.setAccessoryTagTitle(accessoryTagTitle: self.gameState.getCompanyLabel(atIndex: self.gameState.getGlobalIndex(forEntity: "CGR")))
            exchangeOp.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: playerIdx, shareAmount: shareAmount, shareCompanyBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"))
            
            exchangeShareOps.append(exchangeOp)
            
            CGRAvailableSharesCount -= Int(shareAmount)
        }
        
        if CGRAvailableSharesCount > 0 {
            let shareAmount: Double = min(Double(Int(bankExchangeSharesAmount) / 2), Double(CGRAvailableSharesCount))
            
            if shareAmount > 0 {
                let bankExchangeOp = Operation(type: .float, uid: nil)
                bankExchangeOp.setOperationColorGlobalIndex(colorGlobalIndex: self.gameState.getGlobalIndex(forEntity: "CGR"))
                bankExchangeOp.setAccessoryTagTitle(accessoryTagTitle: self.gameState.getCompanyLabel(atIndex: self.gameState.getGlobalIndex(forEntity: "CGR")))
                bankExchangeOp.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: BankIndex.bank.rawValue, shareAmount: shareAmount, shareCompanyBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"))
                
                exchangeShareOps.append(bankExchangeOp)
            }
        }
        
        for exchangeOp in exchangeShareOps {
            _ = self.gameState.perform(operation: exchangeOp)
        }
        
        var CGRfloatAmout = 0.0
        for absorbedCmpBaseIdx in absorbedCmpBaseIndexes {
            CGRfloatAmout += self.gameState.getCompanyAmount(atBaseIndex: absorbedCmpBaseIdx)
        }
        
        let floatOp = Operation(type: .float, uid: nil)
        floatOp.setOperationColorGlobalIndex(colorGlobalIndex: self.gameState.getGlobalIndex(forEntity: "CGR"))
        floatOp.setAccessoryTagTitle(accessoryTagTitle: self.gameState.getCompanyLabel(atIndex: self.gameState.getGlobalIndex(forEntity: "CGR")))
        floatOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.gameState.getGlobalIndex(forEntity: "CGR"), amount: CGRfloatAmout)
        
        _ = self.gameState.perform(operation: floatOp)
        
        if let hundredShareIndexPath = self.gameState.getPARindex(fromShareValue: 100) {
            
            let PARop = Operation(type: .market)
            
            switch absorbedCmpBaseIndexes.count {
            case 1:
            
                if let shareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: absorbedCmpBaseIndexes[0]), shareValue < 100 {
                    PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: hundredShareIndexPath, marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 100, shouldTruncateDouble: true))")
                    
                } else {
                    let PARvalue = self.gameState.getShareValue(forCompanyAtBaseIndex: absorbedCmpBaseIndexes[0]) ?? 0.0
                    PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: self.gameState.getShareValueIndex(forCompanyAtBaseIndex: absorbedCmpBaseIndexes[0]), marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: PARvalue, shouldTruncateDouble: true))")
                    
                    self.gameState.setPARvalue(value: Int(PARvalue), forCompanyAtBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"))
                }
                
            case 2:
            
                let firstCmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: absorbedCmpBaseIndexes[0]) ?? 0.0
                let secondCmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: absorbedCmpBaseIndexes[1]) ?? 0.0
                let avgShareValue = (firstCmpShareValue + secondCmpShareValue) / 2.0
                
                if avgShareValue < 100 {
                    PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: hundredShareIndexPath, marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 100, shouldTruncateDouble: true))")
                } else {
                    let distanceToNearestFive = Int(avgShareValue) % 5
                    var nearestFiveShareValue = 0
                    if distanceToNearestFive < 3 {
                        nearestFiveShareValue = ((Int(avgShareValue) / 5) * 5)
                    } else {
                        nearestFiveShareValue = ((Int(avgShareValue) / 5) * 5) + 5
                    }
                    
                    let shareValueMatrix = self.gameState.getShareValueMatrix()
                    
                    for i in 5..<shareValueMatrix.count {
                        if let currentShareValue = shareValueMatrix[i][0] {
                            if currentShareValue > Double(nearestFiveShareValue) {
                                if let nextShareValue = shareValueMatrix[i][0], let prevShareValue = shareValueMatrix[i-1][0] {
                                    
                                    if nextShareValue - Double(nearestFiveShareValue) <= Double(nearestFiveShareValue) - prevShareValue {
                                        let shareValue = self.gameState.getShareValue(atIndexPath: ShareValueIndexPath(x: i, y: 0))
                                        
                                        PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: i, y: 0), marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: shareValue ?? 0.0, shouldTruncateDouble: true))")
                                        
                                        self.gameState.setPARvalue(value: shareValue.map(Int.init), forCompanyAtBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"))
                                    } else {
                                        let shareValue = self.gameState.getShareValue(atIndexPath: ShareValueIndexPath(x: i - 1, y: 0))
                                        
                                        PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: i - 1, y: 0), marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: shareValue ?? 0.0, shouldTruncateDouble: true))")
                                        
                                        self.gameState.setPARvalue(value: shareValue.map(Int.init), forCompanyAtBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"))
                                    }
                                    
                                    break
                                }
                            }
                        }
                    }
                }
            default:
                var minShareValue = 1000.0
                var totalShareValueSum = 0.0
                
                for absorbedCmpBaseIndex in absorbedCmpBaseIndexes {
                    let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: absorbedCmpBaseIndex) ?? 0.0
                    
                    totalShareValueSum += cmpShareValue
                    if cmpShareValue < minShareValue {
                        minShareValue = cmpShareValue
                    }
                }
                
                totalShareValueSum -= minShareValue
                
                let avgShareValue = totalShareValueSum / Double(absorbedCmpBaseIndexes.count - 1)
                
                if avgShareValue < 100 {
                    PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: hundredShareIndexPath, marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 100, shouldTruncateDouble: true))")
                } else {
                    let distanceToNearestFive = Int(avgShareValue) % 5
                    var nearestFiveShareValue = 0
                    if distanceToNearestFive < 3 {
                        nearestFiveShareValue = ((Int(avgShareValue) / 5) * 5)
                    } else {
                        nearestFiveShareValue = ((Int(avgShareValue) / 5) * 5) + 5
                    }
                    
                    let shareValueMatrix = self.gameState.getShareValueMatrix()
                    
                    for i in 5..<shareValueMatrix.count {
                        if let currentShareValue = shareValueMatrix[i][0] {
                            if currentShareValue > Double(nearestFiveShareValue) {
                                if let nextShareValue = shareValueMatrix[i][0], let prevShareValue = shareValueMatrix[i-1][0] {
                                    if nextShareValue - Double(nearestFiveShareValue) <= Double(nearestFiveShareValue) - prevShareValue {
                                        let shareValue = self.gameState.getShareValue(atIndexPath: ShareValueIndexPath(x: i, y: 0))
                                        
                                        PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: i, y: 0), marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: shareValue ?? 0.0, shouldTruncateDouble: true))")
                                        
                                        self.gameState.setPARvalue(value: shareValue.map(Int.init), forCompanyAtBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"))
                                    } else {
                                        let shareValue = self.gameState.getShareValue(atIndexPath: ShareValueIndexPath(x: i - 1, y: 0))
                                        
                                        PARop.addMarketDetails(marketShareValueCmpBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"), marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: i - 1, y: 0), marketLogStr: "CGR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: shareValue ?? 0.0, shouldTruncateDouble: true))")
                                        
                                        self.gameState.setPARvalue(value: shareValue.map(Int.init), forCompanyAtBaseIndex: self.gameState.getBaseIndex(forEntity: "CGR"))
                                    }
                                    
                                    break
                                }
                            }
                        }
                    }
                }
            }
            
            if self.gameState.isOperationLegit(operation: PARop, reverted: false) {
                _ = self.gameState.perform(operation: PARop, reverted: false)
            }
        }
        
        for absorbedCmpBaseIndex in absorbedCmpBaseIndexes {
            self.gameState.closeCompany(atBaseIndex: absorbedCmpBaseIndex)
        }
        
        let certificateLimits = [[28, 22, 18, 15],
                                 [25, 20, 16, 14],
                                 [22, 18, 15, 12],
                                 [20, 16, 13, 11],
                                 [18, 14, 11, 10],
                                 [15, 12, 10, 8],
                                 [13, 10, 8, 7],
                                 [10, 8, 7, 6]]
        
        if absorbedCmpBaseIndexes.count < 8 {
            self.gameState.certificateLimit = Double(certificateLimits[absorbedCmpBaseIndexes.count][self.gameState.playersSize - 3])
        } else {
            self.gameState.certificateLimit = Double(certificateLimits[7][self.gameState.playersSize - 2])
        }
        
        self.dismiss(animated: true)
    }

    func commitButtonPressed() -> Bool? {
        if self.hasUserConfirmedIrreversibleOperations { return true }
        
        var opsToBePerformed: [Operation] = []
        
        var absorbedCmpBaseIndexes: [Int] = []
        var illegalPlayers: Set<String> = []
        
        if let loansAmounts = self.gameState.loans {
            
            var playerAmounts = self.gameState.getPlayerIndexes().map { self.gameState.getPlayerAmount(atIndex: $0) }
            
            for (i, stackView) in self.outerStackView.arrangedSubviews.enumerated() {
                if let stackView = stackView as? UIStackView, stackView.isHidden == false {
                    let cmpIdx = self.gameState.forceConvert(index: i, backwards: false, withIndexType: .companies)
                    let cmpBaseIdx = i
                    
                    let amountToPay = Double(loansAmounts[cmpIdx] * 100)
                    
                    let redeemOpUid = Operation.generateUid()
                    
                    if self.gameState.getCompanyAmount(atBaseIndex: i) >= amountToPay {
                        let cmpOp = Operation(type: .loan, uid: redeemOpUid)
                        cmpOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
                        cmpOp.addCashDetails(sourceIndex: cmpIdx, destinationIndex: BankIndex.bank.rawValue, amount: amountToPay)
                        cmpOp.addLoanDetails(loansSourceGlobalIndex: cmpIdx, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: loansAmounts[cmpIdx])
                        
                        opsToBePerformed.append(cmpOp)
                    } else {
                        if let cmpPopupButton = stackView.arrangedSubviews.first(where: { $0 is UIButton }) as? UIButton, cmpPopupButton.currentTitle! != "no help" {
                            let cmpAmount = Double((Int(self.gameState.getCompanyAmount(atBaseIndex: cmpBaseIdx)) / 100) * 100)
                            let presAmount = amountToPay - cmpAmount
                            
                            let presIdx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: cmpPopupButton.currentTitle!)
                            let presBaseIdx = self.gameState.forceConvert(index: presIdx, backwards: true, withIndexType: .players)
                            
                            if playerAmounts[presBaseIdx] >= presAmount {
                                
                                if cmpAmount > 0 {
                                    let cmpOp = Operation(type: .loan, uid: redeemOpUid)
                                    cmpOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
                                    cmpOp.addCashDetails(sourceIndex: cmpIdx, destinationIndex: BankIndex.bank.rawValue, amount: cmpAmount)
                                    
                                    opsToBePerformed.append(cmpOp)
                                }
                                    
                                let presOp = Operation(type: .loan, uid: redeemOpUid)
                                presOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
                                presOp.addCashDetails(sourceIndex: presIdx, destinationIndex: BankIndex.bank.rawValue, amount: presAmount)
                                presOp.addLoanDetails(loansSourceGlobalIndex: cmpIdx, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: loansAmounts[cmpIdx])
                                
                                opsToBePerformed.append(presOp)
                                
                                playerAmounts[presBaseIdx] -= presAmount
                                
                            } else {
                                illegalPlayers.insert(self.gameState.getPlayerLabel(atIndex: presIdx))
                            }
                            
                        } else {
                            // no help, not enough money
                            absorbedCmpBaseIndexes.append(cmpBaseIdx)
                        }
                    }
                }
            }
        }
        
        if !illegalPlayers.isEmpty {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "\(illegalPlayers.joined(separator: ", ")) cannot afford to help. Please correct the data and try again.")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return nil
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return false
        }
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "ATTENTION", andMessage: "The operation cannot be undo. Do you want to proceed anyway?")
        alert.addCancelAction(withLabel: "Cancel")
        alert.addConfirmAction(withLabel: "OK") {
            self.performCGRFormation(opsToBePerformed: opsToBePerformed, absorbedCmpBaseIndexes: absorbedCmpBaseIndexes)
            
            self.hasUserConfirmedIrreversibleOperations = true
            
            self.parentVC.doneButtonPressed(sender: UIButton())
        }
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
        return nil
        
    }


}
