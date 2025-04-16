//
//  ShareStartingLocation.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation

enum ShareStartingLocation: Codable {
    case bank, ipo, aside, tradeIn, company
    
    func getBankIndex() -> Int? {
        switch self {
        case .bank:
            return BankIndex.bank.rawValue
        case .ipo:
            return BankIndex.ipo.rawValue
        case .aside:
            return BankIndex.aside.rawValue
        case .tradeIn:
            return BankIndex.tradeIn.rawValue
        case .company:
            return nil
        }
    }
}
