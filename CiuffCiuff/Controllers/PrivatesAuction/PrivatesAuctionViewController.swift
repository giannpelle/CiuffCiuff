//
//  PrivatesAuctionViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 07/07/24.
//

import UIKit

class PrivatesAuctionViewController: UIViewController {
    
    var gameState: GameState!
    var userSelectedCompany: String? = nil
    
    static let temporaryPlayerColors: [UIColor] = [UIColor.fromHex("8D99AE")!, UIColor.fromHex("8AC926")!, UIColor.fromHex("FF924C")!, UIColor.fromHex("FF5DB6")!, UIColor.fromHex("1982C4")!, UIColor.fromHex("9C6644")!]
    
    //[UIColor.fromHex("E40303")!, UIColor.fromHex("FF8C00")!, UIColor.fromHex("FFED00")!, UIColor.fromHex("008026")!, UIColor.fromHex("004DFF")!, UIColor.fromHex("750787")!]
    
    var accompanyingCompaniesIndexes: [Int?] = []
    var accompanyingCompaniesMayBeRerolled: [Bool] = []
    var accompanyingCompaniesAmounts: [Int?] = []
    
    var bidsAmountsByPrivate: [[Int]] = []
    var incomeAmountsByPlayer: [Int] = []
    
    var PARindexSelected: Int = 0
    var playerIndexSelected: Int = 0
    var privateIndexSelected: Int = 0
    var bidAmountIndexSelected: Int = 0
    var lastPlayerToMakeTurnBaseIndex: Int = 0
    var lastPlayerToBuyAtFaceValueBaseIndex: Int = 0
    var privatesMayNotBePaidMoreThanFaceValue: Bool = false
    
