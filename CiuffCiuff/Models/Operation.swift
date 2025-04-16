//
//  Operation.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation

class Operation: Codable {
    static var lastUid = 0
    static func generateUid() -> Int {
        lastUid += 1
        return lastUid
    }
    
    static var privateCompanyLabels: [String] = []
    static var opEntityLabels: [String] = []
    static var opBaseCompanyLabels: [String] = []
    
    var uid: Int
    var type: OperationType
    var colorGlobalIndex: Int
    var accessoryTagTitle: String?
    var isEmergencyEnabled: Bool
    var isActive: Bool
    
    var sourceGlobalIndex: Int? = nil
    var sourceStr: String? = nil
    var destinationGlobalIndex: Int? = nil
    var destinationStr: String? = nil
    var amount: Double? = nil
    
    var trainPrice: Double? = nil
    
    var shareSourceGlobalIndex: Int? = nil
    var shareSourceStr: String? = nil
    var shareDestinationGlobalIndex: Int? = nil
    var shareDestinationStr: String? = nil
    var shareAmount: Double? = nil
    var shareCompanyBaseIndex: Int? = nil
    var shareCompanyStr: String? = nil
    var sharePreviousPresidentGlobalIndex: Int? = nil
    
    var payoutWithholdCompanyBaseIndex: Int? = nil
    var payoutWithholdCompanyStr: String? = nil
    var payoutShareAmount: Double? = nil
    var payoutTotalAmount: Int? = nil
    var isStandardPayout: Bool? = nil
    
    var trashAmount: Double? = nil
    var trashTargetGlobalIndex: Int? = nil
    var trashTargetStr: String? = nil
    var trashCompanyBaseIndex: Int? = nil
    var trashCompanyStr: String? = nil
    
    var generateAmount: Double? = nil
    var generateTargetGlobalIndex: Int? = nil
    var generateTargetStr: String? = nil
    var generateCompanyBaseIndex: Int? = nil
    var generateCompanyStr: String? = nil
    
    var privateSourceGlobalIndex: Int? = nil
    var privateSourceStr: String? = nil
    var privateDestinationGlobalIndex: Int? = nil
    var privateDestinationStr: String? = nil
    var privateCompanyBaseIndex: Int? = nil
    var privateCompanyStr: String? = nil
    
    var loansSourceGlobalIndex: Int? = nil
    var loansSourceStr: String? = nil
    var loansDestinationGlobalIndex: Int? = nil
    var loansDestinationStr: String? = nil
    var loansAmount: Int? = nil
    
    var bondsSourceGlobalIndex: Int? = nil
    var bondsSourceStr: String? = nil
    var bondsDestinationGlobalIndex: Int? = nil
    var bondsDestinationStr: String? = nil
    var bondsAmount: Int? = nil
    
    var g1840LineSourceGlobalIndex: Int? = nil
    var g1840LineSourceStr: String? = nil
    var g1840LineDestinationGlobalIndex: Int? = nil
    var g1840LineDestinationStr: String? = nil
    var g1840LineBaseIndex: Int? = nil
    var g1840LineLabel: String? = nil
    var g1840LineRunAmount: Double? = nil
    var g1840LineRunIndex: Int? = nil
    
    var marketShareValueCmpBaseIndex: Int? = nil
    var marketShareValueFromIndex: ShareValueIndexPath? = nil
    var marketShareValueToIndex: ShareValueIndexPath? = nil
    var marketLogStr: String? = nil
    var marketPreviousPARValue: Double? = nil
    
    func addCashDetails(sourceIndex: Int, destinationIndex: Int, amount: Double, isEmergencyEnabled: Bool = false, trainPrice: Double? = nil) {
        self.isEmergencyEnabled = isEmergencyEnabled
        self.sourceGlobalIndex = sourceIndex
        self.sourceStr = Operation.opEntityLabels[sourceIndex]
        self.destinationGlobalIndex = destinationIndex
        self.destinationStr = Operation.opEntityLabels[destinationIndex]
        self.amount = amount
        self.trainPrice = trainPrice
    }
    
