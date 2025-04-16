//
//  ShareValueManager.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 09/08/24.
//

import Foundation
import UIKit

func +(lhs: ShareValueIndexPath, rhs: ShareValueIndexPath) -> ShareValueIndexPath {
    return ShareValueIndexPath(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func ==(lhs: ShareValueIndexPath, rhs: ShareValueIndexPath) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

struct ShareValueIndexPath: Codable {
    let x: Int
    let y: Int
}

extension ShareValueIndexPath: Comparable {
    static func < (lhs: ShareValueIndexPath, rhs: ShareValueIndexPath) -> Bool {
        if lhs.x != rhs.x {
            return lhs.x < rhs.x
        }
        
        return lhs.y > rhs.y
    }
}

class ShareValueManager: Codable {
    
    var sortedCmpBaseIndexesByShareValueDesc: [Int] = []
    private var currentIndexesPathsByCmpBaseIndexes: [ShareValueIndexPath?] {
        willSet {
            let fromIndexes = currentIndexesPathsByCmpBaseIndexes
            let toIndexes = newValue
            
            for i in 0..<fromIndexes.count {
                if !shareValueIndexesAreInSameLocation(firstIndex: fromIndexes[i], secondIndex: toIndexes[i]) {
                    let tmpSortedCmpBaseIndexesByShareValueDesc = toIndexes.enumerated().compactMap {
                        (first, second) -> (Int, ShareValueIndexPath)? in
                        guard let secondValue = second else {
                            return nil
                        }
                        return (first, secondValue)
                    }.sorted { !isFirstSmallerThanSecond(firstIndex: $0, secondIndex: $1, cmpBaseIdxAlwaysLast: i) }.map { $0.0 }
                    
                    var nilElements = toIndexes.enumerated().filter { $0.1 == nil && !self.cmpBaseIndexesOutsideShareValueBoard.contains($0.0) }.map { $0.0 }
                        if toIndexes[i] == nil {
                        nilElements = nilElements.filter { $0 != i }
                        nilElements.append(i)
                    }
                    
                    self.sortedCmpBaseIndexesByShareValueDesc = tmpSortedCmpBaseIndexesByShareValueDesc + nilElements + self.cmpBaseIndexesOutsideShareValueBoard
                }
            }
        }
    }
    var gamePARValues: [Int]
    var compTypesByCmpBaseIndexes: [CompanyType] = []
    var PARvaluesByCmpBaseIndexes: [Int?] = []
    var cmpBaseIndexesOutsideShareValueBoard: [Int] = []
    let shareValuesMatrix: [[Double?]]
    var distinctShareValuesSorted: [Double]
    let horizontalCellCount: Int
    let verticalCellCount: Int
    var yellowShareValueIndexPaths: [ShareValueIndexPath]
    var orangeShareValueIndexPaths: [ShareValueIndexPath]
    var brownShareValueIndexPaths: [ShareValueIndexPath]
    var openingLocations: [ShareValueIndexPath]
    var closeLocations: [ShareValueIndexPath] = []
    var temporaryIgnoreLocations: [ShareValueIndexPath] = []
    var temporaryIgnoreLocationsBackup: [ShareValueIndexPath] = []
    var gameEndLocation: ShareValueIndexPath? = nil
    var customColorsIndexPaths: [ShareValueIndexPath] = []
    var customColors: [Color] = []
    var UPcanProceedRight: Bool = false
    var RIGHTcanProceedUp: Bool = true
    var DOWNcanProceedLeft: Bool = false
    var LEFTcanProceedDown: Bool = true
    
    var g1848BoEShareValues: [Double]? = nil
    
    func shareValueIndexesAreInSameLocation(firstIndex: ShareValueIndexPath?, secondIndex: ShareValueIndexPath?) -> Bool {
        if let firstIndex = firstIndex, let secondIndex = secondIndex {
            return firstIndex == secondIndex
        }
        
        if firstIndex != nil {
            return false
        }
        
        if secondIndex != nil {
            return false
        }
        
        return true
    }
    
    private func isFirstSmallerThanSecond(firstIndex: (Int, ShareValueIndexPath), secondIndex: (Int, ShareValueIndexPath), cmpBaseIdxAlwaysLast: Int? = nil) -> Bool {
        let (firstCmpBaseIdx, firstShareValueIdx) = firstIndex
        let (secondCmpBaseIdx, secondShareValueIdx) = secondIndex
        
        if let firstShareValue = self.getShareValue(atIndexPath: firstShareValueIdx), let secondShareValue = self.getShareValue(atIndexPath: secondShareValueIdx) {
            if firstShareValue != secondShareValue {
                return firstShareValue < secondShareValue
            }
        }
        
        if shareValueIndexesAreInSameLocation(firstIndex: firstShareValueIdx, secondIndex: secondShareValueIdx) {
            if let cmpBaseIdxAlwaysLast = cmpBaseIdxAlwaysLast, cmpBaseIdxAlwaysLast == firstCmpBaseIdx {
                return true
            }
            
            if let cmpBaseIdxAlwaysLast = cmpBaseIdxAlwaysLast, cmpBaseIdxAlwaysLast == secondCmpBaseIdx {
                return false
            }
            
            if let firstIdx = self.sortedCmpBaseIndexesByShareValueDesc.firstIndex(of: firstCmpBaseIdx), let secondIdx = self.sortedCmpBaseIndexesByShareValueDesc.firstIndex(of: secondCmpBaseIdx) {
                return firstIdx > secondIdx
            }
        }
        
        return firstShareValueIdx < secondShareValueIdx
    }
    
    init(shareValuesMatrix: [[Double?]], game: Game, compTypes: [CompanyType], gamePARValues: [Int]) {
        
        self.compTypesByCmpBaseIndexes = compTypes
        self.gamePARValues = gamePARValues
        self.shareValuesMatrix = shareValuesMatrix
        self.distinctShareValuesSorted = Set([0] + self.shareValuesMatrix.flatMap({ $0.compactMap { $0 } })).sorted()
        
        switch game {
        case .g1846:
            self.UPcanProceedRight = true
            self.RIGHTcanProceedUp = false
            self.DOWNcanProceedLeft = true
            self.LEFTcanProceedDown = false
        case .g1848:
            self.g1848BoEShareValues = [70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 195, 210, 225, 240, 260, 280, 300, 320, 340]
            self.LEFTcanProceedDown = false
        case .g1830, .g1840, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            break
        }
        
        self.currentIndexesPathsByCmpBaseIndexes = Array(repeating: nil, count: compTypes.count)
        self.PARvaluesByCmpBaseIndexes = Array(repeating: nil, count: compTypes.count)
        
        let cmpBaseIndexesOnShareValueBoard = compTypes.enumerated().filter { $0.1.isShareValueTokenOnBoard() }.map { $0.0 }
        let cmpBaseIndexesOutsideShareValueBoard = compTypes.enumerated().filter { !$0.1.isShareValueTokenOnBoard() }.map { $0.0 }
        self.cmpBaseIndexesOutsideShareValueBoard = cmpBaseIndexesOutsideShareValueBoard
        
        self.sortedCmpBaseIndexesByShareValueDesc = cmpBaseIndexesOnShareValueBoard + cmpBaseIndexesOutsideShareValueBoard
        self.horizontalCellCount = self.shareValuesMatrix.count
        self.verticalCellCount = self.shareValuesMatrix.map({ $0.count }).max() ?? 1
        
        switch game {
        case .g1830:
            
            self.openingLocations = [(6, 0), (6, 1), (6, 2), (6, 3), (6, 4), (6, 5)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = [(0, 0), (0, 1), (0, 2), (1, 1), (1, 2), (1, 3), (2, 2), (2, 3), (2, 4), (3, 3), (3, 4), (3, 5), (4, 5), (4, 6), (4, 7), (5, 7), (5, 8), (6, 8), (6, 9)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.orangeShareValueIndexPaths = [(0, 3), (0, 4), (1, 4), (1, 5), (2, 5), (2, 6), (3, 6), (3, 7), (4, 8), (5, 9), (6, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.brownShareValueIndexPaths = [(0, 5), (0, 6), (0, 7), (1, 6), (1, 7), (1, 8), (2, 7), (2, 8), (2, 9), (3, 8), (3, 9), (3, 10), (4, 9), (4, 10), (5, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.closeLocations = []
            
        case .g1840:
            
            self.openingLocations = [(2, 1), (2, 2), (2, 3), (2, 4)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = []
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = []
            
            self.closeLocations = []
            
        case .g1846:
            
            self.openingLocations = [(4, 0), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0), (11, 0), (12, 0), (13, 0), (14, 0)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = []
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = []
            
            self.closeLocations = [(0, 0)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
        case .g1848:
            
            self.openingLocations = [(5, 1), (5, 2), (5, 3), (5, 4)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = []
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = []
            
            self.closeLocations = [(0, 0), (0, 1), (0, 2), (0, 3), (0, 4), (0, 5)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.gameEndLocation = ShareValueIndexPath(x: 16, y: 0)
            
        case .g1849:
            
            self.openingLocations  = [(2, 4), (5, 3), (8, 2), (11, 1)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.temporaryIgnoreLocations = [(13, 0), (13, 1), (13, 2), (14, 0), (14, 1), (14, 2), (15, 0), (15, 1), (15, 2)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.temporaryIgnoreLocationsBackup = self.temporaryIgnoreLocations
            
            self.yellowShareValueIndexPaths = []
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = []
            
            self.closeLocations = [(0, 9)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.customColorsIndexPaths = [(13, 0), (13, 1), (13, 2), (14, 0), (14, 1), (14, 2), (15, 1), (15, 2)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.customColors = Array(repeating: Color(uiColor: UIColor.fromHex("82D0C8") ?? UIColor.white), count: 8)
            
            self.gameEndLocation = ShareValueIndexPath(x: 15, y: 0)
            
        case .g1856:
            
            self.openingLocations = [(4, 0), (4, 1), (4, 2), (4, 3), (4, 4), (4, 5)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = [(0, 4), (0, 5), (1, 5), (1, 6), (2, 6), (2, 7), (3, 7), (3, 8), (4, 8), (4, 9)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = [(0, 6), (0, 7), (0, 8), (1, 7), (1, 8), (1, 9), (2, 8), (2, 9), (2, 10), (3, 9), (3, 10), (4, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.closeLocations = [(0, 9), (0, 10), (1, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
        case .g1882:
            
            self.openingLocations  = [(3, 0), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = [(0, 3), (0, 4), (0, 5), (1, 5), (1, 6), (1, 7), (2, 7), (2, 8), (3, 8), (3, 9)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.orangeShareValueIndexPaths = [(0, 6), (0, 7), (1, 8), (2, 9), (3, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.brownShareValueIndexPaths = [(0, 8), (0, 9), (0, 10), (1, 9), (1, 10), (2, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.closeLocations = []
            
        case .g1889:
            
            self.openingLocations = [(3, 0), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = [(0, 5), (0, 6), (0, 7), (1, 6), (1, 7), (1, 8), (2, 7), (2, 8), (2, 9), (3, 8), (3, 9), (3, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = [(0, 8), (0, 9), (0, 10), (1, 9), (1, 10), (2, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.closeLocations = []
            
        case .g18Chesapeake:
            
            self.openingLocations = [(2, 4), (3, 3), (4, 2)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = [(0, 5), (0, 6), (0, 7), (1, 6), (1, 7), (2, 7)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = []
            
            self.closeLocations = []
            
        case .g18MEX:
            
            self.openingLocations = [(2, 2), (3, 1), (4, 0), (4, 1), (5, 0)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            
            self.yellowShareValueIndexPaths = [(0, 4), (0, 5), (0, 6), (0, 7), (1, 5), (1, 6), (2, 5), (2, 6), (3, 5), (3, 6), (4, 5), (4, 6)].map { ShareValueIndexPath(x: $0.0, y: $0.1) }
            self.orangeShareValueIndexPaths = []
            self.brownShareValueIndexPaths = []
            
            self.closeLocations = []
            
            self.gameEndLocation = ShareValueIndexPath(x: 14, y: 0)
        }
    }
    
    func unlockAllPayoutWithoutLocations() {
        self.temporaryIgnoreLocations = []
    }
    
    func lockAllPayoutWithoutLocations() {
        self.temporaryIgnoreLocations = self.temporaryIgnoreLocationsBackup
    }
    
    func setGameEndLocation(gameEndLocation: ShareValueIndexPath) {
        self.gameEndLocation = gameEndLocation
    }
    
    func overrideCustomColors(indexes: [ShareValueIndexPath], colors: [UIColor]) {
        self.customColorsIndexPaths = indexes
        self.customColors = colors.map { Color(uiColor: $0) }
    }
    
    func getPARindex(fromShareValue shareValue: Double) -> ShareValueIndexPath? {
        for openingLocation in openingLocations {
            if self.getShareValue(atIndexPath: openingLocation) == shareValue {
                return openingLocation
            }
        }
        
        return nil
    }
    
    func setShareValueIndexPath(index: ShareValueIndexPath?, forCompanyAtBaseIndex cmpBaseIdx: Int) {
        if self.cmpBaseIndexesOutsideShareValueBoard.contains(cmpBaseIdx) {
            return
        }
        
        guard let index = index else {
            self.deleteShareValue(forCompanyAtBaseIndex: cmpBaseIdx)
            return
        }
        
        if self.PARvaluesByCmpBaseIndexes[cmpBaseIdx] == nil {
            if self.openingLocations.contains(index) {
                if let shareValue = self.getShareValue(atIndexPath: index) {
                    self.PARvaluesByCmpBaseIndexes[cmpBaseIdx] = Int(shareValue)
                }
            }
        }
        self.currentIndexesPathsByCmpBaseIndexes[cmpBaseIdx] = index
    }
    
    func getShareValueIndex(forCompanyAtBaseIndex cmpBaseIdx: Int) -> ShareValueIndexPath? {
        return self.currentIndexesPathsByCmpBaseIndexes[cmpBaseIdx]
    }
    
    func getCompanyBaseIndexesOfCompInYellowOrangeBrownZone() -> [Int] {
        var cmpBaseIndexes: [Int] = []
        
        for (i, indexPath) in self.currentIndexesPathsByCmpBaseIndexes.enumerated() {
            if let indexPath = indexPath {
                if self.yellowShareValueIndexPaths.contains(indexPath) {
                    cmpBaseIndexes.append(i)
                    continue
                }
                
                if self.orangeShareValueIndexPaths.contains(indexPath) {
                    cmpBaseIndexes.append(i)
                    continue
                }
                
                if self.brownShareValueIndexPaths.contains(indexPath) {
                    cmpBaseIndexes.append(i)
                    continue
                }
            }
        }
        
        return cmpBaseIndexes
    }
    
    func getCompanyBaseIndexesOfCompInCloseZone() -> [Int] {
        var cmpBaseIndexes: [Int] = []
        
        for (i, indexPath) in self.currentIndexesPathsByCmpBaseIndexes.enumerated() {
            if let indexPath = indexPath {
                if self.closeLocations.contains(indexPath) {
                    cmpBaseIndexes.append(i)
                }
            }
        }
        
        return cmpBaseIndexes
    }
    
    func reorderCmpBaseIndexes(sortedCmpBaseIndexes: [Int]) {
        if let firstIdx = self.sortedCmpBaseIndexesByShareValueDesc.firstIndex(where: { sortedCmpBaseIndexes.contains($0) }), let lastIdx = self.sortedCmpBaseIndexesByShareValueDesc.lastIndex(where: { sortedCmpBaseIndexes.contains($0) }) {
            if (lastIdx - firstIdx + 1) == sortedCmpBaseIndexes.count {
                for (i, cmpBaseIdx) in sortedCmpBaseIndexes.enumerated() {
                    self.sortedCmpBaseIndexesByShareValueDesc[firstIdx + i] = cmpBaseIdx
                }
            }
        }
    }
    
    func getPARvalue(forCompanyAtBaseIndex cmpBaseIdx: Int) -> Int? {
        switch self.compTypesByCmpBaseIndexes[cmpBaseIdx] {
        case .standard:
            return self.PARvaluesByCmpBaseIndexes[cmpBaseIdx]
        case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g1856CGR, .g18MEXMinor:
            return nil
        }
    }
    
    func setPARvalue(value: Int?, forCompanyAtBaseIndex cmpBaseIdx: Int) {
        switch self.compTypesByCmpBaseIndexes[cmpBaseIdx] {
        case .standard:
            self.PARvaluesByCmpBaseIndexes[cmpBaseIdx] = value
        case .g1840Stadtbahn, .g1846Miniature, .g1848BoE, .g1856CGR, .g18MEXMinor:
            break
        }
    }
    
    func getShareValue(forCompanyAtBaseIndex cmpBaseIdx: Int, BoELoans: Int? = nil) -> Double? {
        switch self.compTypesByCmpBaseIndexes[cmpBaseIdx] {
        case .standard, .g1840Stadtbahn, .g1856CGR:
            if let shareIndexPath = self.currentIndexesPathsByCmpBaseIndexes[cmpBaseIdx] {
                return self.getShareValue(atIndexPath: shareIndexPath)
            }
        case .g1848BoE:
            if let boeShareValues = self.g1848BoEShareValues, let BoELoans = BoELoans {
                return boeShareValues[20 - BoELoans]
            }
        case .g1846Miniature, .g18MEXMinor:
            return nil
        }
        
        return nil
    }
    
    func getShareValue(atIndexPath indexPath: ShareValueIndexPath) -> Double? {
        if !self.isOutOfGrid(indexPath: indexPath) {
            return self.shareValuesMatrix[indexPath.x][indexPath.y]
        }
        return nil
    }
    
    func getShareValueIndexPreview(forCompanyAtBaseIndex cmpBaseIdx: Int, withMovements movements: [ShareValueMovementType]) -> ShareValueIndexPath? {
        if let startingIndexPath = self.getShareValueIndex(forCompanyAtBaseIndex: cmpBaseIdx) {
            
            var futureIndexPath: ShareValueIndexPath = startingIndexPath
            
            for movement in movements {
                var indexPathPreview = futureIndexPath + movement.getMovementVector()
                
                if self.isOutOfGrid(indexPath: indexPathPreview) || self.temporaryIgnoreLocations.contains(indexPathPreview) {
                    switch movement {
                    case .up:
                        if self.UPcanProceedRight {
                            indexPathPreview = futureIndexPath + ShareValueMovementType.right.getMovementVector()
                        }
                    case .down:
                        if self.DOWNcanProceedLeft {
                            indexPathPreview = futureIndexPath + ShareValueMovementType.left.getMovementVector()
                        }
                    case .right:
                        if self.RIGHTcanProceedUp {
                            indexPathPreview = futureIndexPath + ShareValueMovementType.up.getMovementVector()
                        }
                    case .left:
                        if self.LEFTcanProceedDown {
                            indexPathPreview = futureIndexPath + ShareValueMovementType.down.getMovementVector()
                        }
                    }
                }
                
                if !self.isOutOfGrid(indexPath: indexPathPreview) {
                    futureIndexPath = indexPathPreview
                }
                
            }
            
            if self.compTypesByCmpBaseIndexes[cmpBaseIdx] == .g1856CGR && self.closeLocations.contains(futureIndexPath) {
                return startingIndexPath
            }
            
            return futureIndexPath
        }
        
        return nil
    }
    
    func updateShareValue(forCompanyAtBaseIndex cmpBaseIdx: Int, withMovements movements: [ShareValueMovementType]) -> Bool {
        guard self.cmpBaseIndexesOutsideShareValueBoard.contains(cmpBaseIdx) == false else { return true }
        
        if let futureIndexPath = self.getShareValueIndexPreview(forCompanyAtBaseIndex: cmpBaseIdx, withMovements: movements) {

            self.setShareValueIndexPath(index: futureIndexPath, forCompanyAtBaseIndex: cmpBaseIdx)
            return true
        }
        
        return false
    }
    
    func deleteShareValue(forCompanyAtBaseIndex cmpBaseIdx: Int) {
        self.currentIndexesPathsByCmpBaseIndexes[cmpBaseIdx] = nil
        self.PARvaluesByCmpBaseIndexes[cmpBaseIdx] = nil
    }
    
    func isOutOfGrid(indexPath: ShareValueIndexPath) -> Bool {
        if indexPath.x < self.horizontalCellCount && indexPath.x >= 0 {
            if indexPath.y < self.verticalCellCount && indexPath.y >= 0 {
                return self.shareValuesMatrix[indexPath.x][indexPath.y] == nil
            }
        }
        
        return true
    }
    
    func companyHasReachedGameEndLocation() -> Int? {
        if let gameEndLocation = self.gameEndLocation {
            for (i, index) in self.currentIndexesPathsByCmpBaseIndexes.enumerated() {
                if let index = index, index == gameEndLocation {
                    return i
                }
            }
        }
        
        return nil
    }
    
    
    // COLLECTION VIEW Rendering methods
    func getShareValueIndex(fromCollectionViewIndexPath indexPath: IndexPath) -> ShareValueIndexPath {
        let section = indexPath.row / self.verticalCellCount
        let row = indexPath.row % self.verticalCellCount
        
        return ShareValueIndexPath(x: section, y: row)
    }
    
    func getCollectionViewNumberOfItems() -> Int {
        return self.verticalCellCount * self.horizontalCellCount
    }
    
    func getShareValue(forCollectionViewIndexPath indexPath: IndexPath) -> Double? {
        
        let section = indexPath.row / self.verticalCellCount
        let row = indexPath.row % self.verticalCellCount
        
        let shareValueIndexPath = ShareValueIndexPath(x: section, y: row)
        
        if self.isOutOfGrid(indexPath: shareValueIndexPath) {
            return nil
        } else {
            return self.getShareValue(atIndexPath: shareValueIndexPath)
        }
    }
    
    func getCompanyBaseIndexes(withShareValueInIndexPath indexPath: IndexPath) -> [Int] {
        
        var indexes: [Int] = []
        
        let section = indexPath.row / self.verticalCellCount
        let row = indexPath.row % self.verticalCellCount
        
        let shareValueIndexPath: ShareValueIndexPath = ShareValueIndexPath(x: section, y: row)
        
        for (i, currentIndexPath) in self.sortedCmpBaseIndexesByShareValueDesc.map({ self.currentIndexesPathsByCmpBaseIndexes[$0] }).enumerated() {
            if let currentIndexPath = currentIndexPath, shareValueIndexPath == currentIndexPath {
                indexes.append(self.sortedCmpBaseIndexesByShareValueDesc[i])
            }
        }
        
        return indexes
    }
    
    func match(collectionViewIndexPath indexPath: IndexPath, withShareIndexOfCompanyBaseIndex cmpBaseIdx: Int) -> Bool {
        
        let section = indexPath.row / self.verticalCellCount
        let row = indexPath.row % self.verticalCellCount
        
        let shareValueIndexPath = ShareValueIndexPath(x: section, y: row)
        
        if self.isOutOfGrid(indexPath: shareValueIndexPath) {
            return false
        }
        
        if let shareValueIdx = self.getShareValueIndex(forCompanyAtBaseIndex: cmpBaseIdx) {
            return shareValueIndexPath == shareValueIdx
        }
        
        return false
    }
    
    func updateLocation(forCompanyAtBaseIndex cmpBaseIdx: Int, withCollectionViewIndexIndexPath indexPath: IndexPath) -> Bool {
        let section = indexPath.row / self.verticalCellCount
        let row = indexPath.row % self.verticalCellCount
        
        let shareValueIndexPath = ShareValueIndexPath(x: section, y: row)
        
        if !self.isOutOfGrid(indexPath: shareValueIndexPath) {
            self.setShareValueIndexPath(index: shareValueIndexPath, forCompanyAtBaseIndex: cmpBaseIdx)
            return true
        }
        
        return false
    }
    
    func getBackgroundColorForCell(atCollectionViewIndexPath indexPath: IndexPath) -> UIColor? {
        let section = indexPath.row / self.verticalCellCount
        let row = indexPath.row % self.verticalCellCount
        
        let shareValueIndexPath = ShareValueIndexPath(x: section, y: row)
        
        if let firstIdx = self.customColorsIndexPaths.firstIndex(where: { $0 == shareValueIndexPath }) {
            return self.customColors[firstIdx].uiColor
        } else if self.closeLocations.contains(where: { $0 == shareValueIndexPath }) {
            return UIColor.tertiaryAccentColor
        } else if self.openingLocations.contains(where: { $0 == shareValueIndexPath }) {
            return UIColor.fromHex("F5D9D8") ?? UIColor.black
        } else if self.yellowShareValueIndexPaths.contains(where: { $0 == shareValueIndexPath }) {
            return UIColor.fromHex("FEECA6") ?? UIColor.black
        } else if self.orangeShareValueIndexPaths.contains(where: { $0 == shareValueIndexPath }) {
            return UIColor.fromHex("EEC97E") ?? UIColor.black
        } else if self.brownShareValueIndexPaths.contains(where: { $0 == shareValueIndexPath }) {
            return UIColor.fromHex("AF8E7D") ?? UIColor.black
        } else if let gameEndLocation = self.gameEndLocation, gameEndLocation == shareValueIndexPath {
            return UIColor.primaryAccentColor.withAlphaComponent(0.6)
        }
        
        return nil
        
    }
    
    func getTextColorForCell(atCollectionViewIndexPath indexPath: IndexPath) -> UIColor {
        let section = indexPath.row / self.verticalCellCount
        let row = indexPath.row % self.verticalCellCount
        
        let shareValueIndexPath = ShareValueIndexPath(x: section, y: row)
        
        if self.closeLocations.contains(where: { $0 == shareValueIndexPath }) {
            return UIColor.white
        }
        
        return UIColor.black
    }
    
}
