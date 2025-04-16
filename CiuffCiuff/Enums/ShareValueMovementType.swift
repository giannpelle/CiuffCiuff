//
//  ShareValueMovementType.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 09/08/24.
//

import Foundation

enum ShareValueMovementType: String, Codable {
    case up = "UP", right = "RIGHT", down = "DOWN", left = "LEFT"
    
    func getMovementVector() -> ShareValueIndexPath {
        switch self {
        case .up:
            return ShareValueIndexPath(x: 0, y: -1)
        case .right:
            return ShareValueIndexPath(x: 1, y: 0)
        case .down:
            return ShareValueIndexPath(x: 0, y: 1)
        case .left:
            return ShareValueIndexPath(x: -1, y: 0)
        }
    }
}
