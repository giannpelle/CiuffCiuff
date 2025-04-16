//
//  GameState.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation
import UIKit

class DeepCopier {
    
    static func Copy<T:Codable>(of object:T) -> T? {
       do {
           let json = try JSONEncoder().encode(object)
           return try JSONDecoder().decode(T.self, from: json)
       }
       catch let error {
           print(error)
           return nil
       }
    }
}

class GameState: Codable {
    
    let game: Game
    fileprivate let shareValuesManager: ShareValueManager
    var currentRoundOperationType: OperationType
    var currentRoundOperationTypeIndex: Int? {
        if let currentRoundOperationTypeIndex = roundOperationTypes.firstIndex(of: currentRoundOperationType) {
            return currentRoundOperationTypeIndex
        } else {
            return nil
        }
    }
    var playerTurnOrderType: PlayerTurnOrderType
    var gameSpecificPlayerTurnOrderType: PlayerTurnOrderType
    
    var roundOperationTypes: [OperationType]
    var roundOperationTypeColors: [Color]
    var roundOperationTypeTextColors: [Color]
    
    var g1840RoundOperationTypeBaselineTexts: [String?]? = nil
    var g1840RoundOperationTypeCRMultipliers: [Int?]? = nil
    
    let totalBankAmount: Double
    
    let bankSize: Int
    let companiesSize: Int
    let playersSize: Int
    
    var amounts: [Double]
    var shares: [[Double]]
    let labels: [String]
    var loans: [Int]? = nil
    var bonds: [Int]? = nil

    var floatModifiers: [Int]
    let compTypes: [CompanyType]
    let compLogos: [String]
    var compPresidentsGlobalIndexes: [Int?]

    let colors: [Color]
    let textColors: [Color]
    var compTotShares: [Double]
    let predefinedShareAmounts: [Double]
    let presidentCertificateShareAmount: Double
    let printShareAmountsAsInt: Bool
    
    var openCompanyValues: [Int]
    var PARValueIsIrrelevantToShow: Bool
    let tileTokensPriceSuggestions: [Int]
    var trainPriceValues: [Int]
    var trainPriceIndexToCloseAllPrivates: Int
    var currentTrainPriceIndex: Int
    var certificateLimit: Double
    let currencyType: CurrencyType
    
    var requiredNumberOfSharesToFloat: Int
    var floatedCompanies: [Bool]
    
    var operations: [Operation]
    var activeOperations: [Operation] {
        self.operations.filter { $0.isActive }
    }
    
    var lastUid: Int
    
    let ipoSharesPayBank: Bool
    let bankSharesPayBank: Bool
    let compSharesPayBank: Bool
    let asideSharesPayBank: Bool
    let tradeInSharesPayBank: Bool
    
    let buyShareFromIPOPayBank: Bool
    let buyShareFromBankPayBank: Bool
    let buyShareFromCompPayBank: Bool
    
    let sharesFromIPOHavePARprice: Bool
    let sharesFromBankHavePARprice: Bool
    let sharesFromCompHavePARprice: Bool
    let sharesFromAsideHavePARprice: Bool
    let sharesFromTradeInHavePARprice: Bool
    
    let unitShareValuePayoutRoundPolicy: PayoutRoundPolicy
    let isPayoutRoundedUpOnTotalValue: Bool
    let buySellRoundPolicyOnTotal: BuySellRoundPolicy
    let isGenerateTrashHidden: Bool
    let shareStartingLocation: ShareStartingLocation
    
    let legalActionsPlayers: [Int]
    let legalActionsCompanies: [Int]
    var homeCompaniesCollectionViewBaseIndexesSorted: [Int]
    var homeReducedCompaniesCollectionViewBaseIndexesSorted: [Int]
    var homePlayersCollectionViewBaseIndexesSorted: [Int]
    var homeDynamicTurnOrdersPreviewByPlayerBaseIndexes: [Int]
    
    let rulesText: String!
    let privatesBuyInModifiers: [String]
    let privatesLabels: [String]
    var privatesPrices: [Double]
    var privatesIncomes: [Double]
    var privatesMayBeBuyInFlags: [Bool]
    var privatesDescriptions: [String]
    var privatesOwnerGlobalIndexes: [Int]
    var privatesMayBeVoluntarilyClosedFlags: [Bool]
    let privatesLockMoneyIfOutbidden: Bool
    let privatesWillCloseAutomatically: Bool
    
    // NOT HANDLED BY OPERATIONS
    var companiesOperated: [Bool]
    var lastCompPayoutValues: [Int]
    
    var g1840LinesOwnerGlobalIndexes: [Int]? = nil
    var g1840LinesLabels: [String]? = nil
    var g1840LinesRevenue: [[Int]]? = nil
    var g1840LastCompanyRevenues: [Int]? = nil
    
    var g1846IsFirstEverOR: Bool? = nil
    var g1846DynamicCertificateLimits: [Int]? = nil
    
    var g1848CompaniesInReceivershipFlags: [Bool]? = nil
    var g1848CompaniesInReceivershipPresidentPlayerIndexes: [Int?]? = nil
    var g1848ReceivershipPresidentCertificatePenalty: Int? = nil
    var g1848CertificateLimits: [Double]? = nil
    
    var g1856CompaniesStatus: [G1856CompanyStatus]? = nil
    var g1856DynamicCertificateLimits: [Int]? = nil
    
    var g18MEXIsCertificateLimitAugmentedByOne: Bool? = nil
    var g18MEXLastMailValues: [Int]? = nil
    
//-----------------------------------------------------------------------------------------------------------------------------
    