    var isZoomedIn: Bool {
        return self.zoomInButton.isSelected
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var zoomInButton: UIButton!
    
    @IBOutlet weak var zoomedOutScrollView: UIScrollView!
    @IBOutlet weak var zoomedInView: UIView!
    
    // zoomed in income view
    @IBOutlet weak var zoomedInIncomeView: UIView!
    @IBOutlet weak var zoomedInIncomeScrollContentView: UIView!
    @IBOutlet weak var zoomedInIncomeStackView: UIStackView!
    @IBOutlet weak var zoomedInIncomePlayersLabelsStackView: UIStackView!
    @IBOutlet weak var zoomedInIncomeCashLabelsStackView: UIStackView!
    @IBOutlet weak var zoomedInIncomeBidsLabelsStackView: UIStackView!
//    @IBOutlet weak var zoomedInIncomeAmountsLabelsStackView: UIStackView!
    @IBOutlet weak var zoomedInIncomePARLabelsStackView: UIStackView!
    
    @IBOutlet weak var zoomedInIncomeAlphaBackgroundView: UIView!
    @IBOutlet weak var zoomedInPerformORStackView: UIStackView!
    @IBOutlet weak var zoomedInPerformORButton: UIButton!
    @IBOutlet weak var zoomedInResetIncomeButton: UIButton!
    //---------------------------------------------------------------------
    // zoomed out income view
    @IBOutlet weak var incomeView: UIView!
    @IBOutlet weak var incomeScrollContentView: UIView!
    @IBOutlet weak var incomeStackView: UIStackView!
    @IBOutlet weak var incomePlayersLabelsStackView: UIStackView!
    @IBOutlet weak var incomeCashLabelsStackView: UIStackView!
    @IBOutlet weak var incomeBidsLabelsStackView: UIStackView!
//    @IBOutlet weak var incomeAmountsLabelsStackView: UIStackView!
    @IBOutlet weak var incomePARLabelsStackView: UIStackView!
    
    @IBOutlet weak var incomeAlphaBackgroundView: UIView!
    @IBOutlet weak var performORStackView: UIStackView!
    @IBOutlet weak var performORButton: UIButton!
    @IBOutlet weak var resetIncomeButton: UIButton!
    
    @IBOutlet var privatesViews: [UIView]!
    @IBOutlet var privatesLabels: [UILabel]!
    @IBOutlet var privatesAccessoryLabels: [UILabel]!
    @IBOutlet var privatesDescriptionTextViews: [UITextView]!
    @IBOutlet var accompanyingShareLabels: [PaddingLabel]!
    @IBOutlet var rerollShareButtons: [UIButton]!
    @IBOutlet var bidsStackViewsByPrivateBaseIndex: [UIStackView]!
    
    @IBOutlet weak var privatesCollectionView: UICollectionView!
    @IBOutlet weak var privatesCollectionViewLeadingLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var privatesCollectionViewTrailingLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var zoomedInPrivatesCollectionView: UICollectionView!
    @IBOutlet weak var customIncomeButton: UIButton!
    
    @IBOutlet weak var privateViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstRowStackViewLeadingLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstRowStackViewTrailingLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondRowStackViewLeadingLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondRowStackViewTrailingLayoutConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.zoomedInIncomeScrollContentView.backgroundColor = UIColor.secondaryAccentColor
        self.zoomedInIncomeView.backgroundColor = UIColor.secondaryAccentColor
        //---------------------------------------------------------------------------------
        self.incomeScrollContentView.backgroundColor = UIColor.secondaryAccentColor
        self.incomeView.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.zoomInButton.setImage(UIImage(named: "zoom_out"), for: .normal)
        self.zoomInButton.setImage(UIImage(named: "zoom_in"), for: .selected)
        self.zoomInButton.tintColor = UIColor.clear
        self.zoomedOutScrollView.isHidden = false
        self.zoomedInView.isHidden = true
        self.zoomedInView.backgroundColor = UIColor.secondaryAccentColor
        
        self.zoomedInIncomeAlphaBackgroundView.isHidden = true
        self.zoomedInPerformORButton.setTitle(withText: "Perform OR", fontSize: 17.0, fontWeight: .medium, textColor: .white)
        self.zoomedInPerformORButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.zoomedInResetIncomeButton.setTitle(withText: "Reset income", fontSize: 17.0, fontWeight: .medium, textColor: .white)
        self.zoomedInResetIncomeButton.setBackgroundColor(UIColor.systemGray)
        //----------------------------------------------------------------------------------------------------------------------
        self.incomeAlphaBackgroundView.isHidden = true
        self.performORButton.setTitle(withText: "Perform OR", fontSize: 17.0, fontWeight: .medium, textColor: .white)
        self.performORButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.resetIncomeButton.setTitle(withText: "Reset income", fontSize: 17.0, fontWeight: .medium, textColor: .white)
        self.resetIncomeButton.setBackgroundColor(UIColor.systemGray)
        
        self.customIncomeButton.tag = -1
        self.customIncomeButton.setTitle(withText: "Custom income", fontSize: 18.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
        self.customIncomeButton.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.customIncomeButton.layer.borderWidth = 3
        self.customIncomeButton.addTarget(self, action: #selector(makeABidTapped(_:)), for: .touchUpInside)
        
        self.playerIndexSelected = self.gameState.playersSize - 1
        self.lastPlayerToMakeTurnBaseIndex = self.gameState.playersSize - 1
        self.lastPlayerToBuyAtFaceValueBaseIndex = self.gameState.playersSize - 1
        
        let privateViewWidth: CGFloat = UIScreen.main.bounds.size.width / CGFloat(min(3, ((Double(self.gameState.privatesPrices.count) / 2.0).rounded(.up))))
        self.privateViewWidthConstraint.constant = privateViewWidth
        
        let layoutOffset = (privateViewWidth / 2.0) + 6.0
        if (self.gameState.privatesPrices.count + 1) % 2 == 0 {
            self.privatesCollectionViewLeadingLayoutConstraint.constant = layoutOffset - 6.0
            self.privatesCollectionViewTrailingLayoutConstraint.constant = layoutOffset - 6.0
            
            self.firstRowStackViewLeadingLayoutConstraint.constant = layoutOffset
            self.firstRowStackViewTrailingLayoutConstraint.constant = 6.0
            
            self.secondRowStackViewLeadingLayoutConstraint.constant = 6.0
            self.secondRowStackViewTrailingLayoutConstraint.constant = layoutOffset
        } else {
            self.privatesCollectionViewLeadingLayoutConstraint.constant = layoutOffset - 6.0
            self.privatesCollectionViewTrailingLayoutConstraint.constant = layoutOffset - 6.0
            
            self.firstRowStackViewLeadingLayoutConstraint.constant = layoutOffset
            self.firstRowStackViewTrailingLayoutConstraint.constant = layoutOffset
            
            self.secondRowStackViewLeadingLayoutConstraint.constant = 6.0
            self.secondRowStackViewTrailingLayoutConstraint.constant = 6.0
        }
        
        self.privatesCollectionView.tag = 0
        self.privatesCollectionView.dataSource = self
        self.privatesCollectionView.delegate = self
        //-------------------------------------------
        self.zoomedInPrivatesCollectionView.tag = 1
        self.zoomedInPrivatesCollectionView.dataSource = self
        self.zoomedInPrivatesCollectionView.delegate = self
        self.zoomedInPrivatesCollectionView.backgroundColor = UIColor.secondaryAccentColor
        self.zoomedInPrivatesCollectionView.contentInset.left = 6.0
        self.zoomedInPrivatesCollectionView.contentInset.right = 6.0
        
        self.accompanyingCompaniesIndexes = Array(repeating: nil, count: self.gameState.privatesPrices.count)
        self.accompanyingCompaniesMayBeRerolled = Array(repeating: false, count: self.gameState.privatesPrices.count)
        self.accompanyingCompaniesAmounts = Array(repeating: nil, count: self.gameState.privatesPrices.count)
        
        self.bidsAmountsByPrivate = Array(repeating: Array(repeating: -5, count: self.gameState.playersSize), count: self.gameState.privatesPrices.count)
        self.incomeAmountsByPlayer = Array(repeating: 0, count: self.gameState.playersSize)
        
        switch self.gameState.game {
        case .g1830:
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 160 }) {
                if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "PRR" }) {
                    self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                    self.accompanyingCompaniesAmounts[privateIdx] = 1
                }
            }
            
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 220 }) {
                if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "B&O" }) {
                    self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                    self.accompanyingCompaniesAmounts[privateIdx] = 2
                }
            }
            
            break
            
        case .g1846:
            let minorPrivateIndexes: [Int] = Array<Int>((self.gameState.privatesPrices.count - 2)..<self.gameState.privatesPrices.count)
            let minorCmpIndexes = [self.gameState.getGlobalIndex(forEntity: "Big 4"), self.gameState.getGlobalIndex(forEntity: "MS")]
            
            for (i, minorPrivateIdx) in minorPrivateIndexes.enumerated() {
                self.accompanyingCompaniesIndexes[minorPrivateIdx] = minorCmpIndexes[i]
                self.accompanyingCompaniesAmounts[minorPrivateIdx] = 1
            }
            
        case .g1848:
            if let privateIdx = self.gameState.privatesPrices.lastIndex(where: { $0 == 140 }) {
                if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "QR" }) {
                    self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                    self.accompanyingCompaniesAmounts[privateIdx] = 1
                }
            }
            
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 200 }) {
                if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "CAR" }) {
                    self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                    self.accompanyingCompaniesAmounts[privateIdx] = 2
                    
                    if let parIndex = self.gameState.getPARindex(fromShareValue: 100) {
                        let op = Operation(type: .market)
                        op.addMarketDetails(marketShareValueCmpBaseIndex: cmpBaseIdx, marketShareValueFromIndex: nil, marketShareValueToIndex: parIndex, marketLogStr: "CAR: PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 100))")
                        
                        _ = self.gameState.perform(operation: op, reverted: false)
                    }
                }
            }
            
            break
            
        case .g1849:
            if let companyStr = self.userSelectedCompany {
                if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 150 }) {
                    if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == companyStr }) {
                        self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                        self.accompanyingCompaniesMayBeRerolled[privateIdx] = true
                        self.accompanyingCompaniesAmounts[privateIdx] = 2
                    }
                }
            }
            
            break
            
        case .g1882:
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 140 }) {
                let cmpBaseIdx = Int.random(in: 1..<self.gameState.companiesSize - 1)
                self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                self.accompanyingCompaniesMayBeRerolled[privateIdx] = true
                self.accompanyingCompaniesAmounts[privateIdx] = 1
            }
            
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 180 }) {
                if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "CPR" }) {
                    self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                    self.accompanyingCompaniesAmounts[privateIdx] = 2
                }
            }
            
            break
        case .g18Chesapeake:
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 100 }) {
                if let cmpBaseIdx = (0..<self.gameState.companiesSize).map({ self.gameState.getCompanyLabel(atBaseIndex: $0) }).firstIndex(where: { $0 == "B&O" }) {
                    self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                    self.accompanyingCompaniesAmounts[privateIdx] = 1
                }
            }
            
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 200 }) {
                let cmpBaseIdx = Int.random(in: 0..<self.gameState.companiesSize)
                self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                self.accompanyingCompaniesMayBeRerolled[privateIdx] = true
                self.accompanyingCompaniesAmounts[privateIdx] = 2
            }
            
            break
        case .g18MEX:
            let minorPrivateIndexes: [Int] = self.gameState.privatesPrices.enumerated().filter({ $0.1 == 50 }).map({ $0.0 })
            let minorCmpIndexes = [self.gameState.getGlobalIndex(forEntity: "A"), self.gameState.getGlobalIndex(forEntity: "B"), self.gameState.getGlobalIndex(forEntity: "C")]
            
            for (i, minorPrivateIdx) in minorPrivateIndexes.enumerated() {
                self.accompanyingCompaniesIndexes[minorPrivateIdx] = minorCmpIndexes[i]
                self.accompanyingCompaniesAmounts[minorPrivateIdx] = 1
            }
            
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 100 }) {
                let cmpBaseIdx = self.gameState.getBaseIndex(forEntity: "CHI")
                self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                self.accompanyingCompaniesAmounts[privateIdx] = 1
            }
            
            if let privateIdx = self.gameState.privatesPrices.firstIndex(where: { $0 == 140 }) {
                let cmpBaseIdx = self.gameState.getBaseIndex(forEntity: "NDM")
                self.accompanyingCompaniesIndexes[privateIdx] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
                self.accompanyingCompaniesAmounts[privateIdx] = 2
            }
            
            break
        case .g1840, .g1846, .g1856, .g1889:
            break
        }
        
        switch self.gameState.game {
        case .g1846, .g1848:
            self.privatesMayNotBePaidMoreThanFaceValue = true
        case .g1830, .g1840, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            self.privatesMayNotBePaidMoreThanFaceValue = false
        }
        
        if let incomePlayersLabels = self.incomePlayersLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomePlayerLabel) in incomePlayersLabels.enumerated() {
                incomePlayerLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    incomePlayerLabel.text = "\(self.gameState.getPlayerLabel(atBaseIndex: i))"
                    incomePlayerLabel.textAlignment = .left
                    incomePlayerLabel.paddingLeft = 6.0
                    incomePlayerLabel.paddingRight = 6.0
                    //                incomePlayerLabel.paddingTop = 6.0
                    //                incomePlayerLabel.paddingBottom = 6.0
                    incomePlayerLabel.backgroundColor = Self.temporaryPlayerColors[i]
                    incomePlayerLabel.textColor = UIColor.black
                    incomePlayerLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomePlayerLabel.layer.cornerRadius = 4.0
                    incomePlayerLabel.clipsToBounds = true
                } else {
                    incomePlayerLabel.isHidden = true
                }
            }
        }
        //--------------------------------------------------------------------------------------------------
        if let incomePlayersLabels = self.zoomedInIncomePlayersLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomePlayerLabel) in incomePlayersLabels.enumerated() {
                incomePlayerLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    incomePlayerLabel.text = "\(self.gameState.getPlayerLabel(atBaseIndex: i))"
                    incomePlayerLabel.textAlignment = .left
                    incomePlayerLabel.paddingLeft = 6.0
                    incomePlayerLabel.paddingRight = 6.0
                    //                incomePlayerLabel.paddingTop = 6.0
                    //                incomePlayerLabel.paddingBottom = 6.0
                    incomePlayerLabel.backgroundColor = Self.temporaryPlayerColors[i]
                    incomePlayerLabel.textColor = UIColor.black
                    incomePlayerLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomePlayerLabel.layer.cornerRadius = 4.0
                    incomePlayerLabel.clipsToBounds = true
                } else {
                    incomePlayerLabel.isHidden = true
                }
            }
        }
        
        if let incomeCashLabels = self.incomeCashLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeCashLabel) in incomeCashLabels.enumerated() {
                incomeCashLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    incomeCashLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atBaseIndex: i)))"
                    incomeCashLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomeCashLabel.paddingLeft = 6.0
                    incomeCashLabel.paddingRight = 6.0
                    //                incomeCashLabel.paddingTop = 6.0
                    //                incomeCashLabel.paddingBottom = 6.0
                } else {
                    incomeCashLabel.isHidden = true
                }
            }
        }
        //--------------------------------------------------------------------------------------------------
        if let incomeCashLabels = self.zoomedInIncomeCashLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeCashLabel) in incomeCashLabels.enumerated() {
                incomeCashLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    incomeCashLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atBaseIndex: i)))"
                    incomeCashLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomeCashLabel.paddingLeft = 6.0
                    incomeCashLabel.paddingRight = 6.0
                    //                incomeCashLabel.paddingTop = 6.0
                    //                incomeCashLabel.paddingBottom = 6.0
                } else {
                    incomeCashLabel.isHidden = true
                }
            }
        }
        
        if let incomeBidsLabels = self.incomeBidsLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeBidLabel) in incomeBidsLabels.enumerated() {
                incomeBidLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    incomeBidLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 0.0))"
                    incomeBidLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomeBidLabel.paddingLeft = 6.0
                    incomeBidLabel.paddingRight = 6.0
                    //                incomeBidLabel.paddingTop = 6.0
                    //                incomeBidLabel.paddingBottom = 6.0
                } else {
                    incomeBidLabel.isHidden = true
                }
            }
        }
        //--------------------------------------------------------------------------------------------------
        if let incomeBidsLabels = self.zoomedInIncomeBidsLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeBidLabel) in incomeBidsLabels.enumerated() {
                incomeBidLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    incomeBidLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 0.0))"
                    incomeBidLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomeBidLabel.paddingLeft = 6.0
                    incomeBidLabel.paddingRight = 6.0
                    //                incomeBidLabel.paddingTop = 6.0
                    //                incomeBidLabel.paddingBottom = 6.0
                } else {
                    incomeBidLabel.isHidden = true
                }
            }
        }
        
