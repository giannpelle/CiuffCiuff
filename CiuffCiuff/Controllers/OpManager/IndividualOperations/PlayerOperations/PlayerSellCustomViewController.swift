//
//  PlayerSellCustomViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/03/23.
//

import UIKit

class PlayerSellCustomViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var shareAmounts: [Double] = []
    var shareCompanyIndexes: [Int] = []
    var buyersGlobalIndices: [Int] = []
    var hasManuallyEditedCashTextField: Bool = false
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var cashTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var numberPadStackView: UIStackView!
    @IBOutlet weak var sharesAmountPopupButton: UIButton!
    @IBOutlet weak var sharesCompanyPopupButton: UIButton!
    //@IBOutlet weak var buyersPopupButton: UIButton!
    
    @IBOutlet weak var backToSmartSellButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backToSmartSellButton.setTitle(withText: "Back to smart SELL", fontSize: 18.0, fontWeight: .bold, textColor: UIColor.white)
        self.backToSmartSellButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.sellButton.setTitle(withText: "SELL", fontSize: 18.0, fontWeight: .bold, textColor: UIColor.white)
        self.sellButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.shareAmounts = self.gameState.getPredefinedShareAmounts()
        
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
                self.shareCompanyIndexes.append(cmpIndex)
            }
        }
        
        if self.shareCompanyIndexes.isEmpty {
            self.buyersGlobalIndices = []
        } else {
            switch self.gameState.getCompanyType(atIndex: self.shareCompanyIndexes[0]) {
            case .g1848BoE:
                self.buyersGlobalIndices = [BankIndex.ipo.rawValue]
            case .g1840Stadtbahn, .g1846Miniature, .g1856CGR, .g18MEXMinor, .standard:
                self.buyersGlobalIndices = [BankIndex.bank.rawValue]//Array<Int>(self.gameState.getBankEntityIndexes())
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
            self.setupPopupButtons()
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
    
    func setupPopupButtons() {
        var sharesAmountActions: [UIAction] = []
        for shareAmount in self.shareAmounts {
            if shareAmount == 1 {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) share", state: .on, handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            } else {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                }))
            }
        }
        
        if sharesAmountActions.isEmpty {
            self.sharesAmountPopupButton.isHidden = true
        } else {
            self.sharesAmountPopupButton.isHidden = false
            if sharesAmountActions.count == 1 {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.sharesAmountPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.sharesAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
            self.sharesAmountPopupButton.showsMenuAsPrimaryAction = true
            self.sharesAmountPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        var sharesCompanyActions: [UIAction] = []

        for (i, shareCompanyIdx) in self.shareCompanyIndexes.enumerated() {
            if i == 0 {
                sharesCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), state: .on, handler: { action in
                    let cmpIdx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.colors[cmpIdx].uiColor)
                    self.sharesCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[cmpIdx].uiColor)
                    
                    let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
                    
                    switch self.gameState.getCompanyType(atIndex: self.shareCompanyIndexes[0]) {
                    case .g1848BoE:
                        self.buyersGlobalIndices = [BankIndex.ipo.rawValue]
                    case .g1840Stadtbahn, .g1846Miniature, .g1856CGR, .g18MEXMinor, .standard:
                        self.buyersGlobalIndices = [BankIndex.bank.rawValue]//Array<Int>(self.gameState.getBankEntityIndexes())
                    }
                    
                    //self.buildBuyersPopupButton()
                    
                    if !self.hasManuallyEditedCashTextField {
                        if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) {
                            self.cashTextField.text = "\(Int(cmpShareValue))"
                        } else if let PARvalue = self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx), PARvalue != 0 {
                            self.cashTextField.text = "\(PARvalue)"
                        }
                    }
                }))
            } else {
                sharesCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), handler: { action in
                    let cmpIdx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.colors[cmpIdx].uiColor)
                    self.sharesCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[cmpIdx].uiColor)
                    
                    let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
                    
                    switch self.gameState.getCompanyType(atIndex: self.shareCompanyIndexes[0]) {
                    case .g1848BoE:
                        self.buyersGlobalIndices = [BankIndex.ipo.rawValue]
                    case .g1840Stadtbahn, .g1846Miniature, .g1856CGR, .g18MEXMinor, .standard:
                        self.buyersGlobalIndices = [BankIndex.bank.rawValue]//Array<Int>(self.gameState.getBankEntityIndexes())
                    }
                    
                    //self.buildBuyersPopupButton()
                    
                    if !self.hasManuallyEditedCashTextField {
                        if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) {
                            self.cashTextField.text = "\(Int(cmpShareValue))"
                        } else if let PARvalue = self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx), PARvalue != 0 {
                            self.cashTextField.text = "\(PARvalue)"
                        }
                    }
                }))
            }
        }
        
        if sharesCompanyActions.isEmpty {
            self.sharesCompanyPopupButton.isHidden = true
        } else {
            self.sharesCompanyPopupButton.isHidden = false
            if sharesCompanyActions.count == 1 {
                self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: self.shareCompanyIndexes[0]))
                self.sharesCompanyPopupButton.setPopupTitle(withText: sharesCompanyActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyIndexes[0]].uiColor)
            } else {
                self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: self.shareCompanyIndexes[0]))
                self.sharesCompanyPopupButton.setPopupTitle(withText: sharesCompanyActions.first?.title ?? "", textColor: self.gameState.textColors[self.shareCompanyIndexes[0]].uiColor)
            }
            
            self.sharesCompanyPopupButton.menu = UIMenu(children: sharesCompanyActions)
            self.sharesCompanyPopupButton.showsMenuAsPrimaryAction = true
            self.sharesCompanyPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        //self.buildBuyersPopupButton()
        
        if let cmpIdx = self.shareCompanyIndexes.first {
            let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
            
            if !self.hasManuallyEditedCashTextField {
                if let cmpShareValue = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) {
                    self.cashTextField.text = "\(Int(cmpShareValue))"
                } else if let PARvalue = self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx), PARvalue != 0 {
                    self.cashTextField.text = "\(PARvalue)"
                }
            }
        }
    }
    