    init(game: Game, turnOrderType: PlayerTurnOrderType, players: [String], customOverrides: [String: Any] = [String: Any]()) {
        
        var gameMetadata = game.getMetadata()
        
        for (key, val) in customOverrides {
            gameMetadata[key] = val
        }
        
        let gameSpecificPlayerTurnOrderType = gameMetadata["gameSpecificPlayerTurnOrderType"] as! PlayerTurnOrderType
        let roundOperationTypes = gameMetadata["roundOperationTypes"] as! [OperationType]
        let roundOperationTypeColors = gameMetadata["roundOperationTypeColors"] as! [UIColor]
        let roundOperationTypeTextColors = gameMetadata["roundOperationTypeTextColors"] as! [UIColor]
        
        let companies = gameMetadata["companies"] as! [String]
        let floatModifiers = gameMetadata["floatModifiers"] as! [Int]
        let companiesTypes = gameMetadata["companiesTypes"] as! [CompanyType]
        let compTotShares = gameMetadata["compTotShares"] as! [Double]
        let compLogos = gameMetadata["compLogos"] as! [String]
        let compColors = gameMetadata["compColors"] as! [UIColor]
        let compTextColors = gameMetadata["compTextColors"] as! [UIColor]
        
        let bankAmounts = gameMetadata["totalBankAmount"] as! [Double]
        let playersStartingMoney = gameMetadata["playersStartingMoney"] as! [Double]
        let certificateLimit = gameMetadata["certificateLimit"] as! [Double]
        
        let legalActionsPlayers = gameMetadata["legalActionsPlayers"] as! [Int]
        let legalActionsCompanies = gameMetadata["legalActionsCompanies"] as! [Int]
        
        let shareStartingLocation = gameMetadata["shareStartingLocation"] as! ShareStartingLocation
        let predefinedShareAmounts = gameMetadata["predefinedShareAmounts"] as! [Double]
        let printShareAmountsAsInt = gameMetadata["printShareAmountsAsInt"] as! Bool
        
        self.game = game
        self.playerTurnOrderType = turnOrderType
        self.gameSpecificPlayerTurnOrderType = gameSpecificPlayerTurnOrderType
        
        switch game {
        case .g1830, .g1846, .g1848, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            self.currentRoundOperationType = .SR
            self.operations = [Operation(type: .SR, uid: nil)]
            self.roundOperationTypes = roundOperationTypes
        case .g1840:
            self.currentRoundOperationType = .g1840SR1
            self.operations = [Operation(type: .g1840SR1, uid: nil)]
            self.roundOperationTypes = [OperationType.g1840SR1, OperationType.g1840CR1, OperationType.g1840LR1a, OperationType.g1840LR1b, OperationType.g1840CR2, OperationType.g1840SR2, OperationType.g1840LR2a, OperationType.g1840LR2b, OperationType.g1840CR3, OperationType.g1840SR3, OperationType.g1840LR3a, OperationType.g1840LR3b, OperationType.g1840CR4, OperationType.g1840SR4, OperationType.g1840LR4a, OperationType.g1840LR4b, OperationType.g1840CR5, OperationType.g1840SR5, OperationType.g1840LR5a, OperationType.g1840LR5b, OperationType.g1840LR5c, OperationType.g1840CR6]
            self.g1840RoundOperationTypeBaselineTexts = ["1", "1", "1a", "1b", "2", "2", "2a", "2b", "3", "3", "3a", "3b", "4", "4", "4a", "4b", "5", "5", "5a", "5b", "5c", "6"]
            self.g1840RoundOperationTypeCRMultipliers = [nil, 1, nil, nil, 1, nil, nil, nil, 1, nil, nil, nil, 2, nil, nil, nil, 3, nil, nil, nil, nil, 10]
        }
        
        self.roundOperationTypeColors = roundOperationTypeColors.map { Color(uiColor: $0) }
        self.roundOperationTypeTextColors = roundOperationTypeTextColors.map { Color(uiColor: $0) }
        
        let bankSize = BankIndex.getBankSize()
        let companiesSize = companies.count
        let playersSize = players.count
        
        switch game {
        case .g1830, .g1882, .g1889, .g18Chesapeake:
            break
        case .g1840:
            self.loans = [100] + [Int](repeating: 0, count: bankSize + companiesSize + playersSize - 1)
            self.g1840LastCompanyRevenues = Array(repeating: 0, count: companiesSize)
            
        case .g1846:
            self.g1846IsFirstEverOR = true
            let certLimitTable = [Array<Int>(repeating: 11, count: 5) + [14, 14, 14],
                                  Array<Int>(repeating: 8, count: 5) + [10, 12, 12],
                                  Array<Int>(repeating: 6, count: 5) + [8, 10, 11]]
            self.g1846DynamicCertificateLimits = certLimitTable[playersSize - 3]
            
        case .g1848:
            self.loans = [Int](repeating: 0, count: bankSize) + [20] + Array(repeating: 0, count: companiesSize - 1 + playersSize)
            
            let certificateLimitsByPlayerSize: [[Double]] = [[20, 18, 16, 14, 12, 10], [17, 15, 13, 11, 10, 9], [14, 13, 12, 10, 9, 8], [12, 11, 10, 9, 8, 7]]
            
            self.g1848CompaniesInReceivershipFlags = Array(repeating: false, count: companiesSize)
            self.g1848CompaniesInReceivershipPresidentPlayerIndexes = Array(repeating: nil, count: companiesSize)
            self.g1848ReceivershipPresidentCertificatePenalty = playersSize <= 4 ? 2 : 1
            self.g1848CertificateLimits = certificateLimitsByPlayerSize[playersSize - 3]
            
        case .g1849:
            self.bonds = [100] + Array(repeating: 0, count: bankSize + companiesSize + playersSize - 1)
            
        case .g1856:
            self.loans = [100] + [Int](repeating: 0, count: bankSize + companiesSize + playersSize - 1)
            self.g1856CompaniesStatus = Array(repeating: G1856CompanyStatus.incrementalCapitalizationCapped, count: companiesSize - 1) + [G1856CompanyStatus.fullCapitalization]
            let certLimitTable = [Array<Int>(repeating: 10, count: 5) + [13, 15, 18, 20, 22, 25, 28],
                                  Array<Int>(repeating: 8, count: 5) + [10, 12, 14, 16, 18, 20, 22],
                                  Array<Int>(repeating: 7, count: 5) + [8, 10, 11, 13, 15, 16, 18],
                                  Array<Int>(repeating: 6, count: 5) + [7, 8, 10, 11, 12, 14, 15]]
            self.g1856DynamicCertificateLimits = certLimitTable[playersSize - 3]
            
        case .g18MEX:
            self.g18MEXLastMailValues = Array(repeating: 0, count: companiesSize)
            self.g18MEXIsCertificateLimitAugmentedByOne = false
        }
        
        let playerAmount = playersStartingMoney[players.count - 1 - 1]
        self.certificateLimit = certificateLimit[players.count - 1 - 1]
        
        self.totalBankAmount = bankAmounts.count == 1 ? bankAmounts[0] : bankAmounts[players.count - 1]
        let bankAmount = self.totalBankAmount - (playerAmount * Double(players.count))
        let companiesAmounts = [Double](repeating: 0.0, count: companies.count)
        let playersAmounts = [Double](repeating: Double(playerAmount), count: players.count)
        let amounts = [Double(bankAmount)] + Array(repeating: 0.0, count: bankSize - 1) + companiesAmounts + playersAmounts
        let labels = BankIndex.getBankLabels() + companies + players
        
        self.bankSize = bankSize
        self.companiesSize = companiesSize
        self.playersSize = playersSize
        
        self.homeCompaniesCollectionViewBaseIndexesSorted = Array<Int>(0..<companiesSize)
        self.homeReducedCompaniesCollectionViewBaseIndexesSorted = Array<Int>(0..<companiesSize)
        self.homePlayersCollectionViewBaseIndexesSorted = Array<Int>(0..<playersSize)
        self.homeDynamicTurnOrdersPreviewByPlayerBaseIndexes = Array<Int>(0..<playersSize)
        self.labels = labels
        self.amounts = amounts
        self.floatModifiers = floatModifiers
        self.compTypes = companiesTypes
        self.compPresidentsGlobalIndexes = Array(repeating: nil, count: companiesSize)
        self.compTotShares = compTotShares
        self.predefinedShareAmounts = predefinedShareAmounts
        self.printShareAmountsAsInt = printShareAmountsAsInt
        
        switch game {
        case .g1840:
            self.presidentCertificateShareAmount = 5.0
        case .g1830, .g1846, .g1848, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            self.presidentCertificateShareAmount = 2.0
        }
        
        var shares: [[Double]] = []
        for _ in 1...self.bankSize + self.companiesSize + self.playersSize {
            shares.append([Double](repeating: 0, count: companiesSize))
        }
        
        switch shareStartingLocation {
        case .bank:
            for i in 0..<companiesSize {
                shares[BankIndex.bank.rawValue][i] = compTotShares[i]
            }
        case .ipo:
            for i in 0..<companiesSize {
                shares[BankIndex.ipo.rawValue][i] = compTotShares[i]
            }
        case .aside:
            for i in 0..<companiesSize {
                shares[BankIndex.aside.rawValue][i] = compTotShares[i]
            }
        case .company:
            for cmpIndex in bankSize..<bankSize + companiesSize {
                let cmpBaseIndex = cmpIndex - bankSize
                shares[cmpIndex][cmpBaseIndex] = compTotShares[cmpBaseIndex]
            }
        case .tradeIn:
            for i in 0..<companiesSize {
                shares[BankIndex.tradeIn.rawValue][i] = compTotShares[i]
            }
        }
        
        self.shares = shares
        
        self.compLogos = compLogos
        
        let systemColor = UIColor.primaryAccentColor
        let companyColors = compColors.map{ Color(uiColor: $0) }
        self.colors = Array(repeating: Color(uiColor: systemColor), count: bankSize) + companyColors + Array(repeating: Color(uiColor: systemColor), count: playersSize)
        let companyTextColors = compTextColors.map { Color(uiColor: $0) }
        let playerTextColors = Array(repeating: UIColor.white, count: 6).map { Color(uiColor: $0) }
        self.textColors = Array(repeating: Color(uiColor: UIColor.white), count: bankSize) + companyTextColors + playerTextColors
        
        self.companiesOperated = Array(repeating: false, count: self.companiesSize)
        
        self.lastCompPayoutValues = Array(repeating: 0, count: self.companiesSize)
        self.openCompanyValues = gameMetadata["openCompanyValues"] as! [Int]
        self.PARValueIsIrrelevantToShow = gameMetadata["PARValueIsIrrelevantToShow"] as! Bool
        self.tileTokensPriceSuggestions = gameMetadata["tileTokensPriceSuggestions"] as! [Int]
        self.trainPriceValues = gameMetadata["trainPriceValues"] as! [Int]
        self.trainPriceIndexToCloseAllPrivates = gameMetadata["trainPriceIndexToCloseAllPrivates"] as! Int
        self.currentTrainPriceIndex = 0
        self.currencyType = gameMetadata["currencyType"] as! CurrencyType
        
        let gamePARValues = gameMetadata["gamePARValues"] as! [Int]
        let shareValues = gameMetadata["shareValues"] as! [[Double?]]
        
        self.shareValuesManager = ShareValueManager(shareValuesMatrix: shareValues, game: game, compTypes: companiesTypes, gamePARValues: gamePARValues)
        
        self.requiredNumberOfSharesToFloat = gameMetadata["requiredNumberOfSharesToFloat"] as! Int
        
        self.floatedCompanies = Array(repeating: false, count: companiesSize)
        
        self.lastUid = 0
        
        self.ipoSharesPayBank = gameMetadata["ipoSharesPayBank"] as! Bool
        self.bankSharesPayBank = gameMetadata["bankSharesPayBank"] as! Bool
        self.compSharesPayBank = gameMetadata["compSharesPayBank"] as! Bool
        self.asideSharesPayBank = gameMetadata["asideSharesPayBank"] as! Bool
        self.tradeInSharesPayBank = gameMetadata["tradeInSharesPayBank"] as! Bool
        
        self.buyShareFromIPOPayBank = gameMetadata["buyShareFromIPOPayBank"] as! Bool
        self.buyShareFromBankPayBank = gameMetadata["buyShareFromBankPayBank"] as! Bool
        self.buyShareFromCompPayBank = gameMetadata["buyShareFromCompPayBank"] as! Bool
        
        self.sharesFromIPOHavePARprice = gameMetadata["sharesFromIPOHavePARprice"] as! Bool
        self.sharesFromBankHavePARprice = gameMetadata["sharesFromBankHavePARprice"] as! Bool
        self.sharesFromCompHavePARprice = gameMetadata["sharesFromCompHavePARprice"] as! Bool
        self.sharesFromAsideHavePARprice = gameMetadata["sharesFromAsideHavePARprice"] as! Bool
        self.sharesFromTradeInHavePARprice = gameMetadata["sharesFromTradeInHavePARprice"] as! Bool
        
        self.unitShareValuePayoutRoundPolicy = gameMetadata["unitShareValuePayoutRoundPolicy"] as! PayoutRoundPolicy
        self.isPayoutRoundedUpOnTotalValue = gameMetadata["isPayoutRoundedUpOnTotalValue"] as! Bool
        self.buySellRoundPolicyOnTotal = gameMetadata["buySellRoundPolicyOnTotal"] as! BuySellRoundPolicy
        self.isGenerateTrashHidden = gameMetadata["isGenerateTrashHidden"] as! Bool
        
        self.shareStartingLocation = shareStartingLocation
        
        self.legalActionsPlayers = legalActionsPlayers
        self.legalActionsCompanies = legalActionsCompanies
        
        let rulesTxtPath = game.getRulesTxtPath()

        if let filePath = Bundle.main.path(forResource: rulesTxtPath, ofType: "txt") {
            do {
                let text = try String(contentsOfFile: filePath, encoding: .utf8)
                self.rulesText = text
            }
            catch {
                self.rulesText = ""
            }
            
        } else {
            self.rulesText = ""
        }
        
        self.privatesBuyInModifiers = gameMetadata["privatesBuyInModifiers"] as! [String]
        self.privatesLabels = gameMetadata["privatesLabels"] as! [String]
        self.privatesPrices = gameMetadata["privatesPrices"] as! [Double]
        self.privatesIncomes = gameMetadata["privatesIncomes"] as! [Double]
        self.privatesMayBeBuyInFlags = gameMetadata["privatesMayBeBuyInFlags"] as! [Bool]
        self.privatesDescriptions = gameMetadata["privatesDescriptions"] as! [String]
        self.privatesOwnerGlobalIndexes = gameMetadata["privatesOwnerGlobalIndexes"] as! [Int]
        self.privatesMayBeVoluntarilyClosedFlags = gameMetadata["privatesMayBeVoluntarilyClosedFlags"] as! [Bool]
        self.privatesLockMoneyIfOutbidden = gameMetadata["privatesLockMoneyIfOutbidden"] as! Bool
        self.privatesWillCloseAutomatically = true
        
        Operation.privateCompanyLabels = (0..<self.privatesLabels.count).map({ self.privatesLabels[$0] })
        Operation.opEntityLabels = self.labels
        Operation.opBaseCompanyLabels = (0..<self.companiesSize).map({ self.getCompanyLabel(atBaseIndex: $0) })
        
        let setupOps = game.getSetupOperations(forGameState: self)
        if !setupOps.isEmpty {
            if !self.areOperationsLegit(operations: setupOps, reverted: false) {
                return
            }
        }
        
        for op in setupOps {
            _ = self.perform(operation: op)
        }
        
    }
    
