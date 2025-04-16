//
//  G1846SetupViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 26/03/25.
//

import UIKit

class G1846SetupViewController: UIViewController {
    
    var gameState: GameState!
    var game: Game!
    var turnOrderType: PlayerTurnOrderType!
    var players: [String]!
    
    var squarePrivatesBaseIndexes: [Int] = [4, 5, 6, 7]
    var roundPrivatesBaseIndexes: [Int] = [0, 1, 2, 3]
    var diamondCompaniesBaseIndexes: [Int] = [1, 2, 6]
    
    var excludedSquarePrivatesFlags: [Bool] = []
    var excludedRoundPrivatesFlags: [Bool] = []
    var excludedDiamondPrivatesFlags: [Bool] = []
    
    var squarePrivatesToBeExcluded: Int = 0
    var roundPrivatesToBeExcluded: Int = 0
    var diamondCompaniesToBeExcluded: Int = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var excludePrivatesLabel: UILabel!
    @IBOutlet weak var squarePrivatesCollectionView: UICollectionView!
    @IBOutlet weak var roundPrivatesCollectionView: UICollectionView!
    @IBOutlet weak var excludeCompaniesLabel: UILabel!
    @IBOutlet weak var diamondCompaniesCollectionView: UICollectionView!
    @IBOutlet weak var randomizeExcludedCompaniesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.excludedSquarePrivatesFlags = Array(repeating: false, count: 4)
        self.excludedRoundPrivatesFlags = Array(repeating: false, count: 4)
        self.excludedDiamondPrivatesFlags = Array(repeating: false, count: 3)
        
        switch players.count {
        case 5:
            (self.squarePrivatesToBeExcluded, self.roundPrivatesToBeExcluded, self.diamondCompaniesToBeExcluded) = (1, 1, 0)
        case 4:
            (self.squarePrivatesToBeExcluded, self.roundPrivatesToBeExcluded, self.diamondCompaniesToBeExcluded) = (2, 2, 1)
        case 3:
            (self.squarePrivatesToBeExcluded, self.roundPrivatesToBeExcluded, self.diamondCompaniesToBeExcluded) = (3, 3, 2)
        default:
            (self.squarePrivatesToBeExcluded, self.roundPrivatesToBeExcluded, self.diamondCompaniesToBeExcluded) = (0, 0, 0)
        }

        self.excludePrivatesLabel.text = "Exclude \(self.squarePrivatesToBeExcluded) [private], \(self.roundPrivatesToBeExcluded) (private):"
        
        self.squarePrivatesCollectionView.tag = 0
        self.squarePrivatesCollectionView.dataSource = self
        self.squarePrivatesCollectionView.delegate = self
        
        self.roundPrivatesCollectionView.tag = 1
        self.roundPrivatesCollectionView.dataSource = self
        self.roundPrivatesCollectionView.delegate = self
        
        self.randomizePrivatesSelectionButtonPressed(sender: UIButton())
        
