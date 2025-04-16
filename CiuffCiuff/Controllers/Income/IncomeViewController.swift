//
//  IncomeViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/01/23.
//

import UIKit

class IncomeViewController: UIViewController {
    
    var parentVC: HomeViewController!
    var gameState: GameState!
    
    var operatingPrivatesBaseIndexes: [Int] = []
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var payoutButton: UIButton!
    @IBOutlet weak var privatesCollectionView: UICollectionView!
    @IBOutlet weak var closeAllButton: UIButton!
    
    var PARindexSelected: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.cancelButton.setTitle(withText: "Cancel", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.cancelButton.setBackgroundColor(UIColor.redAccentColor)
        self.payoutButton.setTitle(withText: "Payout", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.payoutButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.closeAllButton.setTitle(withText: "Close ALL", fontSize: 19.0, fontWeight: .bold, textColor: UIColor.white)
        self.closeAllButton.setBackgroundColor(UIColor.redAccentColor)
        self.closeAllButton.layer.cornerRadius = 25
        self.closeAllButton.clipsToBounds = true
        
        self.operatingPrivatesBaseIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 != BankIndex.bank.rawValue }.map { $0.0 }
        
        self.privatesCollectionView.delegate = self
        self.privatesCollectionView.dataSource = self
        self.privatesCollectionView.backgroundColor = UIColor.secondaryAccentColor
        
    }
    
    func closePrivate(atIndexPath indexPath: IndexPath) {
        
        let srcGlobalIndex: Int = BankIndex.bank.rawValue
        let dstGlobalIndex: Int = self.gameState.privatesOwnerGlobalIndexes[self.operatingPrivatesBaseIndexes[indexPath.row]]
        
        var amount = 0.0
        
        if self.gameState.game == .g1840 {
            amount = self.gameState.privatesPrices[self.operatingPrivatesBaseIndexes[indexPath.row]]
        }
        
        let closePrivateOp = Operation(type: .privates, uid: nil)
        closePrivateOp.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: amount)
        closePrivateOp.addPrivatesDetails(privateSourceGlobalIndex: dstGlobalIndex, privateDestinationGlobalIndex: srcGlobalIndex, privateCompanyBaseIndex: self.operatingPrivatesBaseIndexes[indexPath.row])
                        
        if !self.gameState.isOperationLegit(operation: closePrivateOp, reverted: false) {
            return
        }
        
