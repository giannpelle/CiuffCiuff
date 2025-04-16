//
//  PayoutRoundPolicy.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/03/24.
//

import Foundation

enum PayoutRoundPolicy: Int, Codable {
    case doNotRound = 0, roundUp, roundDown
}
