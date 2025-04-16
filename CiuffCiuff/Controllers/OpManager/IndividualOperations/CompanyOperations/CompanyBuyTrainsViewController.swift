//
//  TrainsViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/03/23.
//

import UIKit

class CompanyBuyTrainsViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var trainOwnerGlobalIndexes: [Int] = []
    var playerIndexes: [Int] = []
    
    var g1846emergencyShareIssuesOperations: [Operation] = []
    var g1846emergencyShareIssuedMoneyRaised: Double = 0.0
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var trainPopupButton: UIButton!
    @IBOutlet weak var trainPricesStackView: UIStackView!
    @IBOutlet weak var trainPurchaseAccessoryLabel: PaddingLabel!
    @IBOutlet weak var emergencyPopupButton: UIButton!
    @IBOutlet weak var emergencyStackView: UIStackView!
    @IBOutlet weak var g1848IssueLoanStackView: UIStackView!
    @IBOutlet weak var g1848issueLoanLeftTwiceButton: UIButton!
    @IBOutlet weak var g1848issueLoanLeftThreeTimesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        if self.gameState.game == .g1848 {
            self.g1848issueLoanLeftTwiceButton.setBackgroundColor(UIColor.redAccentColor)
            self.g1848issueLoanLeftThreeTimesButton.setBackgroundColor(UIColor.redAccentColor)
        }
        
        self.plusButton.setTitle(withText: "+", fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
        self.plusButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        let cmpIndexes = self.gameState.getCompanyIndexes().filter { self.gameState.getCompanyType(atIndex: $0).canSellTrains() }
        
        if self.gameState.game == .g1840 {
            self.trainOwnerGlobalIndexes = [BankIndex.bank.rawValue]
        } else {
            self.trainOwnerGlobalIndexes = [BankIndex.bank.rawValue] + cmpIndexes
        }
        
        self.playerIndexes = Array<Int>(self.gameState.getPlayerIndexes())
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        self.emergencyStackView.isHidden = true
        self.g1848IssueLoanStackView.isHidden = true
        self.trainPurchaseAccessoryLabel.isHidden = true
        
        var trainPrices: [Int] = []
        
        if self.gameState.game == .g1846 {
            if self.gameState.currentTrainPriceIndex > 0 {
                for i in 0..<2 {
                    if self.gameState.currentTrainPriceIndex + i < self.gameState.trainPriceValues.count {
                        trainPrices.append(self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex + i])
                    }
                }
                let plusTrainIncrements = [0, 20, 50, 100]
                trainPrices.insert(trainPrices[0] + plusTrainIncrements[self.gameState.currentTrainPriceIndex], at: 1)
            } else {
                trainPrices = [self.gameState.trainPriceValues[0], self.gameState.trainPriceValues[1], self.gameState.trainPriceValues[1] + 20]
            }
        } else if self.gameState.game == .g1848 {
            for i in 0..<2 {
                if self.gameState.currentTrainPriceIndex + i < self.gameState.trainPriceValues.count {
                    trainPrices.append(self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex + i])
                }
            }
            let plusTrainIncrements = [20, 30, 40, 50, 60, 300]
            trainPrices.insert(trainPrices[0] + plusTrainIncrements[self.gameState.currentTrainPriceIndex], at: 1)
        } else {
            for i in 0..<3 {
                if self.gameState.currentTrainPriceIndex + i < self.gameState.trainPriceValues.count {
                    trainPrices.append(self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex + i])
                }
            }
        }
        
        self.trainPricesStackView.backgroundColor = UIColor.secondaryAccentColor
        if let trainPricesButtons = self.trainPricesStackView.arrangedSubviews as? [UIButton] {
            for (idx, trainPriceButton) in trainPricesButtons.enumerated() {
                if idx < trainPrices.count {
                    trainPriceButton.setTitle(withText: String(trainPrices[idx]), fontSize: 21.0, fontWeight: .heavy, textColor: UIColor.secondaryAccentColor)
                    trainPriceButton.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                } else {
                    trainPriceButton.isHidden = true
                }
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
        
        self.setupPopupButtons()
        
    }
    
    func setupPopupButtons() {
        var actions: [UIAction] = []
        for (i, trainOwnerGlobalIdx) in self.trainOwnerGlobalIndexes.enumerated() {
            if i == 0 {
                actions.append(UIAction(title: self.gameState.labels[trainOwnerGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[trainOwnerGlobalIdx].uiColor), state: .on, handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.trainPopupButton.setBackgroundColor(self.gameState.colors[idx].uiColor)
                    self.trainPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                    self.updateBottomStackView(withTrainPopupButtonTitle: action.title)
                }))
            } else {
                actions.append(UIAction(title: self.gameState.labels[trainOwnerGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[trainOwnerGlobalIdx].uiColor), handler: { action in
                    let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.trainPopupButton.setBackgroundColor(self.gameState.colors[idx].uiColor)
                    self.trainPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                    self.updateBottomStackView(withTrainPopupButtonTitle: action.title)
                }))
            }
        }
        
        if actions.isEmpty {
            self.trainPopupButton.isHidden = true
        } else {
            self.trainPopupButton.isHidden = false
            if actions.count == 1 {
                self.trainPopupButton.setBackgroundColor(self.gameState.colors[self.trainOwnerGlobalIndexes[0]].uiColor)
                self.trainPopupButton.setPopupTitle(withText: actions.first?.title ?? "", textColor: self.gameState.textColors[self.trainOwnerGlobalIndexes[0]].uiColor)
            } else {
                self.trainPopupButton.setBackgroundColor(self.gameState.colors[self.trainOwnerGlobalIndexes[0]].uiColor)
                self.trainPopupButton.setPopupTitle(withText: actions.first?.title ?? "", textColor: self.gameState.textColors[self.trainOwnerGlobalIndexes[0]].uiColor)
            }
            
            self.trainPopupButton.menu = UIMenu(children: actions)
            self.trainPopupButton.showsMenuAsPrimaryAction = true
            self.trainPopupButton.changesSelectionAsPrimaryAction = true
        }
        
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
    
    func updateBottomStackView(withTrainPopupButtonTitle trainPopupButtonTitle: String? = nil) {
        self.g1846emergencyShareIssuesOperations = []
        
        let trainOwnerStr: String = trainPopupButtonTitle ?? self.trainPopupButton.titleLabel?.text ?? "Bank"
        
        // EMERGENCY
        let trainPrice = self.getTotalAmountFromCashTextField() ?? 0
        if self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) < Double(trainPrice) && trainOwnerStr == "Bank" {
            if self.gameState.game == .g1848, let cmpIsInReceivership = self.gameState.g1848CompaniesInReceivershipFlags?[self.operatingCompanyBaseIndex], !cmpIsInReceivership {
                
                self.g1848IssueLoanStackView.isHidden = false
                self.emergencyStackView.isHidden = true
                self.trainPurchaseAccessoryLabel.isHidden = true
                
            } else if self.gameState.game == .g1846 {
                
                let sharesInPlayersHands = self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: self.operatingCompanyBaseIndex).filter { self.gameState.getPlayerIndexes().contains($0) }.map { self.gameState.getSharesPortfolioForPlayer(atIndex: $0)[self.operatingCompanyBaseIndex] }.reduce(0, +)
                
                let soldableSharesCount = min(sharesInPlayersHands - self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[self.operatingCompanyBaseIndex], self.gameState.getSharesPortfolioForCompany(atIndex: self.operatingCompanyIndex)[self.operatingCompanyBaseIndex])
                
                let shortfallAmount = Double(trainPrice) - self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)
                let distinctShareValues = self.gameState.getDistinctShareValuesSorted()
                
                let currentCmpShareValueIdx = distinctShareValues.firstIndex(of: self.gameState.getShareValue(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex) ?? 0) ?? 0
                
                var changeAfterMaxIssueOps: Double = -shortfallAmount
                var issuedSharesCount = 0
                
                if soldableSharesCount > 0 && currentCmpShareValueIdx > 1 {
                    for (i, idx) in (2..<currentCmpShareValueIdx - 1).reversed().enumerated() where changeAfterMaxIssueOps < 0 {
                        let currentShareCount = Double(i + 1)
                        
                        if currentShareCount > soldableSharesCount { break }
                        let moneyRaisedForCurrentIteration = distinctShareValues[idx] * currentShareCount
                        
                        if moneyRaisedForCurrentIteration >= shortfallAmount || idx == 2 || currentShareCount == soldableSharesCount {
                            let emergencyOp = Operation(type: .sell, uid: nil)
                            emergencyOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                            emergencyOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.operatingCompanyIndex, amount: distinctShareValues[idx] * currentShareCount)
                            emergencyOp.addSharesDetails(shareSourceIndex: self.operatingCompanyIndex, shareDestinationIndex: BankIndex.bank.rawValue, shareAmount: currentShareCount, shareCompanyBaseIndex: self.operatingCompanyBaseIndex)
                            
                            if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array(repeating: .down, count: Int(currentShareCount)), withUid: emergencyOp.uid) {
                                self.g1846emergencyShareIssuesOperations = [emergencyOp, marketOp]
                            } else {
                                self.g1846emergencyShareIssuesOperations = [emergencyOp]
                            }
                            
                            changeAfterMaxIssueOps = moneyRaisedForCurrentIteration - shortfallAmount
                            issuedSharesCount = Int(currentShareCount)
                            self.g1846emergencyShareIssuedMoneyRaised = moneyRaisedForCurrentIteration
                        }
                    }
                }
                
                self.g1848IssueLoanStackView.isHidden = true
                self.emergencyStackView.isHidden = changeAfterMaxIssueOps >= 0
                
                self.trainPurchaseAccessoryLabel.isHidden = false
                self.trainPurchaseAccessoryLabel.backgroundColor = .clear
                self.trainPurchaseAccessoryLabel.textColor = .black
                if issuedSharesCount > 0 {
                    self.trainPurchaseAccessoryLabel.text = "\(self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex)) will issue \(issuedSharesCount) shares -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: changeAfterMaxIssueOps))"
                } else {
                    self.trainPurchaseAccessoryLabel.text = "\(self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex)) cannot issue shares"
                }
                    
            } else {
                self.emergencyStackView.isHidden = false
                self.g1848IssueLoanStackView.isHidden = true
                self.trainPurchaseAccessoryLabel.isHidden = true
            }
            
            return
        }
        
        // NO EMERGENCY
        self.g1848IssueLoanStackView.isHidden = true
        self.emergencyStackView.isHidden = true
        
        let cmpIdx = self.gameState.getCompanyIndexFromPopupButtonTitle(title: trainOwnerStr)
        if cmpIdx != -1 && self.gameState.getCompanyIndexes().contains(cmpIdx) {
            
            self.trainPurchaseAccessoryLabel.isHidden = false
            self.trainPurchaseAccessoryLabel.numberOfLines = 0
            self.trainPurchaseAccessoryLabel.textAlignment = .center
            
            let buyingCompanyText = "\(self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex)) -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: (self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex) - Double(trainPrice))))"
            let sellingCompanyText = "\(self.gameState.getCompanyLabel(atIndex: cmpIdx)) -> \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: (self.gameState.getCompanyAmount(atIndex: cmpIdx) + Double(trainPrice))))"
            
            self.trainPurchaseAccessoryLabel.backgroundColor = UIColor.primaryAccentColor
            self.trainPurchaseAccessoryLabel.textColor = .white
            self.trainPurchaseAccessoryLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .medium)
            self.trainPurchaseAccessoryLabel.clipsToBounds = true
            self.trainPurchaseAccessoryLabel.layer.cornerRadius = 5.0
            self.trainPurchaseAccessoryLabel.paddingLeft = 10.0
            self.trainPurchaseAccessoryLabel.paddingRight = 10.0
            
            self.trainPurchaseAccessoryLabel.text = "\(buyingCompanyText)     //     \(sellingCompanyText)"
        } else {
            self.trainPurchaseAccessoryLabel.isHidden = true
        }
    }
    
    @IBAction func g1848IssueLoanLeftTwiceButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let issueLoanOp = Operation(type: .loan, uid: nil)
        issueLoanOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        issueLoanOp.addCashDetails(sourceIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), destinationIndex: self.operatingCompanyIndex, amount: 100.0)
        issueLoanOp.addLoanDetails(loansSourceGlobalIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), loansDestinationGlobalIndex: self.operatingCompanyIndex, loansAmount: 1)

        opsToBePerformed.append(issueLoanOp)
        
        if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .left, count: 2), withUid: issueLoanOp.uid) {
            opsToBePerformed.append(marketOp)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "There are no more loans/cash available in the Bank of England")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
            
        for op in opsToBePerformed {
            if !self.gameState.perform(operation: op) {
                return
            }
        }
            
        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
            self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
            return
            
        } else {
            self.startingAmountLabel.text = self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex))
            self.parentVC.amountsCollectionView.reloadData()
            self.trainPriceButtonPressed(sender: UIButton())
        }
        
    }
    
    @IBAction func g1848IssueLoanLeftThreeTimesButtonPressed(sender: UIButton) {
        
        var opsToBePerformed: [Operation] = []
        
        let issueLoanOp = Operation(type: .cash, uid: nil)
        issueLoanOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        issueLoanOp.addCashDetails(sourceIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), destinationIndex: self.operatingCompanyIndex, amount: 100.0)
        issueLoanOp.addLoanDetails(loansSourceGlobalIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), loansDestinationGlobalIndex: self.operatingCompanyIndex, loansAmount: 1)

        opsToBePerformed.append(issueLoanOp)
        
        if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.operatingCompanyBaseIndex, andMovements: Array<ShareValueMovementType>(repeating: .left, count: 3), withUid: issueLoanOp.uid) {
            opsToBePerformed.append(marketOp)
        }
        
        if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "There are no more loans/cash available in the Bank of England")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
         
        for op in opsToBePerformed {
            if !self.gameState.perform(operation: op) {
                return
            }
        }
         
        if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.operatingCompanyBaseIndex) {
            self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex)
            return
            
        } else {
            self.startingAmountLabel.text = self.gameState.getCompanyLabel(atIndex: self.operatingCompanyIndex) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex))
            self.parentVC.amountsCollectionView.reloadData()
            self.trainPriceButtonPressed(sender: UIButton())
        }

    }
    
    @IBAction func trainPriceButtonPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if let textFieldText = self.cashTextField.text {
                if let lastChar = textFieldText.last {
                    if lastChar.isNumber {
                        self.cashTextField.text = textFieldText + " + \(text)"
                    } else {
                        self.cashTextField.text = textFieldText + " \(text)"
                    }
                } else {
                    self.cashTextField.text = textFieldText + text
                }
            }
        }
        
        self.updateBottomStackView()
    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let text = sender.titleLabel?.text {
            if let textFieldText = self.cashTextField.text {
                if text == "+" {
                    self.cashTextField.text = textFieldText + " \(text)"
                } else {
                    if let lastChar = textFieldText.last {
                        if lastChar.isNumber {
                            self.cashTextField.text = textFieldText + text
                        } else {
                            self.cashTextField.text = textFieldText + " \(text)"
                        }
                    } else {
                        self.cashTextField.text = textFieldText + text
                    }
                }
            }
        }
        
        self.updateBottomStackView()
        
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.cashTextField.text = ""
        self.updateBottomStackView()
    }
    
    func getTotalAmountFromCashTextField() -> Int? {
        guard let amountStr = self.cashTextField.text else {
            return nil
        }
        
        let components = amountStr.split(separator: " ")
        var values: [Int] = []
    
        var isTxtLegal = true
        for (i, component) in components.enumerated() {
            if i % 2 == 0 {
                if let value = Int(component) {
                    values.append(value)
                } else {
                    isTxtLegal = false
                }
            } else {
                if !(component == "+") {
                    isTxtLegal = false
                }
            }
        }
        
        if !isTxtLegal {
            return nil
        }
        
        var amount = 0
        
        if !values.isEmpty {
            for val in values {
                amount += val
            }
        }
        
        return amount
    }

    func commitButtonPressed() -> Bool? {
        
        guard let amount = self.getTotalAmountFromCashTextField() else {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Invalid input in amount")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return false
        }

        if amount == 0 {
            return true
        }

        let srcGlobalIndex: Int = self.operatingCompanyIndex
        var dstGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.trainPopupButton.currentTitle!)
        //let shareCmpBaseIndex: Int = self.gameState.forceConvert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)
        
        if self.gameState.getBankEntityIndexes().contains(dstGlobalIndex) {
            dstGlobalIndex = BankIndex.bank.rawValue
        }
        
        let operation = Operation(type: .trains, uid: nil)
        operation.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
        operation.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(amount), trainPrice: Double(amount))
        
        if !self.gameState.isOperationLegit(operation: operation, reverted: false) {
            let trainEmergencyOpUid = Operation.generateUid()
            
            let srcAmount = self.gameState.getCompanyAmount(atIndex: self.operatingCompanyIndex)
            
            var opsToBePerformed: [Operation] = []
            
            if srcAmount > 0 {
                let trainOp = Operation(type: .trains, uid: trainEmergencyOpUid)
                trainOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                trainOp.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(srcAmount), trainPrice: Double(amount))
                opsToBePerformed.append(trainOp)
            }
            
            var remainingAmount = Double(amount) - srcAmount
            
            if !self.g1846emergencyShareIssuesOperations.isEmpty {
                self.g1846emergencyShareIssuesOperations.forEach { $0.uid = trainEmergencyOpUid }
                opsToBePerformed += self.g1846emergencyShareIssuesOperations
                
                remainingAmount -= self.g1846emergencyShareIssuedMoneyRaised
            }
            
            if !self.emergencyStackView.isHidden {
                let newSrcGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.emergencyPopupButton.currentTitle!)
                
                let emergencyOp = Operation(type: .trains, uid: trainEmergencyOpUid)
                emergencyOp.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
                emergencyOp.addCashDetails(sourceIndex: newSrcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(remainingAmount), isEmergencyEnabled: true, trainPrice: Double(amount))
                
                opsToBePerformed.append(emergencyOp)
            }
            
            if !self.gameState.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
                return false
            }
            
            for op in opsToBePerformed {
                let _ = self.gameState.perform(operation: op)
            }
            
            return true
            
        }
        
        var values: [Int] = []
        
        if let amountStr = self.cashTextField.text {
            let components = amountStr.split(separator: " ")
        
            for (i, component) in components.enumerated() {
                if i % 2 == 0 {
                    if let value = Int(component) {
                        values.append(value)
                    }
                }
            }
        }
        
        for val in values {
            let op = Operation(type: .trains, uid: nil)
            op.setOperationColorGlobalIndex(colorGlobalIndex: self.operatingCompanyIndex)
            op.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(val), trainPrice: Double(val))
            
            _ = self.gameState.perform(operation: op)
        }
        
        return true
    }

}
