//
//  CurrencyType.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 06/05/24.
//

import Foundation

enum CurrencyType: String, Codable {
    case none = "", dollar = "$", pound = "£", lira = "L.", yuan = "¥", krone = "K"
    
    func getCurrencyStringFromAmount(amount: Double, shouldTruncateDouble: Bool = true) -> String {
        let formattedAmountStr = shouldTruncateDouble ? String(Int(amount)) : String(amount)
        switch self {
        case .none:
            return formattedAmountStr
        case .dollar, .pound, .yuan, .krone:
            return formattedAmountStr + " " + self.rawValue
        case .lira:
            return self.rawValue + " " + formattedAmountStr
        }
    }
}
