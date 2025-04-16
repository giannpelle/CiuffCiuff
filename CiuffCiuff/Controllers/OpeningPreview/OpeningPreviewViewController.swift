//
//  OpeningPreviewViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 03/08/24.
//

import UIKit

class OpeningPreviewViewController: UIViewController {
    
    var parentVC: HomeViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var companyBaseIndexes: [Int]!
    var previewAmountsByComp: [Int]!
    var previewShareAmountsByComp: [Int]!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var openingHintStackView: UIStackView!
    @IBOutlet weak var salesCollectionView: UICollectionView!
    @IBOutlet weak var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backgroundView.backgroundColor = UIColor.primaryAccentColor
        
        self.cancelButton.setTitle(withText: "Cancel", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.cancelButton.setBackgroundColor(UIColor.redAccentColor)
        self.sellButton.setTitle(withText: "SELL", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.sellButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.previewAmountsByComp = Array(repeating: 0, count: self.companyBaseIndexes.count)
        self.previewShareAmountsByComp = Array(repeating: 0, count: self.companyBaseIndexes.count)

        self.titleLabel.text = "\(self.gameState.getPlayerLabel(atIndex: self.operatingPlayerIndex)) (cash + sales): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex)))"
        
        self.openingHintStackView.axis = .horizontal
        self.openingHintStackView.distribution = .fillEqually
        self.openingHintStackView.alignment = .fill
        self.openingHintStackView.spacing = 4.0
        
        for i in 0..<self.gameState.openCompanyValues.count {
            let openingLabel = PaddingLabel()
            openingLabel.font = UIFont.systemFont(ofSize: 20.0)
            openingLabel.textAlignment = .center
            openingLabel.textColor = UIColor.black
            openingLabel.backgroundColor = UIColor.white
            openingLabel.numberOfLines = 0
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            paragraphStyle.alignment = .center
            
            let PARValues = self.gameState.getGamePARValues()
            
            var openingsStr = "PAR \(PARValues[i]):\n"
            
            switch self.gameState.game {
            case .g1849:
                openingsStr += "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * 2))) - "
                openingsStr += "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * 3))) - "
                openingsStr += "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * 4)))"
            case .g1856:
                let necessaryShareAmount = min(self.gameState.currentTrainPriceIndex + 2, 5)
                
                openingsStr += "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * necessaryShareAmount))) / "
                openingsStr += "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(PARValues[i] * (necessaryShareAmount + 1))))"
            case .g1830, .g1840, .g1846, .g1848, .g1882, .g1889, .g18MEX, .g18Chesapeake:
                openingsStr += self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(self.gameState.openCompanyValues[i]))
            }
            
            let attributedString = NSMutableAttributedString(string: openingsStr)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

            openingLabel.attributedText = attributedString
            
            openingLabel.paddingRight = 15.0
            openingLabel.paddingLeft = 15.0
            openingLabel.paddingTop = 15.0
            openingLabel.paddingBottom = 15.0
            
            self.openingHintStackView.addArrangedSubview(openingLabel)
        }
        
        self.salesCollectionView.dataSource = self
        self.salesCollectionView.delegate = self
        self.salesCollectionView.backgroundColor = UIColor.secondaryAccentColor
        
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SELLButtonPressed(sender: UIButton) {
        
        var sellOps: [Operation] = []
        
        for (i, cmpBaseIdx) in self.companyBaseIndexes.enumerated() {
            if self.previewShareAmountsByComp[i] > 0 && self.previewAmountsByComp[i] > 0 {
                
                let dstGlobalIndex: Int = self.operatingPlayerIndex
                let srcGlobalIndex: Int = BankIndex.bank.rawValue
                
                let shareDstGlobalIndex: Int = BankIndex.bank.rawValue
                let shareSrcGlobalIndex: Int = self.operatingPlayerIndex
//                let shareCmpGlobalIndex: Int = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                let shareCmpBaseIndex: Int = cmpBaseIdx
                
                let sellOp = Operation(type: .sell, uid: nil)
                sellOp.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(self.previewAmountsByComp[i]))
                sellOp.addSharesDetails(shareSourceIndex: shareSrcGlobalIndex, shareDestinationIndex: shareDstGlobalIndex, shareAmount: Double(self.previewShareAmountsByComp[i]), shareCompanyBaseIndex: shareCmpBaseIndex, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex))
                
                sellOps.append(sellOp)

                if self.gameState.game == .g1846 {
                    if let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex), presidentPlayerIdx == self.operatingPlayerIndex {
                        sellOps += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: shareCmpBaseIndex, andSharesAmount: Double(self.previewShareAmountsByComp[i]), withUid: sellOp.uid)
                    }
                } else {
                    sellOps += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: shareCmpBaseIndex, andSharesAmount: Double(self.previewShareAmountsByComp[i]), withUid: sellOp.uid)
                }
            }
        }
        
        if !self.gameState.areOperationsLegit(operations: sellOps, reverted: false) || sellOps.isEmpty {
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "No operation was performed, correct the data and try again")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        for op in sellOps {
            if !self.gameState.perform(operation: op) {
                return
            }
        }
        
        self.dismiss(animated: true)
        self.parentVC.refreshUI()
    }
    
    func refreshTitleLabel() {
        let previewSum = self.previewAmountsByComp.reduce(0, +)
        self.titleLabel.text = "\(self.gameState.getPlayerLabel(atIndex: self.operatingPlayerIndex)) (cash + sales): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex) + Double(previewSum)))"
    }

}

