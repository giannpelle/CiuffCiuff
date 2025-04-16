//
//  HomeViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/12/22.
//

import UIKit

enum CollectionViewType: Int {
    case companies = 0, players, market, reducedCompanies, reducedPlayers, roundTrack, g1840Lines
}

enum MarketCollectionViewCellType: Int {
    case standard = 0, g1846
}

class HomeViewController: UIViewController {
    
    static var isPresentingSnackBar: Bool = false
    
    var gameState: GameState!
    var mainlineCompanyBaseIndex: Int? = nil
    
    var isGameOver: Bool = false
    
    @IBOutlet weak var topMenuView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    let roundTrackClassicCellWidth: CGFloat = 111.0
    let roundTrackClassicLastCellWidth: CGFloat = 94.0
    let roundTrackClassicCellHeight: CGFloat = 90.0
    @IBOutlet weak var roundTrackCollectionView: UICollectionView!
    @IBOutlet weak var roundTrackCollectionViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var editMarketButton: UIButton!
    
    @IBOutlet weak var marketCollectionView: UICollectionView!
    @IBOutlet weak var marketCollectionViewHeightConstraint: NSLayoutConstraint!
    var marketCollectionViewCellType: MarketCollectionViewCellType = .standard
    
    var flyingLayer: CALayer? = nil
    var flyingAccessoryTextLayer: CATextLayer? = nil
    var flyingAccessoryTextColor: UIColor = UIColor.white
    var flyingCurrentIndexPath: IndexPath? = nil
    var flyingCompanyBaseIndexes: [Int] = []
    var flyingCompanyBaseIndexPickerSelected: Int = 0
    var previousTranslation: CGPoint = CGPoint.zero
    
    var lastLocationInView: CGPoint = CGPoint.zero
    var isScrollingAutomatically: Bool = false
    
    @IBOutlet weak var companiesCollectionView: UICollectionView!
    @IBOutlet weak var companiesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reducedCompaniesCollectionView: UICollectionView!
    @IBOutlet weak var reducedCompaniesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var reducedCompaniesFilteredBaseIndexes: [Int] = []
    var reducedCompaniesCollectionViewSmallHeight: CGFloat = 90.0
    var reducedCompaniesCollectionViewBigHeight: CGFloat = 120.0
    
    var playersDeltas: [Double] = []
    var playersTotalNetWorths: [Double] = []
    var playersLiquidity: [Double] = []
    
    @IBOutlet weak var playersCollectionView: UICollectionView!
    @IBOutlet weak var playersCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reducedPlayersCollectionView: UICollectionView!
    @IBOutlet weak var reducedPlayersCollectionViewHeightConstraint: NSLayoutConstraint!
    
    let lineRunABCellHeight: CGFloat = 170.0
    let lineRunABCCellHeight: CGFloat = 210.0
    @IBOutlet weak var g1840LinesCollectionView: UICollectionView!
    @IBOutlet weak var g1840LinesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var g1840ActiveLineBaseIndexes: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGray4
        
        self.playersDeltas = Array(repeating: 0.0, count: self.gameState.playersSize)
        self.playersTotalNetWorths = Array(repeating: 0.0, count: self.gameState.playersSize)
        self.playersLiquidity = Array(repeating: 0.0, count: self.gameState.playersSize)
        
        self.editMarketButton.setTitle(withText: "Edit", fontSize: 19.0, fontWeight: .bold, textColor: UIColor.white)
        self.editMarketButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.editMarketButton.layer.cornerRadius = 25
        self.editMarketButton.clipsToBounds = true
        
        self.topMenuView.backgroundColor = UIColor.secondaryAccentColor
        
        self.roundTrackCollectionView.tag = CollectionViewType.roundTrack.rawValue
        self.roundTrackCollectionView.delegate = self
        self.roundTrackCollectionView.dataSource = self
        
        self.roundTrackCollectionViewWidthConstraint.constant = roundTrackClassicCellWidth * min(4.0, CGFloat(self.gameState.roundOperationTypes.count)) + (roundTrackClassicLastCellWidth - roundTrackClassicCellWidth)
        
        self.mainScrollView.contentInset.bottom = self.mainScrollView.safeAreaInsets.bottom
        self.mainScrollView.backgroundColor = UIColor.secondaryAccentColor
        
        self.companiesCollectionView.backgroundColor = UIColor.systemGray4
        self.companiesCollectionView.tag = CollectionViewType.companies.rawValue
        self.companiesCollectionView.delegate = self
        self.companiesCollectionView.dataSource = self
        
        self.playersCollectionView.backgroundColor = UIColor.systemGray4
        self.playersCollectionView.tag = CollectionViewType.players.rawValue
        self.playersCollectionView.delegate = self
        self.playersCollectionView.dataSource = self
        
        self.playersCollectionViewHeightConstraint.constant = 220.0
        
