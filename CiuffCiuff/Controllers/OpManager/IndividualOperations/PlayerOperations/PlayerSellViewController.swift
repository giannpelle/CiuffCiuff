//
//  PlayerSellViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 17/12/24.
//

import UIKit

class PlayerSellViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var shareCompanyIndexes: [Int] = []
    var shareCompanyAmounts: [Double] = []
    var shareCompanySelectedAmounts: [Double] = []
    var shareCompanyValues: [Double] = []
    var maxSellOperations: [Operation?] = Array(repeating: nil, count: 3)
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var sellCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var sellOutStackView: UIStackView!
    @IBOutlet weak var maxSellOpsStackView: UIStackView!
    @IBOutlet weak var performCustomSellButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.performCustomSellButton.setTitle(withText: "Perform Custom Sell", fontSize: 18.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
        self.performCustomSellButton.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.performCustomSellButton.layer.borderWidth = 3
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        let playerSharesPortfolio = self.gameState.getSharesPortfolioForPlayer(atIndex: self.operatingPlayerIndex)
        
        for cmpBaseIndex in 0..<self.gameState.companiesSize where self.gameState.getCompanyType(atBaseIndex: cmpBaseIndex).areSharesPurchasebleByPlayers() {
            let cmpIndex = self.gameState.forceConvert(index: cmpBaseIndex, backwards: false, withIndexType: .companies)
            
            if playerSharesPortfolio[cmpBaseIndex] > 0 {
                
                if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIndex), cmpShareValue != 0.0 {
                    self.shareCompanyIndexes.append(cmpIndex)
                    self.shareCompanyAmounts.append(playerSharesPortfolio[cmpBaseIndex])
                    self.shareCompanySelectedAmounts.append(self.gameState.predefinedShareAmounts[0])
                    self.shareCompanyValues.append(cmpShareValue)
                }
            }
        }
        
        if self.shareCompanyIndexes.isEmpty {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
            return
        } else {
            self.parentVC.emptyLabel.isHidden = true
            self.view.isHidden = false
        }
        
        self.sellCollectionView.dataSource = self
        self.sellCollectionView.delegate = self
        self.sellCollectionView.backgroundColor = UIColor.secondaryAccentColor
        
        var rows = 0.0
        var cols = 0.0
        
        if [5, 6].contains(self.shareCompanyIndexes.count) {
            rows = 2
            cols = 3
        } else {
            cols = min(4.0, Double(self.shareCompanyIndexes.count))
            rows = (Double(self.shareCompanyIndexes.count) / 4.0).rounded(.up)
        }
        
        self.collectionViewHeightLayoutConstraint.constant = (rows * (106.0 + 40.0) - 40.0)
        self.collectionViewWidthLayoutConstraint.constant = (225.0 * cols) - 25.0
        
        let cmpBaseIndexesSorted = self.gameState.shares[self.operatingPlayerIndex].enumerated().filter{ $0.1 > 0 }.sorted { $0.1 > $1.1 }.map { $0.0 }
        
        var counter = 0
        for cmpBaseIdx in cmpBaseIndexesSorted where self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx).areSharesPurchasebleByPlayers() && counter < 3 {
            
            var maxShareAmount = self.gameState.shares[self.operatingPlayerIndex][cmpBaseIdx]
            
            let cmpType = self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx)
            if let shareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx), shareValue != 0 {
                
                if !cmpType.canSellOutEverything() {
                    
                    switch self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx) {
                    case .standard, .g1856CGR:
                        
                        var canSellEverything = false
                        for shareholderIdx in self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIdx).filter({ self.gameState.getPlayerIndexes().contains($0) }) where shareholderIdx != self.operatingPlayerIndex {
                            if self.gameState.shares[shareholderIdx][cmpBaseIdx] >= self.gameState.presidentCertificateShareAmount {
                                canSellEverything = true
                            }
                        }
                        
                        if !canSellEverything {
                            maxShareAmount -= self.gameState.presidentCertificateShareAmount
                        }
                        
                        if self.gameState.game != .g1840 {
                            maxShareAmount = min(maxShareAmount, max(5 - self.gameState.shares[BankIndex.bank.rawValue][cmpBaseIdx], 0))
                        }
                        
                    case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g18MEXMinor:
                        break
                    }
                }
            }
            
            var shareValue = 0.0
            
            if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) {
                shareValue = cmpShareValue
            }
                
            if maxShareAmount <= 0 || shareValue == 0.0 { continue }
                
            var amount = 0.0
            if self.gameState.buySellRoundPolicyOnTotal == .roundUp {
                amount = floor(shareValue * maxShareAmount)
            } else {
                amount = ceil(shareValue * maxShareAmount)
            }
            
            let dstGlobalIndex: Int = self.operatingPlayerIndex
            let srcGlobalIndex: Int = BankIndex.bank.rawValue
            
            let shareDstGlobalIndex: Int = self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx) != .g1848BoE ? BankIndex.bank.rawValue : BankIndex.ipo.rawValue
            let shareSrcGlobalIndex: Int = self.operatingPlayerIndex
            let shareCmpBaseIndex: Int = cmpBaseIdx
            
            let operation = Operation(type: self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex) < 0 ? .sellEmergency : .sell, uid: nil)
            operation.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: amount)
            operation.addSharesDetails(shareSourceIndex: shareSrcGlobalIndex, shareDestinationIndex: shareDstGlobalIndex, shareAmount: maxShareAmount, shareCompanyBaseIndex: shareCmpBaseIndex, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex))
            
            self.maxSellOperations[counter] = operation
            
            counter += 1
        }
        
        if maxSellOperations.compactMap({$0}).count != 0 {
            
            self.sellOutStackView.isHidden = false
            
            for (i, op) in self.maxSellOperations.enumerated() {
                if let op = op {
                    if let maxSellButton = self.maxSellOpsStackView.arrangedSubviews[i] as? UIButton {
                        if let amount = op.amount, let shareAmount = op.shareAmount, let shareCompanyBaseIndex = op.shareCompanyBaseIndex, let shareCmpStr = op.shareCompanyStr {
                            maxSellButton.isHidden = false
                            
                            maxSellButton.setTitle(withText: "SELL \(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) \(shareCmpStr) (\(Int(amount)) -> \(self.gameState.getPlayerLabel(atIndex: self.operatingPlayerIndex)))", fontSize: 19, fontWeight: .medium, textColor: self.gameState.getCompanyTextColor(atBaseIndex: shareCompanyBaseIndex))
                            maxSellButton.setBackgroundColor(self.gameState.getCompanyColor(atBaseIndex: shareCompanyBaseIndex))
                        }
                    }
                } else {
                    self.maxSellOpsStackView.arrangedSubviews[i].isHidden = true
                }
            }
            
        } else {
            self.sellOutStackView.isHidden = true
        }

    }
    
    func updateShareAmount(forCompanyAtIndexPathRow: Int, withAmount: Double) {
        self.shareCompanySelectedAmounts[forCompanyAtIndexPathRow] = withAmount
    }
    
    // max sell operation
    @IBAction func maxSellOpButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        if let maxSellOp = self.maxSellOperations[sender.tag], let cmpBaseIdx = maxSellOp.shareCompanyBaseIndex, let shareAmount = maxSellOp.shareAmount {
            
            opsToBePerformed.append(maxSellOp)
            
            if self.gameState.game == .g1846 {
                if let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: cmpBaseIdx), presidentPlayerIdx == self.operatingPlayerIndex {
                    opsToBePerformed += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: cmpBaseIdx, andSharesAmount: shareAmount, withUid: maxSellOp.uid)
                }
            } else {
                opsToBePerformed += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: cmpBaseIdx, andSharesAmount: shareAmount, withUid: maxSellOp.uid)
            }
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "No operation was performed, correct the data and try again")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.parentVC.present(alert, animated: true)
                
                return
            }
            
            for op in opsToBePerformed {
                if !self.gameState.perform(operation: op) {
                        
                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "No operation was performed, correct the data and try again")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.parentVC.present(alert, animated: true)
                    
                    return
                }
            }
            
            
            if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(cmpBaseIdx) {
                self.closeCompany(atBaseIndex: cmpBaseIdx)
                return
            }
        }
        
        self.parentVC.doneButtonPressed(sender: UIButton())
        
    }
    
    @IBAction func activateCustomSellVC(sender: UIButton) {
        self.parentVC.loadCustomSellVC()
    }
    
    func commitButtonPressed() -> Bool? {
        return true
    }
    
}