        if self.gameState.perform(operation: closePrivateOp) {
            
            switch self.gameState.game {
            case .g1830:
                if self.gameState.privatesLabels[self.operatingPrivatesBaseIndexes[indexPath.row]] == "Mohawk" {
                    //10% NYC
                    if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "NYC" }) {
                        let ownerGlobalIndex = self.gameState.privatesOwnerGlobalIndexes[self.operatingPrivatesBaseIndexes[indexPath.row]]
                        
                        if self.gameState.getPlayerIndexes().contains(ownerGlobalIndex) {
                            let isShareAvailableInIPO = self.gameState.shares[BankIndex.ipo.rawValue][cmpBaseIdx] > 0
                            let isShareAvailableInBank = self.gameState.shares[BankIndex.bank.rawValue][cmpBaseIdx] > 0
                            
                            if isShareAvailableInIPO || isShareAvailableInBank {
                                
                                let dstGlobalIndex = ownerGlobalIndex
                                let srcGlobalIndex = isShareAvailableInIPO ? BankIndex.ipo.rawValue : BankIndex.bank.rawValue
                                
                                let exchangeOp = Operation(type: .privates, uid: nil)
                                exchangeOp.addSharesDetails(shareSourceIndex: srcGlobalIndex, shareDestinationIndex: dstGlobalIndex, shareAmount: 1, shareCompanyBaseIndex: cmpBaseIdx, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: cmpBaseIdx))
                                
                                if self.gameState.isOperationLegit(operation: exchangeOp, reverted: false) {
                                    
                                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                                    alert.setup(withTitle: "Activate private ability?", andMessage: "Handle 10% NYC from \(isShareAvailableInIPO ? "IPO" : "Bank") to \(self.gameState.getPlayerLabel(atIndex: ownerGlobalIndex))?")
                                    alert.addConfirmAction(withLabel: "Yes") {
                                        _ = self.gameState.perform(operation: exchangeOp)
                                        
                                        self.completeCloseOperation()
                                    }
                                    alert.addCancelAction(withLabel: "No") {
                                        self.completeCloseOperation()
                                    }
                                    
                                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                                    
                                    self.present(alert, animated: true)
                                    return
                                }
                            }
                        }
                    }
                }
                
            case .g1882:
                
                if self.gameState.privatesLabels[self.operatingPrivatesBaseIndexes[indexPath.row]] == "P2" {
                    //10% SCR
                    if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "SCR" }) {
                        
                        let cmpIdx = self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                        let PARValues = self.gameState.getGamePARValues()
                        
                        let pickerElementsAttributedTexts = PARValues.map { "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double($0)))" }.map { NSAttributedString(string: $0) }
                        
                        let alert = storyboard?.instantiateViewController(withIdentifier: "customPickerViewAlertViewController") as! CustomPickerViewAlertViewController
                        
                        let attrTitle = NSMutableAttributedString()
                        attrTitle.append(NSAttributedString(string: "Activate ability?\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21.0, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.black]))
                        attrTitle.append(NSAttributedString(string: "Set PAR for \(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)):", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.black]))
                        
                        alert.setup(withAttributedTitle: attrTitle, andPickerElementsAttributedTextsByComponent: [pickerElementsAttributedTexts])
                        alert.addCancelAction(withLabel: "No") {
                            
                            self.completeCloseOperation()
                        }
                        alert.addConfirmAction(withLabel: "OK") { selectedIndexesByComponent in
                            
                            if selectedIndexesByComponent.isEmpty { return }
                            
                            self.PARindexSelected = selectedIndexesByComponent[0]
                            
                            var additionalOperations: [Operation] = []
                            
                            let PARvalue = Double(PARValues[self.PARindexSelected])
                            if let parIndex = self.gameState.getPARindex(fromShareValue: PARvalue) {
                                let op = Operation(type: .cash)
                                op.addMarketDetails(marketShareValueCmpBaseIndex: cmpBaseIdx, marketShareValueFromIndex: nil, marketShareValueToIndex: parIndex, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) -> PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: PARvalue, shouldTruncateDouble: true))")
                                additionalOperations.append(op)
                            }
                            
                            let shareOp = Operation(type: .cash, uid: nil)
                            shareOp.addSharesDetails(shareSourceIndex: self.gameState.shareStartingLocation.getBankIndex() ?? cmpIdx, shareDestinationIndex: dstGlobalIndex, shareAmount: 1, shareCompanyBaseIndex: cmpBaseIdx)
                               
                            additionalOperations.append(shareOp)
                            
                            if self.gameState.areOperationsLegit(operations: additionalOperations, reverted: false) {
                                for op in additionalOperations {
                                    _ = self.gameState.perform(operation: op)
                                }
                            }
                            
                            self.completeCloseOperation()
                            
                            HomeViewController.presentSnackBar(withMessage: "Remember to make available the EXTRA train")
                        }
                        
                        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                        
                        self.present(alert,animated: true, completion: nil)
                        return
                    }
                }
                
            case .g1889:
                if self.gameState.privatesLabels[self.operatingPrivatesBaseIndexes[indexPath.row]] == "E" {
                    //10% IR
                    if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "IR" }) {
                        let ownerGlobalIndex = self.gameState.privatesOwnerGlobalIndexes[self.operatingPrivatesBaseIndexes[indexPath.row]]
                        
                        if self.gameState.getPlayerIndexes().contains(ownerGlobalIndex) {
                            let isShareAvailableInIPO = self.gameState.shares[BankIndex.ipo.rawValue][cmpBaseIdx] > 0
                            
                            if isShareAvailableInIPO {
                                
                                let dstGlobalIndex = ownerGlobalIndex
                                let srcGlobalIndex = BankIndex.ipo.rawValue
                                
                                let exchangeOp = Operation(type: .privates, uid: nil)
                                exchangeOp.addSharesDetails(shareSourceIndex: srcGlobalIndex, shareDestinationIndex: dstGlobalIndex, shareAmount: 1, shareCompanyBaseIndex: cmpBaseIdx, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: cmpBaseIdx))
                                
                                if self.gameState.isOperationLegit(operation: exchangeOp, reverted: false) {
                                    
                                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                                    alert.setup(withTitle: "Activate private ability?", andMessage: "Handle 10% IR from IPO to \(self.gameState.getPlayerLabel(atIndex: ownerGlobalIndex))?")
                                    alert.addConfirmAction(withLabel: "Yes") {
                                        _ = self.gameState.perform(operation: exchangeOp)
                                        
                                        self.completeCloseOperation()
                                    }
                                    alert.addCancelAction(withLabel: "No") {
                                        self.completeCloseOperation()
                                    }
                                    
                                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                                    
                                    self.present(alert, animated: true)
                                    return
                                }
                            }
                        }
                    }
                }
            case .g1840, .g1846, .g1848, .g1849, .g1856, .g18Chesapeake, .g18MEX:
                break
            }
            
            self.completeCloseOperation()
        }
    }
    
    func completeCloseOperation() {
        
        self.operatingPrivatesBaseIndexes = self.gameState.privatesOwnerGlobalIndexes.enumerated().filter { $0.1 != BankIndex.bank.rawValue }.map { $0.0 }
        if self.operatingPrivatesBaseIndexes.isEmpty {
            self.dismiss(animated: true)
            self.parentVC.refreshUI()
        } else {
            self.privatesCollectionView.reloadData()
        }
    }
    
    @IBAction func closeAllPrivateCompanies(sender: UIButton) {
        self.gameState.closeAllPrivatesCompanies()
        
        self.dismiss(animated: true)
        self.parentVC.refreshUI()
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
        self.parentVC.refreshUI()
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        
        self.gameState.makePrivatesCompaniesOperate()
        
        self.dismiss(animated: true)
        self.parentVC.refreshUI()
    }

}

