//
//  PlayerTurnOrderType.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 25/12/24.
//

import Foundation

enum PlayerTurnOrderType: Int, Codable {
    case gameSpecific = 0, passOrder, classic, mostCashAmount
}
