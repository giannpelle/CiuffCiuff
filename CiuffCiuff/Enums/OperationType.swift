//
//  OperationType.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation

enum OperationType: String, Codable {
    case cash, income, payout, withhold, privates, trains, sell, sellEmergency = "Emergency sell", buy, tokens, float, acquisition, close, trash, generate, brownOR, greenOR, yellowOR, SR, mail, g18MEXcloseMinors = "MINORS", setup, line, g1840Shortfall = "Shortfall", loan, bond, interests, g1882NWR = "NWR", g1882Bridge = "Bridge", g18MEXmerge = "MERGE", market, sellPrivate = "Sell private", buyPrivate = "Buy private", g1840SR1, g1840CR1, g1840LR1a, g1840LR1b, g1840CR2, g1840SR2, g1840LR2a, g1840LR2b, g1840CR3, g1840SR3, g1840LR3a, g1840LR3b, g1840CR4, g1840SR4, g1840LR4a, g1840LR4b, g1840CR5, g1840SR5, g1840LR5a, g1840LR5b, g1840LR5c, g1840CR6, g1840LineRun = "Line run"
    
    func canBeUndo() -> Bool {
        switch self {
        case .close, .acquisition, .g18MEXcloseMinors, .setup, .g18MEXmerge:
            return false
        case .cash, .income, .payout, .withhold, .privates, .trains, .sell, .sellEmergency, .buy, .tokens, .float, .trash, .generate, .brownOR, .greenOR, .yellowOR, .SR, .mail, .line, .g1840Shortfall, .loan, .bond, .interests, .g1882NWR, .g1882Bridge, .market, .sellPrivate, .buyPrivate, .g1840SR1, .g1840CR1, .g1840LR1a, .g1840LR1b, .g1840CR2, .g1840SR2, .g1840LR2a, .g1840LR2b, .g1840CR3, .g1840SR3, .g1840LR3a, .g1840LR3b, .g1840CR4, .g1840SR4, .g1840LR4a, .g1840LR4b, .g1840CR5, .g1840SR5, .g1840LR5a, .g1840LR5b, .g1840LR5c, .g1840CR6, .g1840LineRun:
            return true
        }
    }
    
    func getRoundTrackLabel() -> String {
        switch self {
        case .SR, .g1840SR1, .g1840SR2, .g1840SR3, .g1840SR4, .g1840SR5:
            return "SR"
        case .yellowOR, .greenOR, .brownOR:
            return "OR"
        case .g1840CR1, .g1840CR2, .g1840CR3, .g1840CR4, .g1840CR5, .g1840CR6:
            return "CR"
        case .g1840LR1a, .g1840LR2a, .g1840LR3a, .g1840LR4a, .g1840LR5a, .g1840LR1b, .g1840LR2b, .g1840LR3b, .g1840LR4b, .g1840LR5b, .g1840LR5c:
            return "LR"
        case .acquisition, .close, .g18MEXcloseMinors, .setup, .g18MEXmerge, .cash, .income, .payout, .withhold, .privates, .trains, .sell, .sellEmergency, .buy, .tokens, .float, .trash, .generate, .mail, .g1840Shortfall, .g1882NWR, .g1882Bridge, .market, .line, .loan, .bond, .interests, .sellPrivate, .buyPrivate, .g1840LineRun:
            return ""
        }
    }
    
    static func getSROperationTypes() -> [OperationType] {
        return [.SR, .g1840SR1, .g1840SR2, .g1840SR3, .g1840SR4, .g1840SR5]
    }
    
    static func getOROperationTypes() -> [OperationType] {
        return [.brownOR, .greenOR, .yellowOR]
    }
    
    static func getRoundTypeOperationsWhenPrivatesPayout() -> [OperationType] {
        return [.brownOR, .greenOR, .yellowOR, .g1840CR1, .g1840CR2, .g1840CR3, .g1840CR4, .g1840CR5, .g1840CR6]
    }
}