//        for (i, incomeAmountLabel) in self.incomeAmountsLabels.enumerated() {
//            if i < self.gameState.playersSize {
//                incomeAmountLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 0.0))"
//            } else {
//                incomeAmountLabel.isHidden = true
//            }
//        }
        //--------------------------------------------------------------------------------------------------
//        for (i, incomeAmountLabel) in self.zoomedInIncomeAmountsLabels.enumerated() {
//            if i < self.gameState.playersSize {
//                incomeAmountLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: 0.0))"
//            } else {
//                incomeAmountLabel.isHidden = true
//            }
//        }
        
        if let incomePARLabels = self.incomePARLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomePARLabel) in incomePARLabels.enumerated() {
                incomePARLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    //incomePARLabel.text = self.getPARText(forCashAmount: self.gameState.getPlayerAmount(atBaseIndex: i))
                    incomePARLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomePARLabel.paddingLeft = 6.0
                    incomePARLabel.paddingRight = 6.0
                    //                incomePARLabel.paddingTop = 6.0
                    //                incomePARLabel.paddingBottom = 6.0
                    if let maxBidAmount = self.getMaxBidAmountToFloat(forPlayerAtBaseIndex: i) {
                        incomePARLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: maxBidAmount)
                    } else {
                        incomePARLabel.text = "no way"
                    }
                } else {
                    incomePARLabel.isHidden = true
                }
            }
        }
        //--------------------------------------------------------------------------------------------------
        if let incomePARLabels = self.zoomedInIncomePARLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomePARLabel) in incomePARLabels.enumerated() {
                incomePARLabel.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
                
                if i < self.gameState.playersSize {
                    //incomePARLabel.text = self.getPARText(forCashAmount: self.gameState.getPlayerAmount(atBaseIndex: i))
                    incomePARLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
                    incomePARLabel.paddingLeft = 6.0
                    incomePARLabel.paddingRight = 6.0
                    //                incomePARLabel.paddingTop = 6.0
                    //                incomePARLabel.paddingBottom = 6.0
                    if let maxBidAmount = self.getMaxBidAmountToFloat(forPlayerAtBaseIndex: i) {
                        incomePARLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: maxBidAmount)
                    } else {
                        incomePARLabel.text = "no way"
                    }
                } else {
                    incomePARLabel.isHidden = true
                }
            }
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privateViewTapped(_:)))
        
        self.incomeView.tag = -1
        self.incomeView.isUserInteractionEnabled = true
        self.incomeView.addGestureRecognizer(tapGestureRecognizer)
        self.incomeView.layer.cornerRadius = 8
        self.incomeView.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.incomeView.layer.borderWidth = 3
        //--------------------------------------------------------------------------------------------------
        self.zoomedInIncomeView.tag = -1
        self.zoomedInIncomeView.isUserInteractionEnabled = true
        self.zoomedInIncomeView.addGestureRecognizer(tapGestureRecognizer)
        self.zoomedInIncomeView.layer.cornerRadius = 8
        self.zoomedInIncomeView.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.zoomedInIncomeView.layer.borderWidth = 3
        
        for (i, privateView) in self.privatesViews.enumerated() {
            if i < self.gameState.privatesPrices.count {
                privateView.isHidden = false
                privateView.tag = i
                privateView.layer.cornerRadius = 8
                privateView.layer.borderColor = UIColor.primaryAccentColor.cgColor
                privateView.layer.borderWidth = 3
                privateView.backgroundColor = UIColor.secondaryAccentColor
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privateViewTapped(_:)))
                privateView.isUserInteractionEnabled = true
                privateView.addGestureRecognizer(tapGestureRecognizer)
                
            } else {
                privateView.isHidden = true
            }
        }
        
        for (i, privateLabel) in self.privatesLabels.enumerated() where i < self.gameState.privatesPrices.count {
            privateLabel.text = "Private \(self.gameState.privatesLabels[i])"
        }
        
        for (i, privateAccessoryLabel) in self.privatesAccessoryLabels.enumerated() where i < self.gameState.privatesPrices.count {
            privateAccessoryLabel.text = "(\(Int(self.gameState.privatesPrices[i]))/\(Int(self.gameState.privatesIncomes[i])))"
        }
        
        for (i, privateDescriptionTextView) in self.privatesDescriptionTextViews.enumerated() where i < self.gameState.privatesPrices.count {
            privateDescriptionTextView.font = UIFont.systemFont(ofSize: 18)
            privateDescriptionTextView.text = self.gameState.privatesDescriptions[i]
            privateDescriptionTextView.tag = i
            privateDescriptionTextView.delegate = self
            privateDescriptionTextView.backgroundColor = UIColor.clear
        }
        
        for (i, accompanyingShareLabel) in self.accompanyingShareLabels.enumerated() where i < self.gameState.privatesPrices.count {
            if let cmpShareIdx = self.accompanyingCompaniesIndexes[i], let cmpShareAmount = self.accompanyingCompaniesAmounts[i] {
                accompanyingShareLabel.isHidden = false
                accompanyingShareLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
                accompanyingShareLabel.textAlignment = .center
                let totShareAmount = Double(self.gameState.getTotalShareNumberOfCompany(atIndex: cmpShareIdx))
                accompanyingShareLabel.text = "\(Int(Double(cmpShareAmount) / totShareAmount * 100.0))% \(self.gameState.getCompanyLabel(atIndex: cmpShareIdx))"
                accompanyingShareLabel.backgroundColor = self.gameState.getCompanyColor(atIndex: cmpShareIdx)
                accompanyingShareLabel.textColor = self.gameState.getCompanyTextColor(atIndex: cmpShareIdx)
                accompanyingShareLabel.clipsToBounds = true
                accompanyingShareLabel.layer.cornerRadius = 4.0
                
                accompanyingShareLabel.paddingLeft = 8.0
                accompanyingShareLabel.paddingRight = 8.0
                accompanyingShareLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            } else {
                accompanyingShareLabel.isHidden = true
            }
        }
        
        for (i, rerollShareButton) in self.rerollShareButtons.enumerated() where i < self.gameState.privatesPrices.count {
            if let _ = self.accompanyingCompaniesIndexes[i], let _ = self.accompanyingCompaniesAmounts[i] {
                rerollShareButton.isHidden = false
                
                if self.accompanyingCompaniesMayBeRerolled[i] {
                    rerollShareButton.isUserInteractionEnabled = true
                    rerollShareButton.setImage(UIImage(named: "random"), for: .normal)
                    rerollShareButton.tag = i
                    rerollShareButton.tintColor = .clear
                    rerollShareButton.addTarget(self, action: #selector(rerollButtonPressed), for: .touchUpInside)
                } else {
                    rerollShareButton.isHidden = true
                }
                
            } else {
                rerollShareButton.isHidden = true
            }
        }
     
        for (_, bidStackView) in self.bidsStackViewsByPrivateBaseIndex.enumerated() {
            bidStackView.spacing = 8.0
            
            if let bidsStackViews = bidStackView.arrangedSubviews as? [UIStackView] {
                for (_, stackView) in bidsStackViews.enumerated() {
                    stackView.spacing = 8.0
                    
                    for (_, view) in stackView.arrangedSubviews.enumerated() {
                        if let bidLabel = view as? PaddingLabel {
                            bidLabel.paddingTop = 6.0
                            bidLabel.paddingBottom = 6.0
                            bidLabel.paddingLeft = 10.0
                            bidLabel.paddingRight = 10.0
                            bidLabel.layer.cornerRadius = 6.0
                            bidLabel.clipsToBounds = true
                            bidLabel.textAlignment = .center
                            bidLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
                            bidLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
                            bidLabel.isHidden = true
                            bidLabel.isUserInteractionEnabled = true
                            
                            if !self.privatesMayNotBePaidMoreThanFaceValue {
                                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(topUpBid))
                                tapGestureRecognizer.numberOfTapsRequired = 1
                                
                                bidLabel.addGestureRecognizer(tapGestureRecognizer)
                            }
                        }
                    }
                }
            }
        }
       
    }
    
    @IBAction func zoomInButtonPressed(sender: UIButton) {
        self.zoomInButton.isSelected = !self.zoomInButton.isSelected
        
        self.zoomedOutScrollView.isHidden = self.isZoomedIn
        self.zoomedInView.isHidden = !self.isZoomedIn
    }
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        
        let descriptionStr = "@bcash:@n\nmoney in front of players\n@blocked:@n\nmoney stuck on bids\n@bmax bid to float:@n\nmaximum bid you can make to be able to float during SR\n@l\n@umoney coming from ORs/income operations are sum up with cash"
        
        let components = descriptionStr.components(separatedBy: "@")
        
        let attributedText = NSMutableAttributedString()
        
        let littleLineSpacingParagraphStyle = NSMutableParagraphStyle()
        littleLineSpacingParagraphStyle.lineSpacing = 2.5
        
        for component in components where !component.isEmpty {
            let componentStr = String(Array(component)[1...])
            
            if component.first! == "n" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .regular)]))
            } else if component.first! == "b" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .bold)]))
            } else if component.first! == "u" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .medium), NSAttributedString.Key.underlineStyle: 1]))
            } else if component.first! == "l" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 7, weight: .regular)]))
            }
        }
        
        attributedText.addAttribute(.paragraphStyle, value: littleLineSpacingParagraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "Money explanation:", andAttributedMessage: attributedText)
        alert.addConfirmAction(withLabel: "OK")
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
    }
    
    func getMaxBidAmountToFloat(forPlayerAtBaseIndex playerBaseIdx: Int) -> Double? {
        let playerLiquidity = self.getPortfolioAmountIfAuctionWouldEndNow(forPlayerAtBaseIndex: playerBaseIdx)
        let amountToFloat = Double(self.gameState.openCompanyValues[0])
        
        if playerLiquidity >= amountToFloat {
            return playerLiquidity - amountToFloat
        }
        
        return nil
    }
    
