//
//  StringExtensions.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 12/01/24.
//

import Foundation

extension String {
    /// Localized string for key.
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