    func addSharesDetails(shareSourceIndex: Int, shareDestinationIndex: Int, shareAmount: Double, shareCompanyBaseIndex: Int, sharePreviousPresidentGlobalIndex: Int? = nil) {
        self.shareSourceGlobalIndex = shareSourceIndex
        self.shareSourceStr = Operation.opEntityLabels[shareSourceIndex]
        self.shareDestinationGlobalIndex = shareDestinationIndex
        self.shareDestinationStr = Operation.opEntityLabels[shareDestinationIndex]
        self.shareAmount = Double(shareAmount)
        self.shareCompanyBaseIndex = shareCompanyBaseIndex
        self.shareCompanyStr = Operation.opBaseCompanyLabels[shareCompanyBaseIndex]
        self.sharePreviousPresidentGlobalIndex = sharePreviousPresidentGlobalIndex
    }
    
    func addPayoutDetails(payoutCompanyBaseIndex: Int, payoutShareAmount: Double, payoutTotalAmount: Int, isStandardPayout: Bool = false) {
        self.payoutWithholdCompanyBaseIndex = payoutCompanyBaseIndex
        self.payoutWithholdCompanyStr = Operation.opBaseCompanyLabels[payoutCompanyBaseIndex]
        self.payoutShareAmount = payoutShareAmount
        self.payoutTotalAmount = payoutTotalAmount
        self.isStandardPayout = isStandardPayout
    }
    
    func addWithholdDetails(withholdCompanyBaseIndex: Int, payoutTotalAmount: Int, isStandardPayout: Bool = false) {
        self.payoutWithholdCompanyBaseIndex = withholdCompanyBaseIndex
        self.payoutWithholdCompanyStr = Operation.opBaseCompanyLabels[withholdCompanyBaseIndex]
        self.payoutTotalAmount = payoutTotalAmount
        self.isStandardPayout = isStandardPayout
    }
    
    func addTrashDetails(trashAmount: Double, trashTargetIndex: Int, trashCompanyBaseIndex: Int, sharePreviousPresidentGlobalIndex: Int? = nil) {
        self.trashAmount = Double(trashAmount)
        self.trashTargetGlobalIndex = trashTargetIndex
        self.trashTargetStr = Operation.opEntityLabels[trashTargetIndex]
        self.trashCompanyBaseIndex = trashCompanyBaseIndex
        self.trashCompanyStr = Operation.opBaseCompanyLabels[trashCompanyBaseIndex]
        self.sharePreviousPresidentGlobalIndex = sharePreviousPresidentGlobalIndex
    }
    
    func addGenerateDetails(generateAmount: Double, generateTargetIndex: Int, generateCompanyBaseIndex: Int, sharePreviousPresidentGlobalIndex: Int? = nil) {
        self.generateAmount = Double(generateAmount)
        self.generateTargetGlobalIndex = generateTargetIndex
        self.generateTargetStr = Operation.opEntityLabels[generateTargetIndex]
        self.generateCompanyBaseIndex = generateCompanyBaseIndex
        self.generateCompanyStr = Operation.opBaseCompanyLabels[generateCompanyBaseIndex]
        self.sharePreviousPresidentGlobalIndex = sharePreviousPresidentGlobalIndex
    }
    
    func addPrivatesDetails(privateSourceGlobalIndex: Int, privateDestinationGlobalIndex: Int, privateCompanyBaseIndex: Int) {
        self.privateSourceGlobalIndex = privateSourceGlobalIndex
        self.privateSourceStr = Operation.opEntityLabels[privateSourceGlobalIndex]
        self.privateDestinationGlobalIndex = privateDestinationGlobalIndex
        self.privateDestinationStr = Operation.opEntityLabels[privateDestinationGlobalIndex]
        self.privateCompanyBaseIndex = privateCompanyBaseIndex
        self.privateCompanyStr = Operation.privateCompanyLabels[privateCompanyBaseIndex]
    }
    