//    func getPARText(forCashAmount amount: Double) -> String {
//        var openCompanyValues: [Int] = self.gameState.openCompanyValues
//        var PARcompanyValues: [Int] = self.gameState.gamePARValues
//
//        if self.gameState.game == .g1849 {
//            openCompanyValues = [68 * 2, 68 * 3, 68 * 4, 100 * 2, 100 * 3, 100 * 4]
//            PARcompanyValues = [68, 68, 68, 100, 100, 100]
//        }
//        
//        for (i, openCompanyValue) in openCompanyValues.enumerated().sorted(by: { $0.1 > $1.1 }) {
//            let maxAmount = amount - Double(openCompanyValue)
//
//            if maxAmount >= 0 {
//                if self.gameState.game == .g1849 {
//                    return "PAR \(PARcompanyValues[i]) \((i % 3) + 2)x"
//                }
//                return "PAR \(PARcompanyValues[i])"
//            }
//        }
//        
//        return "No way"
//    }
    
    @objc func rerollButtonPressed(sender: UIButton) {
        var cmpBaseIdx = Int.random(in: 0..<self.gameState.companiesSize)
        
        if self.gameState.game == .g1882 {
            cmpBaseIdx = Int.random(in: 1..<self.gameState.companiesSize - 1)
        }
        
        self.accompanyingCompaniesIndexes[sender.tag] = self.gameState.convert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
        
        if let cmpShareIdx = self.accompanyingCompaniesIndexes[sender.tag], let cmpShareAmount = self.accompanyingCompaniesAmounts[sender.tag] {
            let totShareAmount = Double(self.gameState.getTotalShareNumberOfCompany(atIndex: cmpShareIdx))
            self.accompanyingShareLabels[sender.tag].text = "\(Int(Double(cmpShareAmount) / totShareAmount * 100.0))% \(self.gameState.getCompanyLabel(atIndex: cmpShareIdx))"
            self.accompanyingShareLabels[sender.tag].backgroundColor = self.gameState.getCompanyColor(atIndex: cmpShareIdx)
            self.accompanyingShareLabels[sender.tag].textColor = self.gameState.getCompanyTextColor(atIndex: cmpShareIdx)
        }
        
        self.zoomedInPrivatesCollectionView.reloadData()
    }
    
    @objc func topUpBid(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        
        self.playerIndexSelected = tag % 10
        self.privateIndexSelected = tag / 10
        
        if let maxBid = self.bidsAmountsByPrivate[self.privateIndexSelected].max() {
            self.makeBid(withBidAmount: maxBid + 5)
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("CiuffCiuffGameState.json")
            
            try FileManager.default.removeItem(at: fileURL)
            print("JSON file deleted")
            
        } catch {
        }
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func privateViewTapped(_ sender: UITapGestureRecognizer) {
        
        self.privateViewTapped(withTag: sender.view!.tag)
    }
    
    @IBAction func makeABidTapped(_ sender: UIButton) {
        
        self.privateViewTapped(withTag: sender.tag)
    }
    
    func privateViewTapped(withTag tag: Int) {
        
        self.privateIndexSelected = tag
        
        // handle Income
        if tag == -1 {
            
            let firstComponentElementsAttributedTexts = (0..<self.gameState.playersSize).map { self.gameState.getPlayerLabel(atBaseIndex: $0) }.map { NSAttributedString(string: $0) }
            let secondComponentElementsAttributedTexts = (["reset"] + (1...80).map { "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double($0 * 5)))" }).map { NSAttributedString(string: $0) }
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customPickerViewAlertViewController") as! CustomPickerViewAlertViewController
            alert.setup(withTitle: "Get income", andPickerElementsAttributedTextsByComponent: [firstComponentElementsAttributedTexts, secondComponentElementsAttributedTexts])
            alert.suggestInitialPickerViewIndex(hint: 1, forComponent: 1)
            alert.addCancelAction(withLabel: "Cancel")
            alert.addConfirmAction(withLabel: "OK") { selectedIndexesByComponent in
                
                if selectedIndexesByComponent.count == 2 {
                    self.playerIndexSelected = selectedIndexesByComponent[0]
                    self.bidAmountIndexSelected = selectedIndexesByComponent[1]
                    
                    self.makeIncome()
                }
            }
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
            
        // handle bid
        } else {
            let firstComponentElementsAttributedTexts = (0..<self.gameState.playersSize).map { self.gameState.getPlayerLabel(atBaseIndex: $0) }.map { NSAttributedString(string: $0) }
            var secondComponentElementsAttributedTexts: [NSAttributedString] = []
            if self.privatesMayNotBePaidMoreThanFaceValue {
                let rangeEnd = Int(self.gameState.privatesPrices[self.privateIndexSelected]) / 5
                secondComponentElementsAttributedTexts = (["reset", "free"] + (1...rangeEnd).map { "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double($0 * 5)))" }).map { NSAttributedString(string: $0) }
            } else {
                secondComponentElementsAttributedTexts = (["reset", "free"] + (1...80).map { "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double($0 * 5)))" }).map { NSAttributedString(string: $0) }
            }
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customPickerViewAlertViewController") as! CustomPickerViewAlertViewController
            alert.setup(withTitle: "Make a bid", andPickerElementsAttributedTextsByComponent: [firstComponentElementsAttributedTexts, secondComponentElementsAttributedTexts])
            
            var candidateSuggestionPlayerIdx = 0
            if self.lastPlayerToMakeTurnBaseIndex < self.gameState.playersSize - 1 {
                candidateSuggestionPlayerIdx = self.lastPlayerToMakeTurnBaseIndex + 1
            }
            
//            var isAuctionInProgress: Bool = true
//            // check if is performing auction for current private
//            for (privateBaseIdx, _) in self.bidsAmountsByPrivate.enumerated() where privateBaseIdx < self.privateIndexSelected {
//                if self.isPrivateAvailableForInstantBuy(atBaseIndex: privateBaseIdx) {
//                    isAuctionInProgress = false
//                    break
//                }
//            }
//            isAuctionInProgress = isAuctionInProgress && (self.bidsAmountsByPrivate[self.privateIndexSelected].filter { $0 != -5 }.count >= 2)
//            
//            if isAuctionInProgress {
//                let auctionerIndexes = self.bidsAmountsByPrivate[self.privateIndexSelected].enumerated().filter { $0.1 != -5 }.map { $0.0 }
//                
//                if !auctionerIndexes.contains(candidateSuggestionPlayerIdx) {
//                    candidateSuggestionPlayerIdx = auctionerIndexes.first!
//                }
//                
//                // player is already max bidder, suggest another player
//                if let maxBid = self.bidsAmountsByPrivate[self.privateIndexSelected].max(), maxBid != -5, maxBid == self.bidsAmountsByPrivate[self.privateIndexSelected][candidateSuggestionPlayerIdx] {
//                    if let nextAuctionerIdx = auctionerIndexes.firstIndex(where: { $0 == candidateSuggestionPlayerIdx }) {
//                        if (nextAuctionerIdx + 1) < self.gameState.playersSize - 1 {
//                            candidateSuggestionPlayerIdx = nextAuctionerIdx + 1
//                        } else {
//                            candidateSuggestionPlayerIdx = auctionerIndexes.first!
//                        }
//                    }
//                }
//                
//            } else {
//                // player is already max bidder, suggest another player
//                if let maxBid = self.bidsAmountsByPrivate[self.privateIndexSelected].max(), maxBid != -5, maxBid == self.bidsAmountsByPrivate[self.privateIndexSelected][candidateSuggestionPlayerIdx] {
//                    if candidateSuggestionPlayerIdx < self.gameState.playersSize - 1 {
//                        candidateSuggestionPlayerIdx += 1
//                    } else {
//                        candidateSuggestionPlayerIdx = 0
//                    }
//                }
//            }
            alert.suggestInitialPickerViewIndex(hint: candidateSuggestionPlayerIdx, forComponent: 0)
            
            var faceValueAmount = Int(self.gameState.privatesPrices[self.privateIndexSelected])
            if self.gameState.game == .g1846 {
                if self.gameState.privatesLabels[self.privateIndexSelected] == "Big 4" {
                    faceValueAmount = 100
                } else if self.gameState.privatesLabels[self.privateIndexSelected] == "MS" {
                    faceValueAmount = 140
                }
            }
            
            if self.privatesMayNotBePaidMoreThanFaceValue {
                alert.suggestInitialPickerViewIndex(hint: (faceValueAmount / 5) + 1, forComponent: 1)
            } else if let maxBid = self.bidsAmountsByPrivate[self.privateIndexSelected].max(), maxBid >= faceValueAmount {
                alert.suggestInitialPickerViewIndex(hint: (maxBid / 5) + 2, forComponent: 1)
            } else if self.isPrivateAvailableForInstantBuy(atBaseIndex: self.privateIndexSelected) {
                alert.suggestInitialPickerViewIndex(hint: (faceValueAmount / 5) + 1, forComponent: 1)
            } else {
                alert.suggestInitialPickerViewIndex(hint: (faceValueAmount / 5) + 2, forComponent: 1)
            }
            
            alert.addCancelAction(withLabel: "Cancel")
            alert.addConfirmAction(withLabel: "Bid") { selectedIndexesByComponent in
                
                if selectedIndexesByComponent.count == 2 {
                    self.playerIndexSelected = selectedIndexesByComponent[0]
                    self.bidAmountIndexSelected = selectedIndexesByComponent[1]
                    
                    if self.bidsAmountsByPrivate[self.privateIndexSelected][self.playerIndexSelected] == -5 {
                        self.lastPlayerToMakeTurnBaseIndex = selectedIndexesByComponent[0]
                    }
                    
                    self.makeBid()
                }
            }
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
    }
    
    func isPrivateAvailableForInstantBuy(atBaseIndex baseIdx: Int) -> Bool {
        if self.gameState.game == .g1840 { return true }
        
        for (privateBaseIdx, bids) in self.bidsAmountsByPrivate.enumerated() {
            if bids.allSatisfy({ $0 == -5 }) {
                return privateBaseIdx == baseIdx
            }
        }
        
        return false
    }
    
    func makeIncome() {
        
        let playerPickerIdx = self.playerIndexSelected
        let bidAmount = self.bidAmountIndexSelected * 5
        
        // handle reset
        if bidAmount == 0 {
            self.incomeAmountsByPlayer[playerPickerIdx] = 0
        } else {
            self.incomeAmountsByPlayer[playerPickerIdx] += bidAmount
        }
        
        self.updateIncomeView()
    }
    
    func makeBid() {
        let bidAmount = (self.bidAmountIndexSelected - 1) * 5
        
        self.makeBid(withBidAmount: bidAmount)
    }
    
    func makeBid(withBidAmount bidAmount: Int) {
        
        let playerPickerIdx = self.playerIndexSelected
        let privatePickerIdx = self.privateIndexSelected
        
//        if (self.gameState.getPlayerAmount(atBaseIndex: playerPickerIdx) - self.getTotalBidExpenses(forPlayerAtBaseIndex: playerPickerIdx, excludePrivateBaseIdx: privatePickerIdx)) < Double(bidAmount) {
//            let alert = UIAlertController(title: "ATTENTION", message: "\(self.gameState.getPlayerLabel(atBaseIndex: playerPickerIdx)) does not have enough money to bid \(String(bidAmount))", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alert, animated: true)
//            return
//        }
        
        self.bidsAmountsByPrivate[privatePickerIdx][playerPickerIdx] = bidAmount
        
        // redraw all bids in stackview
        var bidTextsWithAmount: [String] = []
        var bidTextsWithoutAmount: [String] = []
        var bidColors: [UIColor] = []
        var bidTags: [Int] = []
        
        for (i, bidAmount) in self.bidsAmountsByPrivate[privatePickerIdx].enumerated().sorted(by: { $0.1 >= $1.1 }) {
            if bidAmount == 0 {
                bidTextsWithAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i)): free")
                bidTextsWithoutAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i))")
                bidColors.append(Self.temporaryPlayerColors[i])
                bidTags.append((privatePickerIdx * 10) + i)
            } else if bidAmount != -5 {
                bidTextsWithAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i)): \(bidAmount)")
                bidTextsWithoutAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i))")
                bidColors.append(Self.temporaryPlayerColors[i])
                bidTags.append((privatePickerIdx * 10) + i)
            }
        }
        
        if let bidsStackViews = self.bidsStackViewsByPrivateBaseIndex[privatePickerIdx].arrangedSubviews as? [UIStackView], bidsStackViews.count == 2 {
            let evenStackView = bidsStackViews[0]
            let oddStackView = bidsStackViews[1]
            
            if let bidLabels = evenStackView.arrangedSubviews as? [PaddingLabel] {
                for (i, bidLabel) in bidLabels.enumerated() {
                    if (i * 2) < bidTextsWithAmount.count {
                        bidLabel.isHidden = false
                        
                        if self.privatesMayNotBePaidMoreThanFaceValue {
                            let attributedText = NSMutableAttributedString(string: bidTextsWithAmount[i * 2])
                            bidLabel.attributedText = attributedText
                        } else {
                            
                            let attributedText = NSMutableAttributedString(string: (i == 0 ? bidTextsWithAmount[i * 2] : bidTextsWithoutAmount[i * 2]) + "   ", attributes: [NSAttributedString.Key.baselineOffset: 4.0])
                            attributedText.append(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.baselineOffset: 4.0]))
                            bidLabel.attributedText = attributedText
                        }
                        
                        bidLabel.tag = bidTags[i * 2]
                        
                        if (i == 0) {
                            bidLabel.backgroundColor = bidColors[i * 2]
                            bidLabel.textColor = .black
                        } else {
                            bidLabel.backgroundColor = UIColor.primaryAccentColor
                            bidLabel.textColor = .white
                        }
                    } else {
                        bidLabel.isHidden = true
                    }
                }
            }
            
            if let bidLabels = oddStackView.arrangedSubviews as? [PaddingLabel] {
                for (i, bidLabel) in bidLabels.enumerated() {
                    if ((i * 2) + 1) < bidTextsWithAmount.count {
                        bidLabel.isHidden = false
                        
                        if self.privatesMayNotBePaidMoreThanFaceValue {
                            let attributedText = NSMutableAttributedString(string: bidTextsWithAmount[(i * 2) + 1])
                            bidLabel.attributedText = attributedText
                        } else {
                            let attributedText = NSMutableAttributedString(string: bidTextsWithoutAmount[(i * 2) + 1] + "   ", attributes: [NSAttributedString.Key.baselineOffset: 4.0])
                            attributedText.append(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.baselineOffset: 4.0]))
                            bidLabel.attributedText = attributedText
                        }
                        
                        bidLabel.backgroundColor = UIColor.primaryAccentColor
                        bidLabel.tag = bidTags[(i * 2) + 1]
                        bidLabel.textColor = .white
                    } else {
                        bidLabel.isHidden = true
                    }
                }
            }
                    
        }
        
        self.updateIncomeView()
        
        self.privatesCollectionView.reloadData()
        self.zoomedInPrivatesCollectionView.reloadData()
        
    }
    
    func updateIncomeView() {
        
        if let incomeCashLabels = self.incomeCashLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeCashLabel) in incomeCashLabels.enumerated() {
                if i < self.gameState.playersSize {
                    incomeCashLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atBaseIndex: i) - self.getMoneyAmountLockedInBids(forPlayerAtBaseIndex: i) + Double(self.incomeAmountsByPlayer[i])))"
                } else {
                    incomeCashLabel.isHidden = true
                }
            }
        }
        //--------------------------------------------------------------------------------------------
        if let incomeCashLabels = self.zoomedInIncomeCashLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeCashLabel) in incomeCashLabels.enumerated() {
                if i < self.gameState.playersSize {
                    incomeCashLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getPlayerAmount(atBaseIndex: i) - self.getMoneyAmountLockedInBids(forPlayerAtBaseIndex: i) + Double(self.incomeAmountsByPlayer[i])))"
                } else {
                    incomeCashLabel.isHidden = true
                }
            }
        }
        
        if let incomeBidsLabels = self.incomeBidsLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeBidLabel) in incomeBidsLabels.enumerated() {
                if i < self.gameState.playersSize {
                    incomeBidLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.getMoneyAmountLockedInBids(forPlayerAtBaseIndex: i)))"
                } else {
                    incomeBidLabel.isHidden = true
                }
            }
        }
        //--------------------------------------------------------------------------------------------
        if let incomeBidsLabels = self.zoomedInIncomeBidsLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomeBidLabel) in incomeBidsLabels.enumerated() {
                if i < self.gameState.playersSize {
                    incomeBidLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.getMoneyAmountLockedInBids(forPlayerAtBaseIndex: i)))"
                } else {
                    incomeBidLabel.isHidden = true
                }
            }
        }
        