    func closeCompany(atIndex cmpIndex: Int) {
        
        let cmpBaseIndex = self.forceConvert(index: cmpIndex, backwards: true, withIndexType: .companies)
        
        // loans
        if let loansAmount = self.loans?[cmpIndex], loansAmount > 0 {
            let op = Operation(type: .loan, uid: nil)
            op.setOperationColorGlobalIndex(colorGlobalIndex: cmpIndex)
            op.addLoanDetails(loansSourceGlobalIndex: cmpIndex, loansDestinationGlobalIndex: BankIndex.bank.rawValue, loansAmount: loansAmount)
            
            _ = self.perform(operation: op)
        }
        
        // bonds
        if let bondsAmount = self.bonds?[cmpIndex], bondsAmount > 0 {
            let op = Operation(type: .bond, uid: nil)
            op.setOperationColorGlobalIndex(colorGlobalIndex: cmpIndex)
            op.addBondDetails(bondsSourceGlobalIndex: cmpIndex, bondsDestinationGlobalIndex: BankIndex.bank.rawValue, bondsAmount: bondsAmount)
            
            _ = self.perform(operation: op)
        }
        
        // privates
        for i in 0..<self.privatesPrices.count {
            if self.privatesOwnerGlobalIndexes[i] == cmpIndex {
                let op = Operation(type: .privates, uid: nil)
                op.setOperationColorGlobalIndex(colorGlobalIndex: cmpIndex)
                op.addPrivatesDetails(privateSourceGlobalIndex: cmpIndex, privateDestinationGlobalIndex: BankIndex.bank.rawValue, privateCompanyBaseIndex: i)
                
                _ = self.perform(operation: op)
            }
        }
        
        // shares
        var shareDstGlobalIdx = 0
        switch self.shareStartingLocation {
        case .bank:
            shareDstGlobalIdx = BankIndex.bank.rawValue
        case .ipo:
            shareDstGlobalIdx = BankIndex.ipo.rawValue
        case .aside:
            shareDstGlobalIdx = BankIndex.aside.rawValue
        case .tradeIn:
            shareDstGlobalIdx = BankIndex.tradeIn.rawValue
        case .company:
            shareDstGlobalIdx = cmpIndex
        }
        
        for shareholderIdx in self.getShareholderGlobalIndexesForCompany(atIndex: cmpIndex) {
            if shareholderIdx == shareDstGlobalIdx { continue }
                
            let op = Operation(type: .close, uid: nil)
            op.setOperationColorGlobalIndex(colorGlobalIndex: cmpIndex)
            op.addSharesDetails(shareSourceIndex: shareholderIdx, shareDestinationIndex: shareDstGlobalIdx, shareAmount: self.shares[shareholderIdx][cmpBaseIndex], shareCompanyBaseIndex: cmpBaseIndex)
            
            _ = self.perform(operation: op)
        }
        
        // money
        let compAmount = self.getCompanyAmount(atIndex: cmpIndex)
        
        if compAmount > 0 {
            let cashOp = Operation(type: .close, uid: nil)
            cashOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIndex)
            cashOp.addCashDetails(sourceIndex: cmpIndex, destinationIndex: BankIndex.bank.rawValue, amount: compAmount)
            
            _ = self.perform(operation: cashOp)
        }
        
        // flags
        self.floatedCompanies[cmpBaseIndex] = false
        self.companiesOperated[cmpBaseIndex] = false
        self.lastCompPayoutValues[cmpBaseIndex] = 0
        
