//
//  G1830SetupViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 19/07/24.
//

import UIKit

class G1830SetupViewController: UIViewController {
    
    var gameState: GameState!
    var game: Game!
    var turnOrderType: PlayerTurnOrderType!
    var players: [String]!
    
    var activePrivates: [Int] = [0, 2, 5, 6, 8, 9]
    var activeCompanies: [Int] = [0, 1, 2, 3, 4, 7, 8, 10]
    let bankSizeValues: [Double] = [12000, 9000, 6000]
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var bankSizeSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var privatesCollectionView: UICollectionView!
    @IBOutlet weak var companiesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.bankSizeSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.bankSizeSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.bankSizeSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.bankSizeSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)

        self.privatesCollectionView.tag = 0
        self.privatesCollectionView.dataSource = self
        self.privatesCollectionView.delegate = self
        
        self.companiesCollectionView.tag = 1
        self.companiesCollectionView.dataSource = self
        self.companiesCollectionView.delegate = self
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        
        if self.activeCompanies.count < 5 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Please select at least 5 companies in order to proceed")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        let gameMetadata = self.game.getMetadata()
        
        self.activeCompanies.sort()
        self.activePrivates.sort()
        
        var overrideMetadata: [String: Any] = [String: Any]()
        overrideMetadata["totalBankAmount"] = [self.bankSizeValues[self.bankSizeSegmentedControl.selectedSegmentIndex]]
        overrideMetadata["companies"] = self.activeCompanies.map { (gameMetadata["companies"] as! [String])[$0] }
        overrideMetadata["floatModifiers"] = self.activeCompanies.map { (gameMetadata["floatModifiers"] as! [Int])[$0] }
        overrideMetadata["companiesTypes"] = self.activeCompanies.map { (gameMetadata["companiesTypes"] as! [CompanyType])[$0] }
        overrideMetadata["compTotShares"] = self.activeCompanies.map { (gameMetadata["compTotShares"] as! [Double])[$0] }
        overrideMetadata["compLogos"] = self.activeCompanies.map { (gameMetadata["compLogos"] as! [String])[$0] }
        overrideMetadata["compColors"] = self.activeCompanies.map { (gameMetadata["compColors"] as! [UIColor])[$0] }
        overrideMetadata["compTextColors"] = self.activeCompanies.map { (gameMetadata["compTextColors"] as! [UIColor])[$0] }
        
        overrideMetadata["privatesLabels"] = self.activePrivates.map { (gameMetadata["privatesLabels"] as! [String])[$0] }
        overrideMetadata["privatesPrices"] = self.activePrivates.map { (gameMetadata["privatesPrices"] as! [Double])[$0] }
        overrideMetadata["privatesIncomes"] = self.activePrivates.map { (gameMetadata["privatesIncomes"] as! [Double])[$0] }
        overrideMetadata["privatesMayBeBuyInFlags"] = self.activePrivates.map { (gameMetadata["privatesMayBeBuyInFlags"] as! [Bool])[$0] }
        overrideMetadata["privatesDescriptions"] = self.activePrivates.map { (gameMetadata["privatesDescriptions"] as! [String])[$0] }
        overrideMetadata["privatesOwnerGlobalIndexes"] = self.activePrivates.map { (gameMetadata["privatesOwnerGlobalIndexes"] as! [Int])[$0] }
        overrideMetadata["privatesMayBeVoluntarilyClosedFlags"] = self.activePrivates.map { (gameMetadata["privatesMayBeVoluntarilyClosedFlags"] as! [Bool])[$0] }
        
        let gameState = GameState(game: self.game, turnOrderType: self.turnOrderType, players: self.players, customOverrides: overrideMetadata)
        
        if self.activePrivates.isEmpty {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            nextVC.gameState = gameState
            
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
        } else {
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
            nextVC.gameState = gameState
            
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
        }
    }

}

extension G1830SetupViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.gameState.privatesPrices.count
        } else {
            return self.gameState.companiesSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "setupPrivateCellId", for: indexPath) as! SetupPrivateCollectionViewCell
            cell.backgroundColor = UIColor.secondaryAccentColor
            cell.privateLabel.text = "\(self.gameState.privatesLabels[indexPath.row]): \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.privatesPrices[indexPath.row]))"
            
            cell.privateLabel.layer.cornerRadius = 12.0
            cell.privateLabel.clipsToBounds = true
            
            if self.activePrivates.contains(indexPath.row) {
                cell.privateLabel.textColor = UIColor.white
                cell.privateLabel.backgroundColor = UIColor.primaryAccentColor
                cell.privateLabel.layer.borderWidth = 0.0
            } else {
                cell.privateLabel.textColor = UIColor.primaryAccentColor
                cell.privateLabel.backgroundColor = UIColor.secondaryAccentColor
                cell.privateLabel.layer.borderColor = UIColor.primaryAccentColor.cgColor
                cell.privateLabel.layer.borderWidth = 3.0
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "setupCompanyCellId", for: indexPath) as! SetupCompanyCollectionViewCell
            let height = UIScreen.main.bounds.size.height > 900 ? 80.0 : 60.0
            cell.companyImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
            
            if !self.activeCompanies.contains(indexPath.row), let whiteLogo = self.gameState.getCompanyWhiteLogo(atBaseIndex: indexPath.row) {
                cell.companyImageView.image = whiteLogo
            } else {
                cell.companyImageView.image = self.gameState.getCompanyLogo(atBaseIndex: indexPath.row)
            }
            
            cell.backgroundColor = self.activeCompanies.contains(indexPath.row) ? self.gameState.getCompanyColor(atBaseIndex: indexPath.row) : UIColor.secondaryAccentColor
            return cell
        }
    }
    
}

extension G1830SetupViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if let index = self.activePrivates.firstIndex(where: { $0 == indexPath.row }) {
                self.activePrivates.remove(at: index)
            } else {
                self.activePrivates.append(indexPath.row)
            }
        } else {
            if let index = self.activeCompanies.firstIndex(where: { $0 == indexPath.row }) {
                self.activeCompanies.remove(at: index)
            } else {
                self.activeCompanies.append(indexPath.row)
            }
        }
        
        collectionView.reloadData()
    }
}

extension G1830SetupViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            if self.gameState.privatesPrices.count > 10 {
                let rows = 3.0
                let cols = ceil(CGFloat(self.gameState.privatesPrices.count) / rows)
                
                return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true)
            } else {
                let rows = 2.0
                let cols = ceil(CGFloat(self.gameState.privatesPrices.count) / rows)
                
                return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true)
            }
        } else {
            if self.gameState.companiesSize > 10 {
                let rows = 3.0
                let cols = ceil(CGFloat(self.gameState.companiesSize) / rows)
                
                return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true)
            } else {
                let rows = 2.0
                let cols = ceil(CGFloat(self.gameState.companiesSize) / rows)
                
                return collectionView.getSizeForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true)
            }
        }
    }
}