        self.marketCollectionView.backgroundColor = UIColor.systemGray4
        self.marketCollectionView.tag = CollectionViewType.market.rawValue
        self.marketCollectionView.delegate = self
        self.marketCollectionView.dataSource = self
        self.marketCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 150.0)
        
        switch self.gameState.game {
        case .g1846:
            self.marketCollectionViewHeightConstraint.constant = 240.0
            self.marketCollectionViewCellType = .g1846
            
        case .g1830, .g1840, .g1848, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            self.marketCollectionViewHeightConstraint.constant = CGFloat(self.gameState.getVerticalCellCount() * 40) + 2.0 * CGFloat(self.gameState.getVerticalCellCount() + 1)
        }
        
        self.reducedCompaniesCollectionView.backgroundColor = UIColor.systemGray4
        self.reducedCompaniesCollectionView.tag = CollectionViewType.reducedCompanies.rawValue
        self.reducedCompaniesCollectionView.delegate = self
        self.reducedCompaniesCollectionView.dataSource = self
        
        self.reducedCompaniesCollectionViewHeightConstraint.constant = reducedCompaniesCollectionViewBigHeight
        
        self.reducedPlayersCollectionView.backgroundColor = UIColor.systemGray4
        self.reducedPlayersCollectionView.tag = CollectionViewType.reducedPlayers.rawValue
        self.reducedPlayersCollectionView.delegate = self
        self.reducedPlayersCollectionView.dataSource = self
        
        if self.gameState.game == .g1840 {
            self.g1840LinesCollectionView.isHidden = false
            self.g1840LinesCollectionView.backgroundColor = UIColor.systemGray4
            self.g1840LinesCollectionView.tag = CollectionViewType.g1840Lines.rawValue
            self.g1840LinesCollectionView.delegate = self
            self.g1840LinesCollectionView.dataSource = self
            
            if self.gameState.currentRoundOperationType == .g1840LR5c {
                self.g1840LinesCollectionViewHeightConstraint.constant = lineRunABCCellHeight
            } else {
                self.g1840LinesCollectionViewHeightConstraint.constant = lineRunABCellHeight
            }
            
            if let lines = self.gameState.g1840LinesOwnerGlobalIndexes {
                self.g1840ActiveLineBaseIndexes = lines.enumerated().filter { $0.1 != BankIndex.bank.rawValue }.map { $0.0 }
            }
        } else {
            self.g1840LinesCollectionView.isHidden = true
        }
        
        self.titleLabel.text = "\("Bank"): " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getBankAmount())
        
        self.roundTrackCollectionView.reloadData()
        if let roundIndex = self.gameState.currentRoundOperationTypeIndex, roundIndex > 0 {
            self.roundTrackCollectionView.scrollToItem(at: IndexPath(row: roundIndex - 1, section: 0), at: .left, animated: true)
        }
        
        self.updateVisibleCollectionViews()
        
    }
    
    func updateVisibleCollectionViews() {
        
        switch self.gameState.currentRoundOperationType {
        case .SR, .g1840SR1, .g1840SR2, .g1840SR3, .g1840SR4, .g1840SR5:
            self.editMarketButton.isHidden = false
            self.marketCollectionView.isHidden = false
            self.marketCollectionView.reloadData()
            
            self.reducedCompaniesCollectionView.isHidden = false
            self.sortAndReloadReducedCompaniesCollectionView()
            
            self.playersCollectionView.isHidden = false
            self.gameState.homePlayersCollectionViewBaseIndexesSorted = self.gameState.homeDynamicTurnOrdersPreviewByPlayerBaseIndexes
            self.reloadPlayersCollectionView()
            
            self.companiesCollectionView.isHidden = false
            self.sortAndReloadCompaniesCollectionView()
            
            self.reducedPlayersCollectionView.isHidden = true
            self.g1840LinesCollectionView.isHidden = true
            
        case .yellowOR, .greenOR, .brownOR, .g1840CR1, .g1840CR2, .g1840CR3, .g1840CR4, .g1840CR5, .g1840CR6:
            self.reducedCompaniesCollectionView.isHidden = true
            self.playersCollectionView.isHidden = true
            
            self.editMarketButton.isHidden = false
            self.marketCollectionView.isHidden = false
            self.marketCollectionView.reloadData()
            
            self.reducedCompaniesCollectionView.isHidden = true
            
            self.companiesCollectionView.isHidden = false
            self.sortAndReloadCompaniesCollectionView()
            
            self.reducedPlayersCollectionView.isHidden = false
            self.reloadReducedPlayersCollectionView()
            
            self.g1840LinesCollectionView.isHidden = true
            
        case .g1840LR1a, .g1840LR1b, .g1840LR2a, .g1840LR2b, .g1840LR3a, .g1840LR3b, .g1840LR4a, .g1840LR4b, .g1840LR5a, .g1840LR5b, .g1840LR5c:
            self.reducedCompaniesCollectionView.isHidden = true
            self.playersCollectionView.isHidden = true
            
            self.editMarketButton.isHidden = false
            self.marketCollectionView.isHidden = false
            self.marketCollectionView.reloadData()
            
            self.reducedCompaniesCollectionView.isHidden = true
            
            self.companiesCollectionView.isHidden = false
            self.sortAndReloadCompaniesCollectionView()
            
            self.reducedPlayersCollectionView.isHidden = true
            
            if self.gameState.currentRoundOperationType == .g1840LR5c {
                self.g1840LinesCollectionViewHeightConstraint.constant = lineRunABCCellHeight
            } else {
                self.g1840LinesCollectionViewHeightConstraint.constant = lineRunABCellHeight
            }
            
            if let lines = self.gameState.g1840LinesOwnerGlobalIndexes {
                self.g1840ActiveLineBaseIndexes = lines.enumerated().filter { $0.1 != BankIndex.bank.rawValue }.map { $0.0 }
                
                if !self.g1840ActiveLineBaseIndexes.isEmpty {
                    self.g1840LinesCollectionView.isHidden = false
                    self.g1840LinesCollectionView.reloadData()
                } else {
                    self.g1840LinesCollectionView.isHidden = true
                }
            }
            
        case .close, .acquisition, .g18MEXcloseMinors, .setup, .g18MEXmerge, .cash, .income, .payout, .withhold, .privates, .trains, .sell, .sellEmergency, .buy, .tokens, .float, .trash, .generate, .mail, .line, .g1840Shortfall, .loan, .bond, .interests, .g1882NWR, .g1882Bridge, .market, .sellPrivate, .buyPrivate, .g1840LineRun:
            break
        }
    }
    
    @IBAction func incomeButtonPressed(sender: UIButton) {
        if self.gameState.privatesOwnerGlobalIndexes.enumerated().filter({ $0.1 != BankIndex.bank.rawValue }).isEmpty {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "There are no private companies operating at the moment")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        let incomeVC = storyboard?.instantiateViewController(withIdentifier: "incomeViewController") as! IncomeViewController
        incomeVC.parentVC = self
        incomeVC.gameState = self.gameState
        
        self.present(incomeVC, animated: true)
    }
    
    @IBAction func historyButtonPressed(sender: UIButton) {
        let historyVC = storyboard?.instantiateViewController(withIdentifier: "historyViewController") as! HistoryViewController
        historyVC.parentVC = self
        historyVC.gameState = self.gameState
        
        self.present(historyVC, animated: true)
    }
    
    @IBAction func cashButtonPressed(sender: UIButton) {
        
        let cashVC = storyboard?.instantiateViewController(withIdentifier: "cashViewController") as! CashViewController
        cashVC.parentVC = self
        cashVC.gameState = self.gameState
        
        self.present(cashVC, animated: true)
    }
    
    func calculatePlayerDeltas() {
        
        var lastDeltas = [Double](repeating: 0.0, count: self.gameState.playersSize)
        
        if let lastSROpIdx = self.gameState.activeOperations.lastIndex(where: { op in OperationType.getSROperationTypes().contains(op.type) }) {
            
            let lastORsOps = Array<Operation>(self.gameState.activeOperations[lastSROpIdx...])
            let payoutOps = lastORsOps.filter { op in
                op.type == .payout && self.gameState.getPlayerIndexes().contains { $0 == op.destinationGlobalIndex }
            }
            
            if !payoutOps.isEmpty {
                for op in payoutOps {
                    if let playerBaseIndex = self.gameState.convert(index: op.destinationGlobalIndex, backwards: true, withIndexType: .players) {
                        lastDeltas[playerBaseIndex] += (op.amount ?? 0.0)
                    }
                }
            }
        }
        
        self.playersDeltas = lastDeltas
    }
    
    func calculatePlayersNetWorths() {
        self.playersTotalNetWorths = self.gameState.getPlayersTotalNetWorth()
    }
    
    func calculatePlayersLiquidity() {
        self.playersLiquidity = self.gameState.getPlayersLiquidity()
    }
    
    @IBAction func gameMenuButtonPressed(sender: UIButton) {
        
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "gameMenuViewController") as! GameMenuViewController
        menuVC.gameState = self.gameState
        menuVC.parentVC = self
        
        self.present(menuVC, animated: true)
        
    }
    
    @IBAction func rulesButtonPressed(sender: UIButton) {
        
        let rulesVC = storyboard?.instantiateViewController(withIdentifier: "rulesViewController") as! RulesViewController
        rulesVC.gameState = self.gameState
        rulesVC.rulesText = self.gameState.rulesText
        rulesVC.titleStr = "\(self.gameState.game.rawValue) rules"
        
        self.present(rulesVC, animated: true)
    }
    
    func openSharesViewController(withShareholderGlobalIndexes shareholderGlobalIndexes: [Int], withFilteredCompanyIndex filteredCompanyIndex: Int? = nil) {
        let sharesVC = storyboard?.instantiateViewController(withIdentifier: "sharesViewController") as! SharesViewController
        sharesVC.gameState = self.gameState
        sharesVC.shareholderGlobalIndexes = shareholderGlobalIndexes
        sharesVC.filteredCompanyIndex = filteredCompanyIndex
        
        self.present(sharesVC, animated: true)
    }
    
    func roundTrackButtonPressed(sender: UIButton) {
        let roundOperationTypePressed = self.gameState.roundOperationTypes[sender.tag]
            
        if self.gameState.currentRoundOperationType == roundOperationTypePressed { return }
        
        let roundTrackVC = storyboard?.instantiateViewController(withIdentifier: "roundTrackViewController") as! RoundTrackViewController
        roundTrackVC.gameState = self.gameState
        
        var isEndOfOperatingRound: Bool = false
        var isEndOfStockRound: Bool = false
        var isNewOperatingRound: Bool = false
        var isNewStockRound: Bool = false
        
        if !OperationType.getSROperationTypes().contains(self.gameState.currentRoundOperationType) {
            isEndOfOperatingRound = true
            isEndOfStockRound = false
        } else {
            isEndOfOperatingRound = false
            isEndOfStockRound = true
        }
        
        if !OperationType.getSROperationTypes().contains(roundOperationTypePressed) {
            isNewOperatingRound = true
            isNewStockRound = false
        } else {
            isNewOperatingRound = false
            isNewStockRound = true
        }
        
        roundTrackVC.isEndOfOperatingRound = isEndOfOperatingRound
        roundTrackVC.isEndOfStockRound = isEndOfStockRound
        roundTrackVC.isNewOperatingRound = isNewOperatingRound
        roundTrackVC.isNewStockRound = isNewStockRound
        
        var callToActionDescriptions: [String] = []
        var callToActionCompanyActionMenuTuples: [(Int, Int)] = []
        
        var callToSwitchDescriptions: [String] = []
        var callToSwitchTypes: [CallToSwitchType] = []
        var callToSwitchCmpBaseIndexes: [Int] = []
        
        var bumpCompaniesBaseIndexes: [Int] = []
        var dropCompaniesBaseIndexes: [Int] = []
        
        switch self.gameState.game {
        case .g1848:
            if isEndOfOperatingRound, let receivershipFlags = self.gameState.g1848CompaniesInReceivershipFlags {
                var boeShouldHaveOperated: Bool = true
                
                // at least one share is in player possesion
                boeShouldHaveOperated = boeShouldHaveOperated && !self.gameState.getShareholderGlobalIndexesForCompany(atIndex: self.gameState.getGlobalIndex(forEntity: "BoE")).filter { self.gameState.getPlayerIndexes().contains($0) }.isEmpty
                
                // we are in green phase or a company is in receivership
                boeShouldHaveOperated = boeShouldHaveOperated && (self.gameState.currentTrainPriceIndex != 0 || !receivershipFlags.allSatisfy { !$0 })
                
                if boeShouldHaveOperated {
                    
                    if let beginningIndex = self.gameState.activeOperations.lastIndex(where: { op in
                        OperationType.getOROperationTypes().contains(op.type)
                    }) {
                        let lastOps = self.gameState.activeOperations[beginningIndex...]
                        
                        if !lastOps.contains(where: { op in (op.type == OperationType.payout && op.shareCompanyBaseIndex == self.gameState.getBaseIndex(forEntity: "BoE")) }) {
                            callToActionDescriptions.append("Bank of England did not operate.\nPerform payout now?")
                            callToActionCompanyActionMenuTuples.append((self.gameState.getGlobalIndex(forEntity: "BoE"), ActionMenuType.operate.rawValue))
                        }
                    }
                }
            }
            
        case .g1849:
            if isEndOfOperatingRound {
                // check if all companies with bond paid interests
                
                if let bondsAmounts = self.gameState.bonds {
                    
                    if let beginningIndex = self.gameState.activeOperations.lastIndex(where: { op in
                        OperationType.getOROperationTypes().contains(op.type)
                    }) {
                        let lastOps = self.gameState.activeOperations[beginningIndex...]
                        
                        for cmpBaseIdx in 0..<self.gameState.companiesSize {
                            
                            let cmpIdx = self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                            if bondsAmounts[cmpIdx] == 0 { continue }
                            
                            if !lastOps.contains(where: { op in (op.type == OperationType.interests && op.sourceGlobalIndex == cmpIdx) }) {
                                callToActionDescriptions.append("\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) did not pay interests.\nDo you want to pay interests now?")
                                callToActionCompanyActionMenuTuples.append((self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies), ActionMenuType.loans.rawValue))
                            }
                        }
                    }
                }
            }
            
        case .g1856:
            if isEndOfOperatingRound {
                // check if all companies are within loans limit and have paid interests
                
                if let loansAmounts = self.gameState.loans {
                    
                    if let beginningIndex = self.gameState.activeOperations.lastIndex(where: { op in
                        OperationType.getOROperationTypes().contains(op.type)
                    }) {
                        
                        let lastOps = self.gameState.activeOperations[beginningIndex...]
                    
                        for cmpIdx in self.gameState.getCompanyIndexes() {
                            let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
                            
                            if loansAmounts[cmpIdx] == 0 { continue }
                            
                            let shareholdersGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIdx)
                            let maxLoans: Int = shareholdersGlobalIndexes.filter { self.gameState.getPlayerIndexes().contains($0) }.map { Int(self.gameState.getSharesPortfolioForPlayer(atIndex: $0)[cmpBaseIdx]) }.reduce(0, +)
                            
                            if loansAmounts[cmpIdx] > maxLoans {
                                callToActionDescriptions.append("\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) issued more loans than eligible.\nDo you want to redeem loans in excess now?")
                                callToActionCompanyActionMenuTuples.append((self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies), ActionMenuType.loans.rawValue))
                            }
                            
                            // cmp took a 90 $ loan, no need to pay interests
                            if loansAmounts[cmpIdx] == 1 && lastOps.contains(where: { op in (op.type == .loan && op.destinationGlobalIndex == cmpIdx && op.amount == 90) }) { continue }
                                
                            let cmpIdx = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                            if !lastOps.contains(where: { op in (op.type == OperationType.interests && op.sourceGlobalIndex == cmpIdx) }) {
                                callToActionDescriptions.append("\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) did not pay interests.\nDo you want to pay interests now?")
                                callToActionCompanyActionMenuTuples.append((self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies), ActionMenuType.loans.rawValue))
                            }
                        }
                    }
                }
            }
            
        case .g1830, .g1840, .g1846, .g1882, .g1889, .g18MEX, .g18Chesapeake:
            break
        }
        
        if isEndOfStockRound {
            
            for cmpBaseIdx in 0..<self.gameState.companiesSize where self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx).shareValueCanBumpDrop() {
                
                if self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIdx, includePlayers: false).isEmpty {
                    bumpCompaniesBaseIndexes.append(cmpBaseIdx)
                }
                
                if [.g1846, .g1849].contains(self.gameState.game) && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[cmpBaseIdx] > 0 {
                    dropCompaniesBaseIndexes.append(cmpBaseIdx)
                }
            }
        }
        
        if isEndOfOperatingRound {
            for cmpBaseIdx in 0..<self.gameState.companiesSize where self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx).isShareValueTokenOnBoard() {
                if self.gameState.isCompanyFloated(atBaseIndex: cmpBaseIdx) && !self.gameState.hasCompanyOperated(atBaseIndex: cmpBaseIdx) {
                    callToSwitchDescriptions.append("\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) did not operate this OR. Adjust its share value 1x LEFT?")
                    callToSwitchTypes.append(CallToSwitchType.moveLEFT)
                    callToSwitchCmpBaseIndexes.append(cmpBaseIdx)
                }
            }
        }
        
        if !callToActionDescriptions.isEmpty || !callToSwitchDescriptions.isEmpty || !bumpCompaniesBaseIndexes.isEmpty || !dropCompaniesBaseIndexes.isEmpty {
            
            roundTrackVC.callToActionDescriptions = callToActionDescriptions
            roundTrackVC.callToActionCompanyActionMenuTuples = callToActionCompanyActionMenuTuples
            
            roundTrackVC.callToSwitchDescriptions = callToSwitchDescriptions
            roundTrackVC.callToSwitchTypes = callToSwitchTypes
            roundTrackVC.callToSwitchCmpBaseIndexes = callToSwitchCmpBaseIndexes
            
            roundTrackVC.bumpCompaniesBaseIndexes = bumpCompaniesBaseIndexes
            roundTrackVC.dropCompaniesBaseIndexes = dropCompaniesBaseIndexes
            
            roundTrackVC.parentVC = self
            roundTrackVC.roundOperationTypePressed = roundOperationTypePressed
            
            self.present(roundTrackVC, animated: true)
            return
        }
        
        self.completeRoundTrackValueChanged(withRoundOperationType: roundOperationTypePressed, isEndOfOperatingRound: isEndOfOperatingRound, isEndOfStockRound: isEndOfStockRound)
    }
    
    func completeRoundTrackValueChanged(withRoundOperationType roundOperationType: OperationType, isEndOfOperatingRound: Bool, isEndOfStockRound: Bool, shouldPresentSnackBarMessageWithText snackBarMessage: String? = nil) {
        
        if isEndOfOperatingRound {
            // if company did not payout nor withold, it goes LEFT
            // currently replaced by market share value shown on top of HOME VC
            
//
//            if let beginningIndex = self.gameState.activeOperations.lastIndex(where: { op in
//                OperationType.getOROperationTypes().contains(op.type)
//            }) {
//                let lastOps = self.gameState.activeOperations[beginningIndex...]
//
//                for cmpBaseIdx in 0..<self.gameState.companiesSize where self.gameState.isCompanyStarted(atBaseIndex: cmpBaseIdx) {
//                    if !lastOps.contains(where: { op in (op.type == OperationType.payout || op.type == .withhold) && op.payoutWithholdCompanyBaseIndex == cmpBaseIdx }) {
//                        _ = self.gameState.updateShareValue(forCompanyAtBaseIndex: cmpBaseIdx, withMovementType: .left)
//                    }
//                }
//            }
        }
        
        self.gameState.companiesOperated = Array(repeating: false, count: self.gameState.companiesSize)
        _ = self.gameState.perform(operation: Operation(type: roundOperationType, uid: nil))
        
        if self.gameState.game == .g1840 && OperationType.getSROperationTypes().contains(self.gameState.currentRoundOperationType) {
            self.gameState.g1840LinesRevenue = Array(repeating: Array(repeating: 0, count: 3), count: self.gameState.g1840LinesLabels?.count ?? 0)
        }

        self.roundTrackCollectionView.reloadData()
        if let roundIndex = self.gameState.currentRoundOperationTypeIndex, roundIndex > 0 {
            self.roundTrackCollectionView.scrollToItem(at: IndexPath(row: roundIndex - 1, section: 0), at: .left, animated: true)
        }
        
        if OperationType.getRoundTypeOperationsWhenPrivatesPayout().contains(roundOperationType) {
            if !self.gameState.privatesOwnerGlobalIndexes.filter({ !self.gameState.getBankEntityIndexes().contains($0) }).isEmpty {
                self.gameState.makePrivatesCompaniesOperate()
                
                Self.presentSnackBar(withMessage: "Private companies payout performed")
            } else {
                if self.gameState.game == .g1848, let receivershipFlags = self.gameState.g1848CompaniesInReceivershipFlags {
                    var shouldOpenBoEOperateVC: Bool = true
                    
                    // at least one share is in player possesion
                    shouldOpenBoEOperateVC = shouldOpenBoEOperateVC && !self.gameState.getShareholderGlobalIndexesForCompany(atIndex: self.gameState.getGlobalIndex(forEntity: "BoE")).filter { self.gameState.getPlayerIndexes().contains($0) }.isEmpty
                    
                    // we are in green phase or a company is in receivership
                    shouldOpenBoEOperateVC = shouldOpenBoEOperateVC && (self.gameState.currentTrainPriceIndex != 0 || !receivershipFlags.allSatisfy { !$0 })
                    
                    if shouldOpenBoEOperateVC {
                        self.loadAndPresentOpManagerVC(withOperatingCompanyIndex: self.gameState.getGlobalIndex(forEntity: "BoE"), andActionMenuIndex: ActionMenuType.operate.rawValue)
                    }
                }
            }
        }
        
        if let snackBarMessage = snackBarMessage {
            Self.presentSnackBar(withMessage: snackBarMessage)
        }
        
        self.gameState.operations.removeAll(where: { !$0.isActive })
        
        self.updateVisibleCollectionViews()
        
        if self.gameState.g1846IsFirstEverOR == true {
            self.gameState.g1846IsFirstEverOR = false
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Remember that the first ever OR has to be played in Reverse stock price order (lowest to highest). Companies in the same location will operate top-to-bottom")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
    }
    
    func sortCompaniesCollectionView() {
        
        // SORT COMPANIES
        var sortedCmpBaseIndexes: [Int] = self.gameState.getSortedCmpBaseIndexesByShareValueDesc()
        var floatedCmpBaseIndexes = sortedCmpBaseIndexes.filter { self.gameState.isCompanyFloated(atBaseIndex: $0) }
        
        // little non-public companies operate first
        var operatingFirstCompaniesBaseIndexes: [Int] = []
        for cmpBaseIdx in 0..<self.gameState.companiesSize {
            if floatedCmpBaseIndexes.contains(cmpBaseIdx) && self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx).shouldOperateBeforePublicCompanies() {
                operatingFirstCompaniesBaseIndexes.append(cmpBaseIdx)
            }
        }
        
        var operatingSecondCompaniesBaseIndexes: [Int] = floatedCmpBaseIndexes.filter { !self.gameState.getCompanyType(atBaseIndex: $0).shouldOperateBeforePublicCompanies() }
        
        var sortedFloatedCmpBaseIndexes: [Int] = operatingFirstCompaniesBaseIndexes + operatingSecondCompaniesBaseIndexes
        
        if self.gameState.game == .g1848 {
            let unfloatedCmpBaseIndexes = sortedCmpBaseIndexes.filter { !self.gameState.isCompanyFloated(atBaseIndex: $0) && self.gameState.g1848CompaniesInReceivershipFlags?[$0] == false }
            let receivershipCmpBaseIndexes = sortedCmpBaseIndexes.filter { self.gameState.g1848CompaniesInReceivershipFlags?[$0] == true }
            
            sortedCmpBaseIndexes = sortedFloatedCmpBaseIndexes + unfloatedCmpBaseIndexes + receivershipCmpBaseIndexes
            
        } else {
            let unfloatedCmpBaseIndexes = sortedCmpBaseIndexes.filter { !self.gameState.isCompanyFloated(atBaseIndex: $0) }
            sortedCmpBaseIndexes = sortedFloatedCmpBaseIndexes + unfloatedCmpBaseIndexes
        }
        
        self.gameState.homeCompaniesCollectionViewBaseIndexesSorted = sortedCmpBaseIndexes
        
    }
    
    func sortReducedCompaniesCollectionView() {
        
        // SORT REDUCED COMPANIES
        let cmpBaseIndexesWithPARValue: [Int] = (0..<self.gameState.companiesSize).filter { self.gameState.getPARvalue(forCompanyAtBaseIndex: $0) != nil }
        let cmpBaseIndexesWithPayoutValue: [Int] = (0..<self.gameState.companiesSize).filter { self.gameState.lastCompPayoutValues[$0] != 0 }
        
        var activeCmpBaseIndexes: [Int] = []
        var inactiveCmpBaseIndexes: [Int] = []
        
        if self.gameState.PARValueIsIrrelevantToShow {
            activeCmpBaseIndexes = (0..<self.gameState.companiesSize).filter { cmpBaseIndexesWithPayoutValue.contains($0) }
            inactiveCmpBaseIndexes = (0..<self.gameState.companiesSize).filter { !cmpBaseIndexesWithPayoutValue.contains($0) }
        } else {
            activeCmpBaseIndexes = (0..<self.gameState.companiesSize).filter { cmpBaseIndexesWithPayoutValue.contains($0) || cmpBaseIndexesWithPARValue.contains($0) }
            inactiveCmpBaseIndexes = (0..<self.gameState.companiesSize).filter { !(cmpBaseIndexesWithPayoutValue.contains($0) || cmpBaseIndexesWithPARValue.contains($0)) }
        }
        
        var activeCmpBaseIndexesSorted: [Int] = []
        if self.gameState.PARValueIsIrrelevantToShow {
            activeCmpBaseIndexesSorted = self.gameState.lastCompPayoutValues.enumerated().filter { activeCmpBaseIndexes.contains($0.0) }.sorted(by: { $0.1 >= $1.1 }).map { $0.0 }
        } else {
            activeCmpBaseIndexesSorted = self.gameState.lastCompPayoutValues.enumerated().filter { activeCmpBaseIndexes.contains($0.0) }.sorted(by: { $0.1 == $1.1 ? self.gameState.getPARvalue(forCompanyAtBaseIndex: $0.0) ?? 0 < self.gameState.getPARvalue(forCompanyAtBaseIndex: $1.0) ?? 0 : $0.1 > $1.1 }).map { $0.0 }
        }
        
        // adjust companies with no PAR value (if needed)
        
        self.gameState.homeReducedCompaniesCollectionViewBaseIndexesSorted = activeCmpBaseIndexesSorted + inactiveCmpBaseIndexes
        self.reducedCompaniesFilteredBaseIndexes = activeCmpBaseIndexesSorted
        
    }
    
    func sortAndReloadCompaniesCollectionView() {
        self.sortCompaniesCollectionView()
        self.companiesCollectionView.reloadData()
    }
    
    func sortAndReloadReducedCompaniesCollectionView() {
        self.sortReducedCompaniesCollectionView()
        
        if !self.reducedCompaniesFilteredBaseIndexes.isEmpty {
            var atLeastOneCompanyWithPARPayoutAccessory = false
            
            let cmpIndexesWithPARandPayout = self.reducedCompaniesFilteredBaseIndexes.filter { self.gameState.lastCompPayoutValues[$0] != 0 }.map { self.gameState.forceConvert(index: $0, backwards: false, withIndexType: .companies) }
            
            if let loansAmount = self.gameState.loans, cmpIndexesWithPARandPayout.map({ loansAmount[$0] }).count(where: { $0 != 0 }) > 0 {
                atLeastOneCompanyWithPARPayoutAccessory = true
            } else if let bondsAmount = self.gameState.bonds, cmpIndexesWithPARandPayout.map({ bondsAmount[$0] }).count(where: { $0 != 0 }) > 0 {
                atLeastOneCompanyWithPARPayoutAccessory = true
            }
            
            var heightConstraint = 0.0
            if atLeastOneCompanyWithPARPayoutAccessory {
                heightConstraint = reducedCompaniesCollectionViewBigHeight
            } else {
                heightConstraint = reducedCompaniesCollectionViewSmallHeight
            }
            
            self.reducedCompaniesCollectionViewHeightConstraint.constant = CGFloat(heightConstraint)
            self.reducedCompaniesCollectionView.isHidden = false
            self.mainScrollView.setNeedsLayout()
            self.mainScrollView.layoutIfNeeded()
            
            self.reducedCompaniesCollectionView.reloadData()
        } else {
            self.reducedCompaniesCollectionView.isHidden = true
        }
    }
    
    func calculateAndGetSortedPlayersBaseIndexes() -> [Int] {
        
        // SORT PLAYERS
        let playerTurnOrderType = self.gameState.playerTurnOrderType != .gameSpecific ? self.gameState.playerTurnOrderType : self.gameState.gameSpecificPlayerTurnOrderType
        let currentPlayerOrder = self.gameState.homePlayersCollectionViewBaseIndexesSorted
        
        if let lastSROpIdx = self.gameState.activeOperations.lastIndex(where: { op in OperationType.getSROperationTypes().contains(op.type) }) {
            
            let validOperationsFromLastSR = Array<Operation>(self.gameState.activeOperations[lastSROpIdx...])
            
            let SRoperationsToEvaluate = validOperationsFromLastSR.filter { op in [OperationType.buy, OperationType.sell, OperationType.sellPrivate, OperationType.buyPrivate].contains(op.type) }
            
            var playersGlobalIndexes: [Int] = []
            for op in SRoperationsToEvaluate {
                
                if op.type == .buy, let srcGlobalIdx = op.sourceGlobalIndex {
                    playersGlobalIndexes.append(srcGlobalIdx)
                } else if op.type == .sell, let dstGlobalIdx = op.destinationGlobalIndex {
                    playersGlobalIndexes.append(dstGlobalIdx)
                } else if op.type == .sellPrivate, let srcGlobalIdx = op.privateSourceGlobalIndex {
                    playersGlobalIndexes.append(srcGlobalIdx)
                } else if op.type == .buyPrivate, let dstGlobalIdx = op.privateDestinationGlobalIndex {
                    playersGlobalIndexes.append(dstGlobalIdx)
                }
            }
            
            let playersBaseIndexes = playersGlobalIndexes.map { self.gameState.forceConvert(index: $0, backwards: true, withIndexType: .players) }
            
            switch playerTurnOrderType {
            case .classic:
                if playersGlobalIndexes.isEmpty { return currentPlayerOrder }
                
                if let lastPlayerBuySellBaseIndex = playersBaseIndexes.last {
                    if lastPlayerBuySellBaseIndex == self.gameState.playersSize - 1 {
                        return Array<Int>(0..<self.gameState.playersSize)
                    } else {
                        return Array<Int>((lastPlayerBuySellBaseIndex + 1)..<self.gameState.playersSize) + Array<Int>(0...lastPlayerBuySellBaseIndex)
                    }
                }
            case .passOrder:
                if playersGlobalIndexes.isEmpty { return currentPlayerOrder }
                
                var playerBaseIndexesDesc: [Int] = []
                
                for playerBaseIdx in playersBaseIndexes.reversed() {
                    if playerBaseIndexesDesc.contains(playerBaseIdx) {
                        continue
                    }
                    
                    playerBaseIndexesDesc.append(playerBaseIdx)
                }
                
                let playerBaseIndexesSorted = currentPlayerOrder.filter { !playerBaseIndexesDesc.contains($0) } + playerBaseIndexesDesc.reversed()
                
                return playerBaseIndexesSorted
                
            case .mostCashAmount:
                
                return self.gameState.homePlayersCollectionViewBaseIndexesSorted.map { ($0, self.gameState.getPlayerAmount(atBaseIndex: $0)) }.enumerated().sorted(by: { $0.1 >= $1.1 }).map { $0.0 }
                
            case .gameSpecific:
                return currentPlayerOrder
            }
            
        }
        
        return currentPlayerOrder
        
    }
    
    func reloadPlayersCollectionView() {
        self.calculateDynamicTurnOrdersPreview()
        self.calculatePlayersLiquidity()
        self.calculatePlayersNetWorths()
        self.playersCollectionView.reloadData()
    }
    
    func reloadReducedPlayersCollectionView() {
        self.calculatePlayerDeltas()
        self.calculatePlayersNetWorths()
        self.reducedPlayersCollectionView.reloadData()
    }
    
    static func presentSnackBar(withMessage message: String, initialDelay: Double = 0.6, presentAnimationDuration: Double = 0.6, presentationDuration: Double = 2) {
        
        if Self.isPresentingSnackBar {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
                self.presentSnackBar(withMessage: message, initialDelay: initialDelay, presentAnimationDuration: presentAnimationDuration, presentationDuration: presentationDuration)
            }
            return
        }
        
        if let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last {
    
            Self.isPresentingSnackBar = true
            
            let snackBarLabel = UILabel(frame: CGRect(x: 20, y: -60, width: window.bounds.size.width - 40, height: 60))
            snackBarLabel.backgroundColor = UIColor.redAccentColor
            snackBarLabel.textColor = UIColor.white
            snackBarLabel.text = message
            snackBarLabel.textAlignment = .center
            snackBarLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .medium)
            snackBarLabel.clipsToBounds = true
            snackBarLabel.layer.cornerRadius = 8
            
            window.addSubview(snackBarLabel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
                UIView.animate(withDuration: presentAnimationDuration) {
                    snackBarLabel.frame = CGRect(x: 20, y: 20, width: window.bounds.size.width - 40, height: 60)
                }
    
                DispatchQueue.main.asyncAfter(deadline: .now() + presentationDuration) {
                    UIView.animate(withDuration: presentAnimationDuration) {
                        snackBarLabel.frame = CGRect(x: 20, y: -60, width: window.bounds.size.width - 40, height: 60)
                    } completion: { res in
                        snackBarLabel.removeFromSuperview()
    
                        Self.isPresentingSnackBar = false
                    }
                }
            }
        }
    }
    
    func calculateDynamicTurnOrdersPreview() {
        self.gameState.homeDynamicTurnOrdersPreviewByPlayerBaseIndexes = self.calculateAndGetSortedPlayersBaseIndexes()
    }
    
    func refreshUI() {
        
        self.titleLabel.text = "\("Bank"): " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getBankAmount())
        
        self.roundTrackCollectionView.reloadData()
        if let roundIndex = self.gameState.currentRoundOperationTypeIndex, roundIndex > 0 {
            self.roundTrackCollectionView.scrollToItem(at: IndexPath(row: roundIndex - 1, section: 0), at: .left, animated: true)
        }
        
        if !self.companiesCollectionView.isHidden {
            if self.gameState.currentRoundOperationType == .SR {
                self.sortAndReloadCompaniesCollectionView()
            } else {
                self.companiesCollectionView.reloadData()
            }
        }
        
        if !self.reducedCompaniesCollectionView.isHidden {
            self.sortAndReloadReducedCompaniesCollectionView()
        }
        
        if !self.playersCollectionView.isHidden {
            self.calculateDynamicTurnOrdersPreview()
            self.calculatePlayersLiquidity()
            self.calculatePlayersNetWorths()
            self.playersCollectionView.reloadData()
        }
        
        if !self.reducedPlayersCollectionView.isHidden {
            self.calculatePlayerDeltas()
            self.calculatePlayersNetWorths()
            self.reducedPlayersCollectionView.reloadData()
        }
        
        if !self.marketCollectionView.isHidden {
            self.marketCollectionView.reloadData()
        }
        
        if !self.g1840LinesCollectionView.isHidden {
            self.g1840LinesCollectionView.reloadData()
        }
        
        // check closed companies
        var closedCmpBaseIndexes: [Int] = []
        
        for cmpBaseIdx in 0..<self.gameState.companiesSize {
            let cmpIdx = self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
            
            if self.gameState.getCompanyBaseIndexesOfCompInCloseZone().contains(cmpBaseIdx) {
                closedCmpBaseIndexes.append(cmpBaseIdx)
            }
        }
        
        if !closedCmpBaseIndexes.isEmpty {
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "[\(closedCmpBaseIndexes.map { self.gameState.getCompanyLabel(atBaseIndex: $0) }.joined(separator: ", "))] reached the CLOSE share value space. Please close them, or update their share values")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if !OperationType.getSROperationTypes().contains(self.gameState.currentRoundOperationType) {
            var allCompsOperated = true
            for cmpBaseIdx in 0..<self.gameState.companiesSize {
                if self.gameState.isCompanyFloated(atBaseIndex: cmpBaseIdx) && !self.gameState.hasCompanyOperated(atBaseIndex: cmpBaseIdx) {
                    allCompsOperated = false
                    break
                }
            }
            
            if allCompsOperated {
                Self.presentSnackBar(withMessage: "NEW OR? - Remember to update the Round indicator on top")
                return
            }
        }
        
        // TEST FOR CRITICAL ERROS
        if self.gameState.amounts[BankIndex.ipo.rawValue] != 0 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "CRITICAL ERROR", andMessage: "IPO money amount is different than zero (please export the game state and send it to gianluigi.developer@gmail.com)")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if self.gameState.amounts[BankIndex.aside.rawValue] != 0 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "CRITICAL ERROR", andMessage: "ASIDE money amount is different than zero (please export the game state and send it to gianluigi.developer@gmail.com)")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if self.gameState.amounts[BankIndex.tradeIn.rawValue] != 0 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "CRITICAL ERROR", andMessage: "TRADE-IN money amount is different than zero (please export the game state and send it to gianluigi.developer@gmail.com)")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if self.gameState.amounts.reduce(0.0, +) != self.gameState.totalBankAmount {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "CRITICAL ERROR", andMessage: "The sum of money in the game mismatch the initial bank size (please export the game state and send it to gianluigi.developer@gmail.com)")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        let shareSum = self.gameState.shares.flatMap({$0}).reduce(0, +)
        let setupShareSum = self.gameState.compTotShares.reduce(0, +)
        if shareSum != setupShareSum {
            var irregularCmpBaseIndexes: [Int] = []
            
            for i in 0..<self.gameState.companiesSize {
                var cmpShareCount = 0.0
                for shareholderGlobalIdx in self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: i) {
                    cmpShareCount += self.gameState.shares[shareholderGlobalIdx][i]
                }
                
                if self.gameState.getTotalShareNumberOfCompany(atBaseIndex: i) != cmpShareCount {
                    irregularCmpBaseIndexes.append(i)
                }
            }
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "CRITICAL ERROR", andMessage: "The sum of shares for companies [\(irregularCmpBaseIndexes.map { self.gameState.getCompanyLabel(atBaseIndex: $0) }.joined(separator: ", "))] mismatch the initial shares amounts (please export the game state and send it to gianluigi.developer@gmail.com)")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        if let loans = self.gameState.loans {
            let maxLoansCount = self.gameState.game == .g1848 ? 20 : 100
            if loans.reduce(0, +) != maxLoansCount {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "CRITICAL ERROR", andMessage: "The total number of\(self.gameState.game == .g1848 ? " Bank of England" : "") loans is different than \(maxLoansCount) (please export the game state and send it to gianluigi.developer@gmail.com)")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                
                return
            }
        }
        
        if let bonds = self.gameState.bonds {
            let maxBondsCount = 100
            if bonds.reduce(0, +) != maxBondsCount {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "CRITICAL ERROR", andMessage: "The total number of bonds is different than \(maxBondsCount) (please export the game state and send it to gianluigi.developer@gmail.com)")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                
                return
            }
        }
        
        if !self.isGameOver {
            if let cmpBaseIdx = self.gameState.companyHasReachedGameEndLocation() {
                
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "GAME OVER", andMessage: "\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) has reached the game end share value location")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
        }
        
        if !self.isGameOver && self.gameState.getBankAmount() <= 0 {
            self.isGameOver = true
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "GAME OVER", andMessage: self.gameState.getBankAmount() < 0 ? "The bank has gone bankrupt" : "A player has gone bankrupt")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
    }
    
    func loadAndPresentOpManagerVC(withOperatingCompanyIndex operatingCompanyIndex: Int, andActionMenuIndex actionMenuIndex: Int) {
        let opManagerVC = storyboard?.instantiateViewController(withIdentifier: "opManagerViewController") as! OpManagerViewController
        opManagerVC.parentVC = self
        opManagerVC.gameState = self.gameState
        
        opManagerVC.operatingCompanyIndex = operatingCompanyIndex
        opManagerVC.startingAmountText = self.gameState.getCompanyLabel(atIndex: operatingCompanyIndex) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: operatingCompanyIndex))
        opManagerVC.startingAmountColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
        opManagerVC.startingAmountBackgroundColor = self.gameState.getCompanyColor(atIndex: operatingCompanyIndex)
        opManagerVC.startingAmountFont = UIFont.systemFont(ofSize: 26, weight: .bold)
        opManagerVC.operatingPlayerIndex = nil
        opManagerVC.suggestedActionMenuIndex = actionMenuIndex
        
        opManagerVC.modalPresentationStyle = .fullScreen
        self.present(opManagerVC, animated: true)
    }
    
    @IBAction func editMarketButtonPressed(sender: UIButton) {
        
        let cmpBaseIndexes = Array<Int>(0..<self.gameState.companiesSize).filter { self.gameState.getCompanyType(atBaseIndex: $0).isShareValueTokenOnBoard() }
        let cmpAttributedLabels = cmpBaseIndexes.map {
            NSAttributedString(string: "   \(self.gameState.getCompanyLabel(atBaseIndex: $0))   ", attributes: [NSAttributedString.Key.foregroundColor: self.gameState.getCompanyTextColor(atBaseIndex: $0), NSAttributedString.Key.backgroundColor: self.gameState.getCompanyColor(atBaseIndex: $0)])
        }
        let parValues = self.gameState.getOpeningLocations().compactMap { self.gameState.getShareValue(atIndexPath: $0) }.sorted(by: <)
        let shareAttributedValues = (["delete"] + parValues.map { self.gameState.currencyType.getCurrencyStringFromAmount(amount: $0) }).map { NSAttributedString(string: $0) }
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customPickerViewAlertViewController") as! CustomPickerViewAlertViewController
        
        var titleStr = ""
        if self.gameState.PARValueIsIrrelevantToShow {
            titleStr = "Set initial share value /\nDelete share value"
        } else {
            titleStr = "Set PAR value /\nEdit PAR value /\nDelete share value"
        }
        
        let attributedString = NSMutableAttributedString(string: titleStr)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 21.0, weight: .semibold), range: NSMakeRange(0, attributedString.length))
        
        alert.setup(withAttributedTitle: attributedString, andPickerElementsAttributedTextsByComponent: [cmpAttributedLabels, shareAttributedValues])
        alert.addCancelAction(withLabel: "Cancel")
        alert.addConfirmAction(withLabel: "OK") { selectedIndexesByComponent in
            
            if selectedIndexesByComponent.isEmpty { return }
            
            let selectedCmpBaseIndex = cmpBaseIndexes[selectedIndexesByComponent[0]]
            let selectedShareValueIndex = selectedIndexesByComponent[1]
            
            if selectedShareValueIndex == 0 {
                if let parValue = self.gameState.getPARvalue(forCompanyAtBaseIndex: selectedCmpBaseIndex) {
                    if let idx = self.gameState.getShareValueIndex(forCompanyAtBaseIndex: selectedCmpBaseIndex) {
                        let op = Operation(type: .market)
                        op.setOperationColorGlobalIndex(colorGlobalIndex: self.gameState.forceConvert(index: selectedCmpBaseIndex, backwards: false, withIndexType: .companies))
                        let detailsStr = self.gameState.PARValueIsIrrelevantToShow ? "share value" : "PAR"
                        op.addMarketDetails(marketShareValueCmpBaseIndex: selectedCmpBaseIndex, marketShareValueFromIndex: idx, marketShareValueToIndex: nil, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: selectedCmpBaseIndex)) -> \(detailsStr) reset", marketPreviousPARValue: Double(parValue))
                        _ = self.gameState.perform(operation: op, reverted: false)
                    }
                }
            } else {
                //overriding PAR value, DO NOT update share value
                if let _ = self.gameState.getPARvalue(forCompanyAtBaseIndex: selectedCmpBaseIndex) {
                    self.gameState.setPARvalue(value: Int(parValues[selectedShareValueIndex - 1]), forCompanyAtBaseIndex: selectedCmpBaseIndex)
                } else if let parIdx = self.gameState.getPARindex(fromShareValue: parValues[selectedShareValueIndex - 1]) {
                    let op = Operation(type: .market)
                    op.setOperationColorGlobalIndex(colorGlobalIndex: self.gameState.forceConvert(index: selectedCmpBaseIndex, backwards: false, withIndexType: .companies))
                    let detailsStr = self.gameState.PARValueIsIrrelevantToShow ? "share value -> " : "PAR"
                    op.addMarketDetails(marketShareValueCmpBaseIndex: selectedCmpBaseIndex, marketShareValueFromIndex: nil, marketShareValueToIndex: parIdx, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: selectedCmpBaseIndex)) -> \(detailsStr) \(Int(parValues[selectedShareValueIndex - 1]))")
                    _ = self.gameState.perform(operation: op, reverted: false)
                }
            }
            
            DispatchQueue.main.async {
                self.sortAndReloadReducedCompaniesCollectionView()
                
                if !self.marketCollectionView.isHidden {
                    self.marketCollectionView.reloadData()
                }
            }
        }
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert,animated: true, completion: nil )
        return
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let collectionViewType = CollectionViewType(rawValue: collectionView.tag) {

            switch collectionViewType {
            case CollectionViewType.market:
                
                let companiesBaseIndexes = self.gameState.getCompanyBaseIndexes(withShareValueInIndexPath: indexPath)
                if companiesBaseIndexes.count < 2 { return }
                
                var companiesLogos: [String] = []
                for cmpBaseIdx in companiesBaseIndexes {
                    if let _ = self.gameState.getCompanyWhiteLogo(atBaseIndex: cmpBaseIdx) {
                        companiesLogos.append(self.gameState.getCompanyWhiteLogoStr(atBaseIndex: cmpBaseIdx))
                    } else {
                        companiesLogos.append(self.gameState.getCompanyLogoStr(atBaseIndex: cmpBaseIdx))
                    }
                }
                
                let alert = storyboard?.instantiateViewController(withIdentifier: "customReorderShareValuesAlertViewController") as! CustomReorderShareValuesAlertViewController
                alert.setup(withTitle: "Reorder companies' initiavite for \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getShareValue(forCollectionViewIndexPath: indexPath) ?? 0)) share value", andElementsLogos: companiesLogos)
                
                alert.addCancelAction(withLabel: "Cancel")
                
                alert.addConfirmAction(withLabel: "Confirm") { sortedIndexes in
                    let sortedCmpBaseIndexes = sortedIndexes.map { companiesBaseIndexes[$0] }
                    self.gameState.reorderCmpBaseIndexes(sortedCmpBaseIndexes: sortedCmpBaseIndexes)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.marketCollectionView.reloadData()
                    }
                }
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height + CGFloat((companiesBaseIndexes.count * 60)))
                
                self.present(alert,animated: true, completion: nil)
                return
                
            case CollectionViewType.companies, CollectionViewType.players:
                
                let opManagerVC = storyboard?.instantiateViewController(withIdentifier: "opManagerViewController") as! OpManagerViewController
                opManagerVC.parentVC = self
                opManagerVC.gameState = self.gameState
                
                if collectionView.tag == CollectionViewType.companies.rawValue {
                    if indexPath.row >= self.gameState.companiesSize {
                        return
                    }
                    
                    let operatingCompanyIndex = self.gameState.forceConvert(index: self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row], backwards: false, withIndexType: .companies)
                    opManagerVC.operatingCompanyIndex = operatingCompanyIndex
                    opManagerVC.startingAmountText = self.gameState.getCompanyLabel(atIndex: operatingCompanyIndex) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: operatingCompanyIndex))
                    opManagerVC.startingAmountColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
                    opManagerVC.startingAmountBackgroundColor = self.gameState.getCompanyColor(atIndex: operatingCompanyIndex)
                    opManagerVC.startingAmountFont = UIFont.systemFont(ofSize: 26, weight: .bold)
                    opManagerVC.operatingPlayerIndex = nil
                } else if collectionView.tag == CollectionViewType.players.rawValue {
                    let operatingPlayerIndex = self.gameState.forceConvert(index: self.gameState.homePlayersCollectionViewBaseIndexesSorted[indexPath.row], backwards: false, withIndexType: .players)
                    opManagerVC.operatingPlayerIndex = operatingPlayerIndex
                    opManagerVC.startingAmountText = self.gameState.getPlayerLabel(atIndex: operatingPlayerIndex) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atIndex: operatingPlayerIndex))
                    opManagerVC.startingAmountColor = UIColor.black //self.gameState.getPlayerTextColor(atIndex: operatingPlayerIndex)
                    opManagerVC.startingAmountBackgroundColor = UIColor.clear //self.gameState.getPlayerColor(atIndex: operatingPlayerIndex)
                    opManagerVC.startingAmountFont = UIFont.systemFont(ofSize: 28, weight: .medium)
                    opManagerVC.operatingCompanyIndex = nil
                }
                
                if collectionView.tag == CollectionViewType.companies.rawValue && OperationType.getSROperationTypes().contains(self.gameState.currentRoundOperationType) {
                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "UPDATE ROUND TYPE", andMessage: "Remember to update the round type if you are starting a new OR")
                    alert.addConfirmAction(withLabel: "OK")
                    alert.addCancelAction(withLabel: "Ignore") {
                        opManagerVC.modalPresentationStyle = .fullScreen
                        self.present(opManagerVC, animated: true)
                    }
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                    return
                }
                
                opManagerVC.modalPresentationStyle = .fullScreen
                self.present(opManagerVC, animated: true)
                
            case CollectionViewType.reducedPlayers:
                
                let opManagerVC = storyboard?.instantiateViewController(withIdentifier: "opManagerViewController") as! OpManagerViewController
                opManagerVC.parentVC = self
                opManagerVC.gameState = self.gameState
                
                let operatingPlayerIndex = self.gameState.forceConvert(index: self.gameState.homeDynamicTurnOrdersPreviewByPlayerBaseIndexes[indexPath.row], backwards: false, withIndexType: .players)
                opManagerVC.operatingPlayerIndex = operatingPlayerIndex
                opManagerVC.startingAmountText = "Emergency Sale -> " + self.gameState.getPlayerLabel(atIndex: operatingPlayerIndex) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atIndex: operatingPlayerIndex))
                opManagerVC.startingAmountColor = UIColor.black //self.gameState.getPlayerTextColor(atIndex: operatingPlayerIndex)
                opManagerVC.startingAmountBackgroundColor = UIColor.clear //self.gameState.getPlayerColor(atIndex: operatingPlayerIndex)
                opManagerVC.startingAmountFont = UIFont.systemFont(ofSize: 28, weight: .medium)
                opManagerVC.operatingCompanyIndex = nil
                opManagerVC.overriddenActions = [ActionMenuType.sellShares.rawValue]
                
                opManagerVC.modalPresentationStyle = .fullScreen
                self.present(opManagerVC, animated: true)
                
            case CollectionViewType.reducedCompanies:
                break
            case CollectionViewType.roundTrack:
                break
            case CollectionViewType.g1840Lines:
                
                let opManagerVC = storyboard?.instantiateViewController(withIdentifier: "opManagerViewController") as! OpManagerViewController
                opManagerVC.parentVC = self
                opManagerVC.gameState = self.gameState
                opManagerVC.g1840OperatingLineBaseIndex = self.g1840ActiveLineBaseIndexes[indexPath.row]
                
                let operatingCompanyIndex = self.gameState.g1840LinesOwnerGlobalIndexes?[self.g1840ActiveLineBaseIndexes[indexPath.row]] ?? 0
                opManagerVC.operatingCompanyIndex = operatingCompanyIndex
                opManagerVC.startingAmountText = self.gameState.getCompanyLabel(atIndex: operatingCompanyIndex) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: operatingCompanyIndex))
                opManagerVC.startingAmountColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
                opManagerVC.startingAmountBackgroundColor = self.gameState.getCompanyColor(atIndex: operatingCompanyIndex)
                opManagerVC.startingAmountFont = UIFont.systemFont(ofSize: 26, weight: .bold)
                opManagerVC.operatingPlayerIndex = nil
                opManagerVC.overriddenActions = [ActionMenuType.tilesTokens.rawValue, ActionMenuType.g1840LinesRun.rawValue]
                
                opManagerVC.modalPresentationStyle = .fullScreen
                self.present(opManagerVC, animated: true)
            }
    }
        