//        for (i, incomeAmountLabel) in self.incomeAmountsLabels.enumerated() {
//            if i < self.gameState.playersSize {
//                incomeAmountLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(self.incomeAmountsByPlayer[i])))"
//            } else {
//                incomeAmountLabel.isHidden = true
//            }
//        }
        //--------------------------------------------------------------------------------------------
//        for (i, incomeAmountLabel) in self.zoomedInIncomeAmountsLabels.enumerated() {
//            if i < self.gameState.playersSize {
//                incomeAmountLabel.text = "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(self.incomeAmountsByPlayer[i])))"
//            } else {
//                incomeAmountLabel.isHidden = true
//            }
//        }
        
        if let incomePARLabels = self.incomePARLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomePARLabel) in incomePARLabels.enumerated() {
                if i < self.gameState.playersSize {
                    if let maxBidAmount = self.getMaxBidAmountToFloat(forPlayerAtBaseIndex: i) {
                        incomePARLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: maxBidAmount)
                    } else {
                        incomePARLabel.text = "no way"
                    }
                } else {
                    incomePARLabel.isHidden = true
                }
            }
        }
        //--------------------------------------------------------------------------------------------
        if let incomePARLabels = self.zoomedInIncomePARLabelsStackView.arrangedSubviews as? [PaddingLabel] {
            for (i, incomePARLabel) in incomePARLabels.enumerated() {
                if i < self.gameState.playersSize {
                    if let maxBidAmount = self.getMaxBidAmountToFloat(forPlayerAtBaseIndex: i) {
                        incomePARLabel.text = self.gameState.currencyType.getCurrencyStringFromAmount(amount: maxBidAmount)
                    } else {
                        incomePARLabel.text = "no way"
                    }
                } else {
                    incomePARLabel.isHidden = true
                }
            }
        }
        
        self.incomeAlphaBackgroundView.isHidden = true