    func addLoanDetails(loansSourceGlobalIndex: Int, loansDestinationGlobalIndex: Int, loansAmount: Int) {
        self.loansSourceGlobalIndex = loansSourceGlobalIndex
        self.loansSourceStr = Operation.opEntityLabels[loansSourceGlobalIndex]
        self.loansDestinationGlobalIndex = loansDestinationGlobalIndex
        self.loansDestinationStr = Operation.opEntityLabels[loansDestinationGlobalIndex]
        self.loansAmount = loansAmount
    }
    
    func addBondDetails(bondsSourceGlobalIndex: Int, bondsDestinationGlobalIndex: Int, bondsAmount: Int) {
        self.bondsSourceGlobalIndex = bondsSourceGlobalIndex
        self.bondsSourceStr = Operation.opEntityLabels[bondsSourceGlobalIndex]
        self.bondsDestinationGlobalIndex = bondsDestinationGlobalIndex
        self.bondsDestinationStr = Operation.opEntityLabels[bondsDestinationGlobalIndex]
        self.bondsAmount = bondsAmount
    }
    
    func g1840AddLineDetails(lineSourceGlobalIndex: Int, lineDestinationGlobalIndex: Int, lineBaseIndex: Int, lineLabel: String) {
        self.g1840LineSourceGlobalIndex = lineSourceGlobalIndex
        self.g1840LineSourceStr = Operation.opEntityLabels[lineSourceGlobalIndex]
        self.g1840LineDestinationGlobalIndex = lineDestinationGlobalIndex
        self.g1840LineDestinationStr = Operation.opEntityLabels[lineDestinationGlobalIndex]
        self.g1840LineBaseIndex = lineBaseIndex
        self.g1840LineLabel = lineLabel
    }
    
    func g1840AddLineRunDetails(lineBaseIndex: Int, lineLabel: String, lineRunAmount: Double, lineRunIndex: Int) {
        self.g1840LineBaseIndex = lineBaseIndex
        self.g1840LineLabel = lineLabel
        self.g1840LineRunAmount = lineRunAmount
        self.g1840LineRunIndex = lineRunIndex
    }
    
    func addMarketDetails(marketShareValueCmpBaseIndex: Int, marketShareValueFromIndex: ShareValueIndexPath?, marketShareValueToIndex: ShareValueIndexPath?, marketLogStr: String, marketPreviousPARValue: Double? = nil) {
        self.marketShareValueCmpBaseIndex = marketShareValueCmpBaseIndex
        self.marketShareValueFromIndex = marketShareValueFromIndex
        self.marketShareValueToIndex = marketShareValueToIndex
        self.marketLogStr = marketLogStr
        self.marketPreviousPARValue = marketPreviousPARValue
    }
    
    func overrideUid(uid: Int) {
        self.uid = uid
    }
    
    init(type: OperationType, uid: Int? = nil) {
        if let uid = uid {
            self.uid = uid
        } else {
            self.uid = Operation.generateUid()
        }
        
        self.type = type
        self.colorGlobalIndex = 0
        self.accessoryTagTitle = nil
        
        self.isEmergencyEnabled = false
        self.isActive = true
    }
    
    func setOperationColorGlobalIndex(colorGlobalIndex: Int) {
        self.colorGlobalIndex = colorGlobalIndex
    }
    
    func setAccessoryTagTitle(accessoryTagTitle: String) {
        self.accessoryTagTitle = accessoryTagTitle
    }
    
