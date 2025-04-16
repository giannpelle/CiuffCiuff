//
//  G1830SetupViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 19/07/24.
//

import UIKit

class G1840SetupViewController: UIViewController {
    
    var gameState: GameState!
    var game: Game!
    var turnOrderType: PlayerTurnOrderType!
    var players: [String]!
    
    var tramCompaniesBaseIndexes: [Int] = []
    var activeCompanies: [Int] = []
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var companiesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.selectLabel.text = "Select \(self.gameState.playersSize) companies (one per player):"
        
        self.tramCompaniesBaseIndexes = Array(0..<self.gameState.companiesSize - 4)
        
        self.companiesCollectionView.tag = 0
        self.companiesCollectionView.dataSource = self
        self.companiesCollectionView.delegate = self
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        
        if self.activeCompanies.count != self.players.count {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Please select exactly \(self.players.count) companies to proceed")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        let gameMetadata = self.game.getMetadata()
        
        self.activeCompanies.sort()
        
        let stadtbahnCompanyIndexes = self.players.count <= 3 ? [6, 7, 9] : [6, 7, 8, 9]
        self.activeCompanies += stadtbahnCompanyIndexes
        
        var overrideMetadata: [String: Any] = [String: Any]()
        overrideMetadata["companies"] = self.activeCompanies.map { (gameMetadata["companies"] as! [String])[$0] }
        overrideMetadata["floatModifiers"] = self.activeCompanies.map { (gameMetadata["floatModifiers"] as! [Int])[$0] }
        overrideMetadata["companiesTypes"] = self.activeCompanies.map { (gameMetadata["companiesTypes"] as! [CompanyType])[$0] }
        overrideMetadata["compTotShares"] = self.activeCompanies.map { (gameMetadata["compTotShares"] as! [Double])[$0] }
        overrideMetadata["compLogos"] = self.activeCompanies.map { (gameMetadata["compLogos"] as! [String])[$0] }
        overrideMetadata["compColors"] = self.activeCompanies.map { (gameMetadata["compColors"] as! [UIColor])[$0] }
        overrideMetadata["compTextColors"] = self.activeCompanies.map { (gameMetadata["compTextColors"] as! [UIColor])[$0] }
        
        if self.players.count == 3 {
            
            let praterPrivateBaseIndex = 0
            
            overrideMetadata["privatesLabels"] = (gameMetadata["privatesLabels"] as! [String]).enumerated().filter { $0.0 != praterPrivateBaseIndex }.map { $0.1 } as [String]
            overrideMetadata["privatesPrices"] = (gameMetadata["privatesPrices"] as! [Double]).enumerated().filter { $0.0 != praterPrivateBaseIndex }.map { $0.1 } as [Double]
            overrideMetadata["privatesIncomes"] = (gameMetadata["privatesIncomes"] as! [Double]).enumerated().filter { $0.0 != praterPrivateBaseIndex }.map { $0.1 } as [Double]
            overrideMetadata["privatesMayBeBuyInFlags"] = (gameMetadata["privatesMayBeBuyInFlags"] as! [Bool]).enumerated().filter { $0.0 != praterPrivateBaseIndex }.map { $0.1 } as [Bool]
            overrideMetadata["privatesDescriptions"] = (gameMetadata["privatesDescriptions"] as! [String]).enumerated().filter { $0.0 != praterPrivateBaseIndex }.map { $0.1 } as [String]
            overrideMetadata["privatesOwnerGlobalIndexes"] = (gameMetadata["privatesOwnerGlobalIndexes"] as! [Int]).enumerated().filter { $0.0 != praterPrivateBaseIndex }.map { $0.1 } as [Int]
            overrideMetadata["privatesMayBeVoluntarilyClosedFlags"] = (gameMetadata["privatesMayBeVoluntarilyClosedFlags"] as! [Bool]).enumerated().filter { $0.0 != praterPrivateBaseIndex }.map { $0.1 } as [Bool]
            
        } else if players.count == 2 {
            
            let praterPrivateBaseIndex = 0
            let schonbrunnerPrivateBaseIndex = 5
            
            overrideMetadata["privatesLabels"] = (gameMetadata["privatesLabels"] as! [String]).enumerated().filter { $0.0 != praterPrivateBaseIndex && $0.0 != schonbrunnerPrivateBaseIndex }.map { $0.1 } as [String]
            overrideMetadata["privatesPrices"] = (gameMetadata["privatesPrices"] as! [Double]).enumerated().filter { $0.0 != praterPrivateBaseIndex && $0.0 != schonbrunnerPrivateBaseIndex }.map { $0.1 } as [Double]
            overrideMetadata["privatesIncomes"] = (gameMetadata["privatesIncomes"] as! [Double]).enumerated().filter { $0.0 != praterPrivateBaseIndex && $0.0 != schonbrunnerPrivateBaseIndex }.map { $0.1 } as [Double]
            overrideMetadata["privatesMayBeBuyInFlags"] = (gameMetadata["privatesMayBeBuyInFlags"] as! [Bool]).enumerated().filter { $0.0 != praterPrivateBaseIndex && $0.0 != schonbrunnerPrivateBaseIndex }.map { $0.1 } as [Bool]
            overrideMetadata["privatesDescriptions"] = (gameMetadata["privatesDescriptions"] as! [String]).enumerated().filter { $0.0 != praterPrivateBaseIndex && $0.0 != schonbrunnerPrivateBaseIndex }.map { $0.1 } as [String]
            overrideMetadata["privatesOwnerGlobalIndexes"] = (gameMetadata["privatesOwnerGlobalIndexes"] as! [Int]).enumerated().filter { $0.0 != praterPrivateBaseIndex && $0.0 != schonbrunnerPrivateBaseIndex }.map { $0.1 } as [Int]
            overrideMetadata["privatesMayBeVoluntarilyClosedFlags"] = (gameMetadata["privatesMayBeVoluntarilyClosedFlags"] as! [Bool]).enumerated().filter { $0.0 != praterPrivateBaseIndex && $0.0 != schonbrunnerPrivateBaseIndex }.map { $0.1 } as [Bool]
            
        }
        
        let gameState = GameState(game: self.game, turnOrderType: self.turnOrderType, players: self.players, customOverrides: overrideMetadata)
        
        if players.count >= 4 {
            gameState.g1840LinesLabels = Array(1...18).map { "Line \($0)" }
            gameState.g1840LinesOwnerGlobalIndexes = Array(repeating: 0, count: 18)
            gameState.g1840LinesRevenue = Array(repeating: Array(repeating: 0, count: 3), count: 18)
        } else if players.count == 3 {
            gameState.g1840LinesLabels = (Array(1...8) + [11, 12, 15, 18]).map { "Line \($0)" }
            gameState.g1840LinesOwnerGlobalIndexes = Array(repeating: 0, count: 12)
            gameState.g1840LinesRevenue = Array(repeating: Array(repeating: 0, count: 3), count: 12)
        } else {
            gameState.g1840LinesLabels = (Array(1...7) + [15, 18]).map { "Line \($0)" }
            gameState.g1840LinesOwnerGlobalIndexes = Array(repeating: 0, count: 9)
            gameState.g1840LinesRevenue = Array(repeating: Array(repeating: 0, count: 3), count: 9)
        }
        
        var customOps: [Operation] = []
        
        let DcmpBaseIdx = gameState.getBaseIndex(forEntity: "D")
        let dOp = Operation(type: .float)
        dOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.forceConvert(index: DcmpBaseIdx, backwards: false, withIndexType: .companies), amount: 0)
        dOp.addMarketDetails(marketShareValueCmpBaseIndex: DcmpBaseIdx, marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: 1, y: 1), marketLogStr: "D: PAR 65")
        customOps.append(dOp)
        
        gameState.lastCompPayoutValues[DcmpBaseIdx] = 70
        
        let GcmpBaseIdx = gameState.getBaseIndex(forEntity: "G")
        let gOp = Operation(type: .float)
        gOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.forceConvert(index: GcmpBaseIdx, backwards: false, withIndexType: .companies), amount: 0)
        gOp.addMarketDetails(marketShareValueCmpBaseIndex: GcmpBaseIdx, marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: 1, y: 2), marketLogStr: "G: PAR 75")
        customOps.append(gOp)
        
        let VcmpBaseIdx = gameState.getBaseIndex(forEntity: "V")
        let vOp = Operation(type: .float)
        vOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.forceConvert(index: VcmpBaseIdx, backwards: false, withIndexType: .companies), amount: 0)
        vOp.addMarketDetails(marketShareValueCmpBaseIndex: VcmpBaseIdx, marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: 1, y: 3), marketLogStr: "V: PAR 85")
        customOps.append(vOp)
        
        gameState.lastCompPayoutValues[VcmpBaseIdx] = 70
        
        let WcmpBaseIdx = gameState.getBaseIndex(forEntity: "W")
        let wOp = Operation(type: .float)
        wOp.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: gameState.forceConvert(index: WcmpBaseIdx, backwards: false, withIndexType: .companies), amount: 0)
        wOp.addMarketDetails(marketShareValueCmpBaseIndex: WcmpBaseIdx, marketShareValueFromIndex: nil, marketShareValueToIndex: ShareValueIndexPath(x: 1, y: 4), marketLogStr: "W: PAR 95")
        customOps.append(wOp)
        
        
        if gameState.areOperationsLegit(operations: customOps, reverted: false) {
            for op in customOps {
                _ = gameState.perform(operation: op, reverted: false)
            }
        }
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
        nextVC.gameState = gameState
        
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }

}

extension G1840SetupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tramCompaniesBaseIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "setupCompanyCellId", for: indexPath) as! SetupCompanyCollectionViewCell
        
        if !self.activeCompanies.contains(indexPath.row), let whiteLogo = self.gameState.getCompanyWhiteLogo(atBaseIndex: indexPath.row) {
            cell.companyImageView.image = whiteLogo
        } else {
            cell.companyImageView.image = self.gameState.getCompanyLogo(atBaseIndex: indexPath.row)
        }
        
        cell.backgroundColor = self.activeCompanies.contains(indexPath.row) ? self.gameState.getCompanyColor(atBaseIndex: indexPath.row) : UIColor.secondaryAccentColor
        return cell
    }
    
}

extension G1840SetupViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = self.activeCompanies.firstIndex(where: { $0 == indexPath.row }) {
            self.activeCompanies.remove(at: index)
        } else {
            self.activeCompanies.append(indexPath.row)
        }
        
        collectionView.reloadData()
    }
}

extension G1840SetupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let rows = 2.0
        let cols = ceil(CGFloat(self.tramCompaniesBaseIndexes.count) / rows)
        
        return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true)
    }
}