extension IncomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.operatingPrivatesBaseIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrivateCellId", for: indexPath) as! PrivateCollectionViewCell
        cell.parentVC = self
        cell.indexPath = indexPath
        
        cell.contentView.backgroundColor = .systemGray6
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.primaryAccentColor.cgColor
        
        cell.nameLabel.text = self.gameState.privatesLabels[self.operatingPrivatesBaseIndexes[indexPath.row]]
        cell.nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        
        cell.priceLabel.text = "(\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[self.operatingPrivatesBaseIndexes[indexPath.row]])))"
        cell.priceLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        
        cell.ownerLabel.text = self.gameState.getPlayerLabel(atIndex: self.gameState.privatesOwnerGlobalIndexes[self.operatingPrivatesBaseIndexes[indexPath.row]])
        cell.ownerLabel.textColor = UIColor.white
        cell.ownerLabel.backgroundColor = UIColor.primaryAccentColor
        
        cell.incomeLabel.text = "Income: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesIncomes[self.operatingPrivatesBaseIndexes[indexPath.row]])
        cell.incomeLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        
        cell.closeButton.isHidden = !self.gameState.privatesMayBeVoluntarilyClosedFlags[self.operatingPrivatesBaseIndexes[indexPath.row]]
        cell.closeButton.setTitle(withText: "Close", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        cell.closeButton.setBackgroundColor(UIColor.redAccentColor)
        
        return cell
    }
}

extension IncomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension IncomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cols = 2.0
        let rows = ceil(Double(self.operatingPrivatesBaseIndexes.count) / cols)
            
        return CGSize(width: min(340, collectionView.getWidthForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true, horizontalInsetReduction: 30)), height: 135)
    }
    
}