//        self.incomeAlphaBackgroundView.alpha = 0.5
        //--------------------------------------------------------------------------------------------
        self.zoomedInIncomeAlphaBackgroundView.isHidden = true
//        self.zoomedInIncomeAlphaBackgroundView.alpha = 0.5
        
        if self.incomeAmountsByPlayer.allSatisfy({ $0 == 0 }) {
            self.resetIncomeButton.isHidden = true
        } else {
            self.resetIncomeButton.isHidden = false
//            self.incomeAlphaBackgroundView.isHidden = false
        }
        //--------------------------------------------------------------------------------------------
        if self.incomeAmountsByPlayer.allSatisfy({ $0 == 0 }) {
            self.zoomedInResetIncomeButton.isHidden = true
        } else {
            self.zoomedInResetIncomeButton.isHidden = false
//            self.zoomedInIncomeAlphaBackgroundView.isHidden = false
        }
        
        switch self.gameState.game {
        case .g1840, .g1848:
            
            if self.bidsAmountsByPrivate.flatMap({ $0 }).allSatisfy({ $0 == -5 }) {
                self.performORButton.isHidden = true
            } else {
                self.performORButton.isHidden = false
    //            self.incomeAlphaBackgroundView.isHidden = false
            }
            //--------------------------------------------------------------------------------------------
            if self.bidsAmountsByPrivate.flatMap({ $0 }).allSatisfy({ $0 == -5 }) {
                self.zoomedInPerformORButton.isHidden = true
            } else {
                self.zoomedInPerformORButton.isHidden = false
    //            self.zoomedInIncomeAlphaBackgroundView.isHidden = false
            }
            
        case .g1830, .g1846, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            
            if self.bidsAmountsByPrivate[0].allSatisfy({ $0 == -5 }) {
                self.performORButton.isHidden = true
            } else {
                self.performORButton.isHidden = false
    //            self.incomeAlphaBackgroundView.isHidden = false
            }
            //--------------------------------------------------------------------------------------------
            if self.bidsAmountsByPrivate[0].allSatisfy({ $0 == -5 }) {
                self.zoomedInPerformORButton.isHidden = true
            } else {
                self.zoomedInPerformORButton.isHidden = false
    //            self.zoomedInIncomeAlphaBackgroundView.isHidden = false
            }
        }
        
        self.zoomedInPerformORStackView.isHidden = self.zoomedInResetIncomeButton.isHidden && self.zoomedInPerformORButton.isHidden
        self.performORStackView.isHidden = self.resetIncomeButton.isHidden && self.performORButton.isHidden
    }
    
    @IBAction func performORButtonPressed(sender: UIButton) {
        
        switch self.gameState.game {
        case .g1840, .g1848:
            
            for privateBaseIdx in 0..<self.gameState.privatesPrices.count {
                if self.bidsAmountsByPrivate[privateBaseIdx].filter({ $0 != -5 }).isEmpty {
                    continue
                }
                
                if let maxBid = self.bidsAmountsByPrivate[privateBaseIdx].enumerated().sorted(by: { $0.1 >= $1.1 }).first {
                    self.incomeAmountsByPlayer[maxBid.0] += Int(self.gameState.privatesIncomes[privateBaseIdx])
                }
            }
            
        case .g1830, .g1846, .g1849, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            
            for privateBaseIdx in 0..<self.gameState.privatesPrices.count {
                if self.bidsAmountsByPrivate[privateBaseIdx].filter({ $0 != -5 }).isEmpty {
                    break
                }
                
                if let maxBid = self.bidsAmountsByPrivate[privateBaseIdx].enumerated().sorted(by: { $0.1 >= $1.1 }).first {
                    self.incomeAmountsByPlayer[maxBid.0] += Int(self.gameState.privatesIncomes[privateBaseIdx])
                }
            }
        }
        
        self.updateIncomeView()
    }
    
    @IBAction func resetIncomeButtonPressed(sender: UIButton) {
        self.incomeAmountsByPlayer = Array(repeating: 0, count: self.gameState.playersSize)
        
        self.updateIncomeView()
    }
    
    func getMoneyAmountLockedInBids(forPlayerAtBaseIndex playerBaseIdx: Int) -> Double {
        
        var bidsAmount = 0.0
        
        for privateBaseIdx in 0..<self.gameState.privatesPrices.count {
            if let maxBid = self.bidsAmountsByPrivate[privateBaseIdx].max(), maxBid != self.bidsAmountsByPrivate[privateBaseIdx][playerBaseIdx] {
                if !self.gameState.privatesLockMoneyIfOutbidden {
                    continue
                }
                
                if self.bidsAmountsByPrivate.enumerated().filter({ $0.0 < privateBaseIdx }).allSatisfy({ !$0.1.filter({ $0 != -5 }).isEmpty }) {
                    continue
                }
            }
            
            if self.bidsAmountsByPrivate[privateBaseIdx][playerBaseIdx] == -5 {
                continue
            }
            
            bidsAmount += Double(self.bidsAmountsByPrivate[privateBaseIdx][playerBaseIdx])
        }
        
        return bidsAmount
        
    }
    
    func getPortfolioAmountIfAuctionWouldEndNow(forPlayerAtBaseIndex playerBaseIdx: Int) -> Double {
        var bidsAmount = 0.0
        
        for privateBaseIdx in 0..<self.gameState.privatesPrices.count {
            if let maxBid = self.bidsAmountsByPrivate[privateBaseIdx].max(), maxBid != self.bidsAmountsByPrivate[privateBaseIdx][playerBaseIdx] {
                continue
            }
            
            if self.bidsAmountsByPrivate[privateBaseIdx][playerBaseIdx] == -5 {
                continue
            }
            
            bidsAmount += Double(self.bidsAmountsByPrivate[privateBaseIdx][playerBaseIdx])
        }
        
        let incomeAmount = self.incomeAmountsByPlayer[playerBaseIdx]
        
        return self.gameState.getPlayerAmount(atBaseIndex: playerBaseIdx) - bidsAmount + Double(incomeAmount)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        
        for playerBaseIdx in 0..<self.gameState.playersSize {
            if self.getPortfolioAmountIfAuctionWouldEndNow(forPlayerAtBaseIndex: playerBaseIdx) < 0 {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "\(self.gameState.getPlayerLabel(atBaseIndex: playerBaseIdx)) bid more than available, check the bids and try again")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
        }
        
        // create ops and perform them
        var privateOps: [Operation] = []
        
        for (playerBaseIdx, incomeAmount) in self.incomeAmountsByPlayer.enumerated() {
            if incomeAmount != 0 && incomeAmount != -5 {
                let srcGlobalIndex: Int = BankIndex.bank.rawValue
                let dstGlobalIndex: Int = self.gameState.forceConvert(index: playerBaseIdx, backwards: false, withIndexType: .players)

                let op = Operation(type: .income, uid: nil)
                op.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(incomeAmount))

                privateOps.append(op)
            }
        }
        
        for privateBaseIdx in 0..<self.gameState.privatesPrices.count {
            if let maxBid = self.bidsAmountsByPrivate[privateBaseIdx].max(), maxBid != -5 {
                if let playerBaseIdx = self.bidsAmountsByPrivate[privateBaseIdx].firstIndex(of: maxBid) {
                    
                    if maxBid <= Int(self.gameState.privatesPrices[privateBaseIdx]) {
                        self.lastPlayerToBuyAtFaceValueBaseIndex = playerBaseIdx
                    }
                    
                    let srcGlobalIndex: Int = self.gameState.forceConvert(index: playerBaseIdx, backwards: false, withIndexType: .players)
                    let dstGlobalIndex: Int = BankIndex.bank.rawValue
                    
                    if let cmpIdx = self.accompanyingCompaniesIndexes[privateBaseIdx], let shareAmount = self.accompanyingCompaniesAmounts[privateBaseIdx], self.gameState.shareStartingLocation == .ipo {
                        let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
                        
                        let op = Operation(type: .privates, uid: nil)
                        op.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(maxBid))
                        op.addSharesDetails(shareSourceIndex: BankIndex.ipo.rawValue, shareDestinationIndex: srcGlobalIndex, shareAmount: Double(shareAmount), shareCompanyBaseIndex: cmpBaseIdx)
                        op.addPrivatesDetails(privateSourceGlobalIndex: dstGlobalIndex, privateDestinationGlobalIndex: srcGlobalIndex, privateCompanyBaseIndex: privateBaseIdx)
                        privateOps.append(op)
                    } else if let cmpIdx = self.accompanyingCompaniesIndexes[privateBaseIdx], let shareAmount = self.accompanyingCompaniesAmounts[privateBaseIdx], self.gameState.shareStartingLocation == .company {
                        let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
                        
                        let op = Operation(type: .privates, uid: nil)
                        op.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(maxBid))
                        op.addSharesDetails(shareSourceIndex: cmpIdx, shareDestinationIndex: srcGlobalIndex, shareAmount: Double(shareAmount), shareCompanyBaseIndex: cmpBaseIdx)
                        op.addPrivatesDetails(privateSourceGlobalIndex: dstGlobalIndex, privateDestinationGlobalIndex: srcGlobalIndex, privateCompanyBaseIndex: privateBaseIdx)
                        privateOps.append(op)
                    } else {
                        let op = Operation(type: .privates, uid: nil)
                        op.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: Double(maxBid))
                        op.addPrivatesDetails(privateSourceGlobalIndex: dstGlobalIndex, privateDestinationGlobalIndex: srcGlobalIndex, privateCompanyBaseIndex: privateBaseIdx)
                        privateOps.append(op)
                    }
                }
            }
        }

        if let arrayIdx = self.accompanyingCompaniesAmounts.firstIndex(where: { $0 == 2 }) {
            if let cmpIdx = self.accompanyingCompaniesIndexes[arrayIdx] {
                if let maxBid = self.bidsAmountsByPrivate[arrayIdx].max(), maxBid != -5 {
                    
                    let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
                    
                    let pickerElementsAttributedTexts = self.gameState.getGamePARValues().map { "\(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double($0)))" }.map { NSAttributedString(string: $0) }
                    
                    let alert = storyboard?.instantiateViewController(withIdentifier: "customPickerViewAlertViewController") as! CustomPickerViewAlertViewController
                    alert.setup(withTitle: "Set PAR for \(self.gameState.getCompanyLabel(atIndex: cmpIdx)):", andPickerElementsAttributedTextsByComponent: [pickerElementsAttributedTexts])
                    alert.addCancelAction(withLabel: "Cancel")
                    alert.addConfirmAction(withLabel: "OK") { selectedIndexesByComponent in
                        
                        if selectedIndexesByComponent.isEmpty { return }
                        
                        self.PARindexSelected = selectedIndexesByComponent[0]
                        
                        var additionalOperations: [Operation] = []
                        let PARValues = self.gameState.getGamePARValues()
                        
                        let PARvalue = Double(PARValues[self.PARindexSelected])
                        if let parIndex = self.gameState.getPARindex(fromShareValue: PARvalue) {
                            let op = Operation(type: .market)
                            op.addMarketDetails(marketShareValueCmpBaseIndex: cmpBaseIdx, marketShareValueFromIndex: nil, marketShareValueToIndex: parIndex, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) -> PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: PARvalue, shouldTruncateDouble: true))")
                            additionalOperations.append(op)
                        }
                        
                        if self.gameState.shareStartingLocation == .ipo && !self.gameState.buyShareFromIPOPayBank {
                            let op = Operation(type: .privates, uid: nil)
                            op.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: cmpIdx, amount: 2.0 * Double(PARValues[self.PARindexSelected]))
                            
                            additionalOperations.append(op)
                        } else if self.gameState.shareStartingLocation == .bank && !self.gameState.buyShareFromBankPayBank {
                            let op = Operation(type: .privates, uid: nil)
                            op.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: cmpIdx, amount: 2.0 * Double(PARValues[self.PARindexSelected]))
                            
                            additionalOperations.append(op)
                        } else if self.gameState.shareStartingLocation == .company && !self.gameState.buyShareFromCompPayBank {
                            let op = Operation(type: .privates, uid: nil)
                            op.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: cmpIdx, amount: 2.0 * Double(PARValues[self.PARindexSelected]))
                            
                            additionalOperations.append(op)
                        }
                        
                        if self.gameState.requiredNumberOfSharesToFloat <= 2 {
                            additionalOperations += CompanyFloatViewController.generateFloatOperationsWithAmount(floatAmount: 0, forCompanyAtIndex: cmpIdx, andGameState: self.gameState)
                        }
        
                        self.proceedToNextViewController(performingOperations: privateOps + additionalOperations)
                    }
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert,animated: true, completion: nil )
                    return
                }
            }
        }
        
        if self.gameState.game == .g1840 {
            for playerBaseIdx in 0..<self.gameState.playersSize {
                let op = Operation(type: .setup, uid: nil)
                op.addCashDetails(sourceIndex: BankIndex.bank.rawValue, destinationIndex: self.gameState.forceConvert(index: playerBaseIdx, backwards: false, withIndexType: .players), amount: 350.0)
                privateOps.append(op)
            }
        }
        
        self.proceedToNextViewController(performingOperations: privateOps)
        
    }
    
    func proceedToNextViewController(performingOperations ops: [Operation]) {
        
        if !self.gameState.areOperationsLegit(operations: ops, reverted: false) {
            return
        }
        
        for op in ops {
            let _ = self.gameState.perform(operation: op)
        }
        
        if self.gameState.game == .g1846 {
            self.gameState.privatesPrices[self.gameState.privatesPrices.count - 2] = 40
            self.gameState.privatesPrices[self.gameState.privatesPrices.count - 1] = 60
        }
        
        if self.gameState.game == .g1840 {
            self.gameState.homePlayersCollectionViewBaseIndexesSorted = self.gameState.getPlayerIndexes().map { self.gameState.getPlayerAmount(atIndex: $0) }.enumerated().sorted(by: { $0.1 >= $1.1 }).map { $0.0 }
        } else {
            if self.lastPlayerToBuyAtFaceValueBaseIndex == self.gameState.playersSize - 1 {
                self.gameState.homePlayersCollectionViewBaseIndexesSorted = Array<Int>(0..<self.gameState.playersSize)
            } else {
                self.gameState.homePlayersCollectionViewBaseIndexesSorted = Array<Int>((self.lastPlayerToBuyAtFaceValueBaseIndex + 1)..<self.gameState.playersSize) + Array<Int>(0...self.lastPlayerToBuyAtFaceValueBaseIndex)
            }
        }
        self.gameState.homeDynamicTurnOrdersPreviewByPlayerBaseIndexes = self.gameState.homePlayersCollectionViewBaseIndexesSorted
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        nextVC.gameState = self.gameState
        nextVC.modalTransitionStyle = .flipHorizontal
        
        self.present(nextVC, animated: true)
    }

}

