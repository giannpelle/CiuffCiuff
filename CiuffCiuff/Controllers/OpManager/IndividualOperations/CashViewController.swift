//
//  CashViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 13/03/23.
//

import UIKit

class CashViewController: UIViewController {

    var parentVC: HomeViewController!
    var gameState: GameState!
    
    var cashSourceGlobalIndexes: [Int] = []
    var cashDestinationGlobalIndexes: [Int] = []
    var entityAmounts: [Int] = []
    
    var shareSourceGlobalIndexes: [Int] = []
    var shareDestinationGlobalIndexes: [Int] = []
    var shareAmounts: [Double] = []
    var shareCompanyGlobalIndexes: [Int] = []
    var trashSourceGlobalIndexes: [Int] = []
    
    var privatesBaseIndexes: [Int] = []
    var privatesDestinationGlobalIndexes: [Int] = []
    
    var loansSourceGlobalIndexes: [Int] = []
    var loansDestinationGlobalIndexes: [Int] = []
    var loansAmounts: [Int] = []
    
    var bondsSourceGlobalIndexes: [Int] = []
    var bondsDestinationGlobalIndexes: [Int] = []
    var bondsAmounts: [Int] = []
    
    var g1840LinesBaseIndexes: [Int] = []
    var g1840LinesDestinationGlobalIndexes: [Int] = []
    
    var g1840LineRunBaseIndexes: [Int] = []
    var g1840LineRunAmount = 0
    
    var amountGlobalIndexes: [Int] = []
    var hasUserConfirmedExtraOperations: Bool = false
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var commitButton: UIButton!
    
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var cashSourcePopupButton: UIButton!
    @IBOutlet weak var cashDestinationPopupButton: UIButton!
    @IBOutlet weak var cashAmountCollectionViewCell: UICollectionView!
    
    var numberPadBackgroundView: UIView!
    
    @IBOutlet weak var shareDestinationPopupButton: UIButton!
    @IBOutlet weak var shareAmountPopupButton: UIButton!
    @IBOutlet weak var shareCompanyPopupButton: UIButton!
    @IBOutlet weak var shareSourcePopupButton: UIButton!
    
    @IBOutlet weak var trashLabel: UILabel!
    @IBOutlet weak var generateLabel: UILabel!
    
    @IBOutlet weak var trashStackView: UIStackView!
    @IBOutlet weak var trashTargetPopupButton: UIButton!
    @IBOutlet weak var trashShareAmountPopupButton: UIButton!
    @IBOutlet weak var trashShareCompanyPopupButton: UIButton!
    @IBOutlet weak var generateStackView: UIStackView!
    @IBOutlet weak var generateTargetPopupButton: UIButton!
    @IBOutlet weak var generateShareAmountPopupButton: UIButton!
    @IBOutlet weak var generateShareCompanyPopupButton: UIButton!
    
    @IBOutlet weak var privatesPopupButton: UIButton!
    @IBOutlet weak var privatesDestinationPopupButton: UIButton!
    
    @IBOutlet weak var loansSourcePopupButton: UIButton!
    @IBOutlet weak var loansAmountPopupButton: UIButton!
    @IBOutlet weak var loansDestinationPopupButton: UIButton!
    
    @IBOutlet weak var bondsSourcePopupButton: UIButton!
    @IBOutlet weak var bondsAmountPopupButton: UIButton!
    @IBOutlet weak var bondsDestinationPopupButton: UIButton!
    
    @IBOutlet weak var linesPopupButton: UIButton!
    @IBOutlet weak var linesDestinationPopupButton: UIButton!
    
    @IBOutlet weak var linesRunningPopupButton: UIButton!
    @IBOutlet weak var lineRunningIndexPopupButton: UIButton!
    @IBOutlet weak var lineRevenueStackView: UIStackView!
    @IBOutlet weak var lineRevenueLabel: PaddingLabel!
    
    @IBOutlet weak var contentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var contentSegmentedControlWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var moneyStackView: UIStackView!
    @IBOutlet weak var moneyStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var sharesStackView: UIStackView!
    @IBOutlet weak var sharesStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var privatesStackView: UIStackView!
    @IBOutlet weak var privatesStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var otherStackView: UIStackView!
    @IBOutlet weak var otherStackViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loansStackView: UIStackView!
    @IBOutlet weak var bondsStackView: UIStackView!
    @IBOutlet weak var linesStackView: UIStackView!
    
    @IBOutlet weak var amountsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.cashAmountCollectionViewCell.backgroundColor = UIColor.secondaryAccentColor
        
        self.trashLabel.textColor = UIColor.redAccentColor
        self.generateLabel.textColor = UIColor.greenORColor
        
        self.cancelButton.setTitle(withText: "Cancel", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.cancelButton.setBackgroundColor(UIColor.redAccentColor)
        self.commitButton.setTitle(withText: "Commit", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.commitButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.cashSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.cashDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.shareSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.shareAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.shareDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.generateTargetPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.generateShareAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.trashTargetPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.trashShareAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.privatesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.privatesDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.loansSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.loansAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.loansDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.bondsSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.bondsAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.bondsDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.linesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.linesDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.lineRunningIndexPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.lineRunningIndexPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.amountGlobalIndexes = Array<Int>([BankIndex.bank.rawValue]) + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
        
        self.amountsCollectionView.delegate = self
        self.amountsCollectionView.dataSource = self
        
        self.contentSegmentedControl.removeAllSegments()
        self.contentSegmentedControl.insertSegment(withTitle: "Money", at: 0, animated: false)
        self.contentSegmentedControl.insertSegment(withTitle: "Shares", at: 1, animated: false)
        self.contentSegmentedControl.insertSegment(withTitle: "Privates", at: 2, animated: false)
        
        let areLoansInGame = self.gameState.loans != nil
        let areBondsInGame = self.gameState.bonds != nil
        let areLinesInGame = self.gameState.g1840LinesLabels != nil
        let isOtherTabActive = areLoansInGame || areBondsInGame || areLinesInGame
        
        if isOtherTabActive {
            self.contentSegmentedControl.insertSegment(withTitle: "Other", at: 3, animated: false)
            self.contentSegmentedControlWidthConstraint.constant = 440
            
            self.otherStackViewTopConstraint.constant = 70.0
        } else {
            self.contentSegmentedControlWidthConstraint.constant = 330
        }
        
        self.contentSegmentedControl.selectedSegmentIndex = 0
        self.moneyStackViewTopConstraint.constant = 70.0
        self.sharesStackViewTopConstraint.constant = 70.0
        self.privatesStackViewTopConstraint.constant = 70.0
        
        self.contentSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.contentSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.contentSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.contentSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        self.cashSourceGlobalIndexes = [BankIndex.bank.rawValue] + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
        self.cashDestinationGlobalIndexes = [BankIndex.bank.rawValue] + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
        
        self.entityAmounts = Array(repeating: 0, count: self.gameState.playersSize)
        
        self.cashAmountCollectionViewCell.delegate = self
        self.cashAmountCollectionViewCell.dataSource = self
        
        self.shareDestinationGlobalIndexes = Array<Int>(self.gameState.getBankEntityIndexes()) + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
        self.shareAmounts = [0.0] + self.gameState.getPredefinedShareAmounts()
        self.shareCompanyGlobalIndexes = Array<Int>(self.gameState.getCompanyIndexes())
        self.shareSourceGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: self.shareCompanyGlobalIndexes[0])
        self.trashSourceGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: self.shareCompanyGlobalIndexes[0])
        