    func getDescription() -> String {
        
        // single line descriptions
        switch self.type {
        case .SR, .g1840SR1, .g1840SR2, .g1840SR3, .g1840SR4, .g1840SR5:
            return "Stock Round"
        case .yellowOR, .greenOR, .brownOR:
            return "Operating Round"
        case .g1840CR1, .g1840CR2, .g1840CR3, .g1840CR4, .g1840CR5, .g1840CR6:
            return "Company Round"
        case .g1840LR1a, .g1840LR2a, .g1840LR3a, .g1840LR4a, .g1840LR5a:
            return "Line Round (a)"
        case .g1840LR1b, .g1840LR2b, .g1840LR3b, .g1840LR4b, .g1840LR5b:
            return "Line Round (b)"
        case .g1840LR5c:
            return "Line Round (c)"
        case .acquisition, .close, .g18MEXcloseMinors, .setup, .g18MEXmerge, .cash, .income, .payout, .withhold, .privates, .trains, .sell, .sellEmergency, .buy, .tokens, .float, .trash, .generate, .mail, .g1840Shortfall, .g1882NWR, .g1882Bridge, .market, .line, .loan, .bond, .interests, .sellPrivate, .buyPrivate, .g1840LineRun:
            break
        }
        
        var tagStr = ""
        
        // type tag logger
        tagStr = self.type.rawValue.uppercased()
        if tagStr.contains("-") {
            tagStr = tagStr.components(separatedBy: "-")[1]
        }
        if let payoutWithholdCmpBaseIdx = self.payoutWithholdCompanyBaseIndex {
            tagStr += " (\(Operation.opBaseCompanyLabels[payoutWithholdCmpBaseIdx]))"
        } else if let accessoryTagTitle = self.accessoryTagTitle {
            tagStr += " (\(accessoryTagTitle))"
        }
        tagStr += "-:-"
        
        var components: [String] = []
        
        // money logger
        if let sourceStr = self.sourceStr, let destinationStr = self.destinationStr, let amount = self.amount {
            var componentStr = "\(sourceStr) -> \(Int(amount)) -> \(destinationStr)"
            
            if self.isEmergencyEnabled { componentStr += " (emergency enabled)" }
            
            components.append(componentStr)
        }
        
        // share logger
        if let sourceStr = self.shareSourceStr, let shareAmount = self.shareAmount, let shareCompanyStr = self.shareCompanyStr, let destinationStr = self.shareDestinationStr {
            components.append("\(sourceStr) -> \(shareAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(shareAmount)) : String(shareAmount)) (\(shareCompanyStr)) -> \(destinationStr)")
        }
        
        // trash logger
        if let sourceStr = self.trashTargetStr, let trashAmount = self.shareAmount, let trashCompanyStr = self.trashCompanyStr {
            components.append("\(sourceStr) -> \(trashAmount) (\(trashCompanyStr)) -> TRASH")
        }
        
        // generate logger
        if let destinationStr = self.generateTargetStr, let generateAmount = self.generateAmount, let generateCompanyStr = self.generateCompanyStr {
            components.append("GENERATE -> \(generateAmount) (\(generateCompanyStr)) -> \(destinationStr)")
        }
        
        // privates logger
        if let sourceStr = self.privateSourceStr, let destinationStr = self.privateDestinationStr, let privateStr = self.privateCompanyStr {
            components.append("\(sourceStr) -> \(privateStr) -> \(destinationStr)")
        }
        
        // loans logger
        if let sourceStr = self.loansSourceStr, let destinationStr = self.loansDestinationStr, let loansAmount = self.loansAmount {
            components.append("\(sourceStr) -> \(loansAmount) \(loansAmount == 1 ? "loan" : "loans") -> \(destinationStr)")
        }
        
        // bonds logger
        if let sourceStr = self.bondsSourceStr, let destinationStr = self.bondsDestinationStr, let bondsAmount = self.bondsAmount {
            components.append("\(sourceStr) -> \(bondsAmount) \(bondsAmount == 1 ? "bond" : "bonds") -> \(destinationStr)")
        }
        
        // line logger
        if let sourceStr = self.g1840LineSourceStr, let destinationStr = self.g1840LineDestinationStr, let lineStr = self.g1840LineLabel {
            components.append("\(sourceStr) -> \(lineStr) -> \(destinationStr)")
        }
        
        // line run logger
        if let lineBaseIndex = self.g1840LineBaseIndex, let lineStr = self.g1840LineLabel, let runAmount = self.g1840LineRunAmount, let runIndex = self.g1840LineRunIndex {
            components.append("\(lineStr) -> Run \(["a", "b", "c"][runIndex]) -> \(Int(runAmount))")
        }
        
        // market logger
        if let marketLogStr = self.marketLogStr {
            components.append(marketLogStr)
        }
        
        return tagStr + components.joined(separator: "\n")

    }
}
