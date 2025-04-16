//
//  SharesViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 16/01/23.
//

import UIKit

class SharesViewController: UIViewController {
    
    var gameState: GameState!
    var shareholderGlobalIndexes: [Int] = []
    var filteredCompanyIndex: Int? = nil
    var sharesAmounts: [[Double]] = []
    var companyLabels: [[String]] = []
    var companyImages: [[UIImage]] = []
    var companyColors: [[UIColor]] = []
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sharesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.primaryAccentColor
        
        self.cancelButton.setTitle(withText: "Cancel", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.cancelButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.cancelButton.layer.borderColor = UIColor.white.cgColor
        self.cancelButton.layer.borderWidth = 2
        self.cancelButton.layer.cornerRadius = 8
        self.cancelButton.clipsToBounds = true
        
        for shareholderGlobalIndex in self.shareholderGlobalIndexes {
            let sharesPortfolio = self.gameState.shares[shareholderGlobalIndex]
            
            var sharesAmounts: [Double] = []
            var companyLabels: [String] = []
            var companyImages: [UIImage] = []
            var companyColors: [UIColor] = []
            
            if let filteredCompanyIndex = self.filteredCompanyIndex {
                let filteredCompanyBaseIdx = self.gameState.forceConvert(index: filteredCompanyIndex, backwards: true, withIndexType: .companies)
                
                sharesAmounts.append(sharesPortfolio[filteredCompanyBaseIdx])
                companyLabels.append(self.gameState.getCompanyLabel(atBaseIndex: filteredCompanyBaseIdx))
                companyImages.append(self.gameState.getCompanyLogo(atBaseIndex: filteredCompanyBaseIdx))
                companyColors.append(self.gameState.getCompanyColor(atBaseIndex: filteredCompanyBaseIdx))
            } else {
                for (cmpBaseIdx, sharesAmount) in sharesPortfolio.enumerated() {
                    if sharesAmount == 0 { continue }
                    sharesAmounts.append(sharesAmount)
                    companyLabels.append(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx))
                    companyImages.append(self.gameState.getCompanyLogo(atBaseIndex: cmpBaseIdx))
                    companyColors.append(self.gameState.getCompanyColor(atBaseIndex: cmpBaseIdx))
                }
                
                let sortOrder = sharesAmounts.enumerated().sorted { $0.1 >= $1.1 }.map { $0.0 }
                sharesAmounts = Array(0..<sharesAmounts.count).map { sharesAmounts[sortOrder[$0]] }
                companyLabels = Array(0..<companyLabels.count).map { companyLabels[sortOrder[$0]] }
                companyImages = Array(0..<companyImages.count).map { companyImages[sortOrder[$0]] }
                companyColors = Array(0..<companyColors.count).map { companyColors[sortOrder[$0]] }
            }
            
            self.sharesAmounts.append(sharesAmounts)
            self.companyLabels.append(companyLabels)
            self.companyImages.append(companyImages)
            self.companyColors.append(companyColors)
        }
        
        if let filteredCompanyIndex = self.filteredCompanyIndex {
            self.titleLabel.text = self.gameState.labels[filteredCompanyIndex]
        } else {
            self.titleLabel.text = self.gameState.labels[self.shareholderGlobalIndexes[0]]
            
            if self.shareholderGlobalIndexes.count == 1 && self.gameState.getPlayerIndexes().contains(self.shareholderGlobalIndexes[0]) {
                for (privateBaseIdx, privateOwnerGlobalIdx) in self.gameState.privatesOwnerGlobalIndexes.enumerated() {
                    if privateOwnerGlobalIdx == self.shareholderGlobalIndexes[0] {
                        self.sharesAmounts[0].append(1.0)
                        self.companyLabels[0].append("\(self.gameState.privatesLabels[privateBaseIdx])")
                        self.companyImages[0].append(UIImage(named: "P\(privateBaseIdx + 1)") ?? UIImage())
                        self.companyColors[0].append(UIColor.tertiaryAccentColor)
                    }
                }
            }
        }
        
        self.sharesCollectionView.delegate = self
        self.sharesCollectionView.dataSource = self
        self.sharesCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        self.sharesCollectionView.backgroundColor = UIColor.secondaryAccentColor
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }

}

extension SharesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.shareholderGlobalIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sharesAmounts[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sharesCell", for: indexPath) as! ShareCollectionViewCell
        cell.backView.layer.cornerRadius = 10.0
        cell.backView.clipsToBounds = true
        cell.companyLabel.text = self.companyLabels[indexPath.section][indexPath.row]
        cell.companyLabel.textColor = UIColor.black
        cell.compImageView.image = self.companyImages[indexPath.section][indexPath.row]
        cell.compImageBackgroundView.backgroundColor = self.companyColors[indexPath.section][indexPath.row]
        cell.compImageBackgroundView.clipsToBounds = true
        cell.compImageBackgroundView.layer.cornerRadius = 25.0
        cell.compAccessoryView.backgroundColor = self.companyColors[indexPath.section][indexPath.row]
        let sharesAmount = self.sharesAmounts[indexPath.section][indexPath.row]
        cell.companyAmountLabel.text = "\(sharesAmount.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(sharesAmount)) : String(sharesAmount)) \("shares")"
        return cell
    }

}

extension SharesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
             sectionHeader.label.text = self.gameState.labels[self.shareholderGlobalIndexes[indexPath.section]]
             return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
}

extension SharesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cols = 3.0
        let rows = ceil(Double(self.sharesAmounts[indexPath.section].count) / cols)
        
        return CGSize(width: collectionView.getWidthForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: true), height: 180)
    }
    
}

class SectionHeader: UICollectionReusableView {
     var label: UILabel = {
         let label: UILabel = UILabel()
         label.textColor = .black
         label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
         label.sizeToFit()
         return label
     }()

     override init(frame: CGRect) {
         super.init(frame: frame)

         addSubview(label)

         label.translatesAutoresizingMaskIntoConstraints = false
         label.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
         label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
         label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