//        if collectionView.tag == CollectionViewType.companies.rawValue && !self.gameState.isCompanyFloated(atBaseIndex: self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row]) {
//            
//            if self.gameState.game == .g1856 && self.gameState.getCompanyType(atBaseIndex: indexPath.row) == .g1856CGR {
//                let floatCompanyVC = storyboard?.instantiateViewController(withIdentifier: "g1856CGRFloatCompanyViewController") as! G1856CGRFloatCompanyViewController
//                floatCompanyVC.parentVC = self
//                floatCompanyVC.gameState = self.gameState
//                
//                self.present(floatCompanyVC, animated: true)
//
//                return
//            }
//            
//            let floatCompanyVC = storyboard?.instantiateViewController(withIdentifier: "floatCompanyViewController") as! FloatCompanyViewController
//            floatCompanyVC.parentVC = self
//            floatCompanyVC.gameState = self.gameState
//            
//            let operatingCompanyIndex = self.gameState.forceConvert(index: self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row], backwards: false, withIndexType: .companies)
//            
//            floatCompanyVC.operatingCompanyIndex = operatingCompanyIndex
//            floatCompanyVC.startingAmountText = self.gameState.getCompanyLabel(atIndex: operatingCompanyIndex)
//            floatCompanyVC.startingAmountColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
//            floatCompanyVC.startingAmountBackgroundColor = self.gameState.getCompanyColor(atIndex: operatingCompanyIndex)
//            floatCompanyVC.startingAmountFont = UIFont.systemFont(ofSize: 26, weight: .bold)
//            
//            self.present(floatCompanyVC, animated: true)
//
//            return
//        }
        
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collectionViewType = CollectionViewType(rawValue: collectionView.tag) {
            switch collectionViewType {
            case CollectionViewType.companies:
                return self.gameState.companiesSize
            case CollectionViewType.players:
                return self.gameState.playersSize
            case CollectionViewType.market:
                return self.gameState.getCollectionViewNumberOfItems()
            case CollectionViewType.reducedCompanies:
                return self.reducedCompaniesFilteredBaseIndexes.count
            case CollectionViewType.reducedPlayers:
                return self.gameState.playersSize
            case CollectionViewType.roundTrack:
                return self.gameState.roundOperationTypes.count
            case CollectionViewType.g1840Lines:
                return self.g1840ActiveLineBaseIndexes.count
            }
        }
        
        return 0
    }
    
    func openPreviewOpeningVC(operatingPlayerIndex: Int) {
        let openingPreviewVC = storyboard?.instantiateViewController(withIdentifier: "openingPreviewViewController") as! OpeningPreviewViewController
        openingPreviewVC.parentVC = self
        openingPreviewVC.gameState = self.gameState
        openingPreviewVC.operatingPlayerIndex = operatingPlayerIndex
        
        var companyBaseIndexes: [Int] = []
        for (cmpBaseIdx, shareAmount) in self.gameState.getSharesPortfolioForPlayer(atIndex: operatingPlayerIndex).enumerated() {
            if shareAmount > 0 {
                companyBaseIndexes.append(cmpBaseIdx)
            }
        }
        openingPreviewVC.companyBaseIndexes = companyBaseIndexes
        
        self.present(openingPreviewVC, animated: true)
    }
    
    func setupCompanyCollectionViewBase(collectionViewBase cell: CompanyCollectionViewCellProtocol, forIndexPath indexPath: IndexPath) -> Bool {
        if indexPath.row >= self.gameState.companiesSize {
            cell.contentView.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = .clear
            return false
        } else {
            cell.contentView.isHidden = false
            cell.isUserInteractionEnabled = true
        }
        
        cell.parentVC = self
        
        let operatingCompanyBaseIndex = self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row]
        let operatingCompanyIndex = self.gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
        
        cell.operatingCompanyIndex = operatingCompanyIndex
        cell.operatingCompanyBaseIndex = operatingCompanyBaseIndex
        cell.backgroundColor = self.gameState.getCompanyColor(atIndex: operatingCompanyIndex)
        cell.companyLogoImageView.image = self.gameState.getCompanyLogo(atBaseIndex: operatingCompanyBaseIndex)
        cell.companyAmountLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: operatingCompanyIndex))
        cell.companyAmountLabel.textColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
        
        let bankShareholderGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atIndex: operatingCompanyIndex).filter { self.gameState.getBankEntityIndexes().contains($0) }
        
        var bankShareholdersStrDescription = ""
        for (i, bankEntityGlobalIdx) in bankShareholderGlobalIndexes.enumerated() {
            if i > 0 {
                bankShareholdersStrDescription += "\n"
            }
            let shareAmount = self.gameState.shares[bankEntityGlobalIdx][operatingCompanyBaseIndex]
            let shareAmountStr = self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)
            bankShareholdersStrDescription += "\(self.gameState.getBankEntityLabel(atBaseIndexOrIndex: bankEntityGlobalIdx)): \(shareAmountStr)"
        }
        
        let cmpShareAmount = self.gameState.shares[operatingCompanyIndex][operatingCompanyBaseIndex]
        let cmpShareAmountStr = self.gameState.printShareAmountsAsInt ? String(Int(cmpShareAmount)) : String(cmpShareAmount)
        
        if cmpShareAmount > 0 {
            if bankShareholdersStrDescription != "" {
                bankShareholdersStrDescription += "\n"
            }
            
            bankShareholdersStrDescription += "Comp: \(cmpShareAmountStr)"
        }
        
        if bankShareholdersStrDescription == "" {
            bankShareholdersStrDescription = "Sold out"
        }
        
        cell.sharesAmountLabel.text = bankShareholdersStrDescription
        cell.sharesAmountLabel.textColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
        cell.sharesAmountLabel.backgroundColor = UIColor.clear
        
        let lastPayout = self.gameState.getLastPayoutForCompany(atIndex: operatingCompanyIndex)
        cell.payoutAmount = lastPayout
        if lastPayout != 0 {
            cell.lastPayoutLabel.isHidden = false
            cell.lastPayoutLabel.text = "payout" + "\n" + self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(lastPayout))
            cell.lastPayoutLabel.textAlignment = .center
            cell.lastPayoutLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            cell.lastPayoutLabel.textColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
            cell.lastPayoutLabel.layer.cornerRadius = 10.0
            cell.lastPayoutLabel.clipsToBounds = true
            cell.lastPayoutLabel.layer.borderColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex).cgColor
            cell.lastPayoutLabel.layer.borderWidth = 2.0
            cell.lastPayoutButton.isHidden = false
        } else {
            cell.lastPayoutLabel.isHidden = true
            cell.lastPayoutButton.isHidden = true
        }
        
        if self.gameState.hasCompanyOperated(atBaseIndex: operatingCompanyBaseIndex) && !OperationType.getSROperationTypes().contains(self.gameState.currentRoundOperationType) {
            cell.tickImageView.isHidden = false
            cell.tickImageView.image = self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex) == UIColor.white ? UIImage(named: "tick_white") : UIImage(named: "tick")
        } else {
            cell.tickImageView.isHidden = true
        }
        
        if !self.gameState.isCompanyFloated(atBaseIndex: operatingCompanyBaseIndex) {
            cell.backgroundColor = UIColor.systemGray4
            cell.companyAmountLabel.textColor = UIColor.white
            cell.sharesAmountLabel.textColor = UIColor.white
            cell.sharesAmountLabel.backgroundColor = UIColor.clear
            
            if let whiteLogo = self.gameState.getCompanyWhiteLogo(atBaseIndex: operatingCompanyBaseIndex) {
                cell.companyLogoImageView.image = whiteLogo
            }
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let collectionViewType = CollectionViewType(rawValue: collectionView.tag) {
            
            switch collectionViewType {
                
            case CollectionViewType.companies:
                
                switch self.gameState.game {
                case .g1840:
                    if self.gameState.getCompanyType(atBaseIndex: self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row]) == .standard {
                        
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "g1840CompanyCellId", for: indexPath) as! G1840CompanyCollectionViewCell
                        if !self.setupCompanyCollectionViewBase(collectionViewBase: cell, forIndexPath: indexPath) {
                            return cell
                        }
                        
                        let operatingCompanyBaseIndex = self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row]
                        let operatingCompanyIndex = self.gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
                        
                        if self.gameState.isCompanyFloated(atBaseIndex: operatingCompanyBaseIndex) {
                            cell.totalRevenueLabel.isHidden = false
                            
                            let linesBaseIndexes = self.gameState.g1840LinesOwnerGlobalIndexes?.enumerated().filter { $0.1 == operatingCompanyIndex }.map { $0.0 }
                            let currentRoundRevenue = self.gameState.g1840LinesRevenue?.enumerated().filter { linesBaseIndexes?.contains($0.0) ?? false }.map { $0.1.reduce(0, +) }.reduce(0, +) ?? 0
                            
                            cell.totalRevenueLabel.text = "Runs sum: \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(currentRoundRevenue)))"
                            cell.totalRevenueLabel.textColor = self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex)
                            cell.totalRevenueLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
                        } else {
                            cell.totalRevenueLabel.isHidden = true
                        }
                        
                        if let lastRevenue = self.gameState.g1840LastCompanyRevenues?[operatingCompanyBaseIndex], lastRevenue != 0 {
                            cell.lastPayoutLabel.isHidden = false
                            cell.lastPayoutLabel.text = "Revenue" + "\n" + self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(lastRevenue))
                            cell.lastPayoutLabel.textAlignment = .right
                            cell.lastPayoutLabel.textColor = self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex)
                            cell.lastPayoutLabel.layer.cornerRadius = 10.0
                            cell.lastPayoutLabel.layer.borderColor = UIColor.clear.cgColor
                            cell.lastPayoutLabel.layer.borderWidth = 0.0
                        } else {
                            cell.lastPayoutLabel.isHidden = true
                        }
                        
                        cell.lastPayoutButton.isHidden = true
                        
                        return cell
                    } else {
                        
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "companyCellId", for: indexPath) as! CompanyCollectionViewCell
                        if !self.setupCompanyCollectionViewBase(collectionViewBase: cell, forIndexPath: indexPath) {
                            return cell
                        }
                        
                        return cell
                    }
                    
                case .g1848:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loansCompanyCellId", for: indexPath) as! LoansCompanyCollectionViewCell
                    if !self.setupCompanyCollectionViewBase(collectionViewBase: cell, forIndexPath: indexPath) {
                        return cell
                    }
                    
                    let operatingCompanyBaseIndex = self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row]
                    let operatingCompanyIndex = self.gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
                    
                    if self.gameState.getCompanyType(atIndex: operatingCompanyIndex) == .g1848BoE {
                        cell.centerYLayoutConstraint.constant = 25.0
                        
                        cell.companyShareValueLabel.isHidden = false
                        cell.companyShareValueLabel.text = "\(Int(self.gameState.getShareValue(forCompanyAtBaseIndex: operatingCompanyBaseIndex) ?? 0.0))"
                        cell.companyShareValueLabel.textColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex)
                        cell.companyShareValueLabel.layer.borderColor = self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex).cgColor
                        cell.companyShareValueLabel.layer.borderWidth = 2.0
                    } else {
                        cell.companyShareValueLabel.isHidden = true
                        cell.centerYLayoutConstraint.constant = 0.0
                    }
                    
                    if self.gameState.loans?[operatingCompanyIndex] != 0 {
                        cell.loansLabel.isHidden = false
                        cell.loansLabel.layer.cornerRadius = 4
                        cell.loansLabel.clipsToBounds = true
                        
                        cell.loansLabel.paddingTop = 2
                        cell.loansLabel.paddingBottom = 2
                        cell.loansLabel.paddingLeft = 6
                        cell.loansLabel.paddingRight = 6
                        
                        cell.loansLabel.text = String(self.gameState.loans?[operatingCompanyIndex] ?? 0) + " loans"
                        cell.loansLabel.backgroundColor = self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex)
                        cell.loansLabel.textColor = self.gameState.getCompanyColor(atBaseIndex: operatingCompanyBaseIndex)
                    } else {
                        cell.loansLabel.isHidden = true
                    }
                    
                    if self.gameState.g1848CompaniesInReceivershipFlags?[operatingCompanyBaseIndex] == true {
                        cell.sharesAmountLabel.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: operatingCompanyBaseIndex)
                        cell.sharesAmountLabel.textColor = self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex)
                        cell.sharesAmountLabel.text = "Receivership"
                        cell.sharesAmountLabel.paddingLeft = 6.0
                        cell.sharesAmountLabel.paddingRight = 6.0
                        cell.sharesAmountLabel.paddingTop = 4.0
                        cell.sharesAmountLabel.paddingBottom = 4.0
                    }
                    
                    return cell
                case .g1849:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loansCompanyCellId", for: indexPath) as! LoansCompanyCollectionViewCell
                    if !self.setupCompanyCollectionViewBase(collectionViewBase: cell, forIndexPath: indexPath) {
                        return cell
                    }
                    
                    let operatingCompanyBaseIndex = self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row]
                    let operatingCompanyIndex = self.gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
                    
                    cell.companyShareValueLabel.isHidden = true
                    cell.centerYLayoutConstraint.constant = 0.0
                    
                    if self.gameState.bonds?[operatingCompanyIndex] != 0 {
                        cell.loansLabel.isHidden = false
                        cell.loansLabel.layer.cornerRadius = 4
                        cell.loansLabel.clipsToBounds = true
                        
                        cell.loansLabel.paddingTop = 2
                        cell.loansLabel.paddingBottom = 2
                        cell.loansLabel.paddingLeft = 6
                        cell.loansLabel.paddingRight = 6
                        
                        cell.loansLabel.text = String(self.gameState.bonds?[operatingCompanyIndex] ?? 0) + " BOND"
                        cell.loansLabel.backgroundColor = self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex)
                        cell.loansLabel.textColor = self.gameState.getCompanyColor(atBaseIndex: operatingCompanyBaseIndex)
                    } else {
                        cell.loansLabel.isHidden = true
                    }
                    
                    return cell
                case .g1856:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "g1856companyCellId", for: indexPath) as! G1856CompanyCollectionViewCell
                    if !self.setupCompanyCollectionViewBase(collectionViewBase: cell, forIndexPath: indexPath) {
                        return cell
                    }
                    
                    let operatingCompanyBaseIndex = self.gameState.homeCompaniesCollectionViewBaseIndexesSorted[indexPath.row]
                    let operatingCompanyIndex = self.gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
                    
                    if self.gameState.loans?[operatingCompanyIndex] != 0 {
                        cell.loansLabel.isHidden = false
                        cell.loansLabel.layer.cornerRadius = 4
                        cell.loansLabel.clipsToBounds = true
                        
                        cell.loansLabel.paddingTop = 2
                        cell.loansLabel.paddingBottom = 2
                        cell.loansLabel.paddingLeft = 6
                        cell.loansLabel.paddingRight = 6
                        
                        cell.loansLabel.text = String(self.gameState.loans?[operatingCompanyIndex] ?? 0) + " loans"
                        cell.loansLabel.backgroundColor = self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex)
                        cell.loansLabel.textColor = self.gameState.getCompanyColor(atBaseIndex: operatingCompanyBaseIndex)
                    } else {
                        cell.loansLabel.isHidden = true
                    }
                    
                    cell.companyStatus = self.gameState.g1856CompaniesStatus?[operatingCompanyBaseIndex] ?? .incrementalCapitalizationCapped
                    
                    if operatingCompanyBaseIndex != self.gameState.getBaseIndex(forEntity: "CGR") {
                        let isCmpStarted = self.gameState.isCompanyFloated(atBaseIndex: operatingCompanyBaseIndex)
                        cell.setupPopupButtons(withTextColor: isCmpStarted ? nil : UIColor.white)
                        
                        cell.companyStatusPopupButton.isHidden = false
                        cell.companyStatusPopupButton.layer.borderColor = isCmpStarted ? self.gameState.getCompanyTextColor(atIndex: operatingCompanyIndex).cgColor : UIColor.white.cgColor
                        cell.companyStatusPopupButton.layer.borderWidth = 1.0
                        cell.companyStatusPopupButton.layer.cornerRadius = 8.0
                    } else {
                        cell.companyStatusPopupButton.isHidden = true
                    }
                    
                    return cell
                case .g1830, .g1846, .g1882, .g1889, .g18Chesapeake, .g18MEX:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "companyCellId", for: indexPath) as! CompanyCollectionViewCell
                    if !self.setupCompanyCollectionViewBase(collectionViewBase: cell, forIndexPath: indexPath) {
                        return cell
                    }
                    
                    return cell
                }
                
            case CollectionViewType.players:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCellId", for: indexPath) as! PlayerCollectionViewCell
                cell.parentVC = self
                
                cell.leftDividerAccessoryView.isHidden = indexPath.row == 0
                cell.rightDividerAccessoryView.isHidden = indexPath.row == self.gameState.playersSize - 1
                
                let operatingPlayerBaseIndex = self.gameState.homePlayersCollectionViewBaseIndexesSorted[indexPath.row]
                let operatingPlayerIndex = self.gameState.forceConvert(index: operatingPlayerBaseIndex, backwards: false, withIndexType: .players)
                cell.operatingPlayerIndex = operatingPlayerIndex
                cell.backgroundColor = UIColor.systemGray6
                
                cell.playerTurnOrderLabel.text = "\(indexPath.row + 1)"
                cell.playerTurnOrderLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
                //            cell.playerTurnOrderLabel.textAlignment = .center
                //            cell.playerTurnOrderLabel.layer.cornerRadius = 11.0
                //            cell.playerTurnOrderLabel.layer.borderColor = UIColor.black.cgColor
                //            cell.playerTurnOrderLabel.layer.borderWidth = 2
                //            cell.playerTurnOrderLabel.clipsToBounds = true
                
                cell.playerNameLabel.text = self.gameState.getPlayerLabel(atIndex: operatingPlayerIndex)
                cell.playerAmountLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atIndex: operatingPlayerIndex))
                
                let cmpBaseIndexesOfCompInYellowZone = self.gameState.getCompanyBaseIndexesOfCompInYellowOrangeBrownZone()
                
                var playerCertificateAmount = 0.0
                var playerCertificateInYellowZoneAmount = 0.0
                
                for cmpBaseIdx in 0..<self.gameState.companiesSize {
                    let currentCmpPlayerShareAmount = self.gameState.shares[operatingPlayerIndex][cmpBaseIdx]
                    if currentCmpPlayerShareAmount < self.gameState.presidentCertificateShareAmount {
                        if cmpBaseIndexesOfCompInYellowZone.contains(cmpBaseIdx) {
                            playerCertificateInYellowZoneAmount += currentCmpPlayerShareAmount
                        } else {
                            playerCertificateAmount += currentCmpPlayerShareAmount
                        }
                        continue
                    }
                    
                    let cmpShareholdersGlobalIndexes = self.gameState.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIdx).filter { self.gameState.getPlayerIndexes().contains($0) }
                    let sharesAmountByGlobalIndex = cmpShareholdersGlobalIndexes.map { self.gameState.shares[$0][cmpBaseIdx] }
                    
                    if let presidentPlayerIndex = self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: cmpBaseIdx), presidentPlayerIndex == operatingPlayerIndex {
                        if cmpBaseIndexesOfCompInYellowZone.contains(cmpBaseIdx) {
                            playerCertificateInYellowZoneAmount += (currentCmpPlayerShareAmount - 1)
                        } else {
                            playerCertificateAmount += (currentCmpPlayerShareAmount - 1)
                        }
                    } else {
                        if cmpBaseIndexesOfCompInYellowZone.contains(cmpBaseIdx) {
                            playerCertificateInYellowZoneAmount += currentCmpPlayerShareAmount
                        } else {
                            playerCertificateAmount += currentCmpPlayerShareAmount
                        }
                    }
                }
                
                if self.gameState.game != .g1848 {
                    playerCertificateAmount += Double(self.gameState.privatesOwnerGlobalIndexes.filter { $0 == operatingPlayerIndex }.count)
                }
                
                let certificateAmountStr = (playerCertificateAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(playerCertificateAmount)) : String(playerCertificateAmount))
                
                var certificateLimit = 0.0
                switch self.gameState.game {
                case .g1846:
                    if let dynamicCertLimit = self.gameState.g1846DynamicCertificateLimits {
                        let cmpCount = self.gameState.getCompanyIndexes().filter { self.gameState.getCompanyType(atIndex: $0) == .standard }.count { self.gameState.isCompanyFloated(atIndex: $0) }
                        certificateLimit = Double(dynamicCertLimit[cmpCount])
                    }
                case .g1848:
                    if let g1848CertificateLimits = self.gameState.g1848CertificateLimits {
                        let penalty: Int = (self.gameState.g1848CompaniesInReceivershipPresidentPlayerIndexes?.count(where: { $0 == operatingPlayerIndex }) ?? 0) * (self.gameState.g1848ReceivershipPresidentCertificatePenalty ?? 0)
                        certificateLimit = (g1848CertificateLimits[min(self.gameState.g1848CompaniesInReceivershipFlags?.count { $0 } ?? 0, 5)]) - Double(penalty)
                    }
                case .g1856:
                    if self.gameState.currentTrainPriceIndex >= 4 {
                        if let dynamicCertLimit = self.gameState.g1856DynamicCertificateLimits {
                            let cmpCount = self.gameState.getCompanyIndexes().count { self.gameState.isCompanyFloated(atIndex: $0) }
                            certificateLimit = Double(dynamicCertLimit[cmpCount])
                        }
                    } else {
                        certificateLimit = self.gameState.certificateLimit
                    }
                case .g1830, .g1840, .g1849, .g1882, .g1889, .g18MEX, .g18Chesapeake:
                    certificateLimit = self.gameState.certificateLimit
                }
                
                let certificateAmountColor: UIColor
                if playerCertificateAmount == certificateLimit - 1 {
                    certificateAmountColor = UIColor.systemOrange
                } else if playerCertificateAmount < certificateLimit {
                    certificateAmountColor = UIColor.black
                } else {
                    certificateAmountColor = UIColor.redAccentColor
                }
                
                let certificateAmountAttributedString = NSMutableAttributedString()
                //            if playerCertificateInYellowZoneAmount != 0 {
                //                let certificateAmountInYellowZoneStr = (playerCertificateInYellowZoneAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(playerCertificateInYellowZoneAmount)) : String(playerCertificateInYellowZoneAmount))
                //                certificateAmountAttributedString.append(NSAttributedString(string: certificateAmountStr, attributes: [NSAttributedString.Key.foregroundColor: certificateAmountColor]))
                //                certificateAmountAttributedString.append(NSAttributedString(string: " +" + certificateAmountInYellowZoneStr, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
                //            } else {
                certificateAmountAttributedString.append(NSAttributedString(string: certificateAmountStr + "/\(Int(certificateLimit))", attributes: [NSAttributedString.Key.foregroundColor: certificateAmountColor]))
                //            }
                cell.sharesAmountLabel.attributedText = certificateAmountAttributedString
                
                
                cell.certificateLimitLabel.isHidden = playerCertificateInYellowZoneAmount != 0 ? false : true
                cell.certificateLimitLabel.text = "+\(playerCertificateInYellowZoneAmount)"
                
                var compsToBeFloated: [Int] = []
                
                for i in 0..<self.gameState.companiesSize {
                    if self.gameState.getCompanyType(atBaseIndex: i).canBeFloatedByPlayers() && self.gameState.getPARvalue(forCompanyAtBaseIndex: i) == nil {
                        if !self.gameState.isCompanyFloated(atBaseIndex: i) && self.gameState.g1848CompaniesInReceivershipFlags?[i] != true {
                            compsToBeFloated.append(i)
                        }
                    }
                }
                
                if compsToBeFloated.isEmpty || (self.gameState.currentTrainPriceIndex == self.gameState.trainPriceValues.count - 1) {
                    cell.floatLabel.isHidden = true
                    cell.PARButton.isUserInteractionEnabled = false
                } else {
                    cell.PARButton.isUserInteractionEnabled = true
                    cell.floatLabel.isHidden = false
                    cell.floatLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .semibold)
                    
                    if let maxOpeningIdx = self.gameState.openCompanyValues.lastIndex(where: { Int(self.playersLiquidity[operatingPlayerBaseIndex]) >= $0 }) {
                        cell.floatLabel.text = "ƒ \(self.gameState.getGamePARValues()[maxOpeningIdx])"
                    } else {
                        let missingAmount = self.gameState.openCompanyValues[0] - Int(self.playersLiquidity[operatingPlayerBaseIndex])
                        if missingAmount < 100 {
                            cell.floatLabel.text = "ƒ -\(missingAmount)"
                        } else {
                            cell.floatLabel.text = "ƒ X"
                        }
                    }
                }
                
                if (self.gameState.loans?[operatingPlayerIndex] ?? 0) != 0 {
                    cell.loansLabel.isHidden = false
                    cell.loansLabel.layer.cornerRadius = 4
                    cell.loansLabel.clipsToBounds = true
                    
                    cell.loansLabel.paddingTop = 2
                    cell.loansLabel.paddingBottom = 2
                    cell.loansLabel.paddingLeft = 6
                    cell.loansLabel.paddingRight = 6
                    
                    cell.loansLabel.text = String(self.gameState.loans?[operatingPlayerIndex] ?? 0) + " loans"
                    cell.loansLabel.backgroundColor = UIColor.primaryAccentColor
                    cell.loansLabel.textColor = UIColor.white
                } else {
                    cell.loansLabel.isHidden = true
                }
                
                if OperationType.getSROperationTypes().contains(self.gameState.currentRoundOperationType), let playerIdx = self.gameState.homeDynamicTurnOrdersPreviewByPlayerBaseIndexes.firstIndex(of: operatingPlayerBaseIndex) {
                    cell.dynamicTurnOrderPreviewLabel.isHidden = false
                    if self.gameState.playerTurnOrderType == .passOrder {
                        cell.dynamicTurnOrderPreviewLabel.text = "Pass #\(playerIdx + 1)"
                    } else {
                        cell.dynamicTurnOrderPreviewLabel.text = "next SR #\(playerIdx + 1)"
                    }
                    cell.dynamicTurnOrderPreviewLabel.backgroundColor = UIColor.primaryAccentColor
                } else {
                    cell.dynamicTurnOrderPreviewLabel.isHidden = true
                }
                
                cell.totalNetWorthLabel.text = "TOT:\n" + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.playersTotalNetWorths[operatingPlayerBaseIndex])
                return cell
                
            case CollectionViewType.market:
                
                switch self.marketCollectionViewCellType {
                case .g1846:

                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "g1846MarketCollectionViewCell", for: indexPath) as! G1846MarketCollectionViewCell
                    
                    if let shareValue = self.gameState.getShareValue(forCollectionViewIndexPath: indexPath) {
                        cell.shareValueLabel.isHidden = false
                        cell.contentView.backgroundColor = self.gameState.getBackgroundColorForCell(atCollectionViewIndexPath: indexPath) ?? UIColor.white
                        cell.companiesStackView.isHidden = false
                        
                        cell.shareValueLabel.text = "\(Int(shareValue))"
                        cell.shareValueLabel.textAlignment = .center
                        cell.shareValueLabel.textColor = self.gameState.getTextColorForCell(atCollectionViewIndexPath: indexPath)
                        cell.shareValueLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                        
                        let cmpBaseIndexesMatched = self.gameState.getCompanyBaseIndexes(withShareValueInIndexPath: indexPath)
                        
                        if !cmpBaseIndexesMatched.isEmpty {
                            cell.contentView.isUserInteractionEnabled = true
                            cell.contentView.addGestureRecognizer(cell.companiesScrollView.panGestureRecognizer)
                            
                            for (i, view) in cell.companiesStackView.arrangedSubviews.enumerated() {
                                if i < cmpBaseIndexesMatched.count {
                                    if let imageView = view as? UIImageView {
                                        imageView.isHidden = false
                                        imageView.image = self.gameState.getCompanyLogo(atBaseIndex: cmpBaseIndexesMatched[i])
                                    }
                                } else {
                                    view.isHidden = true
                                }
                            }
                            
                            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
                            cell.contentView.addGestureRecognizer(panGestureRecognizer)
                            
                        } else {
                            cell.contentView.isUserInteractionEnabled = false
                            cell.companiesStackView.isHidden = true
                        }
                        
                    } else {
                        cell.shareValueLabel.isHidden = true
                        cell.contentView.backgroundColor = UIColor.systemGray4
                    }
                    
                    return cell
                    
                case .standard:
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
                    cell.reset()
                    
                    if let shareValue = self.gameState.getShareValue(forCollectionViewIndexPath: indexPath) {
                        cell.shareValueLabel.isHidden = false
                        
                        if self.gameState.game == .g1848 && shareValue == 0 {
                            let shareValueIdx = self.gameState.getShareValueIndex(fromCollectionViewIndexPath: indexPath)
                            cell.shareValueLabel.text = ["Re", "ce", "iv", "er", "sh", "ip"][shareValueIdx.y]
                        } else {
                            cell.shareValueLabel.text = "\(Int(shareValue))"
                        }
                        
                        let cmpBaseIndexesMatched = self.gameState.getCompanyBaseIndexes(withShareValueInIndexPath: indexPath)
                        
                        if !cmpBaseIndexesMatched.isEmpty {
                            cell.isUserInteractionEnabled = true
                            cell.contentView.backgroundColor = self.gameState.getBackgroundColorForCell(atCollectionViewIndexPath: indexPath) ?? UIColor.systemGray6
                            
                            cell.shareValueLabel.backgroundColor = UIColor.clear
                            let whiteTextColorCount = cmpBaseIndexesMatched.filter { self.gameState.getCompanyTextColor(atBaseIndex: $0) == UIColor.white }.count
                            let blackTextColorCount = cmpBaseIndexesMatched.count - whiteTextColorCount
                            
                            if whiteTextColorCount == 0 {
                                cell.shareValueLabel.textColor = UIColor.black
                                cell.shareValueLabel.strokeSize = 0
                                cell.shareValueLabel.strokeColor = UIColor.clear
                            } else if blackTextColorCount == 0 {
                                cell.shareValueLabel.textColor = UIColor.white
                                cell.shareValueLabel.strokeSize = 0
                                cell.shareValueLabel.strokeColor = UIColor.clear
                            } else {
                                cell.shareValueLabel.textColor = UIColor.black
                                cell.shareValueLabel.strokeSize = 6
                                cell.shareValueLabel.strokeColor = UIColor.white
                            }
                            
                            let colors = cmpBaseIndexesMatched.map { self.gameState.getCompanyColor(atBaseIndex: $0) }
                            
                            let paths = self.getBezierPaths(forColors: colors)
                            
                            cell.setBezierPaths(bezierPaths: paths, andColors: colors)
                            
                            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
                            cell.contentView.addGestureRecognizer(panGestureRecognizer)
                            
                        } else {
                            cell.isUserInteractionEnabled = false
                            cell.contentView.backgroundColor = UIColor.white
                            cell.shareValueLabel.backgroundColor = self.gameState.getBackgroundColorForCell(atCollectionViewIndexPath: indexPath) ?? UIColor.systemGray6
                            cell.shareValueLabel.textColor = self.gameState.getTextColorForCell(atCollectionViewIndexPath: indexPath)
                            cell.shareValueLabel.strokeSize = 0
                            cell.shareValueLabel.strokeColor = UIColor.clear
                        }
                        
                    } else {
                        cell.shareValueLabel.isHidden = true
                        cell.contentView.backgroundColor = UIColor.systemGray4
                    }
                    
                    return cell
                }
                
            case CollectionViewType.reducedCompanies:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reducedCompaniesCollectionViewCell", for: indexPath) as! ReducedCompaniesCollectionViewCell
                let operatingCompanyBaseIndex = self.reducedCompaniesFilteredBaseIndexes[indexPath.row]
                let operatingCompanyIndex = self.gameState.forceConvert(index: operatingCompanyBaseIndex, backwards: false, withIndexType: .companies)
                cell.contentView.backgroundColor = UIColor.systemGray4
                cell.labelsStackView.spacing = 2
                
                cell.parLabel.paddingLeft = 12
                cell.parLabel.paddingRight = 12
                
                cell.parLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
                cell.payoutLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
                cell.accessoryLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
                
                var parStr: String = ""
                let parAttributedText = NSMutableAttributedString()
                if let parValue = self.gameState.getPARvalue(forCompanyAtBaseIndex: operatingCompanyBaseIndex), !self.gameState.PARValueIsIrrelevantToShow {
                    parStr = "PAR: \(parValue)"
                } else {
                    parStr = self.gameState.getCompanyLabel(atBaseIndex: operatingCompanyBaseIndex)
                }
                
                parAttributedText.append(NSAttributedString(string: parStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .medium), NSAttributedString.Key.foregroundColor: self.gameState.getCompanyTextColor(atBaseIndex: operatingCompanyBaseIndex)]))
                cell.parLabel.attributedText = parAttributedText
                cell.parLabel.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: operatingCompanyBaseIndex)
                cell.parLabel.clipsToBounds = true
                cell.parLabel.layer.cornerRadius = 17.0
                
                switch self.gameState.game {
                case .g1840:
                    if let lastRevenue = self.gameState.g1840LastCompanyRevenues?[operatingCompanyBaseIndex], lastRevenue != 0 && self.gameState.getCompanyType(atBaseIndex: operatingCompanyBaseIndex) == .standard {
                        cell.payoutLabel.isHidden = false
                        cell.payoutLabel.backgroundColor = UIColor.clear
                        cell.payoutLabel.textColor = UIColor.black
                        cell.payoutLabel.text = "Revenue: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(lastRevenue))
                    } else if self.gameState.getLastPayoutForCompany(atBaseIndex: operatingCompanyBaseIndex) != 0 && self.gameState.getCompanyType(atBaseIndex: operatingCompanyBaseIndex) == .g1840Stadtbahn {
                        cell.payoutLabel.isHidden = false
                        cell.payoutLabel.backgroundColor = UIColor.clear
                        cell.payoutLabel.textColor = UIColor.black
                        cell.payoutLabel.text = "payout: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(self.gameState.getLastPayoutForCompany(atBaseIndex: operatingCompanyBaseIndex)))
                    } else {
                        cell.payoutLabel.isHidden = true
                    }
                case .g1830, .g1846, .g1848, .g1849, .g1856, .g1882, .g1889, .g18MEX, .g18Chesapeake:
                    let lastPayout = self.gameState.getLastPayoutForCompany(atBaseIndex: operatingCompanyBaseIndex)
                    if lastPayout != 0 {
                        cell.payoutLabel.isHidden = false
                        cell.payoutLabel.backgroundColor = UIColor.systemGray4
                        cell.payoutLabel.textColor = UIColor.black
                        cell.payoutLabel.text = "payout: \(Int(lastPayout))"
                    } else {
                        cell.payoutLabel.isHidden = true
                    }
                }
                
                var accessoryStrComponents: [String] = []
                
                if let loansAmount = self.gameState.loans?[operatingCompanyIndex], loansAmount != 0 {
                    accessoryStrComponents.append("\(Int(loansAmount)) loans")
                }
                
                if let bondsAmount = self.gameState.bonds?[operatingCompanyIndex], bondsAmount != 0 {
                    accessoryStrComponents.append("\(Int(bondsAmount)) bonds")
                }
                
                if accessoryStrComponents.isEmpty {
                    cell.accessoryLabel.isHidden = true
                } else {
                    cell.accessoryLabel.isHidden = false
                    cell.accessoryLabel.text = accessoryStrComponents.joined(separator: " - ")
                    cell.accessoryLabel.backgroundColor = UIColor.systemGray4
                }
                
                if !cell.payoutLabel.isHidden && !cell.accessoryLabel.isHidden {
                    cell.labelsStackView.backgroundColor = UIColor.primaryAccentColor
                } else {
                    cell.labelsStackView.backgroundColor = UIColor.clear
                }
                
                return cell
                
            case CollectionViewType.reducedPlayers:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reducedPlayersCollectionViewCell", for: indexPath) as! ReducedPlayersCollectionViewCell
                let operatingPlayerBaseIndex = self.gameState.homeDynamicTurnOrdersPreviewByPlayerBaseIndexes[indexPath.row]
                
                cell.contentView.backgroundColor = UIColor.systemGray6
                cell.labelsStackView.backgroundColor = UIColor.primaryAccentColor
                
                cell.deltaLabel.backgroundColor = UIColor.systemGray6
                cell.deltaLabel.textColor = UIColor.black
                cell.deltaLabel.text = "delta: +\(Int(self.playersDeltas[operatingPlayerBaseIndex]))"
                
                cell.cashLabel.backgroundColor = UIColor.systemGray6
                cell.cashLabel.textColor = UIColor.black
                cell.cashLabel.text = "\(indexPath.row + 1) \(self.gameState.getPlayerLabel(atBaseIndex: operatingPlayerBaseIndex)): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atBaseIndex: operatingPlayerBaseIndex)))"
                
                cell.portfolioLabel.backgroundColor = UIColor.systemGray6
                cell.portfolioLabel.textColor = UIColor.black
                cell.portfolioLabel.text = "portfolio: " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.playersTotalNetWorths[operatingPlayerBaseIndex])
                
                return cell
                
            case CollectionViewType.roundTrack:
                switch self.gameState.game {
                case .g1840:
                    if indexPath.row == self.gameState.roundOperationTypes.count - 1 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roundType1840LastCollectionViewCell", for: indexPath) as! RoundType1840LastCollectionViewCell
                        cell.contentView.backgroundColor = UIColor.secondaryAccentColor
                        cell.parentVC = self
                        
                        cell.roundTypeButton.tag = indexPath.row
                        cell.roundTypeButton.backgroundColor = self.gameState.roundOperationTypeColors[indexPath.row].uiColor
                        cell.roundTypeButton.layer.cornerRadius = 27.0
                        cell.roundTypeButton.clipsToBounds = true
                        cell.roundTypeButton.layer.borderColor = UIColor.black.cgColor
                        cell.roundTypeButton.layer.borderWidth = 2.0
                        
                        if self.gameState.currentRoundOperationType == self.gameState.roundOperationTypes[indexPath.row] {
                            cell.roundTypeLabel.isHidden = true
                            let imageStr = self.gameState.roundOperationTypeColors[indexPath.row].uiColor == .black ? "pawn_white" : "pawn"
                            cell.roundTypeButton.setImage(UIImage(named: imageStr), for: .normal)
                        } else {
                            cell.roundTypeLabel.isHidden = false
                            cell.roundTypeLabel.text = self.gameState.roundOperationTypes[indexPath.row].getRoundTrackLabel()
                            cell.roundTypeLabel.textColor = self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor
                            cell.roundTypeLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                            cell.roundTypeButton.setImage(nil, for: .normal)
                        }
                        
                        if let baselineText = self.gameState.g1840RoundOperationTypeBaselineTexts?[indexPath.row] {
                            cell.roundTypeLabelCenterYLayoutConstraint.constant = -5.0
                            cell.baselineLabel.isHidden = false
                            cell.baselineLabel.text = baselineText
                            cell.baselineLabel.textColor = self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor
                        } else {
                            cell.roundTypeLabelCenterYLayoutConstraint.constant = 0.0
                            cell.baselineLabel.isHidden = true
                        }
                        
                        if let multiplierValue = self.gameState.g1840RoundOperationTypeCRMultipliers?[indexPath.row] {
                            cell.roundTypeButtonCenterYLayoutConstraint.constant = -10.0
                            cell.multiplierLabel.isHidden = false
                            cell.multiplierLabel.text = "\(multiplierValue)x"
                        } else {
                            cell.roundTypeButtonCenterYLayoutConstraint.constant = 0.0
                            cell.multiplierLabel.isHidden = true
                        }
                        
                        return cell
                        
                    } else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roundType1840CollectionViewCell", for: indexPath) as! RoundType1840CollectionViewCell
                        cell.contentView.backgroundColor = UIColor.secondaryAccentColor
                        cell.parentVC = self
                        
                        cell.roundTypeButton.tag = indexPath.row
                        cell.roundTypeButton.backgroundColor = self.gameState.roundOperationTypeColors[indexPath.row].uiColor
                        cell.roundTypeButton.layer.cornerRadius = 27.0
                        cell.roundTypeButton.clipsToBounds = true
                        cell.roundTypeButton.layer.borderColor = UIColor.black.cgColor
                        cell.roundTypeButton.layer.borderWidth = 2.0
                        
                        if self.gameState.currentRoundOperationType == self.gameState.roundOperationTypes[indexPath.row] {
                            cell.roundTypeLabel.isHidden = true
                            let imageStr = self.gameState.roundOperationTypeColors[indexPath.row].uiColor == .black ? "pawn_white" : "pawn"
                            cell.roundTypeButton.setImage(UIImage(named: imageStr), for: .normal)
                        } else {
                            cell.roundTypeLabel.isHidden = false
                            cell.roundTypeLabel.text = self.gameState.roundOperationTypes[indexPath.row].getRoundTrackLabel()
                            cell.roundTypeLabel.textColor = self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor
                            cell.roundTypeLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                            cell.roundTypeButton.setImage(nil, for: .normal)
                        }
                        
                        if let baselineText = self.gameState.g1840RoundOperationTypeBaselineTexts?[indexPath.row] {
                            cell.roundTypeLabelCenterYLayoutConstraint.constant = -5.0
                            cell.baselineLabel.isHidden = false
                            cell.baselineLabel.text = baselineText
                            cell.baselineLabel.textColor = self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor
                        } else {
                            cell.roundTypeLabelCenterYLayoutConstraint.constant = 0.0
                            cell.baselineLabel.isHidden = true
                        }
                        
                        if let multiplierValue = self.gameState.g1840RoundOperationTypeCRMultipliers?[indexPath.row] {
                            cell.roundTypeButtonCenterYLayoutConstraint.constant = -10.0
                            cell.multiplierLabel.isHidden = false
                            cell.multiplierLabel.text = "\(multiplierValue)x"
                        } else {
                            cell.roundTypeButtonCenterYLayoutConstraint.constant = 0.0
                            cell.multiplierLabel.isHidden = true
                        }
                        
                        return cell
                    }
                    
                case .g1830, .g1846, .g1848, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
                    if indexPath.row == self.gameState.roundOperationTypes.count - 1 {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roundTypeClassicLastCollectionViewCell", for: indexPath) as! RoundTypeClassicLastCollectionViewCell
                        cell.contentView.backgroundColor = UIColor.secondaryAccentColor
                        cell.parentVC = self
                        
                        cell.roundTypeButton.tag = indexPath.row
                        cell.roundTypeButton.backgroundColor = self.gameState.roundOperationTypeColors[indexPath.row].uiColor
                        cell.roundTypeButton.layer.cornerRadius = 27.0
                        cell.roundTypeButton.clipsToBounds = true
                        cell.roundTypeButton.layer.borderColor = UIColor.black.cgColor
                        cell.roundTypeButton.layer.borderWidth = 2.0
                        
                        if self.gameState.currentRoundOperationType == self.gameState.roundOperationTypes[indexPath.row] {
                            cell.roundTypeButton.setTitle(withText: "", fontSize: 20.0, fontWeight: .semibold, textColor: self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor)
                            let imageStr = self.gameState.roundOperationTypeColors[indexPath.row].uiColor == .black ? "pawn_white" : "pawn"
                            cell.roundTypeButton.setImage(UIImage(named: imageStr), for: .normal)
                        } else {
                            cell.roundTypeButton.setTitle(withText: self.gameState.roundOperationTypes[indexPath.row].getRoundTrackLabel(), fontSize: 20.0, fontWeight: .semibold, textColor: self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor)
                            cell.roundTypeButton.setImage(nil, for: .normal)
                        }
                        
                        return cell
                    } else {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roundTypeClassicCollectionViewCell", for: indexPath) as! RoundTypeClassicCollectionViewCell
                        cell.contentView.backgroundColor = UIColor.secondaryAccentColor
                        cell.parentVC = self
                        
                        cell.roundTypeButton.tag = indexPath.row
                        cell.roundTypeButton.backgroundColor = self.gameState.roundOperationTypeColors[indexPath.row].uiColor
                        cell.roundTypeButton.layer.cornerRadius = 27.0
                        cell.roundTypeButton.clipsToBounds = true
                        cell.roundTypeButton.layer.borderColor = UIColor.black.cgColor
                        cell.roundTypeButton.layer.borderWidth = 2.0
                        
                        if self.gameState.currentRoundOperationType == self.gameState.roundOperationTypes[indexPath.row] {
                            cell.roundTypeButton.setTitle(withText: "", fontSize: 20.0, fontWeight: .semibold, textColor: self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor)
                            let imageStr = self.gameState.roundOperationTypeColors[indexPath.row].uiColor == .black ? "pawn_white" : "pawn"
                            cell.roundTypeButton.setImage(UIImage(named: imageStr), for: .normal)
                        } else {
                            cell.roundTypeButton.setTitle(withText: self.gameState.roundOperationTypes[indexPath.row].getRoundTrackLabel(), fontSize: 20.0, fontWeight: .semibold, textColor: self.gameState.roundOperationTypeTextColors[indexPath.row].uiColor)
                            cell.roundTypeButton.setImage(nil, for: .normal)
                        }
                        
                        return cell
                    }
                }
                
            case .g1840Lines:
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "g1840LineCollectionViewCell", for: indexPath) as! G1840LineCollectionViewCell
                cell.contentView.backgroundColor = UIColor.black
                
                if [.g1840LR1a, .g1840LR2a, .g1840LR3a, .g1840LR4a, .g1840LR5a].contains(self.gameState.currentRoundOperationType) {
                    cell.outerStackView.spacing = 34.0
                } else {
                    cell.outerStackView.spacing = 20.0
                }
                
                let lineBaseIdx = self.g1840ActiveLineBaseIndexes[indexPath.row]
                let cmpIdx = self.gameState.g1840LinesOwnerGlobalIndexes?[lineBaseIdx] ?? 0
                
                cell.lineLabel.text = "\(self.gameState.g1840LinesLabels?[lineBaseIdx] ?? "")"
                cell.lineLabel.textColor = .white
                cell.lineLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
                
                cell.mainCompanyLabel.text = "\(self.gameState.getCompanyLabel(atIndex: cmpIdx)): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: cmpIdx)))"
                cell.mainCompanyLabel.backgroundColor = .systemGray6
                cell.mainCompanyLabel.textColor = .black
                cell.mainCompanyLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
                cell.mainCompanyLabel.paddingLeft = 12.0
                cell.mainCompanyLabel.paddingRight = 12.0
                cell.mainCompanyLabel.paddingTop = 7.0
                cell.mainCompanyLabel.paddingBottom = 7.0
                
                cell.revenueStackView.spacing = 3.0
                cell.revenueStackView.backgroundColor = UIColor.white
                
                let currentRoundNumber: Character = self.gameState.currentRoundOperationType.rawValue.dropLast().last ?? Character("")
                
                for (i, view) in cell.revenueStackView.arrangedSubviews.enumerated() {
                    if let runLabel = view as? PaddingLabel {
                        if let runValue = self.gameState.g1840LinesRevenue?[lineBaseIdx][i] {
                            let amountStr = runValue != 0 ? self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(runValue)) : " - "
                            
                            switch i {
                            case 0:
                                runLabel.isHidden = false
                                runLabel.text = "Run (\(currentRoundNumber)a): \(amountStr)"
                            case 1:
                                if [OperationType.g1840LR1b, OperationType.g1840LR2b, OperationType.g1840LR3b, OperationType.g1840LR4b, OperationType.g1840LR5b, .g1840LR5c].contains(self.gameState.currentRoundOperationType) {
                                    runLabel.isHidden = false
                                    runLabel.text = "Run (\(currentRoundNumber)b): \(amountStr)"
                                } else {
                                    runLabel.isHidden = true
                                }
                            case 2:
                                if self.gameState.currentRoundOperationType == .g1840LR5c {
                                    runLabel.isHidden = false
                                    runLabel.text = "Run (\(currentRoundNumber)c): \(amountStr)"
                                } else {
                                    runLabel.isHidden = true
                                }
                            default:
                                runLabel.isHidden = true
                            }
                            
                            runLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
                            runLabel.textAlignment = .center
                            runLabel.textColor = .white
                            runLabel.backgroundColor = UIColor.black
                            runLabel.paddingTop = 8.0
                            runLabel.paddingBottom = 8.0
                            
                        }
                    }
                }
                
                let currentRoundChar: Character = self.gameState.currentRoundOperationType.rawValue.last ?? Character("")
                var currentRoundIdx = 0
                if currentRoundChar == "b" {
                    currentRoundIdx = 1
                } else if currentRoundChar == "c" {
                    currentRoundIdx = 2
                }
                
                cell.tickImageView.isHidden = self.gameState.g1840LinesRevenue?[self.g1840ActiveLineBaseIndexes[indexPath.row]][currentRoundIdx] == 0
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func getBezierPaths(forColors colors: [UIColor]) -> [UIBezierPath] {
        
        var paths: [UIBezierPath] = []
        
        let cellWidth = 80.0
        let cellHeight = 40.0
        
        // single row layer
        if colors.count < 4 {
        
            let widthStep = Int(floor(cellWidth / Double(colors.count)))
            let widthRemainder = Int(cellWidth) - (widthStep * colors.count)
            
            for i in 0..<colors.count {
            
                let path = UIBezierPath()
                
                path.move(to: CGPoint(x: widthStep * i, y: 0))
                path.addLine(to: CGPoint(x: (widthStep * (i + 1)) + (i == colors.count - 1 ? widthRemainder : 0), y: 0))
                path.addLine(to: CGPoint(x: (widthStep * (i + 1)) + (i == colors.count - 1 ? widthRemainder : 0), y: Int(cellHeight)))
                path.addLine(to: CGPoint(x: widthStep * i, y: Int(cellHeight)))
                path.close()
                
                paths.append(path)
            
            }
            
        // double row layer
        } else {
            
            let cols = Int(ceil(Double(colors.count) / 2.0))
            let rows = 2
            
            let widthStep = Int(floor(cellWidth / Double(cols)))
            let widthRemainder = Int(cellWidth) - (widthStep * cols)
            
            let heightStep = Int(floor(cellHeight / Double(rows)))
            let heightRemainder = Int(cellHeight) - (heightStep * rows)
            
            for i in 0..<colors.count {
            
                let currentRow = i < Int(ceil(Double(colors.count) / 2.0)) ? 0 : 1
                let currentCol = i % cols
                
                let path = UIBezierPath()
                
                path.move(to: CGPoint(x: widthStep * currentCol, y: currentRow * heightStep))
                path.addLine(to: CGPoint(x: (widthStep * (currentCol + 1)) + (currentCol == cols - 1 ? widthRemainder : 0), y: currentRow * heightStep))
                path.addLine(to: CGPoint(x: (widthStep * (currentCol + 1)) + (currentCol == cols - 1 ? widthRemainder : 0), y: ((currentRow + 1) * heightStep) + (currentRow == 1 ? heightRemainder : 0)))
                path.addLine(to: CGPoint(x: widthStep * currentCol, y: ((currentRow + 1) * heightStep) + (currentRow == 1 ? heightRemainder : 0)))
                path.close()
                
                paths.append(path)
            
            }
            
        }
        
        return paths
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let collectionViewType = CollectionViewType(rawValue: collectionView.tag) {
            
            switch collectionViewType {
                
            case CollectionViewType.companies, CollectionViewType.g1840Lines:
                
                let rows = 1.0
                let cols = ceil(CGFloat(self.gameState.companiesSize) / rows)
                
                //            if self.gameState.companiesSize <= 8 {
                //                return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
                //
                //            } else {
                
                let width = floor((collectionView.bounds.size.width - 40.0) / 4.0)
                let height = collectionView.getHeightForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
                
                return CGSize(width: Int(width), height: height)
                
                //            }
            case CollectionViewType.players:
                
                if self.gameState.playersSize <= 4 {
                    let rows = 1.0
                    let cols = CGFloat(self.gameState.playersSize)
                    
                    return CGSize(width: collectionView.getWidthForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false), height: Int(collectionView.bounds.height))
                } else {
                    
                    let rows = 1.0
                    let cols = CGFloat(self.gameState.playersSize)
                    
                    let width = floor((collectionView.bounds.size.width - 40.0) / 4.0)
                    let height = collectionView.getHeightForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
                    
                    return CGSize(width: Int(width), height: height)
                }
                
            case CollectionViewType.market:
                
                switch self.marketCollectionViewCellType {
                case .g1846:
                    return CGSize(width: 55, height: collectionView.bounds.size.height)
                case .standard:
                    return CGSize(width: 80.0, height: 40.0)
                }
                
            case CollectionViewType.reducedCompanies:
                
                return CGSize(width: 150.0, height: collectionView.bounds.size.height)
                
            case CollectionViewType.reducedPlayers:
                
                if self.gameState.playersSize <= 6 {
                    let rows = 1.0
                    let cols = CGFloat(self.gameState.playersSize)
                    
                    return CGSize(width: collectionView.getWidthForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false), height: Int(collectionView.bounds.height))
                } else {
                    
                    let rows = 1.0
                    let cols = CGFloat(self.gameState.playersSize)
                    
                    let width = floor((collectionView.bounds.size.width - 40.0) / 6.0)
                    let height = collectionView.getHeightForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
                    
                    return CGSize(width: Int(width), height: height)
                }
            case CollectionViewType.roundTrack:
                switch self.gameState.game {
                case .g1830, .g1840, .g1846, .g1848, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
                    return CGSize(width: indexPath.row == self.gameState.roundOperationTypes.count - 1 ? roundTrackClassicLastCellWidth : roundTrackClassicCellWidth, height: roundTrackClassicCellHeight)
                }
                
            }
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == CollectionViewType.market.rawValue {
            return 2.0
        } else {
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == CollectionViewType.market.rawValue {
            return 2.0
        } else {
            return 0.0
        }
    }
}

