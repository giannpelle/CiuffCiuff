//
//  ActionMenuType.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 06/03/24.
//

import Foundation

enum ActionMenuType: Int, Codable {
    case buyPrivate = 0, sellPrivate = 1, buyTrain = 2, tilesTokens = 3, buyShares = 4, sellShares = 5, operate = 7, acquire = 9, tradePrivate = 10, mail = 11, g18MEXCloseMinors = 12, g18MEXMerge = 13, loans = 15, g1849Bond = 16, turnOrder = 17, g1840LinesRun = 18, float = 19, g1846issueShares = 20, g1846redeemShares = 21, close = 99
    
    func shouldHideCommitButton() -> Bool {
        switch self {
        case .buyShares, .sellShares, .g1849Bond, .loans, .close, .g1846issueShares, .g1846redeemShares:
            return true
        case .buyPrivate, .sellPrivate, .buyTrain, .tilesTokens, .operate, .acquire, .tradePrivate, .mail, .g18MEXCloseMinors, .g18MEXMerge, .turnOrder, .float, .g1840LinesRun:
            return false
        }
    }
}