//    func buildBuyersPopupButton() {
//        
//        var sharesBuyersActions: [UIAction] = []
//        let sharesCompanyIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.sharesCompanyPopupButton.currentTitle!)
//        let sharesCompanyBaseIndex = self.gameState.convert(index: sharesCompanyIndex, backwards: true, withIndexType: .companies)
//        
//        for (i, shareBuyerGlobalIdx) in self.buyersGlobalIndices.enumerated() {
//            if i == 0 {
//                sharesBuyersActions.append(UIAction(title: self.gameState.labels[shareBuyerGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareBuyerGlobalIdx].uiColor), state: .on, handler: { action in
//                    self.buyersPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
//                }))
//            } else {
//                sharesBuyersActions.append(UIAction(title: self.gameState.labels[shareBuyerGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[shareBuyerGlobalIdx].uiColor), handler: { action in
//                    self.buyersPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
//                }))
//            }
//        }
//        
//        if sharesBuyersActions.isEmpty {
//            self.buyersPopupButton.isHidden = true
//        } else {
//            self.buyersPopupButton.isHidden = false
//            if sharesBuyersActions.count == 1 {
//                self.buyersPopupButton.setBackgroundColor(UIColor.systemGray2
//                self.buyersPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
//            } else {
//                self.buyersPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
//                self.buyersPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
//            }
//            
//            self.buyersPopupButton.menu = UIMenu(children: sharesBuyersActions)
//            self.buyersPopupButton.showsMenuAsPrimaryAction = true
//            self.buyersPopupButton.changesSelectionAsPrimaryAction = true
//        }
//    }
    
    @IBAction func numberPadButtonPressed(sender: UIButton) {
        if let titleLabelText = sender.titleLabel?.text {
            self.cashTextField.text = self.cashTextField.text! + titleLabelText
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.hasManuallyEditedCashTextField = true
        self.cashTextField.text = ""
    }
    
    @IBAction func sellButtonPressed(sender: UIButton) {
        
        guard let amountStr = self.cashTextField.text else {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        let shareAmount = self.gameState.getAmountFromPopupButtonTitle(title: self.sharesAmountPopupButton.currentTitle!)
    
        var amount = 0.0
        
        if self.gameState.buySellRoundPolicyOnTotal == .roundUp {
            amount = floor((Double(amountStr) ?? 0.0) * shareAmount)
        } else {
            amount = ceil((Double(amountStr) ?? 0.0) * shareAmount)
        }
        
        if amount == 0.0 && shareAmount == 0.0 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        let srcGlobalIndex: Int = BankIndex.bank.rawValue
        let dstGlobalIndex: Int = self.operatingPlayerIndex
        
        let shareDstGlobalIndex: Int = BankIndex.bank.rawValue//self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.buyersPopupButton.currentTitle!)
        let shareSrcGlobalIndex: Int = self.operatingPlayerIndex
        let shareCmpGlobalIndex: Int = self.gameState.getGlobalIndexFromPopupButtonTitle(title: self.sharesCompanyPopupButton.currentTitle!)
        let shareCmpBaseIndex: Int = self.gameState.forceConvert(index: shareCmpGlobalIndex, backwards: true, withIndexType: .companies)
        
        var opsToBePerformed: [Operation] = []
        
        let operation = Operation(type: self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex) < 0 ? .sellEmergency : .sell, uid: nil)
        operation.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: amount)
        operation.addSharesDetails(shareSourceIndex: shareSrcGlobalIndex, shareDestinationIndex: shareDstGlobalIndex, shareAmount: shareAmount, shareCompanyBaseIndex: shareCmpBaseIndex, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex))

        opsToBePerformed.append(operation)
        
        if self.gameState.game == .g1846 {
            if let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex), presidentPlayerIdx == self.operatingPlayerIndex {
                opsToBePerformed += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: shareCmpBaseIndex, andSharesAmount: shareAmount, withUid: operation.uid)
            }
        } else {
            opsToBePerformed += self.gameState.getDropOperationFromSELL(forCompanyAtBaseIndex: shareCmpBaseIndex, andSharesAmount: shareAmount, withUid: operation.uid)
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
    
    @IBAction func activeSmartSellVC(sender: UIButton) {
        self.parentVC.loadSmartSellVC()
    }

    func commitButtonPressed() -> Bool? {
        return true
    }

}