        if self.diamondCompaniesToBeExcluded == 0 {
            self.excludeCompaniesLabel.isHidden = true
            self.diamondCompaniesCollectionView.isHidden = true
            self.randomizeExcludedCompaniesButton.isHidden = true
        } else {
            self.excludeCompaniesLabel.text = "Exclude \(self.diamondCompaniesToBeExcluded) <company>:"
            
            self.diamondCompaniesCollectionView.tag = 2
            self.diamondCompaniesCollectionView.dataSource = self
            self.diamondCompaniesCollectionView.delegate = self
            
            self.randomizeCompaniesSelectionButtonPressed(sender: UIButton())
        }
        
    }
    
    @IBAction func randomizePrivatesSelectionButtonPressed(sender: UIButton) {
        let squarePrivatesRandomIndexes = (0..<self.excludedSquarePrivatesFlags.count).shuffled()[0..<self.squarePrivatesToBeExcluded]
        let roundPrivatesRandomIndexes = (0..<self.excludedRoundPrivatesFlags.count).shuffled()[0..<self.roundPrivatesToBeExcluded]
        
        for i in 0..<self.excludedSquarePrivatesFlags.count {
            self.excludedSquarePrivatesFlags[i] = squarePrivatesRandomIndexes.contains(i)
        }
        
        for j in 0..<self.excludedRoundPrivatesFlags.count {
            self.excludedRoundPrivatesFlags[j] = roundPrivatesRandomIndexes.contains(j)
        }
            
        self.squarePrivatesCollectionView.reloadData()
        self.roundPrivatesCollectionView.reloadData()
    }
    
    @IBAction func randomizeCompaniesSelectionButtonPressed(sender: UIButton) {
        let diamondCompaniesRandomIndexes = (0..<self.excludedDiamondPrivatesFlags.count).shuffled()[0..<self.diamondCompaniesToBeExcluded]
        
        for i in 0..<self.excludedDiamondPrivatesFlags.count {
            self.excludedDiamondPrivatesFlags[i] = diamondCompaniesRandomIndexes.contains(i)
        }
            
        self.diamondCompaniesCollectionView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        
        if self.excludedSquarePrivatesFlags.count(where: { $0 }) != self.squarePrivatesToBeExcluded {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "In a \(self.players.count)p game you must exclude \(self.squarePrivatesToBeExcluded) square private companies from play")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if self.excludedRoundPrivatesFlags.count(where: { $0 }) != self.roundPrivatesToBeExcluded {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "In a \(self.players.count)p game you must exclude \(self.roundPrivatesToBeExcluded) round private companies from play")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if self.excludedDiamondPrivatesFlags.count(where: { $0 }) != self.diamondCompaniesToBeExcluded {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "In a \(self.players.count)p game you must exclude \(self.diamondCompaniesToBeExcluded) diamond companies from play")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        let gameMetadata = self.game.getMetadata()
        
        let squarePrivatesBaseIndexesToBeRemoved = self.excludedSquarePrivatesFlags.enumerated().filter { $0.1 }.map { self.squarePrivatesBaseIndexes[$0.0] }
        let roundPrivatesBaseIndexesToBeRemoved = self.excludedRoundPrivatesFlags.enumerated().filter { $0.1 }.map { self.roundPrivatesBaseIndexes[$0.0] }
        let privatesBaseIndexesToBeRemoved = squarePrivatesBaseIndexesToBeRemoved + roundPrivatesBaseIndexesToBeRemoved
        
        let companiesBaseIndexesToBeRemoved = self.excludedDiamondPrivatesFlags.enumerated().filter { $0.1 }.map { self.diamondCompaniesBaseIndexes[$0.0] }
        
        var overrideMetadata: [String: Any] = [String: Any]()
        overrideMetadata["companies"] = (gameMetadata["companies"] as! [String]).enumerated().filter { !companiesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["floatModifiers"] = (gameMetadata["floatModifiers"] as! [Int]).enumerated().filter { !companiesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["companiesTypes"] = (gameMetadata["companiesTypes"] as! [CompanyType]).enumerated().filter { !companiesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["compTotShares"] = (gameMetadata["compTotShares"] as! [Double]).enumerated().filter { !companiesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["compLogos"] = (gameMetadata["compLogos"] as! [String]).enumerated().filter { !companiesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["compColors"] = (gameMetadata["compColors"] as! [UIColor]).enumerated().filter { !companiesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["compTextColors"] = (gameMetadata["compTextColors"] as! [UIColor]).enumerated().filter { !companiesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        
        overrideMetadata["privatesLabels"] = (gameMetadata["privatesLabels"] as! [String]).enumerated().filter { !privatesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["privatesPrices"] = (gameMetadata["privatesPrices"] as! [Double]).enumerated().filter { !privatesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["privatesIncomes"] = (gameMetadata["privatesIncomes"] as! [Double]).enumerated().filter { !privatesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["privatesMayBeBuyInFlags"] = (gameMetadata["privatesMayBeBuyInFlags"] as! [Bool]).enumerated().filter { !privatesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["privatesDescriptions"] = (gameMetadata["privatesDescriptions"] as! [String]).enumerated().filter { !privatesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["privatesOwnerGlobalIndexes"] = (gameMetadata["privatesOwnerGlobalIndexes"] as! [Int]).enumerated().filter { !privatesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        overrideMetadata["privatesMayBeVoluntarilyClosedFlags"] = (gameMetadata["privatesMayBeVoluntarilyClosedFlags"] as! [Bool]).enumerated().filter { !privatesBaseIndexesToBeRemoved.contains($0.0) }.map { $0.1 }
        
        let gameState = GameState(game: self.game, turnOrderType: self.turnOrderType, players: self.players, customOverrides: overrideMetadata)
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
        nextVC.gameState = gameState
        
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }

}

extension G1846SetupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.squarePrivatesBaseIndexes.count
        } else if collectionView.tag == 1 {
            return self.roundPrivatesBaseIndexes.count
        } else {
            return self.diamondCompaniesBaseIndexes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "g1846SquarePrivateCollectionViewCell", for: indexPath) as! G1846SquarePrivateCollectionViewCell
            cell.backgroundColor = UIColor.secondaryAccentColor
            
            cell.parentVC = self
            cell.indexPathRow = self.squarePrivatesBaseIndexes[indexPath.row]
            
            if self.excludedSquarePrivatesFlags[indexPath.row] {
                cell.accessoryView.backgroundColor = UIColor.redAccentColor.withAlphaComponent(0.75)
            } else {
                cell.accessoryView.backgroundColor = UIColor.systemGray6
            }
            
            cell.accessoryView.layer.cornerRadius = 8.0
            cell.accessoryView.clipsToBounds = true
            cell.accessoryView.layer.borderColor = UIColor.primaryAccentColor.cgColor
            cell.accessoryView.layer.borderWidth = 2.0
            
            cell.privateLabel.text = "\(self.gameState.privatesLabels[self.squarePrivatesBaseIndexes[indexPath.row]])"
            cell.privateLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            
            cell.priceLabel.text = "$ \(Int(self.gameState.privatesPrices[self.squarePrivatesBaseIndexes[indexPath.row]]))"
            cell.priceLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            
            cell.incomeLabel.text = "Income $ \(Int(self.gameState.privatesIncomes[self.squarePrivatesBaseIndexes[indexPath.row]]))"
            cell.incomeLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            
            return cell
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "g1846RoundPrivateCollectionViewCell", for: indexPath) as! G1846RoundPrivateCollectionViewCell
            cell.backgroundColor = UIColor.secondaryAccentColor
            
            cell.parentVC = self
            cell.indexPathRow = self.roundPrivatesBaseIndexes[indexPath.row]
            
            if self.excludedRoundPrivatesFlags[indexPath.row] {
                cell.accessoryView.backgroundColor = UIColor.redAccentColor.withAlphaComponent(0.75)
            } else {
                cell.accessoryView.backgroundColor = UIColor.systemGray6
            }
            
            cell.accessoryView.layer.cornerRadius = 8.0
            cell.accessoryView.clipsToBounds = true
            cell.accessoryView.layer.borderColor = UIColor.primaryAccentColor.cgColor
            cell.accessoryView.layer.borderWidth = 2.0
            
            cell.privateLabel.text = "\(self.gameState.privatesLabels[self.roundPrivatesBaseIndexes[indexPath.row]])"
            cell.privateLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            
            cell.priceLabel.text = "$ \(Int(self.gameState.privatesPrices[self.roundPrivatesBaseIndexes[indexPath.row]]))"
            cell.priceLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            
            cell.incomeLabel.text = "Income $ \(Int(self.gameState.privatesIncomes[self.roundPrivatesBaseIndexes[indexPath.row]]))"
            cell.incomeLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "g1846DiamondCompanyCollectionViewCell", for: indexPath) as! G1846DiamondCompanyCollectionViewCell
            
            if self.excludedDiamondPrivatesFlags[indexPath.row] {
                cell.contentView.backgroundColor = UIColor.redAccentColor.withAlphaComponent(0.75)
            } else {
                cell.contentView.backgroundColor = UIColor.systemGray6
            }
            
            if let whiteLogo = self.gameState.getCompanyWhiteLogo(atBaseIndex: self.diamondCompaniesBaseIndexes[indexPath.row]) {
                cell.companyImageView.image = whiteLogo
            } else {
                cell.companyImageView.image = self.gameState.getCompanyLogo(atBaseIndex: self.diamondCompaniesBaseIndexes[indexPath.row])
            }
            
            return cell
        }
    }
    
    func showPrivateDetails(forPrivateAtBaseIndex privateBaseIdx: Int) {
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customTextViewAlertViewController") as! CustomTextViewAlertViewController
        alert.setup(withTitle: "\(self.gameState.privatesLabels[privateBaseIdx])", andMessage: self.gameState.privatesDescriptions[privateBaseIdx])
        alert.addConfirmAction(withLabel: "OK")
        
        alert.preferredContentSize = CGSize(width: 440, height: 400)
        
        self.present(alert, animated: true)
        return
    }
    
}

extension G1846SetupViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            self.excludedSquarePrivatesFlags[indexPath.row] = !self.excludedSquarePrivatesFlags[indexPath.row]
        } else if collectionView.tag == 1 {
            self.excludedRoundPrivatesFlags[indexPath.row] = !self.excludedRoundPrivatesFlags[indexPath.row]
        } else {
            self.excludedDiamondPrivatesFlags[indexPath.row] = !self.excludedDiamondPrivatesFlags[indexPath.row]
        }
            
        collectionView.reloadData()
    }
}

extension G1846SetupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return collectionView.getSizeForGrid(withRows: 1, andCols: CGFloat(self.squarePrivatesBaseIndexes.count), andIndexPath: indexPath, isVerticalFlow: true)
        } else if collectionView.tag == 1 {
            return collectionView.getSizeForGrid(withRows: 1, andCols: CGFloat(self.roundPrivatesBaseIndexes.count), andIndexPath: indexPath, isVerticalFlow: true)
        } else {
            return collectionView.getSizeForGrid(withRows: 1, andCols: CGFloat(self.diamondCompaniesBaseIndexes.count), andIndexPath: indexPath, isVerticalFlow: true)
        }
    }
}


