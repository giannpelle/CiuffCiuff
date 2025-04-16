//
//  RoundTrackViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 23/12/24.
//

import UIKit

enum CallToSwitchType {
    case moveLEFT
}

class RoundTrackViewController: UIViewController {
    
    @IBOutlet weak var topBarBackgroundView: UIView!
    @IBOutlet weak var scrollMainView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var endOfStockRoundLabel: UILabel!
    @IBOutlet weak var endOfOperatingRoundLabel: UILabel!
    @IBOutlet weak var newOperatingRoundLabel: UILabel!
    @IBOutlet weak var newStockRoundLabel: UILabel!

    @IBOutlet weak var endOfStockRoundStackView: UIStackView!
    @IBOutlet weak var endOfOperatingRoundStackView: UIStackView!
    @IBOutlet weak var newOperatingRoundStackView: UIStackView!
    @IBOutlet weak var newStockRoundStackView: UIStackView!
    
    @IBOutlet weak var bumpCompaniesStackView: UIStackView!
    @IBOutlet weak var dropCompaniesStackView: UIStackView!
    
    @IBOutlet weak var bumpCompaniesCollectionView: UICollectionView!
    @IBOutlet weak var dropCompaniesCollectionView: UICollectionView!
    @IBOutlet weak var insolventCompaniesCollectionView: UICollectionView!
    
    @IBOutlet weak var bumpCompaniesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bumpCompaniesCollectionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropCompaniesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropCompaniesCollectionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var insolventCompaniesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var gameState: GameState!
    var isEndOfStockRound: Bool = false
    var isEndOfOperatingRound: Bool = false
    var isNewOperatingRound: Bool = false
    var isNewStockRound: Bool = false
    var parentVC: HomeViewController!
    var roundOperationTypePressed: OperationType!
    
    var bumpCompaniesBaseIndexes: [Int] = []
    var dropCompaniesBaseIndexes: [Int] = []
    
    var callToActionDescriptions: [String] = []
    var callToActionCompanyActionMenuTuples: [(Int, Int)] = []
    
    var callToSwitchDescriptions: [String] = []
    var callToSwitchTypes: [CallToSwitchType] = []
    var callToSwitchCmpBaseIndexes: [Int] = []
    var callToSwitchStates: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollMainView.backgroundColor = UIColor.secondaryAccentColor
        
        self.topBarBackgroundView.backgroundColor = UIColor.primaryAccentColor
        
        self.endOfStockRoundLabel.backgroundColor = UIColor.primaryAccentColor
        self.endOfOperatingRoundLabel.backgroundColor = UIColor.primaryAccentColor
        self.newOperatingRoundLabel.backgroundColor = UIColor.primaryAccentColor
        self.newStockRoundLabel.backgroundColor = UIColor.primaryAccentColor
        