        // market
        if let parValue = self.shareValuesManager.getPARvalue(forCompanyAtBaseIndex: cmpBaseIndex) {
            if let idx = self.shareValuesManager.getShareValueIndex(forCompanyAtBaseIndex: cmpBaseIndex) {
                let op = Operation(type: .close)
                op.setOperationColorGlobalIndex(colorGlobalIndex: cmpIndex)
                let detailsStr = self.PARValueIsIrrelevantToShow ? "share value" : "PAR"
                op.addMarketDetails(marketShareValueCmpBaseIndex: cmpBaseIndex, marketShareValueFromIndex: idx, marketShareValueToIndex: nil, marketLogStr: "\(self.getCompanyLabel(atBaseIndex: cmpBaseIndex)) -> \(detailsStr) reset", marketPreviousPARValue: Double(parValue))
                _ = self.perform(operation: op, reverted: false)
            }
        }
    }
    
    func closeCompany(atBaseIndex cmpBaseIndex: Int) {
        let cmpIndex = self.forceConvert(index: cmpBaseIndex, backwards: false, withIndexType: .companies)
        
        self.closeCompany(atIndex: cmpIndex)
    }
    
    func closeAllG18MEXMinors() -> Bool {
        
        let minorsCmpBaseIndexes = [self.getBaseIndex(forEntity: "A"), self.getBaseIndex(forEntity: "B"), self.getBaseIndex(forEntity: "C")]
        
        var tradeInShareCmpIndexes: [Int] = []
        let ndmCmpBaseIdx = self.getBaseIndex(forEntity: "NDM")
        tradeInShareCmpIndexes.append(self.forceConvert(index: ndmCmpBaseIdx, backwards: false, withIndexType: .companies))
        tradeInShareCmpIndexes.append(self.forceConvert(index: ndmCmpBaseIdx, backwards: false, withIndexType: .companies))

        let udyCmpBaseIdx = self.getBaseIndex(forEntity: "UDY")
        tradeInShareCmpIndexes.append(self.forceConvert(index: udyCmpBaseIdx, backwards: false, withIndexType: .companies))
        
        let tradeInShareAmounts = [0.5, 0.5, 1]
        
        if minorsCmpBaseIndexes.count != tradeInShareCmpIndexes.count {
            return false
        }
        
        var opsToBePerformed: [Operation] = []
        
        for i in 0..<minorsCmpBaseIndexes.count {
            let minorCmpBaseIdx = minorsCmpBaseIndexes[i]
            let minorCmpIdx = self.forceConvert(index: minorCmpBaseIdx, backwards: false, withIndexType: .companies)
            let tradeInShareCmpIdx = tradeInShareCmpIndexes[i]
            
            for shareholderIdx in self.getShareholderGlobalIndexesForCompany(atIndex: minorCmpIdx) {
                if self.getPlayerIndexes().contains(shareholderIdx) {
                    let firstOp = Operation(type: .g18MEXcloseMinors, uid: nil)
                    firstOp.addCashDetails(sourceIndex: minorCmpIdx, destinationIndex: tradeInShareCmpIdx, amount: self.getCompanyAmount(atIndex: minorCmpIdx))
                    firstOp.addSharesDetails(shareSourceIndex: shareholderIdx, shareDestinationIndex: minorCmpIdx, shareAmount: 1, shareCompanyBaseIndex: minorCmpBaseIdx)

                    let secondOp = Operation(type: .g18MEXcloseMinors, uid: nil)
                    secondOp.addSharesDetails(shareSourceIndex: BankIndex.tradeIn.rawValue, shareDestinationIndex: shareholderIdx, shareAmount: tradeInShareAmounts[i], shareCompanyBaseIndex: self.forceConvert(index: tradeInShareCmpIdx, backwards: true, withIndexType: .companies))
                    
                    opsToBePerformed.append(firstOp)
                    opsToBePerformed.append(secondOp)
                }
            }
        }
        
        if !self.areOperationsLegit(operations: opsToBePerformed, reverted: false) {
            return false
        }
        
        for op in opsToBePerformed {
            let _ = self.perform(operation: op)
        }
        
        for minorCmpBaseIdx in minorsCmpBaseIndexes {
            self.closeCompany(atBaseIndex: minorCmpBaseIdx)
        }
        
        return true
    }
    
    func updateCompanyPresidents(forCompanyAtBaseIndex compBaseIdx: Int? = nil, tieBreakPlayerIdx: Int? = nil) {
        
        var cmpBaseIndexesToBeEvaluated: [Int] = []
        
        if let compBaseIdx = compBaseIdx {
            cmpBaseIndexesToBeEvaluated = [compBaseIdx]
        } else {
            cmpBaseIndexesToBeEvaluated = Array<Int>(0..<self.companiesSize)
        }
        
        for cmpBaseIdx in cmpBaseIndexesToBeEvaluated {
            
            let shareholdersGlobalIndexes = self.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIdx).filter { self.getPlayerIndexes().contains($0) && self.getSharesPortfolioForPlayer(atIndex: $0)[cmpBaseIdx] >= self.presidentCertificateShareAmount }
            
            if shareholdersGlobalIndexes.isEmpty {
                self.compPresidentsGlobalIndexes[cmpBaseIdx] = nil
            } else {
                let sharesAmounts = shareholdersGlobalIndexes.map { self.getSharesPortfolioForPlayer(atIndex: $0)[cmpBaseIdx] }
                if let maxAmount = sharesAmounts.max() {
                    if sharesAmounts.count(where: { $0 == maxAmount }) > 1 {
                        if let tieBreakPlayerIdx = tieBreakPlayerIdx, shareholdersGlobalIndexes.contains(tieBreakPlayerIdx) {
                            self.compPresidentsGlobalIndexes[cmpBaseIdx] = tieBreakPlayerIdx
                            continue
                        }
                        
                        if let currentPresidentGlobalIdx = self.compPresidentsGlobalIndexes[cmpBaseIdx] {
                            if !shareholdersGlobalIndexes.contains(currentPresidentGlobalIdx) {
                                // choose next player after current president in seating order
                                var sortedPlayerIndexes: [Int]
                                let maxPlayerGlobalIdx = self.forceConvert(index: self.playersSize - 1, backwards: false, withIndexType: .players)
                                
                                if currentPresidentGlobalIdx == maxPlayerGlobalIdx {
                                    sortedPlayerIndexes = Array<Int>(0...maxPlayerGlobalIdx)
                                } else {
                                    sortedPlayerIndexes = Array<Int>((currentPresidentGlobalIdx + 1)...maxPlayerGlobalIdx) + Array<Int>(0...currentPresidentGlobalIdx)
                                }
                                for playerIdx in sortedPlayerIndexes {
                                    if self.getSharesPortfolioForPlayer(atIndex: playerIdx)[cmpBaseIdx] == maxAmount {
                                        self.compPresidentsGlobalIndexes[cmpBaseIdx] = playerIdx
                                        break
                                    }
                                }
                            }
                        } else {
                            // weird case, select first at random
                            for playerIdx in self.getPlayerIndexes() {
                                if self.getSharesPortfolioForPlayer(atIndex: playerIdx)[cmpBaseIdx] == maxAmount {
                                    self.compPresidentsGlobalIndexes[cmpBaseIdx] = playerIdx
                                    break
                                }
                            }
                        }
                    } else {
                        self.compPresidentsGlobalIndexes[cmpBaseIdx] = shareholdersGlobalIndexes[sharesAmounts.firstIndex(of: maxAmount) ?? 0]
                    }
                }
            }
        }
    }
    
    func getPresidentPlayerIndex(forCompanyAtBaseIndex cmpBaseIdx: Int) -> Int? {
        return self.compPresidentsGlobalIndexes[cmpBaseIdx]
    }
    
    func getPresidentPlayerIndex(forCompanyAtIndex cmpIdx: Int) -> Int? {
        let cmpBaseIdx = self.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
        
        return self.getPresidentPlayerIndex(forCompanyAtBaseIndex: cmpBaseIdx)
    }
    
    func isCompanyFloated(atIndex cmpIdx: Int) -> Bool {
        let cmpBaseIdx = self.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
        
        return self.isCompanyFloated(atBaseIndex: cmpBaseIdx)
    }
    
    func isCompanyFloated(atBaseIndex cmpBaseIdx: Int) -> Bool {
        return self.floatedCompanies[cmpBaseIdx]
    }
    
    func getCompanyAmount(atIndex index: Int) -> Double {
        return self.amounts[index]
    }
    
    func getCompanyAmount(atBaseIndex baseIndex: Int) -> Double {
        let index = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .companies)
        return self.amounts[index]
    }
    
    func getPlayerAmount(atIndex index: Int) -> Double {
        return self.amounts[index]
    }
    
    func getPlayerAmount(atBaseIndex baseIndex: Int) -> Double {
        let index = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .players)
        return self.amounts[index]
    }
    
    func getBankAmount() -> Double {
        return self.amounts[BankIndex.bank.rawValue]
    }
    
    func getTotalShareNumberOfCompany(atBaseIndex baseIndex: Int) -> Double {
        return self.compTotShares[baseIndex]
    }
    
    func getTotalShareNumberOfCompany(atIndex index: Int) -> Double {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.compTotShares[baseIndex]
    }
    
    func getPredefinedShareAmounts() -> [Double] {
        return self.predefinedShareAmounts
    }
    
    func getSharesPortfolioForBankEntity(atBaseIndexOrIndex index: Int) -> [Double] {
        return self.shares[index]
    }
    
    func getSharesPortfolioForCompany(atBaseIndex baseIndex: Int) -> [Double] {
        let index = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .companies)
        return self.shares[index]
    }
    
    func getSharesPortfolioForCompany(atIndex index: Int) -> [Double] {
        return self.shares[index]
    }
    
    func getSharesPortfolioForPlayer(atBaseIndex baseIndex: Int) -> [Double] {
        let index = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .players)
        return self.shares[index]
    }
    
    func getSharesPortfolioForPlayer(atIndex index: Int) -> [Double] {
        return self.shares[index]
    }
    
    func getCompanyLabel(atBaseIndex baseIndex: Int) -> String {
        let index = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .companies)
        return self.labels[index]
    }
    
    func getCompanyLabel(atIndex index: Int) -> String {
        return self.labels[index]
    }
    
    func getPlayerLabel(atBaseIndex baseIndex: Int) -> String {
        let index = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .players)
        return self.labels[index]
    }
    
    func getPlayerLabel(atIndex index: Int) -> String {
        return self.labels[index]
    }
    
    func getBankEntityLabel(atBaseIndexOrIndex index: Int) -> String {
        return self.labels[index]
    }
    
    func getCompanyLogo(atBaseIndex baseIndex: Int) -> UIImage {
        return UIImage(named: self.compLogos[baseIndex]) ?? UIImage()
    }
    
    func getCompanyLogo(atIndex index: Int) -> UIImage {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.getCompanyLogo(atBaseIndex: baseIndex)
    }
    
    func getCompanyLogoStr(atBaseIndex baseIndex: Int) -> String {
        return self.compLogos[baseIndex]
    }
    
    func getCompanyLogoStr(atIndex index: Int) -> String {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.getCompanyLogoStr(atBaseIndex: baseIndex)
    }
    
    func getCompanyWhiteLogo(atBaseIndex baseIndex: Int) -> UIImage? {
        return UIImage(named: self.compLogos[baseIndex] + "_white")
    }
    
    func getCompanyWhiteLogo(atIndex index: Int) -> UIImage? {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.getCompanyWhiteLogo(atBaseIndex: baseIndex)
    }
    
    func getCompanyWhiteLogoStr(atBaseIndex baseIndex: Int) -> String {
        return self.compLogos[baseIndex] + "_white"
    }
    
    func getCompanyWhiteLogoStr(atIndex index: Int) -> String {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.getCompanyLogoStr(atBaseIndex: baseIndex) + "_white"
    }
    
    func getCompanyColor(atBaseIndex baseIndex: Int) -> UIColor {
        let globalIndex = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .companies)
        return self.colors[globalIndex].uiColor
    }
    
    func getCompanyColor(atIndex index: Int) -> UIColor {
        return self.colors[index].uiColor
    }
    
    func getPlayerColor(atBaseIndex baseIndex: Int) -> UIColor {
        let globalIndex = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .players)
        return self.colors[globalIndex].uiColor
    }
    
    func getPlayerColor(atIndex index: Int) -> UIColor {
        return self.colors[index].uiColor
    }
    
    func getPlayerTextColor(atBaseIndex baseIndex: Int) -> UIColor {
        let globalIndex = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .players)
        return self.textColors[globalIndex].uiColor
    }
    
    func getPlayerTextColor(atIndex index: Int) -> UIColor {
        return self.textColors[index].uiColor
    }
    
    func getBankColor(atBaseIndexOrIndex index: Int) -> UIColor {
        return self.colors[index].uiColor
    }
    
    func getCompanyTextColor(atBaseIndex baseIndex: Int) -> UIColor {
        let index = self.forceConvert(index: baseIndex, backwards: false, withIndexType: .companies)
        return self.textColors[index].uiColor
    }
    
    func getCompanyTextColor(atIndex index: Int) -> UIColor {
        return self.textColors[index].uiColor
    }
    
    func getCompanyType(atBaseIndex baseIndex: Int) -> CompanyType {
        return self.compTypes[baseIndex]
    }
    
    func getCompanyType(atIndex index: Int) -> CompanyType {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.compTypes[baseIndex]
    }
    
    func getLastPayoutForCompany(atBaseIndex baseIndex: Int) -> Int {
        return self.lastCompPayoutValues[baseIndex]
    }
    
    func getLastPayoutForCompany(atIndex index: Int) -> Int {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.lastCompPayoutValues[baseIndex]
    }
    
    func getLoansAmount(forPlayerAtIndex playerIdx: Int) -> Int? {
        if let loans = self.loans {
            return loans[playerIdx]
        }
        
        return nil
    }
    
    func getLoansAmount(forPlayerAtBaseIndex playerBaseIdx: Int) -> Int? {
        let playerIdx = self.forceConvert(index: playerBaseIdx, backwards: false, withIndexType: .players)
        
        return self.getLoansAmount(forPlayerAtIndex: playerIdx)
    }
    
    func getLoansAmount(forCompanyAtIndex companyIdx: Int) -> Int? {
        if let loans = self.loans {
            return loans[companyIdx]
        }
        
        return nil
    }
    
    func getLoansAmount(forCompanyAtBaseIndex companyBaseIdx: Int) -> Int? {
        let companyIdx = self.forceConvert(index: companyBaseIdx, backwards: false, withIndexType: .companies)
        
        return self.getLoansAmount(forCompanyAtIndex: companyIdx)
    }
    
    func getBondsAmount(forPlayerAtIndex playerIdx: Int) -> Int? {
        if let bonds = self.bonds {
            return bonds[playerIdx]
        }
        
        return nil
    }
    
    func getBondsAmount(forPlayerAtBaseIndex playerBaseIdx: Int) -> Int? {
        let playerIdx = self.forceConvert(index: playerBaseIdx, backwards: false, withIndexType: .players)
        
        return self.getBondsAmount(forPlayerAtIndex: playerIdx)
    }
    
    func getBondsAmount(forCompanyAtIndex companyIdx: Int) -> Int? {
        if let bonds = self.bonds {
            return bonds[companyIdx]
        }
        
        return nil
    }
    
    func getBondsAmount(forCompanyAtBaseIndex companyBaseIdx: Int) -> Int? {
        let companyIdx = self.forceConvert(index: companyBaseIdx, backwards: false, withIndexType: .companies)
        
        return self.getBondsAmount(forCompanyAtIndex: companyIdx)
    }
    
    func getBuyInPrivatePrices(forPrivateAtBaseIdx privateBaseIdx: Int) -> [Double] {
        if self.game == .g1848 {
            if privateBaseIdx >= 4 { return [1, 1000] }
            
            let buyIns = [40, 80, 140, 220] as [Double]
            return [1, buyIns[privateBaseIdx]]
        }
        
        let privateFaceValue = self.privatesPrices[privateBaseIdx]
        
        if self.privatesBuyInModifiers.count == 1 {
            let modifier = self.privatesBuyInModifiers[0]
            
            if modifier.contains("x") {
                let multiplier = Double(modifier.dropLast()) ?? 1.0
                return [privateFaceValue * multiplier]
            } else if modifier == "any" {
                return [1, 1000]
            } else {
                return [privateFaceValue]
            }
        } else if self.privatesBuyInModifiers.count >= 1 {
            var values: [Double] = []
            
            for (i, modifier) in self.privatesBuyInModifiers.enumerated() {
                if modifier.contains("x") {
                    let multiplier = Double(modifier.dropLast()) ?? 1.0
                    values.append(privateFaceValue * multiplier)
                } else if modifier == "any" {
                    if i == 0 {
                        values.append(1)
                        values.append(1000)
                    } else {
                        values.append(1000)
                    }
                } else {
                    values.append(Double(modifier) ?? 1.0)
                }
            }
            
            return values
        }
        
        return [1.0, 1000.0]
    }
    
    func getBuyInPrivatePricesText() -> String {
        
        if self.game == .g1848 {
            return "Buy ins: [P1 1-40] [P2 1-80] [P3 1-140] [P4 1-220]"
        }
        
        if self.privatesBuyInModifiers.count == 1 {
            let modifier = self.privatesBuyInModifiers[0]
            
            if modifier.contains("x") {
                return "privates comp can be sold at: [\(modifier) - \(modifier)] face value"
            } else {
                return "privates comp can be sold at: [\(modifier)]"
            }
            
        } else if self.privatesBuyInModifiers.count >= 1 {
            if let firstModifier = self.privatesBuyInModifiers.first, let lastModifier = self.privatesBuyInModifiers.last {
                
                if firstModifier.contains("x") || lastModifier.contains("x") {
                    return "privates comp can be sold at: [\(firstModifier) - \(lastModifier)] face value"
                } else {
                    return "privates comp can be sold at: [\(firstModifier) - \(lastModifier)]"
                }
            }
        }
        
        return ""
    }
    
    func isCompanyStarted(atBaseIndex baseIndex: Int) -> Bool {
        return self.shareValuesManager.getPARvalue(forCompanyAtBaseIndex: baseIndex) != nil
    }
    
    func isCompanyStarted(atIndex index: Int) -> Bool {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.isCompanyStarted(atBaseIndex: baseIndex)
    }
    
    func hasCompanyOperated(atBaseIndex baseIndex: Int) -> Bool {
        return self.companiesOperated[baseIndex]
    }
    
    func hasCompanyOperated(atIndex index: Int) -> Bool {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        return self.companiesOperated[baseIndex]
    }
    
    func getLastMailValueForCompany(atBaseIndex baseIndex: Int) -> Int? {
        if let lastMailValues = self.g18MEXLastMailValues {
            return lastMailValues[baseIndex]
        }
        
        return nil
    }
    
    func getLastMailValueForCompany(atIndex index: Int) -> Int? {
        let baseIndex = self.forceConvert(index: index, backwards: true, withIndexType: .companies)
        
        return self.getLastMailValueForCompany(atBaseIndex: baseIndex)
    }
    
    func getBankEntityIndexes() -> Range<Int> {
        return 0..<self.bankSize
    }
    
    func getCompanyIndexes() -> Range<Int> {
        return self.bankSize..<self.bankSize + self.companiesSize
    }

    func getPlayerIndexes() -> Range<Int> {
        return self.bankSize + self.companiesSize..<self.bankSize + self.companiesSize + self.playersSize
    }
    
    func getShareholderGlobalIndexesForCompany(atBaseIndex cmpBaseIndex: Int, includePlayers: Bool = true) -> [Int] {
        var shareholderIndexes = [Int]()
        
        for bankIndex in self.getBankEntityIndexes() {
            if self.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: bankIndex)[cmpBaseIndex] > 0 {
                shareholderIndexes.append(bankIndex)
            }
        }
        
        for companyIndex in self.getCompanyIndexes() {
            if self.getSharesPortfolioForCompany(atIndex: companyIndex)[cmpBaseIndex] > 0 {
                shareholderIndexes.append(companyIndex)
            }
        }
        
        if includePlayers {
            for playerIndex in self.getPlayerIndexes() {
                if self.getSharesPortfolioForPlayer(atIndex: playerIndex)[cmpBaseIndex] > 0 {
                    shareholderIndexes.append(playerIndex)
                }
            }
        }
        
        return shareholderIndexes
    }
    
    func getShareholderGlobalIndexesForCompany(atIndex cmpIndex: Int, includePlayers: Bool = true) -> [Int] {
        let cmpBaseIndex = self.forceConvert(index: cmpIndex, backwards: true, withIndexType: .companies)
        return self.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIndex, includePlayers: includePlayers)
    }
    
    func getGlobalIndex(forEntity entityText: String) -> Int {
        if let firstIdx = self.labels.firstIndex(of: entityText) {
            return firstIdx
        }
        
        return -1
    }
    
    func getBaseIndex(forEntity entityText: String) -> Int {
        for bankBaseIdx in 0..<self.bankSize {
            if self.getBankEntityLabel(atBaseIndexOrIndex: bankBaseIdx) == entityText {
                return bankBaseIdx
            }
        }
        
        for companyBaseIdx in 0..<self.companiesSize {
            if self.getCompanyLabel(atBaseIndex: companyBaseIdx) == entityText {
                return companyBaseIdx
            }
        }
        
        for playerBaseIdx in 0..<self.playersSize {
            if self.getPlayerLabel(atBaseIndex: playerBaseIdx) == entityText {
                return playerBaseIdx
            }
        }
        
        return -1
    }
    
    func convert(index: Int?, backwards: Bool = false, withIndexType indexType: IndexType = .generic) -> Int? {
        if let index = index {
            switch indexType {
            case .generic:
                return index
            case .companies:
                return backwards ? index - self.bankSize : index + self.bankSize
            case .players:
                return backwards ? index - self.bankSize - self.companiesSize : index + self.bankSize + self.companiesSize
            }
        }
        
        return nil
    }
    
    func forceConvert(index: Int, backwards: Bool = false, withIndexType indexType: IndexType = .generic) -> Int {
        switch indexType {
        case .generic:
            return index
        case .companies:
            return backwards ? index - self.bankSize : index + self.bankSize
        case .players:
            return backwards ? index - self.bankSize - self.companiesSize : index + self.bankSize + self.companiesSize
        }
    }
    
    func makePrivatesCompaniesOperate() {
        var privatesOp: [Operation] = []
        
        for (i, ownerGlobalIdx) in self.privatesOwnerGlobalIndexes.enumerated() {
            if !self.getBankEntityIndexes().contains(ownerGlobalIdx) && self.privatesIncomes[i] != 0 {
                let privateOp = Operation(type: .income, uid: nil)
                privateOp.setAccessoryTagTitle(accessoryTagTitle: self.privatesLabels[i])
                privateOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: ownerGlobalIdx, amount: Double(self.privatesIncomes[i]))
                privatesOp.append(privateOp)
            }
        }
        
        if !(self.areOperationsLegit(operations: privatesOp, reverted: false)) {
            return
        }
        
        for op in privatesOp {
            _ = self.perform(operation: op, reverted: false)
        }
    }
    
    func closeAllPrivatesCompanies() {
        
        var closePrivatesOp: [Operation] = []
        
        for (i, ownerGlobalIdx) in self.privatesOwnerGlobalIndexes.enumerated() {
            if !self.getBankEntityIndexes().contains(ownerGlobalIdx) {
                if self.game == .g1889 && self.privatesLabels[i] == "G" {
                    // G is not closed but is upgraded to 50 dollar income revenue
                    self.privatesIncomes[i] = 50
                    continue
                }
                
                if self.game == .g1846 && self.privatesLabels[i] == "Mail Contract" && self.getCompanyIndexes().contains(ownerGlobalIdx) {
                    // Mail contract does not close if owned by a company
                    continue
                }
                
                let privateOp = Operation(type: .privates, uid: nil)
                //privateOp.setAccessoryTagTitle(accessoryTagTitle: self.privatesLabels[i])
                privateOp.addPrivatesDetails(privateSourceGlobalIndex: ownerGlobalIdx, privateDestinationGlobalIndex: BankIndex.bank.rawValue, privateCompanyBaseIndex: i)
                closePrivatesOp.append(privateOp)
            }
        }
        
        if !(self.areOperationsLegit(operations: closePrivatesOp, reverted: false)) {
            return
        }
        
        for op in closePrivatesOp {
            _ = self.perform(operation: op, reverted: false)
        }
    }
    
    func isOperationLegit(operation: Operation, reverted: Bool) -> Bool {
        // CASH Op cannot contain trash or generate info
        
        if reverted {
            
            // money
            if let dstGlobalIndex = operation.destinationGlobalIndex, let amount = operation.amount {
                if (!operation.isEmergencyEnabled && self.amounts[dstGlobalIndex] < amount && dstGlobalIndex != BankIndex.bank.rawValue) {
                    return false
                }
            }
            
            // shares
            if let dstGlobalIndex = operation.shareDestinationGlobalIndex, let sharesAmount = operation.shareAmount, let cmpBaseIndex = operation.shareCompanyBaseIndex {
                if self.shares[dstGlobalIndex][cmpBaseIndex] < sharesAmount {
                    return false
                }
            }
            
            // trash
            // no check needed, can always undo a trash operation
            
            // generate
            if let dstGlobalIndex = operation.generateTargetGlobalIndex, let cmpBaseIndex = operation.generateCompanyBaseIndex, let amount = operation.generateAmount {
                if self.shares[dstGlobalIndex][cmpBaseIndex] < Double(amount) {
                    return false
                }
            }
            
            // privates
            if let dstGLobalIndex = operation.privateDestinationGlobalIndex, let privateBaseIndex = operation.privateCompanyBaseIndex {
                if self.privatesOwnerGlobalIndexes[privateBaseIndex] != dstGLobalIndex {
                    return false
                }
            }
            
            // loans
            if let loans = self.loans, let dstGlobalIndex = operation.loansDestinationGlobalIndex, let amount = operation.loansAmount {
                if loans[dstGlobalIndex] < amount {
                    return false
                }
            }
            
            // bonds
            if let bonds = self.bonds, let dstGlobalIndex = operation.bondsDestinationGlobalIndex, let amount = operation.bondsAmount {
                if bonds[dstGlobalIndex] < amount {
                    return false
                }
            }
            
            // line
            if let linesOwnerGlobalIndexes = self.g1840LinesOwnerGlobalIndexes, let dstGlobalIndex = operation.g1840LineDestinationGlobalIndex, let lineBaseIndex = operation.g1840LineBaseIndex {
                if linesOwnerGlobalIndexes[lineBaseIndex] != dstGlobalIndex {
                    return false
                }
            }
            
            // market
            // no need to check
            
        } else {
           
            // money
            if let srcGlobalIndex = operation.sourceGlobalIndex, let amount = operation.amount {
                if (!operation.isEmergencyEnabled && self.amounts[srcGlobalIndex] < amount && srcGlobalIndex != BankIndex.bank.rawValue) {
                    return false
                }
            }
            
            // shares
            if let srcGlobalIndex = operation.shareSourceGlobalIndex, let sharesAmount = operation.shareAmount, let cmpBaseIndex = operation.shareCompanyBaseIndex {
                if self.shares[srcGlobalIndex][cmpBaseIndex] < sharesAmount {
                    return false
                }
            }
            
            // trash
            if let srcGlobalIndex = operation.trashTargetGlobalIndex, let cmpBaseIndex = operation.trashCompanyBaseIndex, let amount = operation.trashAmount {
                if self.shares[srcGlobalIndex][cmpBaseIndex] < Double(amount) {
                    return false
                }
            }
            
            // generate
            // no check needed, can always do a generate operation
            
            // privates
            if let srcGLobalIndex = operation.privateSourceGlobalIndex, let privateBaseIndex = operation.privateCompanyBaseIndex {
                if self.privatesOwnerGlobalIndexes[privateBaseIndex] != srcGLobalIndex {
                    return false
                }
            }
            
            // loans
            if let loans = self.loans, let srcGlobalIndex = operation.loansSourceGlobalIndex, let amount = operation.loansAmount {
                if loans[srcGlobalIndex] < amount {
                    return false
                }
            }
            
            // bonds
            if let bonds = self.bonds, let srcGlobalIndex = operation.bondsSourceGlobalIndex, let amount = operation.bondsAmount {
                if bonds[srcGlobalIndex] < amount {
                    return false
                }
            }
            
            // line
            if let linesOwnerGlobalIndexes = self.g1840LinesOwnerGlobalIndexes, let srcGlobalIndex = operation.g1840LineSourceGlobalIndex, let lineBaseIndex = operation.g1840LineBaseIndex {
                if linesOwnerGlobalIndexes[lineBaseIndex] != srcGlobalIndex {
                    return false
                }
            }
            
            // market
            if let cmpBaseIndex = operation.marketShareValueCmpBaseIndex {
                if self.shareValuesManager.getShareValueIndex(forCompanyAtBaseIndex: cmpBaseIndex) != operation.marketShareValueFromIndex {
                    return false
                }
            }
        }
        
        return true
    }
    
    func areOperationsLegit(operations: [Operation], reverted: Bool) -> Bool {
        
        if let gameStateClone = DeepCopier.Copy(of: self) {
            for op in operations {
                if !gameStateClone.isOperationLegit(operation: op, reverted: reverted) {
                    return false
                }
                
                if !gameStateClone.perform(operation: op, reverted: reverted) {
                    return false
                }
            }
        } else {
            return false
        }
        
        return true
    }
    
    func perform(operation: Operation, reverted: Bool = false, save: Bool = true) -> Bool {
        // TRASH and GENERATE are independent operations from CASH (CashVC generates 3 different ops maximum)
        
        // round type
        if self.roundOperationTypes.contains(operation.type) && operation.type != self.currentRoundOperationType {
            self.currentRoundOperationType = operation.type
        }
        
        // money
        if let srcGlobalIndex = operation.sourceGlobalIndex, let dstGlobalIndex = operation.destinationGlobalIndex, let amount = operation.amount {
            if operation.amount != 0 {
                if reverted {
                    if self.amounts[dstGlobalIndex] < amount && operation.destinationGlobalIndex != BankIndex.bank.rawValue && !operation.isEmergencyEnabled { return false }
                    
                    self.amounts[dstGlobalIndex] -= amount
                    self.amounts[srcGlobalIndex] += amount
                } else {
                    if self.amounts[srcGlobalIndex] < amount && operation.sourceGlobalIndex != BankIndex.bank.rawValue && !operation.isEmergencyEnabled { return false }
                    
                    self.amounts[srcGlobalIndex] -= amount
                    self.amounts[dstGlobalIndex] += amount
                }
            }
        }
        
        // shares
        if let srcGlobalIndex = operation.shareSourceGlobalIndex, let dstGlobalIndex = operation.shareDestinationGlobalIndex, let shareAmount = operation.shareAmount, let cmpBaseIndex = operation.shareCompanyBaseIndex {
            if shareAmount != 0 {
                if reverted {
                    if self.shares[dstGlobalIndex][cmpBaseIndex] < shareAmount { return false }
                    
                    self.shares[dstGlobalIndex][cmpBaseIndex] -= shareAmount
                    self.shares[srcGlobalIndex][cmpBaseIndex] += shareAmount
                } else {
                    if self.shares[srcGlobalIndex][cmpBaseIndex] < shareAmount { return false }
                    
                    self.shares[srcGlobalIndex][cmpBaseIndex] -= shareAmount
                    self.shares[dstGlobalIndex][cmpBaseIndex] += shareAmount
                }
                
                if reverted {
                    self.updateCompanyPresidents(forCompanyAtBaseIndex: cmpBaseIndex, tieBreakPlayerIdx: operation.sharePreviousPresidentGlobalIndex)
                } else {
                    self.updateCompanyPresidents(forCompanyAtBaseIndex: cmpBaseIndex)
                }
            }
        }
        
        // trash
        if operation.type == .trash {
            if let trashAmount = operation.trashAmount, let srcGlobalIndex = operation.trashTargetGlobalIndex, let cmpBaseIndex = operation.trashCompanyBaseIndex {
                if operation.trashAmount == 0 { return false }
                
                if reverted {
                    self.shares[srcGlobalIndex][cmpBaseIndex] += trashAmount
                    self.compTotShares[cmpBaseIndex] += trashAmount
                } else {
                    self.shares[srcGlobalIndex][cmpBaseIndex] -= trashAmount
                    self.compTotShares[cmpBaseIndex] -= trashAmount
                }
                
                if reverted {
                    self.updateCompanyPresidents(forCompanyAtBaseIndex: cmpBaseIndex, tieBreakPlayerIdx: operation.sharePreviousPresidentGlobalIndex)
                } else {
                    self.updateCompanyPresidents(forCompanyAtBaseIndex: cmpBaseIndex)
                }
                
                if save {
                    self.operations.append(operation)
                }

                self.saveToDisk()
                return true
            }
            
            return false
        }
        
        // generate
        if operation.type == .generate {
            if let generateAmount = operation.generateAmount, let srcGlobalIndex = operation.generateTargetGlobalIndex, let cmpBaseIndex = operation.generateCompanyBaseIndex {
                if generateAmount == 0 { return false }
                
                if reverted {
                    self.shares[srcGlobalIndex][cmpBaseIndex] -= generateAmount
                    self.compTotShares[cmpBaseIndex] -= generateAmount
                } else {
                    self.shares[srcGlobalIndex][cmpBaseIndex] += generateAmount
                    self.compTotShares[cmpBaseIndex] += generateAmount
                }
                
                if reverted {
                    self.updateCompanyPresidents(forCompanyAtBaseIndex: cmpBaseIndex, tieBreakPlayerIdx: operation.sharePreviousPresidentGlobalIndex)
                } else {
                    self.updateCompanyPresidents(forCompanyAtBaseIndex: cmpBaseIndex)
                }
                
                if save {
                    self.operations.append(operation)
                }
                
                self.saveToDisk()
                return true
            }
            
            return false
        }
        
        // privates
        if let privateCompanyBaseIndex = operation.privateCompanyBaseIndex, let srcGlobalIndex = operation.privateSourceGlobalIndex, let dstGlobalIndex = operation.privateDestinationGlobalIndex {
            if reverted {
                self.privatesOwnerGlobalIndexes[privateCompanyBaseIndex] = srcGlobalIndex
            } else {
                self.privatesOwnerGlobalIndexes[privateCompanyBaseIndex] = dstGlobalIndex
            }
        }
        
        // loans
        if let srcGlobalIndex = operation.loansSourceGlobalIndex, let dstGlobalIndex = operation.loansDestinationGlobalIndex, let loansAmount = operation.loansAmount {
            if reverted {
                self.loans?[dstGlobalIndex] -= loansAmount
                self.loans?[srcGlobalIndex] += loansAmount
            } else {
                self.loans?[srcGlobalIndex] -= loansAmount
                self.loans?[dstGlobalIndex] += loansAmount
            }
        }
        
        // bonds
        if let srcGlobalIndex = operation.bondsSourceGlobalIndex, let dstGlobalIndex = operation.bondsDestinationGlobalIndex, let bondsAmount = operation.bondsAmount {
            if reverted {
                self.bonds?[dstGlobalIndex] -= bondsAmount
                self.bonds?[srcGlobalIndex] += bondsAmount
            } else {
                self.bonds?[srcGlobalIndex] -= bondsAmount
                self.bonds?[dstGlobalIndex] += bondsAmount
            }
        }
        
        // g1840 line
        if let lineBaseIndex = operation.g1840LineBaseIndex, let srcGlobalIndex = operation.g1840LineSourceGlobalIndex, let dstGlobalIndex = operation.g1840LineDestinationGlobalIndex {
            if reverted {
                self.g1840LinesOwnerGlobalIndexes?[lineBaseIndex] = srcGlobalIndex
            } else {
                self.g1840LinesOwnerGlobalIndexes?[lineBaseIndex] = dstGlobalIndex
            }
        }
        
        // g1840 line run
        if let lineBaseIndex = operation.g1840LineBaseIndex, let runAmount = operation.g1840LineRunAmount, let runIndex = operation.g1840LineRunIndex {
            if reverted {
                self.g1840LinesRevenue?[lineBaseIndex][runIndex] = 0
            } else {
                self.g1840LinesRevenue?[lineBaseIndex][runIndex] = Int(runAmount)
            }
        }
        
        // market
        if let cmpBaseIndex = operation.marketShareValueCmpBaseIndex {
            if !reverted {
                self.shareValuesManager.setShareValueIndexPath(index: operation.marketShareValueToIndex, forCompanyAtBaseIndex: cmpBaseIndex)
            } else if reverted {
                self.shareValuesManager.setShareValueIndexPath(index: operation.marketShareValueFromIndex, forCompanyAtBaseIndex: cmpBaseIndex)
                if let prevParValue = operation.marketPreviousPARValue {
                    self.shareValuesManager.PARvaluesByCmpBaseIndexes[cmpBaseIndex] = Int(prevParValue)
                }
            }
        }
        
        // updating Floated companies

        if operation.type == .float, let cmpIdx = operation.destinationGlobalIndex {
            let cmpBaseIdx = self.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
            
            if !reverted {
                self.floatedCompanies[cmpBaseIdx] = true
            } else {
                self.floatedCompanies[cmpBaseIdx] = false
            }
        }
        
        // updating companies operated flags
        
        if let cmpBaseIndex = operation.marketShareValueCmpBaseIndex {
            if !reverted, let _ = operation.marketShareValueToIndex, let _ = operation.marketShareValueFromIndex {
                if !self.activeOperations.contains(where: { op in
                    op.uid == operation.uid && op.type == .sellEmergency
                }) {
                    self.companiesOperated[cmpBaseIndex] = true
                }
            }
        }
        
        // updating train index
        if operation.type == .trains {
            if let trainPrice = operation.trainPrice, operation.destinationGlobalIndex == BankIndex.bank.rawValue {
                if let trainPriceIdx = self.trainPriceValues.lastIndex(where: { $0 <= Int(trainPrice) }) {
                    if !reverted {
                        if trainPriceIdx != self.currentTrainPriceIndex {
                            self.currentTrainPriceIndex = trainPriceIdx
                            
                            if self.game == .g1856 {
                                if self.trainPriceValues[self.currentTrainPriceIndex] == 550 {
                                    self.certificateLimit = [28, 22, 18, 15][self.playersSize - 3]
                                }
                                
                                if self.trainPriceValues[self.currentTrainPriceIndex] == 550 {
                                    for i in 0..<self.companiesSize where i != self.getBaseIndex(forEntity: "CGR") {
                                        if self.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[i] == self.compTotShares[i] {
                                            self.g1856CompaniesStatus?[i] = .incrementalCapitalization
                                        }
                                    }
                                } else if self.trainPriceValues[self.currentTrainPriceIndex] == 700 {
                                    for i in 0..<self.companiesSize where i != self.getBaseIndex(forEntity: "CGR") {
                                        if self.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[i] == self.compTotShares[i] {
                                            self.g1856CompaniesStatus?[i] = .fullCapitalization
                                        }
                                    }
                                }
                            }
                            
                            if self.game == .g1849 {
                                if self.trainPriceValues[self.currentTrainPriceIndex] == 1100 {
                                    self.shareValuesManager.unlockAllPayoutWithoutLocations()
                                }
                            }
                        }
                        
                    // reverted op
                    } else {
                        let maxTrainPrice = self.activeOperations.filter { operation.uid != $0.uid && $0.type == .trains && $0.uid != operation.uid && $0.destinationGlobalIndex == BankIndex.bank.rawValue }.map { $0.trainPrice ?? 0 }.max() ?? 0
                            
                        let trainPriceIdx = self.trainPriceValues.lastIndex(where: { $0 <= Int(maxTrainPrice) }) ?? 0
                        if trainPriceIdx != self.currentTrainPriceIndex {
                            self.currentTrainPriceIndex = trainPriceIdx
                            
                            if self.game == .g1856 {
                                
                                if self.trainPriceValues[self.currentTrainPriceIndex] < 550 {
                                    self.certificateLimit = [0, 20, 16, 13, 11][self.playersSize - 1 - 1]
                                    
                                    for i in 0..<self.companiesSize where i != self.getBaseIndex(forEntity: "CGR") {
                                        if self.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[i] == self.compTotShares[i] {
                                            self.g1856CompaniesStatus?[i] = .incrementalCapitalizationCapped
                                        }
                                    }
                                }
                            }
                            
                            if self.game == .g1849 && self.trainPriceValues.count > self.currentTrainPriceIndex + 1 {
                                if self.trainPriceValues[self.currentTrainPriceIndex + 1] == 1100 {
                                    self.shareValuesManager.lockAllPayoutWithoutLocations()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if save {
            self.operations.append(operation)
        }
        
        self.saveToDisk()
        return true
    }
    
    func getDropOperationFromSELL(forCompanyAtBaseIndex cmpBaseIdx: Int, andSharesAmount sharesAmount: Double, withUid uid: Int? = nil) -> [Operation] {
        
        switch self.game {
        case .g1846:
            if Int(sharesAmount) >= 1 {
                if let marketOp = self.getShareValueMarketOperation(forCompanyAtBaseIndex: cmpBaseIdx, andMovements: [.down], withUid: uid) {
                    return [marketOp]
                }
            }
            
        case .g1848:
            if self.getCompanyType(atBaseIndex: cmpBaseIdx) != .g1848BoE {
                if Int(sharesAmount) >= 1 {
                    if let marketOp = self.getShareValueMarketOperation(forCompanyAtBaseIndex: cmpBaseIdx, andMovements: [.down], withUid: uid) {
                        return [marketOp]
                    }
                }
            }
            
        case .g1830, .g1840, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            
            // self.getTotalShareNumberOfCompany(atBaseIndex: operation.shareCompanyBaseIndex)) {
            if let marketOp = self.getShareValueMarketOperation(forCompanyAtBaseIndex: cmpBaseIdx, andMovements: Array<ShareValueMovementType>(repeating: .down, count: Int(sharesAmount)), withUid: uid) {
                return [marketOp]
            }
        }
        
        return []
    }
        
    func getShareValueMarketOperation(forCompanyAtBaseIndex cmpBaseIdx: Int, andMovements movements: [ShareValueMovementType], withUid uid: Int? = nil) -> Operation? {
        if let fromIndex = self.shareValuesManager.getShareValueIndex(forCompanyAtBaseIndex: cmpBaseIdx) {
            if let toIndex = self.shareValuesManager.getShareValueIndexPreview(forCompanyAtBaseIndex: cmpBaseIdx, withMovements: movements) {
                if fromIndex == toIndex { return nil }
                
                if let fromShareValue = self.shareValuesManager.getShareValue(atIndexPath: fromIndex),
                   let toShareValue = self.shareValuesManager.getShareValue(atIndexPath: toIndex) {
                    let marketOp = Operation(type: .market, uid: uid)
                    marketOp.setOperationColorGlobalIndex(colorGlobalIndex: self.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies))
                    marketOp.addMarketDetails(marketShareValueCmpBaseIndex: cmpBaseIdx, marketShareValueFromIndex: fromIndex, marketShareValueToIndex: toIndex, marketLogStr: "\(self.currencyType.getCurrencyStringFromAmount(amount: fromShareValue)) -> \(self.getCompanyLabel(atBaseIndex: cmpBaseIdx)) -> \(self.currencyType.getCurrencyStringFromAmount(amount: toShareValue))")
                    
                    return marketOp
                }
            }
        }
        
        return nil
    }
    
    func getAmountFromPopupButtonTitle(title: String) -> Double {
        
        let regex = try! NSRegularExpression(pattern: "\\d+(\\.\\d+)?")
        let range = NSRange(location: 0, length: title.utf16.count)
        let match = regex.firstMatch(in: title, options: [], range: range)
        if let matchRange = match?.range {
            let numberString = (title as NSString).substring(with: matchRange)
            if let number = Double(numberString) {
                return number
            }
        }
        
        return 0.0

    }
    
    func getBankEntityIndexFromPopupButtonTitle(title: String) -> Int {
        var titleToCheck = title
        
        if title.contains(" ") {
            titleToCheck = title.components(separatedBy: " ")[0]
        }
        
        for bankIdx in self.getBankEntityIndexes() {
            if titleToCheck == self.getBankEntityLabel(atBaseIndexOrIndex: bankIdx) {
                return bankIdx
            }
        }
        
        return -1
    }
    
    func getCompanyIndexFromPopupButtonTitle(title: String) -> Int {
        var titleToCheck = title
        
        if title.contains(" ") {
            titleToCheck = title.components(separatedBy: " ")[0]
        }
        
        for cmpIdx in self.getCompanyIndexes() {
            if titleToCheck == self.getCompanyLabel(atIndex: cmpIdx) {
                return cmpIdx
            }
        }
        
        return -1
    }
    
    func getPlayerIndexFromPopupButtonTitle(title: String) -> Int {
        var titleToCheck = title
        
        if title.contains(" ") {
            titleToCheck = title.components(separatedBy: " ")[0]
        }
        
        for playerIdx in self.getPlayerIndexes() {
            if titleToCheck == self.getPlayerLabel(atIndex: playerIdx) {
                return playerIdx
            }
        }
        
        return -1
    }
    
    func getGlobalIndexFromPopupButtonTitle(title: String) -> Int {
        let bankIdx = self.getBankEntityIndexFromPopupButtonTitle(title: title)
        
        if bankIdx != -1 {
            return bankIdx
        }
        
        let cmpIdx = self.getCompanyIndexFromPopupButtonTitle(title: title)
        
        if cmpIdx != -1 {
            return cmpIdx
        }
        
        let playerIdx = self.getPlayerIndexFromPopupButtonTitle(title: title)
        
        if playerIdx != -1 {
            return playerIdx
        }
        
        return -1
    }
    
    func getPlayersLiquidity() -> [Double] {
        var playersAmounts: [Double] = Array(self.amounts[self.getPlayerIndexes()])
        
        if self.game == .g1840 {
            // no comp to float after setup, no need to calculate it
            return playersAmounts
        }
        
        for (cmpBaseIdx, _) in self.getCompanyIndexes().enumerated() {
            if let cmpShareValue = self.shareValuesManager.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) {
                if cmpShareValue == 0 { continue }
                
                let sharesInBank = self.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[cmpBaseIdx]
                let shareholdersIndexes = self.getShareholderGlobalIndexesForCompany(atBaseIndex: cmpBaseIdx).filter({ self.getPlayerIndexes().contains($0) })
                let shareholdersSharesCount = shareholdersIndexes.map({ self.shares[$0][cmpBaseIdx] })
                
                for playerBaseIdx in 0..<self.playersSize {
                    
                    let currentPlayerShares = self.getSharesPortfolioForPlayer(atBaseIndex: playerBaseIdx)[cmpBaseIdx]
                    var soldableShares = currentPlayerShares
                    
                    if currentPlayerShares >= self.presidentCertificateShareAmount && currentPlayerShares == shareholdersSharesCount.max() && shareholdersSharesCount.filter({$0 >= self.presidentCertificateShareAmount}).count == 1 {
                        soldableShares -= self.presidentCertificateShareAmount
                    }
                    
                    soldableShares = min((5 - sharesInBank), soldableShares)
                    
                    if self.buySellRoundPolicyOnTotal == .roundUp {
                        playersAmounts[playerBaseIdx] += ceil(soldableShares * cmpShareValue)
                    } else {
                        playersAmounts[playerBaseIdx] += floor(soldableShares * cmpShareValue)
                    }
                }
            }
        }
        
        return playersAmounts
    }
    
    func getPlayersTotalNetWorth() -> [Double] {
        var playersAmounts: [Double] = Array(self.amounts[self.getPlayerIndexes()])
        
        for (cmpBaseIdx, cmpIdx) in self.getCompanyIndexes().enumerated() {
            if let cmpShareValue = self.shareValuesManager.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) {
                if cmpShareValue == 0 { continue }
                
                var companyShareValue = cmpShareValue
                
                if let loans = self.loans {
                    let cmpLoansAmount = loans[cmpIdx]
                    
                    if cmpLoansAmount != 0 {
                        switch self.game {
                        case .g1856:
                            companyShareValue = max(0, cmpShareValue - Double((cmpLoansAmount * 10)))
                        case .g1830, .g1840, .g1846, .g1848, .g1849, .g1882, .g1889, .g18Chesapeake, .g18MEX:
                            break
                        }
                    }
                }
                
                if let bonds = self.bonds {
                    let cmpBondsAmount = bonds[cmpIdx]
                    
                    if cmpBondsAmount != 0 {
                        switch self.game {
                        case .g1849:
                            companyShareValue = max(0, cmpShareValue - 100)
                        case .g1830, .g1840, .g1846, .g1848, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
                            break
                        }
                    }
                }
                
                for playerBaseIdx in 0..<playersAmounts.count {
                    if self.buySellRoundPolicyOnTotal == .roundUp {
                        playersAmounts[playerBaseIdx] += ceil(self.getSharesPortfolioForPlayer(atBaseIndex: playerBaseIdx)[cmpBaseIdx] * companyShareValue)
                    } else {
                        playersAmounts[playerBaseIdx] += floor(self.getSharesPortfolioForPlayer(atBaseIndex: playerBaseIdx)[cmpBaseIdx] * companyShareValue)
                    }
                }
            }
        }
        
        for (playerBaseIdx, playerIdx) in self.getPlayerIndexes().enumerated() {
            if let loans = self.loans {
                let playerLoansAmount = loans[playerIdx]
                
                if playerLoansAmount != 0 {
                    switch self.game {
                    case .g1840:
                        playersAmounts[playerBaseIdx] -= (Double(playerLoansAmount) * 200.0)
                    case .g1830, .g1846, .g1848, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
                        break
                    }
                }
            }
        }
        
        // privates still open?
        for (i, privateOwnerGlobalIdx) in self.privatesOwnerGlobalIndexes.enumerated() {
            if self.getPlayerIndexes().contains(privateOwnerGlobalIdx) {
                playersAmounts[self.forceConvert(index: privateOwnerGlobalIdx, backwards: true, withIndexType: .players)] += self.privatesPrices[i]
            }
        }
        
        return playersAmounts
    }
    
    func saveToDisk() {
        do {
            
            self.lastUid = Operation.lastUid
            
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("CiuffCiuffGameState.json")
            
            try JSONEncoder()
                .encode(self)
                .write(to: fileURL)
        } catch {
            print("error writing data")
        }
    }
    
}

// wrapper for Share value manager methods
extension GameState {
    
    func companyHasReachedGameEndLocation() -> Int? {
        return self.shareValuesManager.companyHasReachedGameEndLocation()
    }
    
    func setGameEndLocation(gameEndLocation: ShareValueIndexPath) {
        self.shareValuesManager.setGameEndLocation(gameEndLocation: gameEndLocation)
    }
    
    func overrideCustomColors(indexes: [ShareValueIndexPath], colors: [UIColor]) {
        self.shareValuesManager.overrideCustomColors(indexes: indexes, colors: colors)
    }
    
    func setOpeningLocations(_ openingLocations: [ShareValueIndexPath]) {
        self.shareValuesManager.openingLocations = openingLocations
    }
    
    func setYellowShareValueIndexPaths(_ yellowLocations: [ShareValueIndexPath]) {
        self.shareValuesManager.yellowShareValueIndexPaths = yellowLocations
    }
    
    func setOrangeShareValueIndexPaths(_ orangeLocations: [ShareValueIndexPath]) {
        self.shareValuesManager.orangeShareValueIndexPaths = orangeLocations
    }
    
    func setBrownShareValueIndexPaths(_ brownLocations: [ShareValueIndexPath]) {
        self.shareValuesManager.brownShareValueIndexPaths = brownLocations
    }
    
    func getOpeningLocations() -> [ShareValueIndexPath] {
        return self.shareValuesManager.openingLocations
    }
    
    func getShareValueMatrix() -> [[Double?]] {
        return self.shareValuesManager.shareValuesMatrix
    }
    
    func getDistinctShareValuesSorted() -> [Double] {
        return self.shareValuesManager.distinctShareValuesSorted
    }
    
    func getSortedCmpBaseIndexesByShareValueDesc() -> [Int] {
        return self.shareValuesManager.sortedCmpBaseIndexesByShareValueDesc
    }
    
    func getGamePARValues() -> [Int] {
        return self.shareValuesManager.gamePARValues
    }
    
    func getPARindex(fromShareValue shareValue: Double) -> ShareValueIndexPath? {
        return self.shareValuesManager.getPARindex(fromShareValue: shareValue)
    }

    func getShareValueIndex(forCompanyAtBaseIndex cmpBaseIdx: Int) -> ShareValueIndexPath? {
        return self.shareValuesManager.getShareValueIndex(forCompanyAtBaseIndex: cmpBaseIdx)
    }

    func getCompanyBaseIndexesOfCompInYellowOrangeBrownZone() -> [Int] {
        return self.shareValuesManager.getCompanyBaseIndexesOfCompInYellowOrangeBrownZone()
    }
    
    func getCompanyBaseIndexesOfCompInCloseZone() -> [Int] {
        return self.shareValuesManager.getCompanyBaseIndexesOfCompInCloseZone()
    }

    func reorderCmpBaseIndexes(sortedCmpBaseIndexes: [Int]) {
        self.shareValuesManager.reorderCmpBaseIndexes(sortedCmpBaseIndexes: sortedCmpBaseIndexes)
    }

    func getPARvalue(forCompanyAtBaseIndex cmpBaseIdx: Int) -> Int? {
        return self.shareValuesManager.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx)
    }
    
    func setPARvalue(value: Int?, forCompanyAtBaseIndex cmpBaseIdx: Int) {
        self.shareValuesManager.setPARvalue(value: value, forCompanyAtBaseIndex: cmpBaseIdx)
    }

    func getShareValue(forCompanyAtBaseIndex cmpBaseIdx: Int) -> Double? {
        
        switch self.getCompanyType(atBaseIndex: cmpBaseIdx) {
        case .g1848BoE:
            return self.shareValuesManager.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx, BoELoans: self.loans?[self.getGlobalIndex(forEntity: "BoE")])
        case .standard, .g1840Stadtbahn, .g1846Miniature, .g1856CGR, .g18MEXMinor:
            return self.shareValuesManager.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx)
        }
    }

    func getShareValue(atIndexPath indexPath: ShareValueIndexPath) -> Double? {
        return self.shareValuesManager.getShareValue(atIndexPath: indexPath)
    }


    // COLLECTION VIEW Rendering methods
    
    func getVerticalCellCount() -> Int {
        return self.shareValuesManager.verticalCellCount
    }
    
    func getShareValueIndex(fromCollectionViewIndexPath indexPath: IndexPath) -> ShareValueIndexPath {
        self.shareValuesManager.getShareValueIndex(fromCollectionViewIndexPath: indexPath)
    }
    
    func getCollectionViewNumberOfItems() -> Int {
        return self.shareValuesManager.getCollectionViewNumberOfItems()
    }
    
    func getShareValue(forCollectionViewIndexPath indexPath: IndexPath) -> Double? {
        return self.shareValuesManager.getShareValue(forCollectionViewIndexPath: indexPath)
    }
    
    func getCompanyBaseIndexes(withShareValueInIndexPath indexPath: IndexPath) -> [Int] {
        return self.shareValuesManager.getCompanyBaseIndexes(withShareValueInIndexPath: indexPath)
    }
    
    func match(collectionViewIndexPath indexPath: IndexPath, withShareIndexOfCompanyBaseIndex cmpBaseIdx: Int) -> Bool {
        return self.shareValuesManager.match(collectionViewIndexPath: indexPath, withShareIndexOfCompanyBaseIndex: cmpBaseIdx)
    }
    
    func updateLocation(forCompanyAtBaseIndex cmpBaseIdx: Int, withCollectionViewIndexIndexPath indexPath: IndexPath) -> Bool {
        return self.shareValuesManager.updateLocation(forCompanyAtBaseIndex: cmpBaseIdx, withCollectionViewIndexIndexPath: indexPath)
    }
    
    func getBackgroundColorForCell(atCollectionViewIndexPath indexPath: IndexPath) -> UIColor? {
        return self.shareValuesManager.getBackgroundColorForCell(atCollectionViewIndexPath: indexPath)
    }
    
    func getTextColorForCell(atCollectionViewIndexPath indexPath: IndexPath) -> UIColor {
        return self.shareValuesManager.getTextColorForCell(atCollectionViewIndexPath: indexPath)
    }
    
}
