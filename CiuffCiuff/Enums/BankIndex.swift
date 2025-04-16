//
//  BankIndex.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation

enum BankIndex: Int, Codable {
    case bank = 0, ipo, aside, tradeIn
    
    static func getBankSize() -> Int {
        return 4
    }
    
    static func getBankLabels() -> [String] {
        return ["Bank", "IPO", "Aside", "Trade-in"]
    }
}