extension PlayerSellViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shareCompanyIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerSellCell", for: indexPath) as! PlayerSellCollectionViewCell
        cell.parentVC = self
        cell.gameState = self.gameState
        cell.totSharesAmount = self.shareCompanyAmounts[indexPath.row]
        cell.indexPathRow = indexPath.row
        
        cell.sharesAmountPopupButton.setBackgroundColor(UIColor.clear, isRectangularShape: false)
        cell.sharesAmountPopupButton.layer.borderColor = UIColor.primaryAccentColor.cgColor
        cell.sharesAmountPopupButton.layer.borderWidth = 3.0
        
        cell.sellLabel.text = "\(self.gameState.getCompanyLabel(atIndex: self.shareCompanyIndexes[indexPath.row])): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.shareCompanyValues[indexPath.row]))"
        
        cell.sellLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        cell.sellLabel.textColor = self.gameState.getCompanyTextColor(atIndex: self.shareCompanyIndexes[indexPath.row])
        cell.sellLabel.backgroundColor = self.gameState.getCompanyColor(atIndex: self.shareCompanyIndexes[indexPath.row])
        
        cell.setupPopupButtons()
        cell.addTapGestureRecognizer()
        
        return cell
    }
}

extension PlayerSellViewController: UICollectionViewDelegate {
    
