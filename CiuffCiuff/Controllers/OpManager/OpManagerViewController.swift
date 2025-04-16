//
//  OpManagerViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 01/01/23.
//

import UIKit

class OpManagerViewController: UIViewController {
    
    var parentVC: HomeViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int? = nil
    var operatingPlayerIndex: Int? = nil
    var g1840OperatingLineBaseIndex: Int? = nil
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    var childVC: UIViewController!
    var suggestedActionMenuIndex: Int? = nil
    var overriddenActions: [Int]? = nil
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var topBarBackgroundView: UIView!
    @IBOutlet weak var actionMenuStackView: UIStackView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var amountsCollectionView: UICollectionView!
    @IBOutlet weak var amountsCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var legalActions: [Int] = []
    var amountGlobalIndexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.primaryAccentColor
        
        self.mainScrollView.backgroundColor = UIColor.secondaryAccentColor
    
        if let top = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last?.safeAreaInsets.top {
            self.mainScrollView.contentInset.top = -top
        }
        self.mainScrollView.automaticallyAdjustsScrollIndicatorInsets = false
        
        self.topBarBackgroundView.backgroundColor = UIColor.primaryAccentColor
        
        self.cancelButton.setTitle(withText: "Cancel", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.cancelButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.doneButton.setTitle(withText: "Done", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.doneButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.cancelButton.layer.borderColor = UIColor.white.cgColor
        self.cancelButton.layer.borderWidth = 2
        self.cancelButton.layer.cornerRadius = 8
        self.cancelButton.clipsToBounds = true
        
        self.doneButton.layer.borderColor = UIColor.white.cgColor
        self.doneButton.layer.borderWidth = 2
        self.doneButton.layer.cornerRadius = 8
        self.doneButton.clipsToBounds = true
        
        self.amountsCollectionView.delegate = self
        self.amountsCollectionView.dataSource = self
        
        // PRESENT CUSTOM ACTIONS
        if let overriddenActions = self.overriddenActions {
            self.legalActions = overriddenActions
        } else {
            
            // CUSTOMIZE ACTIONS FOR COMPANIES
            if let cmpIndex = self.operatingCompanyIndex {
                self.legalActions = self.gameState.getCompanyType(atIndex: cmpIndex).getCustomizedActionMenuTypes(fromLegalActions: self.gameState.legalActionsCompanies)
                
                if self.gameState.isCompanyFloated(atIndex: cmpIndex) {
                    self.legalActions = self.legalActions.filter { $0 != ActionMenuType.float.rawValue }
                }
                
                if self.gameState.game == .g18MEX && self.gameState.getCompanyLabel(atIndex: cmpIndex) == "NDM" {
                    self.legalActions.append(ActionMenuType.g18MEXMerge.rawValue)
                }
            }
            
            // CUSTOMIZE ACTIONS FOR PLAYERS
            if let _ = self.operatingPlayerIndex {
                self.legalActions = self.gameState.legalActionsPlayers
            }
        }
        
        self.amountGlobalIndexes = Array<Int>([BankIndex.bank.rawValue]) + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
        
        for btn in (self.actionMenuStackView.arrangedSubviews as! [UIButton]) {
            if legalActions.contains(btn.tag) {
                btn.isHidden = false
                btn.titleLabel?.textAlignment = .center
                btn.layer.borderColor = UIColor.white.cgColor
            } else {
                btn.isHidden = true
                btn.layer.borderColor = UIColor.white.cgColor
            }
        }
        
        self.emptyLabel.text = "This action is not available\ngiven the current state of the game"
        self.emptyLabel.isHidden = true
        
        self.childVC = UIViewController()
        
        if self.legalActions.count == 1 {
            self.activateMenuAction(atIndex: self.legalActions[0])
            self.loadViewController(withTag: self.legalActions[0])
            return
        }
        
        if let operatingCompanyIndex = self.operatingCompanyIndex {
            
            if let suggestedActionMenuIndex = self.suggestedActionMenuIndex, legalActions.contains(suggestedActionMenuIndex) {
                self.activateMenuAction(atIndex: suggestedActionMenuIndex)
                self.loadViewController(withTag: suggestedActionMenuIndex)
                return
            }
            
            //let operatingCompanyBaseIndex = self.gameState.convert(index: operatingCompanyIndex, backwards: true, withIndexType: .companies)
            if self.gameState.game == .g1848 && self.gameState.getCompanyType(atIndex: operatingCompanyIndex) == .g1848BoE && legalActions.contains(ActionMenuType.operate.rawValue) {
                self.activateMenuAction(atIndex: ActionMenuType.operate.rawValue)
                self.loadViewController(withTag: ActionMenuType.operate.rawValue)
                return
//            } else if !self.gameState.hasCompanyBoughtTrain(atBaseIndex: operatingCompanyBaseIndex) {
//                self.activateMenuAction(atIndex: ActionMenuType.buyTrain.rawValue)
//                self.loadViewController(withTag: ActionMenuType.buyTrain.rawValue)
            } else {
                
                if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(self.gameState.forceConvert(index: operatingCompanyIndex, backwards: true, withIndexType: .companies)) && legalActions.contains(ActionMenuType.close.rawValue) {
                    self.activateMenuAction(atIndex: ActionMenuType.close.rawValue)
                    self.loadViewController(withTag: ActionMenuType.close.rawValue)
                    return
                }
                
                if !self.gameState.isCompanyFloated(atIndex: operatingCompanyIndex) && legalActions.contains(ActionMenuType.float.rawValue) {
                    self.activateMenuAction(atIndex: ActionMenuType.float.rawValue)
                    self.loadViewController(withTag: ActionMenuType.float.rawValue)
                    return
                }
                
                if self.gameState.activeOperations.first(where: { $0.type == .trains && $0.sourceGlobalIndex == operatingCompanyIndex }) == nil && legalActions.contains(ActionMenuType.buyTrain.rawValue) {
                    self.activateMenuAction(atIndex: ActionMenuType.buyTrain.rawValue)
                    self.loadViewController(withTag: ActionMenuType.buyTrain.rawValue)
                    return
                }
                
                if self.gameState.game == .g18MEX {
                    if self.gameState.getCompanyType(atIndex: operatingCompanyIndex) == .g18MEXMinor && legalActions.contains(ActionMenuType.operate.rawValue) {
                        self.activateMenuAction(atIndex: ActionMenuType.operate.rawValue)
                        self.loadViewController(withTag: ActionMenuType.operate.rawValue)
                        return
                    } else if let lastOp = self.gameState.activeOperations.last, lastOp.sourceGlobalIndex == operatingCompanyIndex || lastOp.destinationGlobalIndex == operatingCompanyIndex && legalActions.contains(ActionMenuType.operate.rawValue) {
                        self.activateMenuAction(atIndex: ActionMenuType.operate.rawValue)
                        self.loadViewController(withTag: ActionMenuType.operate.rawValue)
                        return
                    } else if legalActions.contains(ActionMenuType.mail.rawValue){
                        self.activateMenuAction(atIndex: ActionMenuType.mail.rawValue)
                        self.loadViewController(withTag: ActionMenuType.mail.rawValue)
                        return
                    }
                } else if legalActions.contains(ActionMenuType.operate.rawValue){
                    self.activateMenuAction(atIndex: ActionMenuType.operate.rawValue)
                    self.loadViewController(withTag: ActionMenuType.operate.rawValue)
                    return
                }
            }
            
        } else if let _ = self.operatingPlayerIndex {
            
            if legalActions.contains(ActionMenuType.buyShares.rawValue) {
                self.activateMenuAction(atIndex: ActionMenuType.buyShares.rawValue)
                self.loadViewController(withTag: ActionMenuType.buyShares.rawValue)
                return
            }
        }
        
        if let firstActionIndex = self.legalActions.first {
            self.activateMenuAction(atIndex: firstActionIndex)
            self.loadViewController(withTag: firstActionIndex)
        }
        
    }
    
    func activateMenuAction(atIndex index: Int) {
        for btn in (self.actionMenuStackView.arrangedSubviews as! [UIButton]) {
            if btn.tag != index {
                btn.setTitle(withText: btn.currentTitle ?? "", fontSize: 16.0, fontWeight: .bold, textColor: UIColor.white)
                btn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                btn.layer.borderWidth = 2
            } else {
                btn.setTitle(withText: btn.currentTitle ?? "", fontSize: 16.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
                btn.setBackgroundColor(UIColor.white, isRectangularShape: true)
                btn.layer.borderWidth = 0
                if let actionMenuType = ActionMenuType(rawValue: index), actionMenuType.shouldHideCommitButton() {
                    self.doneButton.isHidden = true
                } else {
                    self.doneButton.isHidden = false
                }
            }
        }
    }
    
    @IBAction func actionButtonPressed(sender: UIButton) {
        self.activateMenuAction(atIndex: sender.tag)
        self.loadViewController(withTag: sender.tag)
    }
    
    func loadSmartBuyVC() {
    
        let buyVC = storyboard?.instantiateViewController(withIdentifier: "playerBuyViewController") as! PlayerBuyViewController
        
        buyVC.parentVC = self
        buyVC.gameState = self.gameState
        buyVC.operatingPlayerIndex = self.operatingPlayerIndex
        buyVC.startingAmountText = self.startingAmountText
        buyVC.startingAmountColor = self.startingAmountColor
        buyVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
        buyVC.startingAmountFont = self.startingAmountFont
        
        self.loadSmartCustomBuySellVC(vc: buyVC)
    }
    
    func loadCustomBuyVC() {
        
        let buyVC = storyboard?.instantiateViewController(withIdentifier: "playerBuyCustomViewController") as! PlayerBuyCustomViewController
        
        buyVC.parentVC = self
        buyVC.gameState = self.gameState
        buyVC.operatingPlayerIndex = self.operatingPlayerIndex
        buyVC.startingAmountText = self.startingAmountText
        buyVC.startingAmountColor = self.startingAmountColor
        buyVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
        buyVC.startingAmountFont = self.startingAmountFont
        
        self.loadSmartCustomBuySellVC(vc: buyVC)
    }
    
    func loadSmartSellVC() {
        
        let sellVC = storyboard?.instantiateViewController(withIdentifier: "playerSellViewController") as! PlayerSellViewController
        
        sellVC.parentVC = self
        sellVC.gameState = self.gameState
        sellVC.operatingPlayerIndex = self.operatingPlayerIndex
        sellVC.startingAmountText = self.startingAmountText
        sellVC.startingAmountColor = self.startingAmountColor
        sellVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
        sellVC.startingAmountFont = self.startingAmountFont
        
        self.loadSmartCustomBuySellVC(vc: sellVC)
    }
    
    func loadCustomSellVC() {
        
        let sellVC = storyboard?.instantiateViewController(withIdentifier: "playerSellCustomViewController") as! PlayerSellCustomViewController
        
        sellVC.parentVC = self
        sellVC.gameState = self.gameState
        sellVC.operatingPlayerIndex = self.operatingPlayerIndex
        sellVC.startingAmountText = self.startingAmountText
        sellVC.startingAmountColor = self.startingAmountColor
        sellVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
        sellVC.startingAmountFont = self.startingAmountFont
        
        self.loadSmartCustomBuySellVC(vc: sellVC)
    }
    
    func loadSmartCustomBuySellVC(vc: UIViewController) {
        
        self.childVC.willMove(toParent: nil)
        self.childVC.view.removeFromSuperview()
        self.childVC.removeFromParent()
        
        self.addChild(vc)
        self.childView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.childView.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.childView.bottomAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.childView.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.childView.rightAnchor).isActive = true
        vc.didMove(toParent: self)
        self.childVC = vc
    }
    
    func loadViewController(withTag tag: Int) {
        
        self.childVC.willMove(toParent: nil)
        self.childVC.view.removeFromSuperview()
        self.childVC.removeFromParent()
        
        var childrenVC: UIViewController!
        
        var isOperatingACompany = false
        if let _ = self.operatingCompanyIndex {
            isOperatingACompany = true
        }
        
        if let actionMenuType = ActionMenuType(rawValue: tag) {
            
            switch actionMenuType {
            case ActionMenuType.turnOrder:
                let turnOrderVC = storyboard?.instantiateViewController(withIdentifier: "playerTurnOrderViewController") as! PlayerTurnOrderViewController
                turnOrderVC.parentVC = self
                turnOrderVC.gameState = self.gameState
                
                childrenVC = turnOrderVC
                
            case ActionMenuType.buyPrivate:
                let companyBuyPrivateVC = storyboard?.instantiateViewController(withIdentifier: "companyBuyPrivateViewController") as! CompanyBuyPrivateViewController
                companyBuyPrivateVC.parentVC = self
                companyBuyPrivateVC.gameState = self.gameState
                companyBuyPrivateVC.operatingCompanyIndex = self.operatingCompanyIndex
                companyBuyPrivateVC.startingAmountText = self.startingAmountText
                companyBuyPrivateVC.startingAmountColor = self.startingAmountColor
                companyBuyPrivateVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                companyBuyPrivateVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = companyBuyPrivateVC
                
            case ActionMenuType.float:
                if let cmpBaseIdx = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies) {
                    if self.gameState.game == .g1856 && self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx) == .g1856CGR {
                        let floatCompanyVC = storyboard?.instantiateViewController(withIdentifier: "company1856CGRFloatCompanyViewController") as! Company1856CGRFloatCompanyViewController
                        floatCompanyVC.parentVC = self
                        floatCompanyVC.gameState = self.gameState
                        
                        childrenVC = floatCompanyVC
                        
                    } else {
                        
                        let floatCompanyVC = storyboard?.instantiateViewController(withIdentifier: "companyFloatViewController") as! CompanyFloatViewController
                        floatCompanyVC.parentVC = self
                        floatCompanyVC.gameState = self.gameState
                        
                        floatCompanyVC.operatingCompanyIndex = self.operatingCompanyIndex
                        floatCompanyVC.startingAmountText = self.startingAmountText
                        floatCompanyVC.startingAmountColor = self.startingAmountColor
                        floatCompanyVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                        floatCompanyVC.startingAmountFont = UIFont.systemFont(ofSize: 26, weight: .bold)
                        
                        childrenVC = floatCompanyVC
                    }
                }
                
            case ActionMenuType.tradePrivate:
                let tradePrivateVC = storyboard?.instantiateViewController(withIdentifier: "g18mexTradePrivateViewController") as! Player18MEXTradePrivateViewController
                tradePrivateVC.parentVC = self
                tradePrivateVC.gameState = self.gameState
                tradePrivateVC.operatingPlayerIndex = self.operatingPlayerIndex
                tradePrivateVC.startingAmountText = self.startingAmountText
                tradePrivateVC.startingAmountColor = self.startingAmountColor
                tradePrivateVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                tradePrivateVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = tradePrivateVC

            case ActionMenuType.sellPrivate:
                let sellPrivateVC = storyboard?.instantiateViewController(withIdentifier: "sellPrivateViewController") as! PlayerSellPrivateViewController
                sellPrivateVC.parentVC = self
                sellPrivateVC.gameState = self.gameState
                sellPrivateVC.operatingPlayerIndex = self.operatingPlayerIndex
                sellPrivateVC.startingAmountText = self.startingAmountText
                sellPrivateVC.startingAmountColor = self.startingAmountColor
                sellPrivateVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                sellPrivateVC.startingAmountFont = self.startingAmountFont
                
                
                childrenVC = sellPrivateVC
            case ActionMenuType.buyTrain:
                let trainsVC = storyboard?.instantiateViewController(withIdentifier: "trainsViewController") as! CompanyBuyTrainsViewController
                trainsVC.parentVC = self
                trainsVC.gameState = self.gameState
                trainsVC.operatingCompanyIndex = self.operatingCompanyIndex
                trainsVC.startingAmountText = self.startingAmountText
                trainsVC.startingAmountColor = self.startingAmountColor
                trainsVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                trainsVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = trainsVC
            case ActionMenuType.mail:
                let mailVC = storyboard?.instantiateViewController(withIdentifier: "g18mexMailViewController") as! Company18MEXCollectMailViewController
                mailVC.parentVC = self
                mailVC.gameState = self.gameState
                mailVC.operatingCompanyIndex = self.operatingCompanyIndex
                mailVC.startingAmountText = self.startingAmountText
                mailVC.startingAmountColor = self.startingAmountColor
                mailVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                mailVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = mailVC
            case ActionMenuType.tilesTokens:
                let tokensVC = storyboard?.instantiateViewController(withIdentifier: "tokensViewController") as! CompanyBuyTokensViewController
                tokensVC.parentVC = self
                tokensVC.gameState = self.gameState
                tokensVC.g1840OperatingLineBaseIndex = self.g1840OperatingLineBaseIndex
                tokensVC.operatingCompanyIndex = self.operatingCompanyIndex
                tokensVC.startingAmountText = self.startingAmountText
                tokensVC.startingAmountColor = self.startingAmountColor
                tokensVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                tokensVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = tokensVC
            case ActionMenuType.buyShares:
                if isOperatingACompany {
                    let buyVC = storyboard?.instantiateViewController(withIdentifier: "companyBuyOwnSharesViewController") as! CompanyBuyOwnSharesViewController
                    
                    buyVC.parentVC = self
                    buyVC.gameState = self.gameState
                    buyVC.operatingCompanyIndex = self.operatingCompanyIndex
                    buyVC.startingAmountText = self.startingAmountText
                    buyVC.startingAmountColor = self.startingAmountColor
                    buyVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    buyVC.startingAmountFont = self.startingAmountFont
                    
                    childrenVC = buyVC
                } else {
                    let buyVC = storyboard?.instantiateViewController(withIdentifier: "playerBuyViewController") as! PlayerBuyViewController
                    
                    buyVC.parentVC = self
                    buyVC.gameState = self.gameState
                    buyVC.operatingPlayerIndex = self.operatingPlayerIndex
                    buyVC.startingAmountText = self.startingAmountText
                    buyVC.startingAmountColor = self.startingAmountColor
                    buyVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    buyVC.startingAmountFont = self.startingAmountFont
                    
                    childrenVC = buyVC
                }
            case ActionMenuType.sellShares:
                if isOperatingACompany {
                    let sellVC = storyboard?.instantiateViewController(withIdentifier: "companySellOwnSharesViewController") as! CompanySellOwnSharesViewController
                    
                    sellVC.parentVC = self
                    sellVC.gameState = self.gameState
                    sellVC.operatingCompanyIndex = self.operatingCompanyIndex
                    sellVC.startingAmountText = self.startingAmountText
                    sellVC.startingAmountColor = self.startingAmountColor
                    sellVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    sellVC.startingAmountFont = self.startingAmountFont
                    
                    childrenVC = sellVC
                } else {
                    let sellVC = storyboard?.instantiateViewController(withIdentifier: "playerSellViewController") as! PlayerSellViewController
                    
                    sellVC.parentVC = self
                    sellVC.gameState = self.gameState
                    sellVC.operatingPlayerIndex = self.operatingPlayerIndex
                    sellVC.startingAmountText = self.startingAmountText
                    sellVC.startingAmountColor = self.startingAmountColor
                    sellVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    sellVC.startingAmountFont = self.startingAmountFont
                    
                    childrenVC = sellVC
                }
            case ActionMenuType.g1846issueShares:
                let issueSharesVC = storyboard?.instantiateViewController(withIdentifier: "company1846IssueSharesViewController") as! Company1846IssueSharesViewController
                
                issueSharesVC.parentVC = self
                issueSharesVC.gameState = self.gameState
                issueSharesVC.operatingCompanyIndex = self.operatingCompanyIndex
                issueSharesVC.startingAmountText = self.startingAmountText
                issueSharesVC.startingAmountColor = self.startingAmountColor
                issueSharesVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                issueSharesVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = issueSharesVC
            case ActionMenuType.g1846redeemShares:
                let redeemSharesVC = storyboard?.instantiateViewController(withIdentifier: "company1846RedeemSharesViewController") as! Company1846RedeemSharesViewController
                
                redeemSharesVC.parentVC = self
                redeemSharesVC.gameState = self.gameState
                redeemSharesVC.operatingCompanyIndex = self.operatingCompanyIndex
                redeemSharesVC.startingAmountText = self.startingAmountText
                redeemSharesVC.startingAmountColor = self.startingAmountColor
                redeemSharesVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                redeemSharesVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = redeemSharesVC
            case ActionMenuType.operate:
                if isOperatingACompany {
                    if let operatingCompanyIndex = operatingCompanyIndex, self.gameState.getCompanyType(atIndex: operatingCompanyIndex) == .g18MEXMinor {
                        let operationVC = storyboard?.instantiateViewController(withIdentifier: "g18mexMinorOperateViewController") as! Company18MEXMinorOperateViewController
                        
                        operationVC.parentVC = self
                        operationVC.gameState = self.gameState
                        operationVC.operatingCompanyIndex = operatingCompanyIndex
                        operationVC.startingAmountText = self.startingAmountText
                        operationVC.startingAmountColor = self.startingAmountColor
                        operationVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                        operationVC.startingAmountFont = self.startingAmountFont
                        
                        childrenVC = operationVC
                    } else if let operatingCompanyIndex = operatingCompanyIndex, self.gameState.getCompanyType(atIndex: operatingCompanyIndex) == .g1846Miniature {
                        let operationVC = storyboard?.instantiateViewController(withIdentifier: "company1846MiniatureOperateViewController") as! Company1846MiniatureOperateViewController
                        
                        operationVC.parentVC = self
                        operationVC.gameState = self.gameState
                        operationVC.operatingCompanyIndex = operatingCompanyIndex
                        operationVC.startingAmountText = self.startingAmountText
                        operationVC.startingAmountColor = self.startingAmountColor
                        operationVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                        operationVC.startingAmountFont = self.startingAmountFont
                        
                        childrenVC = operationVC
                    } else if let operatingCompanyIndex = operatingCompanyIndex, self.gameState.game == .g1846 {
                        let operationVC = storyboard?.instantiateViewController(withIdentifier: "company1846OperateViewController") as! Company1846OperateViewController

                        operationVC.parentVC = self
                        operationVC.gameState = self.gameState
                        operationVC.operatingCompanyIndex = operatingCompanyIndex
                        operationVC.startingAmountText = self.startingAmountText
                        operationVC.startingAmountColor = self.startingAmountColor
                        operationVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                        operationVC.startingAmountFont = self.startingAmountFont
                        
                        childrenVC = operationVC
                    } else if let operatingCompanyIndex = operatingCompanyIndex, self.gameState.getCompanyType(atIndex: operatingCompanyIndex) == .g1840Stadtbahn {
                        let operationVC = storyboard?.instantiateViewController(withIdentifier: "g1840StadtbahnOperateViewController") as! Company1840StadtbahnOperateViewController
                        
                        operationVC.parentVC = self
                        operationVC.gameState = self.gameState
                        operationVC.operatingCompanyIndex = operatingCompanyIndex
                        operationVC.startingAmountText = self.startingAmountText
                        operationVC.startingAmountColor = self.startingAmountColor
                        operationVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                        operationVC.startingAmountFont = self.startingAmountFont
                        
                        childrenVC = operationVC
                    } else if let operatingCompanyIndex = operatingCompanyIndex, self.gameState.game == .g1840 {
                        let operationVC = storyboard?.instantiateViewController(withIdentifier: "company1840OperateViewController") as! Company1840OperateViewController

                        operationVC.parentVC = self
                        operationVC.gameState = self.gameState
                        operationVC.operatingCompanyIndex = operatingCompanyIndex
                        operationVC.startingAmountText = self.startingAmountText
                        operationVC.startingAmountColor = self.startingAmountColor
                        operationVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                        operationVC.startingAmountFont = self.startingAmountFont
                        
                        childrenVC = operationVC
                        
                    } else {
                        let operationVC = storyboard?.instantiateViewController(withIdentifier: "companyOperateViewController") as! CompanyOperateViewController

                        operationVC.parentVC = self
                        operationVC.gameState = self.gameState
                        operationVC.operatingCompanyIndex = operatingCompanyIndex
                        operationVC.startingAmountText = self.startingAmountText
                        operationVC.startingAmountColor = self.startingAmountColor
                        operationVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                        operationVC.startingAmountFont = self.startingAmountFont
                        
                        childrenVC = operationVC
                    }
                }
                
            case ActionMenuType.acquire:
                let acquireVC = storyboard?.instantiateViewController(withIdentifier: "acquisitionViewController") as! CompanyMakeAcquisitionViewController
                
                acquireVC.parentVC = self
                acquireVC.gameState = self.gameState
                acquireVC.operatingCompanyIndex = self.operatingCompanyIndex
                acquireVC.startingAmountText = self.startingAmountText
                acquireVC.startingAmountColor = self.startingAmountColor
                acquireVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                acquireVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = acquireVC
                
            case ActionMenuType.g1840LinesRun:
                let linesVC = storyboard?.instantiateViewController(withIdentifier: "company1840LinesRunViewController") as! Company1840LinesRunViewController

                linesVC.parentVC = self
                linesVC.gameState = self.gameState
                linesVC.g1840OperatingLineBaseIndex = self.g1840OperatingLineBaseIndex
                
                linesVC.operatingCompanyIndex = operatingCompanyIndex
                linesVC.startingAmountText = self.startingAmountText
                linesVC.startingAmountColor = self.startingAmountColor
                linesVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                linesVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = linesVC
                
            case ActionMenuType.g1849Bond:
                let bondVC = storyboard?.instantiateViewController(withIdentifier: "company1849BondViewController") as! Company1849BondViewController
                
                bondVC.parentVC = self
                bondVC.gameState = self.gameState
                bondVC.operatingCompanyIndex = self.operatingCompanyIndex
                bondVC.startingAmountText = self.startingAmountText
                bondVC.startingAmountColor = self.startingAmountColor
                bondVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                bondVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = bondVC
                
            case ActionMenuType.loans:
                if self.gameState.game == .g1840 {
                    
                    let loansVC = storyboard?.instantiateViewController(withIdentifier: "player1840LoansViewController") as! Player1840LoansViewController
                    
                    loansVC.parentVC = self
                    loansVC.gameState = self.gameState
                    loansVC.operatingPlayerIndex = self.operatingPlayerIndex
                    loansVC.startingAmountText = self.startingAmountText
                    loansVC.startingAmountColor = self.startingAmountColor
                    loansVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    loansVC.startingAmountFont = self.startingAmountFont
                    
                    childrenVC = loansVC
                    
                } else if self.gameState.game == .g1848 {
                    
                    let loansVC = storyboard?.instantiateViewController(withIdentifier: "company1848LoansViewController") as! Company1848LoansViewController
                    
                    loansVC.parentVC = self
                    loansVC.gameState = self.gameState
                    loansVC.operatingCompanyIndex = self.operatingCompanyIndex
                    loansVC.startingAmountText = self.startingAmountText
                    loansVC.startingAmountColor = self.startingAmountColor
                    loansVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    loansVC.startingAmountFont = self.startingAmountFont
                    
                    if let cmpIdx = self.operatingCompanyIndex {
                        loansVC.loansAmount = self.gameState.loans?[cmpIdx] ?? 0
                    }
                    
                    childrenVC = loansVC
                    
                } else if self.gameState.game == .g1856 {
                    
                    let loansVC = storyboard?.instantiateViewController(withIdentifier: "company1856LoansViewController") as! Company1856LoansViewController
                    
                    loansVC.parentVC = self
                    loansVC.gameState = self.gameState
                    loansVC.operatingCompanyIndex = self.operatingCompanyIndex
                    loansVC.startingAmountText = self.startingAmountText
                    loansVC.startingAmountColor = self.startingAmountColor
                    loansVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    loansVC.startingAmountFont = self.startingAmountFont
                    
                    if let cmpIdx = self.operatingCompanyIndex {
                        loansVC.loansAmount = self.gameState.loans?[cmpIdx] ?? 0
                    }
                    
                    childrenVC = loansVC
                }
                
            case ActionMenuType.g18MEXMerge:
                let mergeVC = storyboard?.instantiateViewController(withIdentifier: "company18MEXMergeViewController") as! Company18MEXMergeViewController
                
                mergeVC.parentVC = self
                mergeVC.gameState = self.gameState
                mergeVC.operatingCompanyIndex = self.operatingCompanyIndex
                mergeVC.startingAmountText = self.startingAmountText
                mergeVC.startingAmountColor = self.startingAmountColor
                mergeVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                mergeVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = mergeVC
                
            case ActionMenuType.g18MEXCloseMinors:
                
                let closeVC = storyboard?.instantiateViewController(withIdentifier: "company18MEXCloseMinorsViewController") as! Company18MEXCloseMinorsViewController
                
                closeVC.parentVC = self
                closeVC.gameState = self.gameState
                closeVC.operatingCompanyIndex = self.operatingCompanyIndex
                closeVC.startingAmountText = self.startingAmountText
                closeVC.startingAmountColor = self.startingAmountColor
                closeVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                closeVC.startingAmountFont = self.startingAmountFont
                
                childrenVC = closeVC
                
            case ActionMenuType.close:
                switch self.gameState.game {
                case .g1848:
                    
                    let closeVC = storyboard?.instantiateViewController(withIdentifier: "company1848CloseViewController") as! Company1848CloseViewController
                    
                    closeVC.parentVC = self
                    closeVC.gameState = self.gameState
                    closeVC.operatingCompanyIndex = self.operatingCompanyIndex
                    closeVC.startingAmountText = self.startingAmountText
                    closeVC.startingAmountColor = self.startingAmountColor
                    closeVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    closeVC.startingAmountFont = self.startingAmountFont
                    
                    childrenVC = closeVC
                    
                case .g1830, .g1840, .g1846, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
                    
                    let closeVC = storyboard?.instantiateViewController(withIdentifier: "companyCloseViewController") as! CompanyCloseViewController
                    
                    closeVC.parentVC = self
                    closeVC.gameState = self.gameState
                    closeVC.operatingCompanyIndex = self.operatingCompanyIndex
                    closeVC.startingAmountText = self.startingAmountText
                    closeVC.startingAmountColor = self.startingAmountColor
                    closeVC.startingAmountBackgroundColor = self.startingAmountBackgroundColor
                    closeVC.startingAmountFont = self.startingAmountFont
                    
                    childrenVC = closeVC
                }
            }
            
            self.addChild(childrenVC)
            self.childView.addSubview(childrenVC.view)
            childrenVC.view.translatesAutoresizingMaskIntoConstraints = false
            childrenVC.view.topAnchor.constraint(equalTo: self.childView.topAnchor).isActive = true
            childrenVC.view.bottomAnchor.constraint(equalTo: self.childView.bottomAnchor).isActive = true
            childrenVC.view.leftAnchor.constraint(equalTo: self.childView.leftAnchor).isActive = true
            childrenVC.view.rightAnchor.constraint(equalTo: self.childView.rightAnchor).isActive = true
            childrenVC.didMove(toParent: self)
            self.childVC = childrenVC
            
        }
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
        self.parentVC.refreshUI()
    }

    @IBAction func doneButtonPressed(sender: UIButton) {
        if let childVC = self.childVC as? Operable {
            if let success = childVC.commitButtonPressed() {
                if success {
                    self.gameState.saveToDisk()
                    
                    self.dismiss(animated: true)
                    self.parentVC.refreshUI()
                    
                    var shouldSuggestCloseAllPrivateCompanies = self.gameState.currentTrainPriceIndex >= self.gameState.trainPriceIndexToCloseAllPrivates && !self.gameState.privatesOwnerGlobalIndexes.filter { !self.gameState.getBankEntityIndexes().contains($0) }.isEmpty && self.gameState.privatesWillCloseAutomatically
                    
                    if shouldSuggestCloseAllPrivateCompanies && self.gameState.game == .g1889 {
                        if self.gameState.privatesIncomes.count > 6 && self.gameState.privatesIncomes[6] == 50 {
                            shouldSuggestCloseAllPrivateCompanies = false
                        }
                    }
                    
                    if shouldSuggestCloseAllPrivateCompanies {
                        var messageStr = "Private companies should be closed"
                        if self.gameState.game == .g1849 {
                            messageStr = "Messina Earthquake takes place"
                        } else if self.gameState.game == .g18MEX {
                            messageStr = "All companies must repay their loans, otherwise NdM floats"
                        }
                        
                        let alert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                        alert.setup(withTitle: "Close all private companies?", andMessage: messageStr)
                        alert.addConfirmAction(withLabel: "Close") {
                            self.gameState.closeAllPrivatesCompanies()
                            if self.gameState.game == .g18MEX {
                                self.parentVC.loadAndPresentOpManagerVC(withOperatingCompanyIndex: self.gameState.getGlobalIndex(forEntity: "NdM"), andActionMenuIndex: ActionMenuType.float.rawValue)
                            }
                        }
                        alert.addCancelAction(withLabel: "Cancel")
                        
                        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                        
                        self.parentVC.present(alert, animated: true)
                    }
                    
                    // perform snack bar operations for things to remember
                    switch self.gameState.game {
                    case .g1848:
                        if let _ = self.childVC as? Company1848CloseViewController {
                            if [2, 5].contains(self.gameState.g1848CompaniesInReceivershipFlags?.filter({$0}).count) {
                                HomeViewController.presentSnackBar(withMessage: "Remove cheapest permanent train")
                            }
                            HomeViewController.presentSnackBar(withMessage: "Certificate limits updated")
                        }
                    case .g1849:
                        if let _ = self.childVC as? CompanyBuyTrainsViewController {
                            if self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex] == 1100 && self.gameState.activeOperations.count(where: { op in
                                op.type == .trains && op.trainPrice == 1100
                            }) == 1 {
                                HomeViewController.presentSnackBar(withMessage: "R6H trains are now available")
                            }
                        }
                    case .g1856:
                        if let _ = self.childVC as? CompanyBuyTrainsViewController {
                            if self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex] == 550 && self.gameState.activeOperations.count(where: { op in
                                op.type == .trains && op.trainPrice == 550
                            }) == 1 {
                                HomeViewController.presentSnackBar(withMessage: "Certificate limits / Companies status updated")
                            }
                            
                            if self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex] == 700 && self.gameState.activeOperations.count(where: { op in
                                op.type == .trains && op.trainPrice == 700
                            }) == 1 {
                                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                                alert.setup(withTitle: "CGR formation?", andMessage: "All loans must be repaid -> CGR formation?")
                                alert.addConfirmAction(withLabel: "Proceed")
                                alert.addCancelAction(withLabel: "Cancel")
                                
                                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                                
                                self.parentVC?.present(alert, animated: true)
                            }
                        }
                    case .g18MEX:
                        if let _ = self.childVC as? CompanyBuyTrainsViewController {
                            if self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex] == 180 && self.gameState.activeOperations.count(where: { op in
                                op.type == .trains && op.trainPrice == 180
                            }) == 5 {
                                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                                alert.setup(withTitle: "Close Minor companies?", andMessage: "Phase 3(1/2) began: all Minor companies close and NdM becomes available")
                                alert.addConfirmAction(withLabel: "Close") {
                                    if self.gameState.closeAllG18MEXMinors() {
                                        self.parentVC.refreshUI()
                                    }
                                }
                                alert.addCancelAction(withLabel: "Cancel")
                                
                                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                                
                                self.parentVC?.present(alert, animated: true)
                            }
                            
                            if self.gameState.trainPriceValues[self.gameState.currentTrainPriceIndex] == 600 && self.gameState.activeOperations.count(where: { op in
                                op.type == .trains && op.trainPrice == 600
                            }) == 2 {
                                HomeViewController.presentSnackBar(withMessage: "4-trains become obsolete")
                            }
                        }
                    case .g1830, .g1840, .g1846, .g1882, .g1889, .g18Chesapeake:
                        break
                    }
                    
                } else {
                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "No operation was performed, correct the data and try again")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                }
            } else {
                return
            }
        }
    }

}

extension OpManagerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.amountGlobalIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amountCell", for: indexPath) as! AmountCollectionViewCell
        let globalIndex = self.amountGlobalIndexes[indexPath.row]
        cell.backgroundColor = self.gameState.colors[globalIndex].uiColor
        cell.amountLabel.text = "\(self.gameState.labels[globalIndex]): " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.amounts[globalIndex])
        cell.amountLabel.textColor = self.gameState.textColors[globalIndex].uiColor
        return cell
    }
    
}

extension OpManagerViewController: UICollectionViewDelegate {
    
}

extension OpManagerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.amountGlobalIndexes.count <= 10 {
            
            let rows = 2.0
            let cols = ceil(CGFloat(self.amountGlobalIndexes.count) / rows)
            
            return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
            
        } else {
            let width = floor((collectionView.bounds.size.width - 40.0) / 5.0)
            
            return CGSize(width: width, height: 50.0)
        }
        
        
    }
}
