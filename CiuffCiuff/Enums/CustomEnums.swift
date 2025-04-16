//
//  CustomEnums.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/10/24.
//

import Foundation

enum G1856CompanyStatus: Int, Codable {
    case incrementalCapitalizationCapped = 0, incrementalCapitalization, fullCapitalization
    
    func getDescriptionLabel() -> String {
        switch self {
        case .incrementalCapitalizationCapped:
            return "partial cap (max 5)"
        case .incrementalCapitalization:
            return "partial cap"
        case .fullCapitalization:
            return "full cap"
        }
    }
    
    static func getStatusFromDescriptionLabel(label: String) -> Self {
        if label == "partial cap (max 5)" {
            return .incrementalCapitalizationCapped
        } else if label == "partial cap" {
            return .incrementalCapitalization
        } else {
            return .fullCapitalization
        }
    }
}
