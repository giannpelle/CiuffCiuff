//
//  CompanyType.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 20/04/24.
//

import Foundation

enum CompanyType: Int, Codable {
    case standard = 0, g1840Stadtbahn, g1846Miniature, g1848BoE, g1856CGR, g18MEXMinor
    
    func isShareValueTokenOnBoard() -> Bool {
        switch self {
        case .standard, .g1840Stadtbahn, .g1856CGR:
            return true
        case .g1846Miniature, .g1848BoE, .g18MEXMinor:
            return false
        }
    }
    
    func shareValueCanBumpDrop() -> Bool {
        switch self {
        case .standard, .g1856CGR:
            return true
        case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g18MEXMinor:
            return false
        }
    }
    
    func hasProprietaryTreasury() -> Bool {
        switch self {
        case .standard, .g1846Miniature, .g1856CGR, .g18MEXMinor:
            return true
        case .g1840Stadtbahn, .g1848BoE:
            return false
        }
    }
    
    func canBeFloatedByPlayers() -> Bool {
        switch self {
        case .standard:
            return true
        case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g1856CGR, .g18MEXMinor:
            return false
        }
    }
    
    func canSellTrains() -> Bool {
        switch self {
        case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g18MEXMinor:
            return false
        case .g1856CGR, .standard:
            return true
        }
    }
    
    func areSharesPurchasebleByPlayers() -> Bool {
        switch self {
        case .g1846Miniature, .g18MEXMinor:
            return false
        case .g1840Stadtbahn, .g1848BoE, .g1856CGR, .standard:
            return true
        }
    }
    
    func canSellOutEverything() -> Bool {
        switch self {
        case .g1840Stadtbahn, .g1848BoE:
            return true
        case .g1846Miniature, .g1856CGR, .g18MEXMinor, .standard:
            return false
        }
    }
    
    func canBuyPrivateCompany() -> Bool {
        switch self {
        case .g1856CGR, .standard:
            return true
        case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g18MEXMinor:
            return false
        }
    }
    
    func shouldOperateBeforePublicCompanies() -> Bool {
        switch self {
        case .g1856CGR, .standard:
            return false
        case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g18MEXMinor:
            return true
        }
    }
    
    func getCustomizedActionMenuTypes(fromLegalActions legalActions: [Int]) -> [Int] {
        switch self {
        case .g1840Stadtbahn, .g1848BoE:
            return [ActionMenuType.operate.rawValue]
        case .g1846Miniature:
            return legalActions.filter { $0 != ActionMenuType.buyPrivate.rawValue && $0 != ActionMenuType.buyTrain.rawValue }
        case .g18MEXMinor:
            return legalActions.filter { $0 != ActionMenuType.buyPrivate.rawValue && $0 != ActionMenuType.buyTrain.rawValue && $0 != ActionMenuType.mail.rawValue }
        case .g1856CGR, .standard:
            return legalActions
        }
    }
}