extension PrivatesAuctionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameState.privatesPrices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "privateAuctionCollectionViewCell", for: indexPath) as! PrivateAuctionCollectionViewCell
            cell.backgroundColor = UIColor.secondaryAccentColor
            
            if indexPath.row % 2 != 0 {
                cell.accessoryImageView.image = UIImage(named: "bottom_bids") ?? UIImage()
            } else {
                cell.accessoryImageView.image = UIImage(named: "top_bids") ?? UIImage()
            }
            
            let bidsAmountsByPlayerBaseIndex = self.bidsAmountsByPrivate[indexPath.row].enumerated().sorted(by: { $0.1 >= $1.1 })
            
            let isBidsStackViewEmpty = self.bidsAmountsByPrivate[indexPath.row].allSatisfy({ $0 == -5 })
            
            if isBidsStackViewEmpty {
                cell.bidsScrollView.isHidden = true
            } else {
                for subview in cell.bidsScrollView.subviews {
                    subview.removeFromSuperview()
                }
                
                cell.bidsScrollView.isHidden = false
                cell.bidsScrollView.contentInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
                
                //compose stack view
                let bidsStackView = UIStackView()
                bidsStackView.axis = .horizontal
                bidsStackView.spacing = 4
                bidsStackView.alignment = .center
                bidsStackView.distribution = .fillEqually
                bidsStackView.translatesAutoresizingMaskIntoConstraints = false
                
                for bidPlayerTuple in bidsAmountsByPlayerBaseIndex {
                    let (playerBaseIdx, bidAmount) = bidPlayerTuple
                    
                    if bidAmount != -5 {
                        let bidLabel = PaddingLabel()
                        bidLabel.text = String(self.gameState.getPlayerLabel(atBaseIndex: playerBaseIdx).first ?? "A")
                        bidLabel.textAlignment = .center
                        bidLabel.textColor = UIColor.black
                        bidLabel.backgroundColor = Self.temporaryPlayerColors[playerBaseIdx]
                        bidLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
                        bidLabel.layer.cornerRadius = 18
                        bidLabel.clipsToBounds = true
                        
                        bidLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
                        bidLabel.widthAnchor.constraint(equalToConstant: 36).isActive = true
                        
                        bidsStackView.addArrangedSubview(bidLabel)
                    }
                }
                
                cell.bidsScrollView.addSubview(bidsStackView)
                
                bidsStackView.leadingAnchor.constraint(equalTo: cell.bidsScrollView.leadingAnchor, constant: 0.0).isActive = true
                bidsStackView.trailingAnchor.constraint(equalTo: cell.bidsScrollView.trailingAnchor, constant: 0.0).isActive = true
                bidsStackView.topAnchor.constraint(equalTo: cell.bidsScrollView.topAnchor, constant: 0.0).isActive = true
                bidsStackView.bottomAnchor.constraint(equalTo: cell.bidsScrollView.bottomAnchor, constant: 0.0).isActive = true
                bidsStackView.heightAnchor.constraint(equalTo: cell.bidsScrollView.heightAnchor).isActive = true
                let bidsCount = bidsAmountsByPlayerBaseIndex.count(where: { $0.1 != -5 })
                bidsStackView.widthAnchor.constraint(equalToConstant: CGFloat((bidsCount * 36) + ((bidsCount - 1) * 4))).isActive = true
                
            }
            
            if isBidsStackViewEmpty {
                cell.noBidsPresentLabel.isHidden = false
            } else {
                cell.noBidsPresentLabel.isHidden = true
            }
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zoomedInPrivateCollectionViewCell", for: indexPath) as! ZoomedInPrivateCollectionViewCell
            cell.backgroundColor = UIColor.secondaryAccentColor
            
            cell.parentVC = self
            cell.indexPathRow = indexPath.row
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privateViewTapped(_:)))
            cell.backgroundAccessoryView.tag = indexPath.row
            cell.backgroundAccessoryView.isUserInteractionEnabled = true
            cell.backgroundAccessoryView.addGestureRecognizer(tapGestureRecognizer)
            
            cell.backgroundAccessoryView.backgroundColor = UIColor.secondaryAccentColor
            cell.backgroundAccessoryView.clipsToBounds = true
            cell.backgroundAccessoryView.layer.cornerRadius = 8
            cell.backgroundAccessoryView.layer.borderWidth = 3
            cell.backgroundAccessoryView.layer.borderColor = UIColor.primaryAccentColor.cgColor
            
            cell.titleLabel.text = "P\(indexPath.row + 1) (\(Int(self.gameState.privatesPrices[indexPath.row]))/\(Int(self.gameState.privatesIncomes[indexPath.row])))"
            
            if let cmpShareIdx = self.accompanyingCompaniesIndexes[indexPath.row], let cmpShareAmount = self.accompanyingCompaniesAmounts[indexPath.row] {
                cell.accompanyingShareLabel.isHidden = false
                cell.accompanyingShareLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
                cell.accompanyingShareLabel.textAlignment = .center
                let totShareAmount = Double(self.gameState.getTotalShareNumberOfCompany(atIndex: cmpShareIdx))
                cell.accompanyingShareLabel.text = "\(Int(Double(cmpShareAmount) / totShareAmount * 100.0))% \(self.gameState.getCompanyLabel(atIndex: cmpShareIdx))"
                cell.accompanyingShareLabel.backgroundColor = self.gameState.getCompanyColor(atIndex: cmpShareIdx)
                cell.accompanyingShareLabel.textColor = self.gameState.getCompanyTextColor(atIndex: cmpShareIdx)
                cell.accompanyingShareLabel.clipsToBounds = true
                cell.accompanyingShareLabel.layer.cornerRadius = 4.0
                
                cell.accompanyingShareLabel.paddingLeft = 8.0
                cell.accompanyingShareLabel.paddingRight = 8.0
                cell.accompanyingShareLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
            } else {
                cell.accompanyingShareLabel.isHidden = true
            }
            
            var bidTextsWithAmount: [String] = []
            var bidTextsWithoutAmount: [String] = []
            var bidColors: [UIColor] = []
            var bidTags: [Int] = []
            
            for (i, bidAmount) in self.bidsAmountsByPrivate[indexPath.row].enumerated().sorted(by: { $0.1 >= $1.1 }) {
                if bidAmount == 0 {
                    bidTextsWithAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i)): free")
                    bidTextsWithoutAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i))")
                    bidColors.append(Self.temporaryPlayerColors[i])
                    bidTags.append((indexPath.row * 10) + i)
                } else if bidAmount != -5 {
                    bidTextsWithAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i)): \(bidAmount)")
                    bidTextsWithoutAmount.append("\(self.gameState.getPlayerLabel(atBaseIndex: i))")
                    bidColors.append(Self.temporaryPlayerColors[i])
                    bidTags.append((indexPath.row * 10) + i)
                }
            }
            
            cell.bidsStackView.spacing = 8.0
            cell.bidsStackView.isHidden = bidTextsWithAmount.isEmpty
            
            if !bidTextsWithAmount.isEmpty {
                if let bidLabels = cell.bidsStackView.arrangedSubviews as? [PaddingLabel] {
                    for (i, bidLabel) in bidLabels.enumerated() {
                        if i < bidTextsWithAmount.count {
                            
                            bidLabel.paddingTop = 6.0
                            bidLabel.paddingBottom = 6.0
                            bidLabel.paddingLeft = 10.0
                            bidLabel.paddingRight = 10.0
                            bidLabel.layer.cornerRadius = 6.0
                            bidLabel.clipsToBounds = true
                            bidLabel.textAlignment = .center
                            bidLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
                            bidLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
                            
                            bidLabel.isHidden = false
                            
                            let attributedText = NSMutableAttributedString(string: (i == 0 ? bidTextsWithAmount[i] : bidTextsWithoutAmount[i]) + "   ", attributes: [NSAttributedString.Key.baselineOffset: 4.0])
                            attributedText.append(NSAttributedString(string: "+", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.baselineOffset: 4.0]))
                            
                            bidLabel.attributedText = attributedText
                            bidLabel.tag = bidTags[i]
                            
                            if (i == 0) {
                                bidLabel.backgroundColor = bidColors[i]
                                bidLabel.textColor = .black
                            } else {
                                bidLabel.backgroundColor = UIColor.primaryAccentColor
                                bidLabel.textColor = .white
                            }
                            
                            bidLabel.isUserInteractionEnabled = true
                            
                            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(topUpBid))
                            tapGestureRecognizer.numberOfTapsRequired = 1
                            
                            bidLabel.addGestureRecognizer(tapGestureRecognizer)
                            
                        } else {
                            bidLabel.isHidden = true
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    func showPrivateDetails(forPrivateAtBaseIndex privateBaseIdx: Int) {
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customTextViewAlertViewController") as! CustomTextViewAlertViewController
        alert.setup(withTitle: "Private \(self.gameState.privatesLabels[privateBaseIdx])", andMessage: self.gameState.privatesDescriptions[privateBaseIdx])
        alert.addConfirmAction(withLabel: "OK")
        
        alert.preferredContentSize = CGSize(width: 440, height: 400)
        
        self.present(alert, animated: true)
        return
    }
}

extension PrivatesAuctionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return collectionView.getSizeForGrid(withRows: 1.0, andCols: Double(self.gameState.privatesPrices.count), andIndexPath: indexPath, isVerticalFlow: false)
        } else {
            if self.gameState.privatesPrices.count > 6 {
                let rows = 1.0
                let cols = ceil(CGFloat(self.gameState.privatesPrices.count) / rows)
                    
                let width = floor((collectionView.bounds.size.width - 70.0) / 6.0)
                let height = collectionView.getHeightForGrid(withRows: rows, andCols: cols, andIndexPath: indexPath, isVerticalFlow: false)
                    
                return CGSize(width: Int(width), height: height)
            } else {
                return collectionView.getSizeForGrid(withRows: 1.0, andCols: Double(self.gameState.privatesPrices.count), andIndexPath: indexPath, isVerticalFlow: false)
            }
        }
        
    }
}

//extension PrivatesAuctionViewController: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView.tag == -1 {
//            self.PARindexSelected = row
//        } else {
//            if component == 0 {
//                self.playerIndexSelected = row
//            } else if component == 1 {
//                self.bidAmountIndexSelected = row
//            }
//        }
//    }
//}

extension PrivatesAuctionViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.privateViewTapped(withTag: textView.tag)
        return false
    }
}