        self.privatesBaseIndexes = Array<Int>(0..<self.gameState.privatesLabels.count)
        self.privatesDestinationGlobalIndexes = [BankIndex.bank.rawValue] + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
        
        if areLoansInGame {
            self.loansSourceGlobalIndexes = (self.gameState.game != .g1848 ? [BankIndex.bank.rawValue] : []) + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
            self.loansDestinationGlobalIndexes = (self.gameState.game != .g1848 ? [BankIndex.bank.rawValue] : []) + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
            self.loansAmounts = Array<Int>(0...10)
        }
        
        if areBondsInGame {
            self.bondsSourceGlobalIndexes = [BankIndex.bank.rawValue] + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
            self.bondsDestinationGlobalIndexes = [BankIndex.bank.rawValue] + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
            self.bondsAmounts = Array<Int>(0...10)
        }
        
        if let linesLabels = self.gameState.g1840LinesLabels {
            self.g1840LinesBaseIndexes = Array<Int>(0..<linesLabels.count)
            self.g1840LinesDestinationGlobalIndexes = [BankIndex.bank.rawValue] + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
            
            self.g1840LineRunBaseIndexes = [0, 1, 2]
            
            let modifierTexts = ["-30", "-10", "+10", "+30"]
            for (i, view) in self.lineRevenueStackView.arrangedSubviews.enumerated() {
                if let btn = view as? UIButton {
                    btn.setTitle(withText: modifierTexts[i], fontSize: 19.0, fontWeight: .semibold, textColor: UIColor.white)
                    
                    btn.clipsToBounds = true
                    btn.layer.cornerRadius = 8
                        
                    if modifierTexts[i].contains("-") {
                        btn.setBackgroundColor(UIColor.redAccentColor)
                    } else if modifierTexts[i].contains("+") {
                        btn.setBackgroundColor(UIColor.primaryAccentColor)
                    }
                    
                    btn.addTarget(self, action: #selector(modifierButtonPressed(sender:)), for: .touchUpInside)
                }
            }
            
            self.lineRevenueLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
            self.lineRevenueLabel.text = "Revenue: 0"
        }
        
        if self.gameState.isGenerateTrashHidden {
            self.trashStackView.isHidden = true
            self.generateStackView.isHidden = true
        } else {
            self.trashStackView.isHidden = false
            self.generateStackView.isHidden = false
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
        
        self.numberPadBackgroundView = UIView()
        self.numberPadBackgroundView.backgroundColor = UIColor.primaryAccentColor
        self.view.insertSubview(self.numberPadBackgroundView, belowSubview: self.moneyStackView)
        
        self.numberPadBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.numberPadBackgroundView.topAnchor.constraint(equalTo: self.numberPadStackView.topAnchor, constant: -3).isActive = true
        self.numberPadBackgroundView.bottomAnchor.constraint(equalTo: self.numberPadStackView.bottomAnchor, constant: 3).isActive = true
        self.numberPadBackgroundView.leadingAnchor.constraint(equalTo: self.numberPadStackView.leadingAnchor, constant: -3).isActive = true
        self.numberPadBackgroundView.trailingAnchor.constraint(equalTo: self.numberPadStackView.trailingAnchor, constant: 3).isActive = true
        
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
        
        self.setupPopupButtons()
        
        self.updateVCWithNewContent()
        
    }
    
    @objc func modifierButtonPressed(sender: UIButton) {
        if let modifierAmount = Int(sender.titleLabel?.text ?? "") {
            self.g1840LineRunAmount += modifierAmount
        }
        
        self.lineRevenueLabel.text = "Revenue: \(self.g1840LineRunAmount)"
    }
    
    func setupPopupButtons() {
        
        var cashSourceActions: [UIAction] = []
        for (i, cashSourceGlobalIdx) in self.cashSourceGlobalIndexes.enumerated() {
            if i == 0 {
                cashSourceActions.append(UIAction(title: self.gameState.labels[cashSourceGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[cashSourceGlobalIdx].uiColor), state: .on, handler: { action in
                    self.cashSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                cashSourceActions.append(UIAction(title: self.gameState.labels[cashSourceGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[cashSourceGlobalIdx].uiColor), handler: { action in
                    self.cashSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if cashSourceActions.isEmpty {
            self.cashSourcePopupButton.isHidden = true
        } else {
            self.cashSourcePopupButton.isHidden = false
            if cashSourceActions.count == 1 {
                self.cashSourcePopupButton.setBackgroundColor(UIColor.systemGray2)
                self.cashSourcePopupButton.setPopupTitle(withText: cashSourceActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.cashSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.cashSourcePopupButton.setPopupTitle(withText: cashSourceActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.cashSourcePopupButton.menu = UIMenu(children: cashSourceActions)
            self.cashSourcePopupButton.showsMenuAsPrimaryAction = true
            self.cashSourcePopupButton.changesSelectionAsPrimaryAction = true
        }
        
        var cashDestinationActions: [UIAction] = []
        for (i, cashDestinationGlobalIdx) in self.cashDestinationGlobalIndexes.enumerated() {
            if i == 0 {
                cashDestinationActions.append(UIAction(title: self.gameState.labels[cashDestinationGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[cashDestinationGlobalIdx].uiColor), state: .on, handler: { action in
                    self.cashDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                cashDestinationActions.append(UIAction(title: self.gameState.labels[cashDestinationGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[cashDestinationGlobalIdx].uiColor), handler: { action in
                    self.cashDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if cashDestinationActions.isEmpty {
            self.cashDestinationPopupButton.isHidden = true
        } else {
            self.cashDestinationPopupButton.isHidden = false
            if cashDestinationActions.count == 1 {
                self.cashDestinationPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.cashDestinationPopupButton.setPopupTitle(withText: cashDestinationActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.cashDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.cashDestinationPopupButton.setPopupTitle(withText: cashDestinationActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.cashDestinationPopupButton.menu = UIMenu(children: cashDestinationActions)
            self.cashDestinationPopupButton.showsMenuAsPrimaryAction = true
            self.cashDestinationPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        var sharesAmountActions: [UIAction] = []
        for (i, shareAmount) in self.shareAmounts.enumerated() {
            if i == 1 {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) share", state: .on, handler: { action in
                    self.shareAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.shareAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesAmountActions.isEmpty {
            self.shareAmountPopupButton.isHidden = true
        } else {
            self.shareAmountPopupButton.isHidden = false
            if sharesAmountActions.count == 1 {
                self.shareAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.shareAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.shareAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.shareAmountPopupButton.setPopupTitle(withText: sharesAmountActions[1].title, textColor: UIColor.white)
            }
            
            self.shareAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
            self.shareAmountPopupButton.showsMenuAsPrimaryAction = true
            self.shareAmountPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        var sharesCompanyActions: [UIAction] = []
        for (i, shareCompanyGlobalIdx) in self.shareCompanyGlobalIndexes.enumerated() {
            if i == 0 {
                sharesCompanyActions.append(UIAction(title: self.gameState.labels[shareCompanyGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareCompanyGlobalIdx].uiColor), state: .on, handler: {action in
                    let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: action.title)
                    self.shareCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                    self.shareCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                    self.shareSourceGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: companyIdx)
                    self.updateShareSourcePopupButtons()
                }))
            } else {
                sharesCompanyActions.append(UIAction(title: self.gameState.labels[shareCompanyGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareCompanyGlobalIdx].uiColor), handler: {action in
                    let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: action.title)
                    self.shareCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                    self.shareCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                    self.shareSourceGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: companyIdx)
                    self.updateShareSourcePopupButtons()}))
            }
        }
        
        if sharesCompanyActions.isEmpty {
            self.shareCompanyPopupButton.isHidden = true
        } else {
            self.shareCompanyPopupButton.isHidden = false
            if sharesCompanyActions.count == 1 {
                self.shareCompanyPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.shareCompanyPopupButton.setPopupTitle(withText: sharesCompanyActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.shareCompanyPopupButton.setBackgroundColor(self.gameState.colors[self.shareCompanyGlobalIndexes[0]].uiColor)
                self.shareCompanyPopupButton.setPopupTitle(withText: sharesCompanyActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyGlobalIndexes[0]].uiColor)
            }
            
            self.shareCompanyPopupButton.menu = UIMenu(children: sharesCompanyActions)
            self.shareCompanyPopupButton.showsMenuAsPrimaryAction = true
            self.shareCompanyPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        
        var sharesSourceActions: [UIAction] = []
        for (i, shareSourceGlobalIdx) in self.shareSourceGlobalIndexes.enumerated() {
            let sharesAmount = self.gameState.shares[shareSourceGlobalIdx][self.gameState.forceConvert(index: self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.shareCompanyPopupButton.currentTitle!), backwards: true, withIndexType: .companies)]
            if i == 0 {
                sharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), state: .on, handler: { action in
                    self.shareSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), handler: { action in
                    self.shareSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesSourceActions.isEmpty {
            self.shareSourcePopupButton.isHidden = true
        } else {
            self.shareSourcePopupButton.isHidden = false
            if sharesSourceActions.count == 1 {
                self.shareSourcePopupButton.setBackgroundColor(UIColor.systemGray2)
                self.shareSourcePopupButton.setPopupTitle(withText: sharesSourceActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.shareSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.shareSourcePopupButton.setPopupTitle(withText: sharesSourceActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.shareSourcePopupButton.menu = UIMenu(children: sharesSourceActions)
            self.shareSourcePopupButton.showsMenuAsPrimaryAction = true
            self.shareSourcePopupButton.changesSelectionAsPrimaryAction = true
        }
                                                          
        
        var sharesDestinationActions: [UIAction] = []
        for (i, shareDestinationGlobalIdx) in self.shareDestinationGlobalIndexes.enumerated() {
            if i == 0 {
                sharesDestinationActions.append(UIAction(title: self.gameState.labels[shareDestinationGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareDestinationGlobalIdx].uiColor), state: .on, handler: { action in
                    self.shareDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesDestinationActions.append(UIAction(title: self.gameState.labels[shareDestinationGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareDestinationGlobalIdx].uiColor), handler: { action in
                    self.shareDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesDestinationActions.isEmpty {
            self.shareDestinationPopupButton.isHidden = true
        } else {
            self.shareDestinationPopupButton.isHidden = false
            if sharesDestinationActions.count == 1 {
                self.shareDestinationPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.shareDestinationPopupButton.setPopupTitle(withText: sharesDestinationActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.shareDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.shareDestinationPopupButton.setPopupTitle(withText: sharesDestinationActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.shareDestinationPopupButton.menu = UIMenu(children: sharesDestinationActions)
            self.shareDestinationPopupButton.showsMenuAsPrimaryAction = true
            self.shareDestinationPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        // setup of trash shares / generate shares
        if !self.gameState.isGenerateTrashHidden {
            var trashSharesSourceActions: [UIAction] = []
            for (i, shareSourceGlobalIdx) in self.trashSourceGlobalIndexes.enumerated() {
                let sharesAmount = self.gameState.shares[shareSourceGlobalIdx][self.gameState.forceConvert(index: self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.shareCompanyPopupButton.currentTitle!), backwards: true, withIndexType: .companies)]
                if i == 0 {
                    trashSharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), state: .on, handler: { action in
                        self.trashTargetPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    trashSharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), handler: { action in
                        self.trashTargetPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if trashSharesSourceActions.isEmpty {
                self.trashTargetPopupButton.isHidden = true
            } else {
                self.trashTargetPopupButton.isHidden = false
                if trashSharesSourceActions.count == 1 {
                    self.trashTargetPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.trashTargetPopupButton.setPopupTitle(withText: trashSharesSourceActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.trashTargetPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.trashTargetPopupButton.setPopupTitle(withText: trashSharesSourceActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.trashTargetPopupButton.menu = UIMenu(children: trashSharesSourceActions)
                self.trashTargetPopupButton.showsMenuAsPrimaryAction = true
                self.trashTargetPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            if sharesAmountActions.isEmpty {
                self.trashShareAmountPopupButton.isHidden = true
            } else {
                self.trashShareAmountPopupButton.isHidden = false
                if sharesAmountActions.count == 1 {
                    self.trashShareAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.trashShareAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.trashShareAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.trashShareAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.trashShareAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
                self.trashShareAmountPopupButton.showsMenuAsPrimaryAction = true
                self.trashShareAmountPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            
            var trashSharesCompanyActions: [UIAction] = []
            for (i, shareCompanyGlobalIdx) in self.shareCompanyGlobalIndexes.enumerated() {
                if i == 0 {
                    trashSharesCompanyActions.append(UIAction(title: self.gameState.labels[shareCompanyGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareCompanyGlobalIdx].uiColor), state: .on, handler: {action in
                        let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: action.title)
                        self.trashShareCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                        self.trashShareCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                        self.trashSourceGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: companyIdx)
                        self.updateTrashShareSourcePopupButtons()
                    }))
                } else {
                    trashSharesCompanyActions.append(UIAction(title: self.gameState.labels[shareCompanyGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareCompanyGlobalIdx].uiColor), handler: {action in
                        let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: action.title)
                        self.trashShareCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                        self.trashShareCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                        self.trashSourceGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: companyIdx)
                        self.updateTrashShareSourcePopupButtons()}))
                }
            }
            
            if trashSharesCompanyActions.isEmpty {
                self.trashShareCompanyPopupButton.isHidden = true
            } else {
                self.trashShareCompanyPopupButton.isHidden = false
                if trashSharesCompanyActions.count == 1 {
                    self.trashShareCompanyPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.trashShareCompanyPopupButton.setPopupTitle(withText: trashSharesCompanyActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.trashShareCompanyPopupButton.setBackgroundColor(self.gameState.colors[self.shareCompanyGlobalIndexes[0]].uiColor)
                    self.trashShareCompanyPopupButton.setPopupTitle(withText: trashSharesCompanyActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyGlobalIndexes[0]].uiColor)
                }
                
                self.trashShareCompanyPopupButton.menu = UIMenu(children: trashSharesCompanyActions)
                self.trashShareCompanyPopupButton.showsMenuAsPrimaryAction = true
                self.trashShareCompanyPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            if sharesDestinationActions.isEmpty {
                self.generateTargetPopupButton.isHidden = true
            } else {
                self.generateTargetPopupButton.isHidden = false
                if sharesDestinationActions.count == 1 {
                    self.generateTargetPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.generateTargetPopupButton.setPopupTitle(withText: sharesDestinationActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.generateTargetPopupButton.setBackgroundColor(self.gameState.colors[self.shareCompanyGlobalIndexes[0]].uiColor)
                    self.generateTargetPopupButton.setPopupTitle(withText: sharesDestinationActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyGlobalIndexes[0]].uiColor)
                }
                
                self.generateTargetPopupButton.menu = UIMenu(children: sharesDestinationActions)
                self.generateTargetPopupButton.showsMenuAsPrimaryAction = true
                self.generateTargetPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            if sharesAmountActions.isEmpty {
                self.generateShareAmountPopupButton.isHidden = true
            } else {
                self.generateShareAmountPopupButton.isHidden = false
                if sharesAmountActions.count == 1 {
                    self.generateShareAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.generateShareAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.generateShareAmountPopupButton.setBackgroundColor(self.gameState.colors[self.shareCompanyGlobalIndexes[0]].uiColor)
                    self.generateShareAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyGlobalIndexes[0]].uiColor)
                }
                
                self.generateShareAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
                self.generateShareAmountPopupButton.showsMenuAsPrimaryAction = true
                self.generateShareAmountPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            
            var generateSharesCompanyActions: [UIAction] = []
            for (i, shareCompanyGlobalIdx) in self.shareCompanyGlobalIndexes.enumerated() {
                if i == 0 {
                    generateSharesCompanyActions.append(UIAction(title: self.gameState.labels[shareCompanyGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareCompanyGlobalIdx].uiColor), state: .on, handler: {action in
                        let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: action.title)
                        self.generateShareCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                        self.generateShareCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                    }))
                } else {
                    generateSharesCompanyActions.append(UIAction(title: self.gameState.labels[shareCompanyGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareCompanyGlobalIdx].uiColor), handler: {action in
                        let companyIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: action.title)
                        self.generateShareCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: companyIdx))
                        self.generateShareCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[companyIdx].uiColor)
                    }))
                }
            }
            
            if generateSharesCompanyActions.isEmpty {
                self.generateShareCompanyPopupButton.isHidden = true
            } else {
                self.generateShareCompanyPopupButton.isHidden = false
                if generateSharesCompanyActions.count == 1 {
                    self.generateShareCompanyPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.generateShareCompanyPopupButton.setPopupTitle(withText: generateSharesCompanyActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.generateShareCompanyPopupButton.setBackgroundColor(self.gameState.colors[self.shareCompanyGlobalIndexes[0]].uiColor)
                    self.generateShareCompanyPopupButton.setPopupTitle(withText: generateSharesCompanyActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyGlobalIndexes[0]].uiColor)
                }
                
                self.generateShareCompanyPopupButton.menu = UIMenu(children: generateSharesCompanyActions)
                self.generateShareCompanyPopupButton.showsMenuAsPrimaryAction = true
                self.generateShareCompanyPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            self.trashShareAmountPopupButton.forceSelectedIndex(0)
            self.generateShareAmountPopupButton.forceSelectedIndex(0)
        }
        
        var privatesActions: [UIAction] = []
        for (i, privateBaseIndex) in self.privatesBaseIndexes.enumerated() {
            if i == 0 {
                privatesActions.append(UIAction(title: self.gameState.privatesLabels[privateBaseIndex], image: UIImage.circle(diameter: 20.0, color: UIColor.black), state: .on, handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                privatesActions.append(UIAction(title: self.gameState.privatesLabels[privateBaseIndex], image: UIImage.circle(diameter: 20.0, color: UIColor.black), handler: { action in
                    self.privatesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if privatesActions.isEmpty {
            self.privatesPopupButton.isHidden = true
        } else {
            self.privatesPopupButton.isHidden = false
            if privatesActions.count == 1 {
                self.privatesPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.privatesPopupButton.setPopupTitle(withText: privatesActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.privatesPopupButton.setBackgroundColor(UIColor.tertiaryAccentColor)
                self.privatesPopupButton.setPopupTitle(withText: privatesActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.privatesPopupButton.menu = UIMenu(children: privatesActions)
            self.privatesPopupButton.showsMenuAsPrimaryAction = true
            self.privatesPopupButton.changesSelectionAsPrimaryAction = true
        }

        
        var privatesDestinationActions: [UIAction] = []
        for (i, privatesDestinationGlobalIndex) in self.privatesDestinationGlobalIndexes.enumerated() {
            if i == 0 {
                privatesDestinationActions.append(UIAction(title: self.gameState.labels[privatesDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[privatesDestinationGlobalIndex].uiColor), state: .on, handler: { action in
                    self.privatesDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                privatesDestinationActions.append(UIAction(title: self.gameState.labels[privatesDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[privatesDestinationGlobalIndex].uiColor), handler: { action in
                    self.privatesDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if privatesDestinationActions.isEmpty {
            self.privatesDestinationPopupButton.isHidden = true
        } else {
            self.privatesDestinationPopupButton.isHidden = false
            if privatesDestinationActions.count == 1 {
                self.privatesDestinationPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.privatesDestinationPopupButton.setPopupTitle(withText: privatesDestinationActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.privatesDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.privatesDestinationPopupButton.setPopupTitle(withText: privatesDestinationActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.privatesDestinationPopupButton.menu = UIMenu(children: privatesDestinationActions)
            self.privatesDestinationPopupButton.showsMenuAsPrimaryAction = true
            self.privatesDestinationPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        // OTHER tab
        
        //LOANS
        
        if self.gameState.loans != nil {
            var loansSourceActions: [UIAction] = []
            for (i, loansSourceGlobalIndex) in self.loansSourceGlobalIndexes.enumerated() {
                if i == 0 {
                    loansSourceActions.append(UIAction(title: self.gameState.labels[loansSourceGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[loansSourceGlobalIndex].uiColor), state: .on, handler: { action in
                        self.loansSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    loansSourceActions.append(UIAction(title: self.gameState.labels[loansSourceGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[loansSourceGlobalIndex].uiColor), handler: { action in
                        self.loansSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if loansSourceActions.isEmpty {
                self.loansSourcePopupButton.isHidden = true
            } else {
                self.loansSourcePopupButton.isHidden = false
                if loansSourceActions.count == 1 {
                    self.loansSourcePopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.loansSourcePopupButton.setPopupTitle(withText: loansSourceActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.loansSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.loansSourcePopupButton.setPopupTitle(withText: loansSourceActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.loansSourcePopupButton.menu = UIMenu(children: loansSourceActions)
                self.loansSourcePopupButton.showsMenuAsPrimaryAction = true
                self.loansSourcePopupButton.changesSelectionAsPrimaryAction = true
            }
            
            var loansDestinationActions: [UIAction] = []
            for (i, loansDestinationGlobalIndex) in self.loansDestinationGlobalIndexes.enumerated() {
                if i == 0 {
                    loansDestinationActions.append(UIAction(title: self.gameState.labels[loansDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[loansDestinationGlobalIndex].uiColor), state: .on, handler: { action in
                        self.loansDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    loansDestinationActions.append(UIAction(title: self.gameState.labels[loansDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[loansDestinationGlobalIndex].uiColor), handler: { action in
                        self.loansDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if loansDestinationActions.isEmpty {
                self.loansDestinationPopupButton.isHidden = true
            } else {
                self.loansDestinationPopupButton.isHidden = false
                if loansDestinationActions.count == 1 {
                    self.loansDestinationPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.loansDestinationPopupButton.setPopupTitle(withText: loansDestinationActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.loansDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.loansDestinationPopupButton.setPopupTitle(withText: loansDestinationActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.loansDestinationPopupButton.menu = UIMenu(children: loansDestinationActions)
                self.loansDestinationPopupButton.showsMenuAsPrimaryAction = true
                self.loansDestinationPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            var loansAmountActions: [UIAction] = []
            for (i, loanAmount) in (0...10).enumerated() {
                if i == 1 {
                    loansAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(loanAmount)) : String(loanAmount)) loan", state: .on, handler: { action in
                        self.loansAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    loansAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(loanAmount)) : String(loanAmount)) loans", handler: { action in
                        self.loansAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if loansAmountActions.isEmpty {
                self.loansAmountPopupButton.isHidden = true
            } else {
                self.loansAmountPopupButton.isHidden = false
                if loansAmountActions.count == 1 {
                    self.loansAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.loansAmountPopupButton.setPopupTitle(withText: loansAmountActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.loansAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.loansAmountPopupButton.setPopupTitle(withText: loansAmountActions[1].title, textColor: UIColor.white)
                }
                
                self.loansAmountPopupButton.menu = UIMenu(children: loansAmountActions)
                self.loansAmountPopupButton.showsMenuAsPrimaryAction = true
                self.loansAmountPopupButton.changesSelectionAsPrimaryAction = true
            }
        }
        
        // BONDS
        
        if self.gameState.bonds != nil {
            var bondsSourceActions: [UIAction] = []
            for (i, bondsSourceGlobalIndex) in self.bondsSourceGlobalIndexes.enumerated() {
                if i == 0 {
                    bondsSourceActions.append(UIAction(title: self.gameState.labels[bondsSourceGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[bondsSourceGlobalIndex].uiColor), state: .on, handler: { action in
                        self.bondsSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    bondsSourceActions.append(UIAction(title: self.gameState.labels[bondsSourceGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[bondsSourceGlobalIndex].uiColor), handler: { action in
                        self.bondsSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if bondsSourceActions.isEmpty {
                self.bondsSourcePopupButton.isHidden = true
            } else {
                self.bondsSourcePopupButton.isHidden = false
                if bondsSourceActions.count == 1 {
                    self.bondsSourcePopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.bondsSourcePopupButton.setPopupTitle(withText: bondsSourceActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.bondsSourcePopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.bondsSourcePopupButton.setPopupTitle(withText: bondsSourceActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.bondsSourcePopupButton.menu = UIMenu(children: bondsSourceActions)
                self.bondsSourcePopupButton.showsMenuAsPrimaryAction = true
                self.bondsSourcePopupButton.changesSelectionAsPrimaryAction = true
            }
            
            var bondsDestinationActions: [UIAction] = []
            for (i, bondsDestinationGlobalIndex) in self.bondsDestinationGlobalIndexes.enumerated() {
                if i == 0 {
                    bondsDestinationActions.append(UIAction(title: self.gameState.labels[bondsDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[bondsDestinationGlobalIndex].uiColor), state: .on, handler: { action in
                        self.bondsDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    bondsDestinationActions.append(UIAction(title: self.gameState.labels[bondsDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[bondsDestinationGlobalIndex].uiColor), handler: { action in
                        self.bondsDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if bondsDestinationActions.isEmpty {
                self.bondsDestinationPopupButton.isHidden = true
            } else {
                self.bondsDestinationPopupButton.isHidden = false
                if bondsDestinationActions.count == 1 {
                    self.bondsDestinationPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.bondsDestinationPopupButton.setPopupTitle(withText: bondsDestinationActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.bondsDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.bondsDestinationPopupButton.setPopupTitle(withText: bondsDestinationActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.bondsDestinationPopupButton.menu = UIMenu(children: bondsDestinationActions)
                self.bondsDestinationPopupButton.showsMenuAsPrimaryAction = true
                self.bondsDestinationPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            var bondsAmountActions: [UIAction] = []
            for (i, bondAmount) in (0...10).enumerated() {
                if i == 1 {
                    bondsAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(bondAmount)) : String(bondAmount)) bond", state: .on, handler: { action in
                        self.bondsAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    bondsAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(bondAmount)) : String(bondAmount)) bonds", handler: { action in
                        self.bondsAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if bondsAmountActions.isEmpty {
                self.bondsAmountPopupButton.isHidden = true
            } else {
                self.bondsAmountPopupButton.isHidden = false
                if bondsAmountActions.count == 1 {
                    self.bondsAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.bondsAmountPopupButton.setPopupTitle(withText: bondsAmountActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.bondsAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.bondsAmountPopupButton.setPopupTitle(withText: bondsAmountActions[1].title, textColor: UIColor.white)
                }
                
                self.bondsAmountPopupButton.menu = UIMenu(children: bondsAmountActions)
                self.bondsAmountPopupButton.showsMenuAsPrimaryAction = true
                self.bondsAmountPopupButton.changesSelectionAsPrimaryAction = true
            }
        }
        
        // LINES
        
        if self.gameState.g1840LinesLabels != nil {
            
            var linesActions: [UIAction] = []
            for (_, lineBaseIndex) in self.g1840LinesBaseIndexes.enumerated() {
                linesActions.append(UIAction(title: self.gameState.g1840LinesLabels?[lineBaseIndex] ?? "", image: UIImage.circle(diameter: 20.0, color: UIColor.black), handler: { action in
                    self.linesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
            
            linesActions.insert(UIAction(title: "Select line", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                self.linesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
            }), at: 0)
            
            if linesActions.isEmpty {
                self.linesPopupButton.isHidden = true
            } else {
                self.linesPopupButton.isHidden = false
                if linesActions.count == 1 {
                    self.linesPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.linesPopupButton.setPopupTitle(withText: linesActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.linesPopupButton.setBackgroundColor(UIColor.tertiaryAccentColor)
                    self.linesPopupButton.setPopupTitle(withText: linesActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.linesPopupButton.menu = UIMenu(children: linesActions)
                self.linesPopupButton.showsMenuAsPrimaryAction = true
                self.linesPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            var linesDestinationActions: [UIAction] = []
            for (i, linesDestinationGlobalIndex) in self.g1840LinesDestinationGlobalIndexes.enumerated() {
                if i == 0 {
                    linesDestinationActions.append(UIAction(title: self.gameState.labels[linesDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[linesDestinationGlobalIndex].uiColor), state: .on, handler: { action in
                        self.linesDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    linesDestinationActions.append(UIAction(title: self.gameState.labels[linesDestinationGlobalIndex], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[linesDestinationGlobalIndex].uiColor), handler: { action in
                        self.linesDestinationPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if linesDestinationActions.isEmpty {
                self.linesDestinationPopupButton.isHidden = true
            } else {
                self.linesDestinationPopupButton.isHidden = false
                if linesDestinationActions.count == 1 {
                    self.linesDestinationPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.linesDestinationPopupButton.setPopupTitle(withText: linesDestinationActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.linesDestinationPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.linesDestinationPopupButton.setPopupTitle(withText: linesDestinationActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.linesDestinationPopupButton.menu = UIMenu(children: linesDestinationActions)
                self.linesDestinationPopupButton.showsMenuAsPrimaryAction = true
                self.linesDestinationPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            // LINE RUNS
            
            var linesRunningActions: [UIAction] = []
            for (_, lineBaseIndex) in self.g1840LinesBaseIndexes.enumerated() {
                linesRunningActions.append(UIAction(title: self.gameState.g1840LinesLabels?[lineBaseIndex] ?? "", image: UIImage.circle(diameter: 20.0, color: UIColor.black), handler: { action in
                    self.linesRunningPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
            
            linesRunningActions.insert(UIAction(title: "Select line", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                self.linesRunningPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
            }), at: 0)
            
            if linesRunningActions.isEmpty {
                self.linesRunningPopupButton.isHidden = true
            } else {
                self.linesRunningPopupButton.isHidden = false
                if linesRunningActions.count == 1 {
                    self.linesRunningPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.linesRunningPopupButton.setPopupTitle(withText: linesRunningActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.linesRunningPopupButton.setBackgroundColor(UIColor.tertiaryAccentColor)
                    self.linesRunningPopupButton.setPopupTitle(withText: linesRunningActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.linesRunningPopupButton.menu = UIMenu(children: linesRunningActions)
                self.linesRunningPopupButton.showsMenuAsPrimaryAction = true
                self.linesRunningPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            var lineRunsActions: [UIAction] = []
            let lineRunTexts = ["Run a", "Run b", "Run c"]
            for (i, lineRunBaseIndex) in self.g1840LineRunBaseIndexes.enumerated() {
                if i == 0 {
                    lineRunsActions.append(UIAction(title: lineRunTexts[i], state: .on, handler: { action in
                        self.lineRunningIndexPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                } else {
                    lineRunsActions.append(UIAction(title: lineRunTexts[i], handler: { action in
                        self.lineRunningIndexPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    }))
                }
            }
            
            if lineRunsActions.isEmpty {
                self.lineRunningIndexPopupButton.isHidden = true
            } else {
                self.lineRunningIndexPopupButton.isHidden = false
                if lineRunsActions.count == 1 {
                    self.lineRunningIndexPopupButton.setBackgroundColor(UIColor.systemGray2)
                    self.lineRunningIndexPopupButton.setPopupTitle(withText: lineRunsActions.first?.title ?? "", textColor: UIColor.white)
                } else {
                    self.lineRunningIndexPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                    self.lineRunningIndexPopupButton.setPopupTitle(withText: lineRunsActions.first?.title ?? "", textColor: UIColor.white)
                }
                
                self.lineRunningIndexPopupButton.menu = UIMenu(children: lineRunsActions)
                self.lineRunningIndexPopupButton.showsMenuAsPrimaryAction = true
                self.lineRunningIndexPopupButton.changesSelectionAsPrimaryAction = true
            }
            
        }
        
    }
    
    func updateShareSourcePopupButtons() {
    
        var sharesSourceActions: [UIAction] = []
        for (i, shareSourceGlobalIdx) in self.shareSourceGlobalIndexes.enumerated() {
            let sharesAmount = self.gameState.shares[shareSourceGlobalIdx][self.gameState.forceConvert(index: self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.shareCompanyPopupButton.currentTitle!), backwards: true, withIndexType: .companies)]
            if i == 0 {
                sharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), state: .on, handler: { action in
                    self.shareSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), handler: { action in
                    self.shareSourcePopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesSourceActions.isEmpty {
            self.shareSourcePopupButton.isHidden = true
        } else {
            self.shareSourcePopupButton.isHidden = false
            if sharesSourceActions.count == 1 {
                self.shareSourcePopupButton.setBackgroundColor(UIColor.systemGray2)
                self.shareSourcePopupButton.setPopupTitle(withText: sharesSourceActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.shareSourcePopupButton.setBackgroundColor(UIColor.tertiaryAccentColor)
                self.shareSourcePopupButton.setPopupTitle(withText: sharesSourceActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.shareSourcePopupButton.menu = UIMenu(children: sharesSourceActions)
            self.shareSourcePopupButton.showsMenuAsPrimaryAction = true
            self.shareSourcePopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    func updateTrashShareSourcePopupButtons() {
    
        var trashSharesSourceActions: [UIAction] = []
        for (i, shareSourceGlobalIdx) in self.trashSourceGlobalIndexes.enumerated() {
            let sharesAmount = self.gameState.shares[shareSourceGlobalIdx][self.gameState.forceConvert(index: self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.shareCompanyPopupButton.currentTitle!), backwards: true, withIndexType: .companies)]
            if i == 0 {
                trashSharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), state: .on, handler: { action in
                    self.trashTargetPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                trashSharesSourceActions.append(UIAction(title: self.gameState.labels[shareSourceGlobalIdx] + "\n(\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) available)", image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareSourceGlobalIdx].uiColor), handler: { action in
                    self.trashTargetPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if trashSharesSourceActions.isEmpty {
            self.trashTargetPopupButton.isHidden = true
        } else {
            self.trashTargetPopupButton.isHidden = false
            if trashSharesSourceActions.count == 1 {
                self.trashTargetPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.trashTargetPopupButton.setPopupTitle(withText: trashSharesSourceActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.trashTargetPopupButton.setBackgroundColor(UIColor.tertiaryAccentColor)
                self.trashTargetPopupButton.setPopupTitle(withText: trashSharesSourceActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.trashTargetPopupButton.menu = UIMenu(children: trashSharesSourceActions)
            self.trashTargetPopupButton.showsMenuAsPrimaryAction = true
            self.trashTargetPopupButton.changesSelectionAsPrimaryAction = true
        }
        
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = self.cashTextField.text! + titleLabelText
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
    }
    
    @IBAction func contentSegmentedControlValueChanged(sender: UISegmentedControl) {
        self.updateVCWithNewContent()
    }
    
    func updateVCWithNewContent() {
        switch self.contentSegmentedControl.selectedSegmentIndex {
        case 0:
            self.moneyStackView.isHidden = false
            self.numberPadBackgroundView.isHidden = false
            self.sharesStackView.isHidden = true
            self.privatesStackView.isHidden = true
            self.otherStackView.isHidden = true
        case 1:
            self.moneyStackView.isHidden = true
            self.numberPadBackgroundView.isHidden = true
            self.sharesStackView.isHidden = false
            self.privatesStackView.isHidden = true
            self.otherStackView.isHidden = true
        case 2:
            self.moneyStackView.isHidden = true
            self.numberPadBackgroundView.isHidden = true
            self.sharesStackView.isHidden = true
            self.privatesStackView.isHidden = false
            self.otherStackView.isHidden = true
        case 3:
            self.moneyStackView.isHidden = true
            self.numberPadBackgroundView.isHidden = true
            self.sharesStackView.isHidden = true
            self.privatesStackView.isHidden = true
            self.otherStackView.isHidden = false
            
            self.loansStackView.isHidden = self.gameState.loans == nil
            self.bondsStackView.isHidden = self.gameState.bonds == nil
            self.linesStackView.isHidden = self.gameState.g1840LinesLabels == nil
            
        default:
            break
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
        self.parentVC.refreshUI()
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        
        if self.hasUserConfirmedExtraOperations {
            self.hasUserConfirmedExtraOperations = false
            
            self.dismiss(animated: true)
            self.parentVC.refreshUI()
            return
        }
        
        if let success = self.commitButtonPressed() {
            
            if success {
                self.dismiss(animated: true)
                self.parentVC.refreshUI()
                return
            } else {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
            }
        }
    }

    func commitButtonPressed() -> Bool? {
        
        var opsToBePerformed: [Operation] = []
        var deltaForCompany = 0
        var deltaCompanyIndex = 0
        
        switch self.contentSegmentedControl.selectedSegmentIndex {
        case 0:

            if let amount = Int(self.cashTextField.text ?? ""), amount != 0 {
                
                let srcGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.cashSourcePopupButton.currentTitle!)
                let dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.cashDestinationPopupButton.currentTitle!)
                
                if srcGlobalIndex != dstGlobalIndex {
                    let op = Operation(type: .cash, uid: nil)
                    op.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(amount))
                    
                    opsToBePerformed.append(op)
                }
            }
            
            for (i, entityAmount) in self.entityAmounts.enumerated() {
                if entityAmount > 0 {
                    let op = Operation(type: .cash, uid: nil)
                    
                    op.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.gameState.forceConvert(index: i, backwards: false, withIndexType: .players), amount: Double(entityAmount))
                    
                    opsToBePerformed.append(op)
                } else if entityAmount < 0 {
                    let op = Operation(type: .cash, uid: nil)
                    
                    op.addCashDetails(sourceIndex: self.gameState.forceConvert(index: i, backwards: false, withIndexType: .players), destinationIndex: BankIndex.bank.rawValue, amount: Double(entityAmount))
                    
                    opsToBePerformed.append(op)
                }
            }

        case 1:
            
            let shareAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.shareAmountPopupButton.currentTitle!)
            let trashShareAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.trashShareAmountPopupButton.currentTitle!)
            let generateShareAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.generateShareAmountPopupButton.currentTitle!)
            
            if shareAmount == 0 && trashShareAmount == 0 && generateShareAmount == 0 {
                return true
            }
            
            let shareSrcGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: String(self.shareSourcePopupButton.currentTitle!.split(separator: "\n")[0]))
            let shareDstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.shareDestinationPopupButton.currentTitle!)
            let shareCmpGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.shareCompanyPopupButton.currentTitle!)
            let shareCmpBaseIndex: Int = self.gameState.forceConvert(index: shareCmpGlobalIndex, backwards: true, withIndexType: .companies)
            
            if shareSrcGlobalIndex != shareDstGlobalIndex {
                let op = Operation(type: .cash, uid: nil)
                op.addSharesDetails(shareSourceIndex: shareSrcGlobalIndex, shareDestinationIndex: shareDstGlobalIndex, shareAmount: shareAmount, shareCompanyBaseIndex: shareCmpBaseIndex, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex))
                
                opsToBePerformed.append(op)
            }
            
            if !self.gameState.isGenerateTrashHidden {
                if trashShareAmount != 0 {
                    let trashTargetGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: String(self.trashTargetPopupButton.currentTitle!.split(separator: "\n")[0]))
                    let trashShareCmpGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.trashShareCompanyPopupButton.currentTitle!)
                    let trashShareCmpBaseIndex: Int = self.gameState.forceConvert(index: trashShareCmpGlobalIndex, backwards: true, withIndexType: .companies)
                    
                    let op = Operation(type: .trash, uid: nil)
                    op.setOperationColorGlobalIndex(colorGlobalIndex: trashShareCmpGlobalIndex)
                    op.addTrashDetails(trashAmount: trashShareAmount, trashTargetIndex: trashTargetGlobalIndex, trashCompanyBaseIndex: trashShareCmpBaseIndex)
                    
                    opsToBePerformed.append(op)
                }
                
                if generateShareAmount != 0 {
                    let generateTargetGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.generateTargetPopupButton.currentTitle!)
                    let generateShareCmpGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.generateShareCompanyPopupButton.currentTitle!)
                    let generateShareCmpBaseIndex: Int = self.gameState.forceConvert(index: generateShareCmpGlobalIndex, backwards: true, withIndexType: .companies)
                    
                    let op = Operation(type: .generate, uid: nil)
                    op.setOperationColorGlobalIndex(colorGlobalIndex: generateShareCmpGlobalIndex)
                    op.addGenerateDetails(generateAmount: generateShareAmount, generateTargetIndex: generateTargetGlobalIndex, generateCompanyBaseIndex: generateShareCmpBaseIndex)
                    
                    opsToBePerformed.append(op)

                }
            }
            
        case 2:
            
            if let privateTitle = self.privatesPopupButton.currentTitle {
                if let privateBaseIdx = self.gameState.privatesLabels.firstIndex(of: privateTitle) {

                    let dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.privatesDestinationPopupButton.currentTitle!)
                    let ownerGlobalIdx = self.gameState.privatesOwnerGlobalIndexes[privateBaseIdx]
                    
                    if ownerGlobalIdx != dstGlobalIndex {
                        let privateOp = Operation(type: .privates, uid: nil)
                        
                        privateOp.addPrivatesDetails(privateSourceGlobalIndex: ownerGlobalIdx, privateDestinationGlobalIndex: dstGlobalIndex, privateCompanyBaseIndex: privateBaseIdx)
                        
                        opsToBePerformed.append(privateOp)
                    }
                }
            }
            
        case 3:
            
            if !self.loansStackView.isHidden {
                
                let srcGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.loansSourcePopupButton.currentTitle!)
                let dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.loansDestinationPopupButton.currentTitle!)
                let loanAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.loansAmountPopupButton.currentTitle!)
                
                if srcGlobalIndex != dstGlobalIndex {
                    let op = Operation(type: .loan, uid: nil)
                    op.addLoanDetails(loansSourceGlobalIndex: srcGlobalIndex, loansDestinationGlobalIndex: dstGlobalIndex, loansAmount: Int(loanAmount))
                    
                    opsToBePerformed.append(op)
                }
            }
            
            if !self.bondsStackView.isHidden {
                
                let srcGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.bondsSourcePopupButton.currentTitle!)
                let dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.bondsDestinationPopupButton.currentTitle!)
                let bondAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.bondsAmountPopupButton.currentTitle!)
                
                if srcGlobalIndex != dstGlobalIndex {
                    let op = Operation(type: .loan, uid: nil)
                    op.addBondDetails(bondsSourceGlobalIndex: srcGlobalIndex, bondsDestinationGlobalIndex: dstGlobalIndex, bondsAmount: Int(bondAmount))
                    
                    opsToBePerformed.append(op)
                }
            }
            
            if !self.linesStackView.isHidden {
                if let lineTitle = self.linesPopupButton.currentTitle {
                    if let lineBaseIdx = self.gameState.g1840LinesLabels?.firstIndex(of: lineTitle), let ownerGlobalIdx = self.gameState.g1840LinesOwnerGlobalIndexes?[lineBaseIdx] {
                        
                        let dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.linesDestinationPopupButton.currentTitle!)
                        
                        if ownerGlobalIdx != dstGlobalIndex && dstGlobalIndex != -1 {
                            let lineOp = Operation(type: .line, uid: nil)
                            
                            lineOp.g1840AddLineDetails(lineSourceGlobalIndex: ownerGlobalIdx, lineDestinationGlobalIndex: dstGlobalIndex, lineBaseIndex: lineBaseIdx, lineLabel: lineTitle)
                            
                            opsToBePerformed.append(lineOp)
                        }
                    }
                }
                
                if let lineTitle = self.linesRunningPopupButton.currentTitle {
                    if let lineBaseIdx = self.gameState.g1840LinesLabels?.firstIndex(of: lineTitle) {
                        let runIndex = self.lineRunningIndexPopupButton.currentTitle == "Run b" ? 1 : self.lineRunningIndexPopupButton.currentTitle == "Run c" ? 2 : 0
                        
                        let currentRunValue = self.gameState.g1840LinesRevenue?[lineBaseIdx][runIndex] ?? 0
                        
                        if self.g1840LineRunAmount > currentRunValue {
                            // should refund comp expensive if it was negative
                            if currentRunValue < 0 {
                                deltaForCompany = self.g1840LineRunAmount >= 0 ? -currentRunValue : -(self.g1840LineRunAmount - currentRunValue)
                            }
                        } else if self.g1840LineRunAmount < currentRunValue {
                            // should comp pay for negative revenue?
                            if self.g1840LineRunAmount < 0 {
                                deltaForCompany = currentRunValue >= 0 ? self.g1840LineRunAmount : (self.g1840LineRunAmount - currentRunValue)
                            }
                        }
                        
                        let runOp = Operation(type: .g1840LineRun)
                        runOp.g1840AddLineRunDetails(lineBaseIndex: lineBaseIdx, lineLabel: self.gameState.g1840LinesLabels?[lineBaseIdx] ?? "", lineRunAmount: Double(self.g1840LineRunAmount), lineRunIndex: runIndex)
                        
                        opsToBePerformed.append(runOp)
                        
                        if let cmpIdx = self.gameState.g1840LinesOwnerGlobalIndexes?[lineBaseIdx], self.gameState.getCompanyIndexes().contains(cmpIdx) {
                            if deltaForCompany != 0 {
                                let adjustmentOp = Operation(type: .cash)
                                adjustmentOp.overrideUid(uid: runOp.uid)
                                
                                if deltaForCompany > 0 {
                                    adjustmentOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: cmpIdx, amount: Double(deltaForCompany))
                                } else {
                                    adjustmentOp.addCashDetails(sourceIndex: cmpIdx, destinationIndex: BankIndex.bank.rawValue, amount: Double(deltaForCompany))
                                }
                                
                                deltaCompanyIndex = cmpIdx
                                
                                opsToBePerformed.append(adjustmentOp)
                            }
                        }
                    }
                }
            }
            
        default:
            break
        }
        
        if !opsToBePerformed.isEmpty {
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                return false
            }
            
            if self.contentSegmentedControl.selectedSegmentIndex == 3 {
                if let lineTitle = self.linesRunningPopupButton.currentTitle, let lineBaseIdx = self.gameState.g1840LinesLabels?.firstIndex(of: lineTitle) {
                    if opsToBePerformed.contains(where: { op in
                        op.type == .cash
                    }) {
                        var messageStr = ""
                        if deltaForCompany > 0 {
                            messageStr = "\(self.gameState.getCompanyLabel(atIndex: deltaCompanyIndex)) will get a refund of \(deltaForCompany) for negative revenues paid earlier"
                        } else {
                            messageStr = "\(self.gameState.getCompanyLabel(atIndex: deltaCompanyIndex)) will pay a total of \(-deltaForCompany) for the updated negative revenue"
                        }
                        
                        let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                        alert.setup(withTitle: "ATTENTION", andMessage: messageStr)
                        alert.addCancelAction(withLabel: "Cancel")
                        alert.addConfirmAction(withLabel: "OK") {
                            for op in opsToBePerformed {
                                let _ = self.gameState.perform(operation: op)
                            }
                            
                            self.hasUserConfirmedExtraOperations = true
                            self.doneButtonPressed(sender: UIButton())
                        }
                        
                        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                        
                        self.present(alert, animated: true)
                        return nil
                    }
                }
            }
                
            for op in opsToBePerformed {
                _ = self.gameState.perform(operation: op)
            }
        }
        
        return true
    }

}

extension CashViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.amountGlobalIndexes.count
        } else if collectionView.tag == 1 {
            return self.gameState.playersSize
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amountCell", for: indexPath) as! AmountCollectionViewCell
            let globalIndex = self.amountGlobalIndexes[indexPath.row]
            cell.backgroundColor = self.gameState.colors[globalIndex].uiColor
            cell.amountLabel.text = "\(self.gameState.labels[globalIndex]): " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.amounts[globalIndex])
            cell.amountLabel.textColor = self.gameState.textColors[globalIndex].uiColor
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cashAmountCollectionViewCell", for: indexPath) as! CashAmountCollectionViewCell
            cell.indexPathRow = indexPath.row
            cell.parentVC = self
            
            cell.entityLabel.paddingLeft = 10.0
            cell.entityLabel.paddingRight = 10.0
            cell.entityLabel.paddingTop = 6.0
            cell.entityLabel.paddingBottom = 6.0
            
            cell.entityLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .medium)
            cell.entityLabel.text = self.gameState.getPlayerLabel(atBaseIndex: indexPath.row)
            cell.entityLabel.textColor = self.gameState.getPlayerTextColor(atBaseIndex: indexPath.row)
            cell.entityLabel.backgroundColor = self.gameState.getPlayerColor(atBaseIndex: indexPath.row)
//            cell.entityLabel.clipsToBounds = true
//            cell.entityLabel.layer.cornerRadius = 5.0
            
            cell.cashLabel.text = "\(self.entityAmounts[indexPath.row] >= 0 ? "+" : "")\(self.entityAmounts[indexPath.row])"
            cell.cashLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension CashViewController: UICollectionViewDelegate {
    
}

extension CashViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 0 {
            if self.amountGlobalIndexes.count <= 10 {
                
                let rows = 2.0
                let cols = ceil(CGFloat(self.amountGlobalIndexes.count) / rows)
                
                return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
                
            } else {
                let width = floor((collectionView.bounds.size.width - 40.0) / 5.0)
                
                return CGSize(width: width, height: 50.0)
            }
        } else if collectionView.tag == 1 {
            let cols = Double(min(self.gameState.playersSize, 4))
            let rows = ceil(CGFloat(self.gameState.playersSize) / CGFloat(cols))
            
            return CGSize(width: collectionView.getWidthForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true), height: 150)
        }
        
        return CGSize.zero
        
    }
}