        self.cancelButton.setTitle(withText: "Cancel", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.cancelButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.doneButton.setTitle(withText: "Done", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.doneButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.cancelButton.layer.borderColor = UIColor.white.cgColor
        self.cancelButton.layer.borderWidth = 2
        self.cancelButton.layer.cornerRadius = 8
        self.cancelButton.clipsToBounds = true
        
        self.doneButton.layer.cornerRadius = 8
        self.doneButton.clipsToBounds = true
        
        if self.isEndOfOperatingRound {
            self.callToSwitchStates = Array(repeating: false, count: self.callToSwitchDescriptions.count)
        }
        
        let atLeastOneBump = !self.bumpCompaniesBaseIndexes.isEmpty
        let atLeastOneDrop = !self.dropCompaniesBaseIndexes.isEmpty
        
        if self.isEndOfStockRound && (atLeastOneBump || atLeastOneDrop) {
            self.endOfStockRoundStackView.isHidden = false
            
            if atLeastOneBump {
                self.bumpCompaniesStackView.isHidden = false
                
                self.bumpCompaniesCollectionView.dataSource = self
                self.bumpCompaniesCollectionView.delegate = self
                self.bumpCompaniesCollectionView.backgroundColor = UIColor.secondaryAccentColor
                
                self.bumpCompaniesCollectionViewHeightConstraint.constant = (Double(self.bumpCompaniesBaseIndexes.count) / 4.0).rounded(.up) * 50
                self.bumpCompaniesCollectionViewWidthConstraint.constant = CGFloat(self.bumpCompaniesBaseIndexes.count) * 120.0
            } else {
                self.bumpCompaniesStackView.isHidden = true
            }
            
            if atLeastOneDrop {
                self.dropCompaniesStackView.isHidden = false
                
                self.dropCompaniesCollectionView.dataSource = self
                self.dropCompaniesCollectionView.delegate = self
                self.dropCompaniesCollectionView.backgroundColor = UIColor.secondaryAccentColor
                
                self.dropCompaniesCollectionViewHeightConstraint.constant = (Double(self.dropCompaniesBaseIndexes.count) / 4.0).rounded(.up) * 50
                self.dropCompaniesCollectionViewWidthConstraint.constant = CGFloat(self.dropCompaniesBaseIndexes.count) * 120.0
            } else {
                self.dropCompaniesStackView.isHidden = true
            }
            
        } else {
            self.endOfStockRoundStackView.isHidden = true
        }
        
        if self.isEndOfOperatingRound && (!self.callToActionDescriptions.isEmpty || !self.callToSwitchDescriptions.isEmpty) {
            self.endOfOperatingRoundStackView.isHidden = false
            
            self.insolventCompaniesCollectionView.dataSource = self
            self.insolventCompaniesCollectionView.delegate = self
            self.insolventCompaniesCollectionView.backgroundColor = UIColor.clear
            
            self.insolventCompaniesCollectionViewHeightConstraint.constant = CGFloat(self.callToActionDescriptions.count + self.callToSwitchDescriptions.count) * 60.0
            
        } else {
            self.endOfOperatingRoundStackView.isHidden = true
        }
        
        if self.isNewOperatingRound {
            self.newOperatingRoundStackView.isHidden = true
            
        } else {
            self.newOperatingRoundStackView.isHidden = true
        }
        
        if self.isNewStockRound {
            self.newStockRoundStackView.isHidden = true
        } else {
            self.newStockRoundStackView.isHidden = true
        }
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
        
        var snackBarMessage: String? = nil
        
        if self.isEndOfStockRound {
            for bumpCmpBaseIdx in bumpCompaniesBaseIndexes {
                if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: bumpCmpBaseIdx, andMovements: [.up]) {
                    if self.gameState.isOperationLegit(operation: marketOp, reverted: false) {
                        _ = self.gameState.perform(operation: marketOp)
                    }
                }
            }
            
            for dropCmpBaseIndex in dropCompaniesBaseIndexes {
                if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: dropCmpBaseIndex, andMovements: [.down]) {
                    if self.gameState.isOperationLegit(operation: marketOp, reverted: false) {
                        _ = self.gameState.perform(operation: marketOp)
                    }
                }
            }
        }
        
        if self.isEndOfOperatingRound {
            for i in 0..<self.callToSwitchDescriptions.count {
                switch self.callToSwitchTypes[i] {
                case .moveLEFT:
                    if self.callToSwitchStates[i] {
                        if let marketOp = self.gameState.getShareValueMarketOperation(forCompanyAtBaseIndex: self.callToSwitchCmpBaseIndexes[i], andMovements: [.left]) {
                            if self.gameState.isOperationLegit(operation: marketOp, reverted: false) {
                                _ = self.gameState.perform(operation: marketOp)
                            }
                        }
                    }
                }
            }
        }
        
        self.parentVC.completeRoundTrackValueChanged(withRoundOperationType: self.roundOperationTypePressed, isEndOfOperatingRound: self.isEndOfOperatingRound, isEndOfStockRound: self.isEndOfStockRound, shouldPresentSnackBarMessageWithText: snackBarMessage)
        
    }
    
}

