//
//  Company18MEXMergeViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 11/08/24.
//

import UIKit

class Company18MEXMergeViewController: UIViewController, Operable {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var playerIndexes: [Int] = []
    
    let certificateLimitsAugmented = [0, (19 + 1), (14 + 1), (11 + 1), 0] as [Double]
    let certificateLimits = [0, 19, 14, 11, 0] as [Double]
    var hasUserConfirmedIrreversibleOperations: Bool = false
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var certificateLimitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var eligibleCompaniesPopupButton: UIButton!
    @IBOutlet weak var eligibleCompaniesStackView: UIStackView!
    @IBOutlet weak var presidentPopupButton: UIButton!
    @IBOutlet weak var presidentStackView: UIStackView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mergingCompShareValueLabel: UILabel!
    @IBOutlet weak var mergingCompShareValueStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.playerIndexes = Array<Int>(self.gameState.getPlayerIndexes())
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.certificateLimitSegmentedControl.selectedSegmentIndex = (self.gameState.g18MEXIsCertificateLimitAugmentedByOne ?? false) ? 1 : 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let ndmCmpBaseIdx = self.gameState.getBaseIndex(forEntity: "NDM")
        let minorCompIndexes = [self.gameState.getGlobalIndex(forEntity: "A"), self.gameState.getGlobalIndex(forEntity: "B"), self.gameState.getGlobalIndex(forEntity: "C")]
        
        if !minorCompIndexes.enumerated().allSatisfy({ self.gameState.shares[$0.1][$0.0] == self.gameState.getTotalShareNumberOfCompany(atIndex: $0.1) }) {
            let attrString = NSMutableAttributedString(string: "Minor companies need to be closed before merging")
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

            self.messageLabel.attributedText = attrString
            
            self.eligibleCompaniesStackView.isHidden = true
            self.presidentStackView.isHidden = true
            
        } else if self.gameState.shares[BankIndex.tradeIn.rawValue][ndmCmpBaseIdx] == 1 {
            let attrString = NSMutableAttributedString(string: "NdM president may never merge\n(neither unfloated comps he owns the president's certificate of)")
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            
            self.messageLabel.attributedText = attrString
            
            self.eligibleCompaniesStackView.isHidden = false
            self.presidentStackView.isHidden = false
            
            self.setupPopupButtons()
            
        } else {
            let attrString = NSMutableAttributedString(string: "Merge already performed:\nthe operation cannot be canceled (perform custom operations if needed)")
            attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            
            self.messageLabel.attributedText = attrString
            
            self.eligibleCompaniesStackView.isHidden = true
            self.presidentStackView.isHidden = true
        }
        
        self.mergingCompShareValueStepper.minimumValue = 0
        self.mergingCompShareValueStepper.maximumValue = Double(self.gameState.getDistinctShareValuesSorted().count - 1)
        self.mergingCompShareValueStepper.stepValue = 1
        self.mergingCompShareValueStepper.value = 0.0
        self.mergingCompShareValueStepper.isHidden = true
        
        self.mergingCompShareValueLabel.isHidden = true
        self.presidentStackView.isHidden = true
        