extension HomeViewController {
    // handle market drag and drop
    
    @objc func handlePanGestureRecognizer(sender: UIPanGestureRecognizer) {

        if sender.state == .began {
            if let currentIndexPath = self.marketCollectionView.indexPathForItem(at: sender.location(in: self.marketCollectionView)), let currentCell = self.marketCollectionView.cellForItem(at: currentIndexPath), let layerArchivedData = try? NSKeyedArchiver.archivedData(withRootObject: currentCell.layer, requiringSecureCoding: false) {
                
                let cmpBaseIndexesMatched = self.gameState.getCompanyBaseIndexes(withShareValueInIndexPath: currentIndexPath)
                if cmpBaseIndexesMatched.isEmpty { return }
                
                self.flyingCompanyBaseIndexes = cmpBaseIndexesMatched
                self.flyingCompanyBaseIndexPickerSelected = cmpBaseIndexesMatched[0]
                
                do {
                    if let flyingLayer: CALayer = try NSKeyedUnarchiver.unarchivedObject(ofClass: CALayer.self, from: layerArchivedData) {
                        
                        self.marketCollectionView.layer.insertSublayer(flyingLayer, at: UInt32(self.gameState.getCollectionViewNumberOfItems() - 1))
                        
                        var textLayerFrame: CGRect
                        var textLayerTextColor: UIColor
                        var textLayerBackgroundColor: UIColor
                        var textLayerFont: UIFont
                        var textLayerFontSize: Double
                        
                        switch self.marketCollectionViewCellType {
                        case .g1846:
                            textLayerFrame = CGRect(x: 0, y: 13, width: 55, height: 50)
                            textLayerTextColor = UIColor.black
                            textLayerBackgroundColor = UIColor.clear
                            textLayerFontSize = 22.0
                            textLayerFont = UIFont.systemFont(ofSize: textLayerFontSize, weight: .semibold)
                            
                        case .standard:
                            textLayerFrame = CGRect(x: 0, y: 6, width: 80, height: 40)
                            
                            let whiteTextColorCount = cmpBaseIndexesMatched.filter { self.gameState.getCompanyTextColor(atBaseIndex: $0) == UIColor.white }.count
                            let blackTextColorCount = cmpBaseIndexesMatched.count - whiteTextColorCount
                            textLayerTextColor = whiteTextColorCount >= blackTextColorCount ? UIColor.white : UIColor.black
                            
                            textLayerBackgroundColor = UIColor.clear
                            textLayerFontSize = 24.0
                            textLayerFont = UIFont.systemFont(ofSize: textLayerFontSize, weight: .semibold)
                        }
                        
                        let textlayer = CATextLayer()

                        textlayer.frame = textLayerFrame
                        textlayer.alignmentMode = .center
                        textlayer.font = textLayerFont
                        textlayer.fontSize = textLayerFontSize
                        textlayer.string = "\(Int(self.gameState.getShareValue(forCollectionViewIndexPath: currentIndexPath) ?? 0.0))"
                        textlayer.isWrapped = true
                        textlayer.truncationMode = .end
                        textlayer.backgroundColor = textLayerBackgroundColor.cgColor
                        textlayer.foregroundColor = textLayerTextColor.cgColor
                        textlayer.contentsScale = UIScreen.main.scale

                        flyingLayer.addSublayer(textlayer)
                        
                        self.flyingLayer = flyingLayer
                        self.flyingAccessoryTextLayer = textlayer
                        self.flyingAccessoryTextColor = textLayerTextColor
                        self.flyingCurrentIndexPath = currentIndexPath
                        
                        self.previousTranslation = sender.translation(in: self.marketCollectionView)
                    }
                }
                catch {
                    
                }
                
            }
        } else if sender.state == .changed {
            if let flyingLayer = self.flyingLayer {
                if let currentIndexPath = self.marketCollectionView.indexPathForItem(at: sender.location(in: self.marketCollectionView)) {
                    if let flyingCurrentIndexPath = self.flyingCurrentIndexPath {
                        let isGestureTooFast = abs(sender.velocity(in: self.marketCollectionView).x) > 500 || abs(sender.velocity(in: self.marketCollectionView).y) > 500
                        if currentIndexPath != flyingCurrentIndexPath && !isGestureTooFast {
                            
                            var textLayerStr = "\(Int(self.gameState.getShareValue(forCollectionViewIndexPath: currentIndexPath) ?? -1.0))"
                            if textLayerStr == "-1" { textLayerStr = "-" }
                            
                            self.flyingAccessoryTextLayer?.removeFromSuperlayer()
                            
                            var textLayerFrame: CGRect
                            var textLayerBackgroundColor: UIColor
                            var textLayerFont: UIFont
                            var textLayerFontSize: Double
                            
                            switch self.marketCollectionViewCellType {
                            case .g1846:
                                textLayerFrame = CGRect(x: 0, y: 13, width: 55, height: 50)
                                textLayerBackgroundColor = UIColor.clear
                                textLayerFontSize = 22.0
                                textLayerFont = UIFont.systemFont(ofSize: textLayerFontSize, weight: .semibold)
                                
                            case .standard:
                                textLayerFrame = CGRect(x: 0, y: 6, width: 80, height: 40)
                                textLayerBackgroundColor = UIColor.clear
                                textLayerFontSize = 24.0
                                textLayerFont = UIFont.systemFont(ofSize: textLayerFontSize, weight: .semibold)
                            }
                            
                            let textlayer = CATextLayer()

                            textlayer.frame = textLayerFrame
                            textlayer.alignmentMode = .center
                            textlayer.font = textLayerFont
                            textlayer.fontSize = textLayerFontSize
                            textlayer.string = textLayerStr
                            textlayer.isWrapped = true
                            textlayer.truncationMode = .end
                            textlayer.backgroundColor = textLayerBackgroundColor.cgColor
                            textlayer.foregroundColor = self.flyingAccessoryTextColor.cgColor
                            textlayer.contentsScale = UIScreen.main.scale

                            flyingLayer.addSublayer(textlayer)
                            
                            if let _ = self.gameState.getShareValue(forCollectionViewIndexPath: currentIndexPath), let hoverCell = self.marketCollectionView.cellForItem(at: currentIndexPath) {
                                hoverCell.layer.borderWidth = 4.0
                                hoverCell.layer.borderColor = UIColor.primaryAccentColor.cgColor
                            }
                            
                            if let prevCell = self.marketCollectionView.cellForItem(at: flyingCurrentIndexPath) {
                                prevCell.layer.borderWidth = 0.0
                                prevCell.layer.borderColor = UIColor.clear.cgColor
                            }
                            
                            self.flyingCurrentIndexPath = currentIndexPath
                            self.flyingAccessoryTextLayer = textlayer
                        }
                        
                    }
                    
                } else if sender.location(in: self.marketCollectionView).y < -25 || sender.location(in: self.marketCollectionView).y > self.marketCollectionView.bounds.height + 25 {
                    
                    if let flyingCurrentIndexPath = self.flyingCurrentIndexPath, let prevCell = self.marketCollectionView.cellForItem(at: flyingCurrentIndexPath) {
                        prevCell.layer.borderWidth = 0.0
                        prevCell.layer.borderColor = UIColor.clear.cgColor
                    }
                    
                    resetFlyingComponents()
                    return
                }
                
                let locationInCollectionView = sender.location(in: self.marketCollectionView)
                
                if !self.lastLocationInView.equalTo(locationInCollectionView) {
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    let currentTranslation = sender.translation(in: self.marketCollectionView)
                    let deltaTranslation = CGPoint(x: currentTranslation.x - self.previousTranslation.x, y: currentTranslation.y - self.previousTranslation.y)
                    self.previousTranslation = currentTranslation
                    
                    flyingLayer.position.x += deltaTranslation.x
                    flyingLayer.position.y += deltaTranslation.y
                    CATransaction.commit()
                }
                
                let minContentOffsetX: CGFloat = 0.0
                let maxContentOffsetX: CGFloat = self.marketCollectionView.contentSize.width - self.marketCollectionView.bounds.width
                
                if self.marketCollectionView.contentOffset.x < maxContentOffsetX && locationInCollectionView.x > self.marketCollectionView.bounds.width + self.marketCollectionView.contentOffset.x - 90 {
                    
                    if self.lastLocationInView.equalTo(locationInCollectionView) {
                        let updateContentOffset = CGPoint(x: min(self.marketCollectionView.contentOffset.x + 1.0, maxContentOffsetX), y: 0.0)
                        flyingLayer.position.x += (updateContentOffset.x - self.marketCollectionView.contentOffset.x)
                        self.marketCollectionView.setContentOffset(updateContentOffset, animated: false)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.handlePanGestureRecognizer(sender: sender)
                    }
                } else if self.marketCollectionView.contentOffset.x > minContentOffsetX && locationInCollectionView.x < self.marketCollectionView.contentOffset.x + 90.0 {
                    
                    if self.lastLocationInView.equalTo(locationInCollectionView) {
                        let updateContentOffset = CGPoint(x: max(self.marketCollectionView.contentOffset.x - 1.0, minContentOffsetX), y: 0.0)
                        flyingLayer.position.x -= (self.marketCollectionView.contentOffset.x - updateContentOffset.x)
                        self.marketCollectionView.setContentOffset(updateContentOffset, animated: false)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        self.handlePanGestureRecognizer(sender: sender)
                    }
                }
                
                self.lastLocationInView = locationInCollectionView
                
            }
        } else if sender.state == .ended {
            if let _ = self.flyingLayer {
                
                if let flyingCurrentIndexPath = self.flyingCurrentIndexPath, let prevCell = self.marketCollectionView.cellForItem(at: flyingCurrentIndexPath) {
                    prevCell.layer.borderWidth = 0.0
                    prevCell.layer.borderColor = UIColor.clear.cgColor
                    
                    let section = flyingCurrentIndexPath.row / self.gameState.getVerticalCellCount()
                    let row = flyingCurrentIndexPath.row % self.gameState.getVerticalCellCount()
                    
                    let shareValueIndexPath = ShareValueIndexPath(x: section, y: row)
                    
                    if let dropShareValue = self.gameState.getShareValue(forCollectionViewIndexPath: flyingCurrentIndexPath) {
                        if self.gameState.getShareValueIndex(forCompanyAtBaseIndex: self.flyingCompanyBaseIndexes[0]) == shareValueIndexPath {
                          // drag from index to same index, do nothing
                            
                        } else if self.flyingCompanyBaseIndexes.count == 1 {
                            
                            if let fromIndex = self.gameState.getShareValueIndex(forCompanyAtBaseIndex: self.flyingCompanyBaseIndexes[0]), let dropShareValue = self.gameState.getShareValue(atIndexPath: shareValueIndexPath) {
                                let op = Operation(type: .market)
                                op.setOperationColorGlobalIndex(colorGlobalIndex: self.gameState.forceConvert(index: self.flyingCompanyBaseIndexes[0], backwards: false, withIndexType: .companies))
                                
                                let fromValue = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getShareValue(atIndexPath: fromIndex) ?? 0.0)
                                let toValue = self.gameState.currencyType.getCurrencyStringFromAmount(amount: dropShareValue)
                                
                                op.addMarketDetails(marketShareValueCmpBaseIndex: self.flyingCompanyBaseIndexes[0], marketShareValueFromIndex: fromIndex, marketShareValueToIndex: shareValueIndexPath, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: self.flyingCompanyBaseIndexes[0])): \(fromValue) -> \(toValue)")
                                _ = self.gameState.perform(operation: op, reverted: false)
                                
                                self.refreshUI()
                            }
                            
                        } else if self.flyingCompanyBaseIndexes.count > 1 {
                            
                            let texts = self.flyingCompanyBaseIndexes.map { self.gameState.getCompanyLabel(atBaseIndex: $0) }
                            let textColors = self.flyingCompanyBaseIndexes.map { self.gameState.getCompanyTextColor(atBaseIndex: $0) }
                            let backgroundColors = self.flyingCompanyBaseIndexes.map { self.gameState.getCompanyColor(atBaseIndex: $0) }
                            
                            let alert = storyboard?.instantiateViewController(withIdentifier: "customMultiselectionPickerViewAlertViewController") as! CustomMultiselectionPickerViewAlertViewController
                            alert.setup(withTitle: "Which company should be dropped at \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: dropShareValue, shouldTruncateDouble: true))?", andElementsTexts: texts, andElementsTextColors: textColors, andElementsBackgroundColors: backgroundColors)
                            
                            alert.addCancelAction(withLabel: "Cancel") {
                                self.resetFlyingComponents()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    self.marketCollectionView.reloadData()
                                }
                            }
                            
                            alert.addConfirmAction(withLabel: "Confirm") { selectedIndexes in
                                
                                var shouldRefreshUI = false
                                
                                for selectedIndex in selectedIndexes {
                                    
                                    if let fromIndex = self.gameState.getShareValueIndex(forCompanyAtBaseIndex: self.flyingCompanyBaseIndexes[selectedIndex]), let dropShareValue = self.gameState.getShareValue(atIndexPath: shareValueIndexPath) {
                                        
                                        if fromIndex != shareValueIndexPath {
                                            shouldRefreshUI = true
                                            
                                            let op = Operation(type: .market)
                                            op.setOperationColorGlobalIndex(colorGlobalIndex: self.gameState.forceConvert(index: self.flyingCompanyBaseIndexes[selectedIndex], backwards: false, withIndexType: .companies))
                                            
                                            let fromValue = self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getShareValue(atIndexPath: fromIndex) ?? 0.0)
                                            let toValue = self.gameState.currencyType.getCurrencyStringFromAmount(amount: dropShareValue)
                                            
                                            op.addMarketDetails(marketShareValueCmpBaseIndex: self.flyingCompanyBaseIndexes[selectedIndex], marketShareValueFromIndex: fromIndex, marketShareValueToIndex: shareValueIndexPath, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: self.flyingCompanyBaseIndexes[selectedIndex])): \(fromValue) -> \(toValue)")
                                            _ = self.gameState.perform(operation: op, reverted: false)
                                        }
                                        
                                    }
                                }
                                
                                self.resetFlyingComponents()
                                
                                if shouldRefreshUI {
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.refreshUI()
                                    }
                                }
                            }
                            
                            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height + CGFloat((self.flyingCompanyBaseIndexes.count * 50)))
                            
                            self.present(alert,animated: true, completion: nil)
                            return
                        }
                    }
                }
                
                resetFlyingComponents()
                
            }
        }
        
    }
    
    func resetFlyingComponents() {
        self.flyingLayer?.removeFromSuperlayer()
        self.flyingLayer = nil
        self.flyingAccessoryTextLayer = nil
        self.flyingCurrentIndexPath = nil
        self.flyingCompanyBaseIndexes = []
        self.flyingCompanyBaseIndexPickerSelected = 0
    }
}