extension RoundTrackViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 2 {
            return 2
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.bumpCompaniesBaseIndexes.count
        } else if collectionView.tag == 1 {
            return self.dropCompaniesBaseIndexes.count
        } else if collectionView.tag == 2 {
            if section == 0 {
                return self.callToActionDescriptions.count
            } else {
                return self.callToSwitchDescriptions.count
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bumpCompanyCollectionViewCell", for: indexPath) as! BumpCompanyCollectionViewCell
            cell.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: self.bumpCompaniesBaseIndexes[indexPath.row])
            cell.companyLabel.textColor = self.gameState.getCompanyTextColor(atIndex: self.bumpCompaniesBaseIndexes[indexPath.row])
            cell.companyLabel.text = self.gameState.getCompanyLabel(atBaseIndex: self.bumpCompaniesBaseIndexes[indexPath.row])
            
            return cell
            
        } else if collectionView.tag == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dropCompanyCollectionViewCell", for: indexPath) as! DropCompanyCollectionViewCell
            cell.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: self.dropCompaniesBaseIndexes[indexPath.row])
            cell.companyLabel.textColor = self.gameState.getCompanyTextColor(atIndex: self.dropCompaniesBaseIndexes[indexPath.row])
            cell.companyLabel.text = self.gameState.getCompanyLabel(atBaseIndex: self.dropCompaniesBaseIndexes[indexPath.row])
            
            return cell
            
        } else if collectionView.tag == 2 {
            
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "insolventCompanyButtonCollectionViewCell", for: indexPath) as! InsolventCompanyButtonCollectionViewCell
                cell.contentView.backgroundColor = UIColor.secondaryAccentColor
                cell.parentVC = self
                cell.tag = indexPath.row
                
                cell.descriptionLabel.text = self.callToActionDescriptions[indexPath.row]
                cell.doItNowButton.tag = indexPath.row
                cell.doItNowButton.setTitle(withText: "Resolve", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
                cell.doItNowButton.setBackgroundColor(UIColor.primaryAccentColor)

                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "insolventCompanySwitchCollectionViewCell", for: indexPath) as! InsolventCompanySwitchCollectionViewCell
                cell.contentView.backgroundColor = UIColor.secondaryAccentColor
                cell.parentVC = self
                cell.tag = indexPath.row
                
                cell.descriptionLabel.text = self.callToSwitchDescriptions[indexPath.row]
                cell.insolvenceSwitch.isOn = false
                
                return cell
            }
            
        }
        
        return UICollectionViewCell()
    }
    
    func didTapDoItNowButton(withTag tag: Int) {
        self.dismiss(animated: true)
        
        let (companyIndex, actionMenuTypeIndex) = self.callToActionCompanyActionMenuTuples[tag]
        
        if self.gameState.game == .g1849 && actionMenuTypeIndex == ActionMenuType.loans.rawValue {
            if Company1849BondViewController.payBondInterests(forCompanyAtIndex: companyIndex, andGameState: self.gameState) {
                self.callToSwitchDescriptions.remove(at: tag)
                self.callToActionCompanyActionMenuTuples.remove(at: tag)
                self.insolventCompaniesCollectionView.reloadData()

                HomeViewController.presentSnackBar(withMessage: "\(self.gameState.getCompanyLabel(atIndex: companyIndex)) paid \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 50.0)) in interests")
                return
            }
        }
        
        if self.gameState.game == .g1856 && actionMenuTypeIndex == ActionMenuType.loans.rawValue {
            if let interestsAmountPaid = Company1856LoansViewController.payInterests(forCompanyAtIndex: companyIndex, andGameState: self.gameState) {
                self.callToSwitchDescriptions.remove(at: tag)
                self.callToActionCompanyActionMenuTuples.remove(at: tag)
                self.insolventCompaniesCollectionView.reloadData()
                
                HomeViewController.presentSnackBar(withMessage: "\(self.gameState.getCompanyLabel(atIndex: companyIndex)) paid \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: interestsAmountPaid)) in interests")
                return
            }
        }
        
        self.parentVC.loadAndPresentOpManagerVC(withOperatingCompanyIndex: companyIndex, andActionMenuIndex: actionMenuTypeIndex)
    }
    
}

extension RoundTrackViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            //return collectionView.getSizeForGrid(withRows: (Double(self.bumpCompaniesBaseIndexes.count) / 4.0).rounded(.up), andCols: 4.0, andIndexPath: indexPath, isVerticalFlow: true)
            return CGSize(width: 120.0, height: 50.0)
        } else if collectionView.tag == 1 {
            //return collectionView.getSizeForGrid(withRows: (Double(self.dropCompaniesBaseIndexes.count) / 4.0).rounded(.up), andCols: 4.0, andIndexPath: indexPath, isVerticalFlow: true)
            return CGSize(width: 120.0, height: 50.0)
        } else if collectionView.tag == 2 {
            return CGSize(width: collectionView.bounds.size.width, height: 60.0)
        }
        
        return CGSize()
        
    }
}