extension OpeningPreviewViewController: UICollectionViewDelegate {
    
    func updateTitleLabel(withTotalAmount amount: Double) {
        self.titleLabel.text = "\(self.gameState.getPlayerLabel(atIndex: self.operatingPlayerIndex)) (cash + sales): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: amount))"
    }
    
}

extension OpeningPreviewViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.companyBaseIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "salePreviewCollectionViewCell", for: indexPath) as! SalePreviewCollectionViewCell
        
        cell.parentVC = self
        cell.gameState = self.gameState
        cell.indexPath = indexPath
        
        cell.companyBackgroundView.layer.cornerRadius = 10.0
        cell.companyBackgroundView.clipsToBounds = true
        cell.backgroundAccessoryView.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: self.companyBaseIndexes[indexPath.row])
        cell.compImageView.image = self.gameState.getCompanyLogo(atBaseIndex: self.companyBaseIndexes[indexPath.row])
        
        cell.compImageBackgroundView.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: self.companyBaseIndexes[indexPath.row])
        cell.compImageBackgroundView.layer.cornerRadius = 30.0
        cell.compImageBackgroundView.clipsToBounds = true
        
        let cmpType = self.gameState.getCompanyType(atBaseIndex: self.companyBaseIndexes[indexPath.row])
        if cmpType.isShareValueTokenOnBoard() {
            
            cell.shareValueStepper.minimumValue = 0
            cell.shareValueStepper.maximumValue = Double(self.gameState.getDistinctShareValuesSorted().count - 1)
            cell.shareValueStepper.stepValue = 1
            
            if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: self.companyBaseIndexes[indexPath.row]),
               let idx = self.gameState.getDistinctShareValuesSorted().firstIndex(of: Double(cmpShareValue)) {
                cell.shareValueStepper.value = Double(idx)
            } else {
                cell.shareValueStepper.value = 0.0
            }
        } else {
            
            cell.shareValueStepper.minimumValue = 0
            cell.shareValueStepper.maximumValue = 500
            cell.shareValueStepper.stepValue = 1
            
            switch cmpType {
            case .g1848BoE:
                if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: self.companyBaseIndexes[indexPath.row]) {
                    cell.shareValueStepper.value = cmpShareValue
                } else {
                    cell.shareValueStepper.value = 0.0
                }
            case .g1840Stadtbahn, .g1846Miniature, .g1856CGR, .g18MEXMinor, .standard:
                break
            }
        }
        
        cell.compShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getDistinctShareValuesSorted()[Int(cell.shareValueStepper.value)])
        
        let shareAmount = self.gameState.getSharesPortfolioForPlayer(atIndex: self.operatingPlayerIndex)[self.companyBaseIndexes[indexPath.row]]
        cell.shareAmountStepper.minimumValue = 0
        cell.shareAmountStepper.maximumValue = shareAmount
        cell.shareAmountStepper.stepValue = 1
        cell.shareAmountStepper.value = 0
        
        cell.shareAmountLabel.text = "SELL: 0"
        cell.maxShareAmountLabel.text = "(max: \(Int(shareAmount)))"
        
        return cell
    }
}

extension OpeningPreviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let staticHeight = 200
        
        let cols = 2.0
        let rows = ceil(Double(self.companyBaseIndexes.count) / cols)

        return CGSize(width: collectionView.getWidthForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true), height: staticHeight)
        
    }
}