    func sell(forIndexPathRow indexPathRow: Int) {
        
        let srcGlobalIndex: Int = BankIndex.bank.rawValue
        let dstGlobalIndex: Int = self.operatingPlayerIndex
        
        let shareCmpGlobalIndex: Int = self.shareCompanyIndexes[indexPathRow]
        let shareCmpBaseIndex: Int = self.gameState.forceConvert(index: shareCmpGlobalIndex, backwards: true, withIndexType: .companies)
        let shareDstGlobalIndex: Int = self.gameState.getCompanyType(atBaseIndex: shareCmpBaseIndex) != .g1848BoE ? BankIndex.bank.rawValue : BankIndex.ipo.rawValue
        let shareSrcGlobalIndex: Int = self.operatingPlayerIndex
        let sharesAmount: Double = self.shareCompanySelectedAmounts[indexPathRow]
        
        var opsToBePerformed: [Operation] = []
        
        let operation = Operation(type: self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex) < 0 ? .sellEmergency : .sell, uid: nil)
        operation.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: self.shareCompanyValues[indexPathRow] * sharesAmount)
        operation.addSharesDetails(shareSourceIndex: shareSrcGlobalIndex, shareDestinationIndex: shareDstGlobalIndex, shareAmount: sharesAmount, shareCompanyBaseIndex: shareCmpBaseIndex, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex))
        
        opsToBePerformed.append(operation)
        
        if self.gameState.game == .g1846 {
            if let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex), presidentPlayerIdx == self.operatingPlayerIndex {
                opsToBePerformed += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: shareCmpBaseIndex, andSharesAmount: sharesAmount, withUid: operation.uid)
            }
        } else {
            opsToBePerformed += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: shareCmpBaseIndex, andSharesAmount: sharesAmount, withUid: operation.uid)
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
        
        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(shareCmpBaseIndex) {
            self.closeCompany(atBaseIndex: shareCmpBaseIndex)
            return
        }
        
        self.parentVC.doneButtonPressed(sender: UIButton())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PlayerSellViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200.0, height: 106.0)
    }
}