        self.certificateLimitSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.certificateLimitSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.certificateLimitSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.certificateLimitSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
    }
    
    func setupPopupButtons() {
            
        var eligibleCompaniesActions: [UIAction] = []
        
        eligibleCompaniesActions.append(UIAction(title: "no merge", image: UIImage.circle(diameter: 20.0, color: UIColor.tintColor), state: .on, handler: {action in
            let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: String(action.title.split(separator: " ")[0]))
            if companyIdx != -1 {
                self.eligibleCompaniesPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                self.eligibleCompaniesPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                self.mergingCompShareValueLabel.isHidden = false
                self.mergingCompShareValueStepper.isHidden = false
                self.presidentStackView.isHidden = false
                if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: self.gameState.forceConvert(index: companyIdx, backwards: true, withIndexType: .companies)) {
                    if let idx = self.gameState.getDistinctShareValuesSorted().firstIndex(of: Double(cmpShareValue)) {
                        self.mergingCompShareValueStepper.value = Double(idx)
                        self.mergingCompShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getDistinctShareValuesSorted()[Int(self.mergingCompShareValueStepper.value)])
                        return
                    }
                }
                self.mergingCompShareValueStepper.value = 0
                self.mergingCompShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getDistinctShareValuesSorted()[Int(self.mergingCompShareValueStepper.value)])
            } else {
                self.eligibleCompaniesPopupButton.setBackgroundColor(UIColor.tintColor)
                self.eligibleCompaniesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                self.mergingCompShareValueLabel.isHidden = true
                self.mergingCompShareValueStepper.isHidden = true
                self.presidentStackView.isHidden = true
            }
        }))
        
        for i in 0..<self.gameState.companiesSize {
            if !["CHI", "MCR", "MEX", "SPM", "UDY"].contains(self.gameState.getCompanyLabel(atBaseIndex: i)) {
                continue
            }

            eligibleCompaniesActions.append(UIAction(title: self.gameState.getCompanyLabel(atBaseIndex: i) + " (unfloated)", image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atBaseIndex: i)), handler: {action in
                let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: String(action.title.split(separator: " ")[0]))
                if companyIdx != -1 {
                    self.eligibleCompaniesPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                    self.eligibleCompaniesPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                    self.mergingCompShareValueLabel.isHidden = false
                    self.mergingCompShareValueStepper.isHidden = false
                    self.presidentStackView.isHidden = false
                    if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: self.gameState.forceConvert(index: companyIdx, backwards: true, withIndexType: .companies)) {
                        if let idx = self.gameState.getDistinctShareValuesSorted().firstIndex(of: Double(cmpShareValue)) {
                            self.mergingCompShareValueStepper.value = Double(idx)
                            self.mergingCompShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getDistinctShareValuesSorted()[Int(self.mergingCompShareValueStepper.value)])
                            return
                        }
                    }
                    self.mergingCompShareValueStepper.value = 0
                    self.mergingCompShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getDistinctShareValuesSorted()[Int(self.mergingCompShareValueStepper.value)])
                } else {
                    self.eligibleCompaniesPopupButton.setBackgroundColor(UIColor.tintColor)
                    self.eligibleCompaniesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    self.mergingCompShareValueLabel.isHidden = true
                    self.mergingCompShareValueStepper.isHidden = true
                    self.presidentStackView.isHidden = true
                }
            }))
        }
        
        if eligibleCompaniesActions.isEmpty {
            self.eligibleCompaniesPopupButton.isHidden = true
        } else {
            self.eligibleCompaniesPopupButton.isHidden = false
            if eligibleCompaniesActions.count == 1 {
                self.eligibleCompaniesPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.eligibleCompaniesPopupButton.setPopupTitle(withText: eligibleCompaniesActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.eligibleCompaniesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.eligibleCompaniesPopupButton.setPopupTitle(withText: eligibleCompaniesActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.eligibleCompaniesPopupButton.menu = UIMenu(children: eligibleCompaniesActions)
            self.eligibleCompaniesPopupButton.showsMenuAsPrimaryAction = true
            self.eligibleCompaniesPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        // president popup button
        
        var playersActions: [UIAction] = []
        for playerIdx in self.playerIndexes {
            playersActions.append(UIAction(title: self.gameState.getPlayerLabel(atIndex: playerIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getPlayerColor(atIndex: playerIdx)), handler: { action in
                    self.presidentPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
        }
        
        let augmentedActions: [UIAction] = [UIAction(title: "no president", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
            self.presidentPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
        })] + playersActions
        
        if augmentedActions.isEmpty {
            self.presidentPopupButton.isHidden = true
        } else {
            self.presidentPopupButton.isHidden = false
            if playersActions.count == 1 {
                self.presidentPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.presidentPopupButton.setPopupTitle(withText: playersActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.presidentPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.presidentPopupButton.setPopupTitle(withText: playersActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.presidentPopupButton.menu = UIMenu(children: augmentedActions)
            self.presidentPopupButton.showsMenuAsPrimaryAction = true
            self.presidentPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    @IBAction func shareValueStepperValueChanged(sender: UIStepper) {
        self.mergingCompShareValueLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getDistinctShareValuesSorted()[Int(sender.value)])
    }
    
    @IBAction func certificateLimitSegmentedControlValueChanged(sender: UISegmentedControl) {
        self.gameState.certificateLimit = sender.selectedSegmentIndex == 0 ? self.certificateLimits[self.gameState.playersSize - 1 - 1] : self.certificateLimitsAugmented[self.gameState.playersSize - 1 - 1]
        
        self.gameState.g18MEXIsCertificateLimitAugmentedByOne = !(sender.selectedSegmentIndex == 0)
        self.gameState.saveToDisk()
    }
    
    func commitButtonPressed() -> Bool? {
        if self.hasUserConfirmedIrreversibleOperations { return true }
        
        let ndmCmpBaseIdx = self.gameState.getBaseIndex(forEntity: "NDM")
            
        let mergingCmpIdx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: String(self.eligibleCompaniesPopupButton.currentTitle!.split(separator: " ")[0]))
        let presidentPlayerIdx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.presidentPopupButton.currentTitle!)
        
        
        var opsToBePerformed: [Operation] = []
        
        
        if mergingCmpIdx == -1 {
            // NO MERGE
            
            let srcIdx = BankIndex.tradeIn.rawValue
            let dstIdx = BankIndex.ipo.rawValue
            
            let firstTradeInOp = Operation(type: .g18MEXmerge, uid: nil)
            firstTradeInOp.addSharesDetails(shareSourceIndex: srcIdx, shareDestinationIndex: dstIdx, shareAmount: 1.0, shareCompanyBaseIndex: ndmCmpBaseIdx)
            
            opsToBePerformed.append(firstTradeInOp)
            
        } else {
            let mergingCmpBaseIdx = self.gameState.forceConvert(index: mergingCmpIdx, backwards: true, withIndexType: .companies)
            
            if presidentPlayerIdx != -1 {
                if self.gameState.getSharesPortfolioForPlayer(atIndex: presidentPlayerIdx)[mergingCmpBaseIdx] < self.gameState.presidentCertificateShareAmount {
                    return false
                }
            }
            
            // MERGE
            
            var srcIdx = BankIndex.tradeIn.rawValue
            var dstIdx = presidentPlayerIdx == -1 ? BankIndex.ipo.rawValue : presidentPlayerIdx
            
            let firstTradeInOp = Operation(type: .g18MEXmerge, uid: nil)
            firstTradeInOp.addSharesDetails(shareSourceIndex: srcIdx, shareDestinationIndex: dstIdx, shareAmount: 1.0, shareCompanyBaseIndex: ndmCmpBaseIdx)
            
            opsToBePerformed.append(firstTradeInOp)
                
            if presidentPlayerIdx != -1 {
                srcIdx = dstIdx
                dstIdx = BankIndex.ipo.rawValue
                
                let secondTradeInOp = Operation(type: .g18MEXmerge, uid: nil)
                secondTradeInOp.addSharesDetails(shareSourceIndex: srcIdx, shareDestinationIndex: dstIdx, shareAmount: 2.0, shareCompanyBaseIndex: mergingCmpBaseIdx)
                
                opsToBePerformed.append(secondTradeInOp)
            }
            
            let shareValueHalved: Double = self.gameState.getDistinctShareValuesSorted()[Int(self.mergingCompShareValueStepper.value)] / 2.0
            
            for shareholderIdx in self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: mergingCmpBaseIdx) {
                if shareholderIdx == BankIndex.ipo.rawValue { continue }
                
                let shareAmount = shareholderIdx == presidentPlayerIdx ? self.gameState.shares[shareholderIdx][mergingCmpBaseIdx] - 2.0 : self.gameState.shares[shareholderIdx][mergingCmpBaseIdx]
                let cashout = self.gameState.getPlayerIndexes().contains(shareholderIdx) ? ceil(shareValueHalved * shareAmount) : 0.0
                
                let op = Operation(type: .g18MEXmerge, uid: nil)
                op.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: shareholderIdx, amount: cashout)
                op.addSharesDetails(shareSourceIndex: shareholderIdx, shareDestinationIndex: BankIndex.ipo.rawValue, shareAmount: shareAmount, shareCompanyBaseIndex: mergingCmpBaseIdx)
                
                opsToBePerformed.append(op)
            }
            
            let op = Operation(type: .g18MEXmerge, uid: nil)
            op.addCashDetails(sourceIndex: mergingCmpIdx, destinationIndex: self.gameState.forceConvert(index: ndmCmpBaseIdx, backwards: false, withIndexType: .companies), amount: self.gameState.getCompanyAmount(atBaseIndex: mergingCmpBaseIdx))
            
            opsToBePerformed.append(op)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return false
        }
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "ATTENTION", andMessage: "The operation cannot be undo. Do you want to proceed anyway?")
        alert.addCancelAction(withLabel: "Cancel")
        alert.addConfirmAction(withLabel: "OK") {
            for op in opsToBePerformed {
                _ = self.gameState.perform(operation: op)
            }
            
            if mergingCmpIdx != -1 {
                self.gameState.closeCompany(atBaseIndex: self.gameState.forceConvert(index: mergingCmpIdx, backwards: true, withIndexType: .companies))
                self.gameState.g18MEXIsCertificateLimitAugmentedByOne = false
            } else {
                self.gameState.g18MEXIsCertificateLimitAugmentedByOne = true
            }
            
            self.hasUserConfirmedIrreversibleOperations = true
            
            self.parentVC.doneButtonPressed(sender: UIButton())

        }
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
        return nil
        
    }

}
