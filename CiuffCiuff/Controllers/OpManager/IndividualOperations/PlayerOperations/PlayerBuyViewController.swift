//
//  PlayerBuyViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 08/03/23.
//

import UIKit

class PlayerBuyViewController: UIViewController, Operable {

    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingPlayerIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    var shareCompanyIndexes: [Int] = []
    var soldCompaniesBaseIndexes: [Int] = []
    
    var operationsByTag: [[Operation]] = []
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var verticalOuterStackView: UIStackView!
    @IBOutlet weak var soldCompaniesStackView: UIStackView!
    @IBOutlet weak var soldCompaniesLabelsStackView: UIStackView!
    @IBOutlet weak var sharesCompanyPopupButton: UIButton!
    @IBOutlet weak var buyOpsStackView: UIStackView!
    var secondaryStackView: UIStackView? = nil
    var thirdStackView: UIStackView? = nil
    
    @IBOutlet weak var performCustomBuyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.performCustomBuyButton.setTitle(withText: "Perform Custom Buy", fontSize: 18.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
        self.performCustomBuyButton.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.performCustomBuyButton.layer.borderWidth = 3
        
        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        var opsAfterLastSR: [Operation] = []
        
        if let lastSROpIdx = self.gameState.activeOperations.lastIndex(where: { op in OperationType.getSROperationTypes().contains(op.type) }) {
            opsAfterLastSR = Array<Operation>(self.gameState.activeOperations[lastSROpIdx...])
            
            let soldCmpBaseIndexes = opsAfterLastSR.filter { ($0.type == .sell) && $0.destinationGlobalIndex == self.operatingPlayerIndex }.map { $0.shareCompanyBaseIndex }
            self.soldCompaniesBaseIndexes = (0..<self.gameState.companiesSize).filter { soldCmpBaseIndexes.contains($0) }
        }
        
        if self.soldCompaniesBaseIndexes.isEmpty {
            self.soldCompaniesStackView.isHidden = true
        } else {
            self.soldCompaniesStackView.isHidden = false
            
            for cmpBaseIdx in self.soldCompaniesBaseIndexes {
                let cmpLabel = UILabel()
                cmpLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .regular)
                cmpLabel.textAlignment = .center
                cmpLabel.text = self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)
                cmpLabel.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: cmpBaseIdx)
                cmpLabel.textColor = self.gameState.getCompanyTextColor(atBaseIndex: cmpBaseIdx)
                
                cmpLabel.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
                cmpLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
                
                self.soldCompaniesLabelsStackView.addArrangedSubview(cmpLabel)
            }
        }
        
        for companyIndex in self.gameState.getCompanyIndexes() where self.gameState.getCompanyType(atIndex: companyIndex).areSharesPurchasebleByPlayers() {
            let companyBaseIndex = self.gameState.forceConvert(index: companyIndex, backwards: true, withIndexType: .companies)
            
            if self.soldCompaniesBaseIndexes.contains(companyBaseIndex) { continue }
            
            let shareAvailableInBank = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[companyBaseIndex] > 0
            let shareAvailableInIpo = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[companyBaseIndex] > 0
            let shareAvailableInCmp = self.gameState.getSharesPortfolioForCompany(atIndex: companyIndex)[companyBaseIndex] > 0
            let shareAvailableInAside = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.aside.rawValue)[companyBaseIndex] > 0
            let shareAvailableInTradeIn = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.tradeIn.rawValue)[companyBaseIndex] > 0
            
            let isMarketPriceAvailable = self.gameState.getShareValue(forCompanyAtBaseIndex: companyBaseIndex) != nil
            let isPARPriceAvailable = self.gameState.getPARvalue(forCompanyAtBaseIndex: companyBaseIndex) != nil
            let cmpCanBeFloatedByPlayer = self.gameState.getCompanyType(atBaseIndex: companyBaseIndex).canBeFloatedByPlayers()
            
            switch self.gameState.shareStartingLocation {
            case .ipo:
                if shareAvailableInIpo {
                    if self.gameState.sharesFromIPOHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromIPOHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[companyBaseIndex] >= self.gameState.compTotShares[companyBaseIndex] - 1 && cmpCanBeFloatedByPlayer {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
                
                if shareAvailableInBank {
                    if self.gameState.sharesFromBankHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromBankHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
                
            case .bank:
                if shareAvailableInBank {
                    if self.gameState.sharesFromBankHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromBankHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[companyBaseIndex] >= self.gameState.compTotShares[companyBaseIndex] - 1 && cmpCanBeFloatedByPlayer {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
            case .aside:
                if shareAvailableInAside {
                    if self.gameState.sharesFromAsideHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromAsideHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.aside.rawValue)[companyBaseIndex] >= self.gameState.compTotShares[companyBaseIndex] - 1 && cmpCanBeFloatedByPlayer {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
                
                if shareAvailableInBank {
                    if self.gameState.sharesFromBankHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromBankHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
            case .company:
                if shareAvailableInCmp {
                    if self.gameState.sharesFromCompHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromCompHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if self.gameState.getSharesPortfolioForCompany(atBaseIndex: companyBaseIndex)[companyBaseIndex] >= self.gameState.compTotShares[companyBaseIndex] - 1 && cmpCanBeFloatedByPlayer {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
                
                if shareAvailableInBank {
                    if self.gameState.sharesFromBankHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromBankHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
            case .tradeIn:
                if shareAvailableInTradeIn {
                    if self.gameState.sharesFromTradeInHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromTradeInHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.tradeIn.rawValue)[companyBaseIndex] >= self.gameState.compTotShares[companyBaseIndex] - 1 && cmpCanBeFloatedByPlayer {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
                
                if shareAvailableInBank {
                    if self.gameState.sharesFromBankHavePARprice && isPARPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    } else if !self.gameState.sharesFromBankHavePARprice && isMarketPriceAvailable {
                        self.shareCompanyIndexes.append(companyIndex)
                        break
                    }
                }
            }
            
        }
            
        if let firstCmpIndex = self.shareCompanyIndexes.first {
//            let firstCmpBaseIdx = self.gameState.convert(index: firstCmpIndex, backwards: true, withIndexType: .companies)
            
            self.parentVC.emptyLabel.isHidden = true
            self.view.isHidden = false
            
            var activeCompanyIdx: Int? = nil
            
            // try too suggest last bought company
            opsAfterLastSR = opsAfterLastSR.filter({ op in
                return op.type == .buy && !self.soldCompaniesBaseIndexes.contains { $0 == op.shareCompanyBaseIndex }
            })

            // check for current player last BUY action

            if let lastOpPlayer = opsAfterLastSR.last(where: { op in op.shareDestinationGlobalIndex == self.operatingPlayerIndex && self.shareCompanyIndexes.contains { $0 == self.gameState.convert(index: op.shareCompanyBaseIndex, backwards: false, withIndexType: .companies) } }) {
                activeCompanyIdx = self.gameState.convert(index: lastOpPlayer.shareCompanyBaseIndex, backwards: false, withIndexType: .companies)
            } else if let lastOpOpponent = opsAfterLastSR.last(where: { op in op.shareDestinationGlobalIndex != self.operatingPlayerIndex && self.shareCompanyIndexes.contains { $0 == self.gameState.convert(index: op.shareCompanyBaseIndex, backwards: false, withIndexType: .companies) } }) {
                activeCompanyIdx = self.gameState.convert(index: lastOpOpponent.shareCompanyBaseIndex, backwards: false, withIndexType: .companies)
            }
                
            var affordableCompanyIndexes: [Int] = []
            
            for cmpIdx in self.shareCompanyIndexes {
                let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
                
                var shouldSuggestPresidentShareCertificate = false
                let isPARvalueAvailable = self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx) != nil
                
                if self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx).canBeFloatedByPlayers() {
                    switch self.gameState.shareStartingLocation {
                    case .ipo:
                        shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
                    case .bank:
                        shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
                    case .company:
                        shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForCompany(atBaseIndex: cmpBaseIdx)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
                    case .aside:
                        shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.aside.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
                    case .tradeIn:
                        shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.tradeIn.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
                    }
                }
                
                let playerCanOpenCompany = Int(self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex)) >= self.gameState.openCompanyValues[0]
                    
                if shouldSuggestPresidentShareCertificate && playerCanOpenCompany {
                    affordableCompanyIndexes.append(cmpIdx)
                } else if !shouldSuggestPresidentShareCertificate && self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex) >= self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) ?? 0 {
                    affordableCompanyIndexes.append(cmpIdx)
                }
            }
            
            if !affordableCompanyIndexes.isEmpty && !affordableCompanyIndexes.contains(where: { $0 == activeCompanyIdx }) {
                activeCompanyIdx = affordableCompanyIndexes[0]
            }
            
            let activeIdx: Int = activeCompanyIdx ?? firstCmpIndex
            
            // setup companies popup button
            var sharesCompanyActions: [UIAction] = []
            for shareCompanyIdx in self.shareCompanyIndexes {
                if shareCompanyIdx == activeIdx {
                    sharesCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), state: .on, handler: { action in
                        let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                        self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.colors[idx].uiColor)
                        self.sharesCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                        
                        self.setupVC(withSelectedCmpIdx: idx)
                    }))
                } else {
                    sharesCompanyActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: shareCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: shareCompanyIdx)), handler: { action in
                        let idx = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                        self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.colors[idx].uiColor)
                        self.sharesCompanyPopupButton.setPopupTitle(withText: action.title, textColor: self.gameState.textColors[idx].uiColor)
                        
                        self.setupVC(withSelectedCmpIdx: idx)
                    }))
                }
            }
            
            if sharesCompanyActions.isEmpty {
                self.sharesCompanyPopupButton.isHidden = true
            } else {
                self.sharesCompanyPopupButton.isHidden = false
                if sharesCompanyActions.count == 1 {
                    self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: activeIdx))
                    self.sharesCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atIndex: activeIdx), textColor: self.gameState.textColors[activeIdx].uiColor)
                } else {
                    self.sharesCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: activeIdx))
                    self.sharesCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atIndex: activeIdx), textColor: self.gameState.textColors[activeIdx].uiColor)
                }
                
                self.sharesCompanyPopupButton.menu = UIMenu(children: sharesCompanyActions)
                self.sharesCompanyPopupButton.showsMenuAsPrimaryAction = true
                self.sharesCompanyPopupButton.changesSelectionAsPrimaryAction = true
            }
            
            self.setupVC(withSelectedCmpIdx: activeIdx)
            
        } else {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
        }
        
    }
    
    func setupVC(withSelectedCmpIdx cmpIdx: Int) {
        let cmpBaseIdx = self.gameState.forceConvert(index: cmpIdx, backwards: true, withIndexType: .companies)
        
        if let secondaryStackView = self.secondaryStackView {
            secondaryStackView.removeFromSuperview()
            self.secondaryStackView = nil
        }
        
        if let thirdStackView = self.thirdStackView {
            thirdStackView.removeFromSuperview()
            self.thirdStackView = nil
        }

        for view in self.buyOpsStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        self.operationsByTag.removeAll()
        
        var shouldSuggestPresidentShareCertificate = false
        let isPARvalueAvailable = self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx) != nil
        
        if self.gameState.getCompanyType(atBaseIndex: cmpBaseIdx).canBeFloatedByPlayers() {
            switch self.gameState.shareStartingLocation {
            case .ipo:
                shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
            case .bank:
                shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
            case .company:
                shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForCompany(atBaseIndex: cmpBaseIdx)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
            case .aside:
                shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.aside.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
            case .tradeIn:
                shouldSuggestPresidentShareCertificate = !isPARvalueAvailable && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.tradeIn.rawValue)[cmpBaseIdx] >= self.gameState.compTotShares[cmpBaseIdx] - 1
            }
        }
        
        if shouldSuggestPresidentShareCertificate {
            
            if self.gameState.game == .g1849 {
                
                let secondaryStackView = UIStackView()
                secondaryStackView.axis = .horizontal
                secondaryStackView.spacing = 20.0
                
                let thirdStackView = UIStackView()
                thirdStackView.axis = .horizontal
                thirdStackView.spacing = 20.0
                
                for (i, presidentShareAmount) in (2...4).enumerated() {
                    for (j, parValue) in self.gameState.getGamePARValues().enumerated() {
                        let shouldHideColumn = self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex) <= Double(parValue) * Double(2)
                        let isBtnEnabled = self.gameState.getPlayerAmount(atIndex: self.operatingPlayerIndex) >= Double(parValue) * Double(presidentShareAmount)
                            
                        let presidentShareBtn = UIButton(type: .custom)
                        presidentShareBtn.tag = i * self.gameState.getGamePARValues().count + j
                        
                        if shouldHideColumn {
                            presidentShareBtn.isHidden = true
                        } else if isBtnEnabled {
                            presidentShareBtn.isHidden = false
                            
                            presidentShareBtn.setTitle(withText: "\(presidentShareAmount)x PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(parValue)))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                            presidentShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                            
                            presidentShareBtn.isUserInteractionEnabled = true
                            presidentShareBtn.addTarget(self, action: #selector(self.presidentButtonPressed(sender:)), for: .touchUpInside)
                        } else {
                            presidentShareBtn.isHidden = false
                            
                            presidentShareBtn.setTitle(withText: "", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                            presidentShareBtn.setBackgroundColor(UIColor.secondaryAccentColor, isRectangularShape: true)
                            
                            presidentShareBtn.isUserInteractionEnabled = false
                        }
                        
                        presidentShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                        presidentShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                        
                        if presidentShareAmount == 2 {
                            self.buyOpsStackView.addArrangedSubview(presidentShareBtn)
                        } else if presidentShareAmount == 3 {
                            secondaryStackView.addArrangedSubview(presidentShareBtn)
                        } else if presidentShareAmount == 4 {
                            thirdStackView.addArrangedSubview(presidentShareBtn)
                        }
                        
                        let presidentOps = self.generateBuyOperations(shareAmount: Double(presidentShareAmount), andSingleShareAmount: Double(parValue), andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: self.gameState.shareStartingLocation.getBankIndex() ?? cmpIdx, andShareDstGlobalIndex: self.operatingPlayerIndex)
                        self.operationsByTag.append(presidentOps)
                    }
                }
                
                self.verticalOuterStackView.insertArrangedSubview(secondaryStackView, at: 3)
                self.verticalOuterStackView.insertArrangedSubview(thirdStackView, at: 4)
                
                self.secondaryStackView = secondaryStackView
                self.thirdStackView = thirdStackView
                
                return
            }
            
            let PARValues = self.gameState.getGamePARValues()
            
            if PARValues.count > 8 {
                
                let secondaryStackView = UIStackView()
                secondaryStackView.axis = .horizontal
                secondaryStackView.spacing = 20.0
                
                let thirdStackView = UIStackView()
                thirdStackView.axis = .horizontal
                thirdStackView.spacing = 20.0
                
                for (i, parValue) in PARValues.enumerated() {
                    let presidentShareBtn = UIButton(type: .custom)
                    presidentShareBtn.tag = i
                    
                    presidentShareBtn.setTitle(withText: "\(Int(self.gameState.presidentCertificateShareAmount))x PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(parValue)))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                    presidentShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                    
                    presidentShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                    presidentShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                    
                    presidentShareBtn.addTarget(self, action: #selector(self.presidentButtonPressed(sender:)), for: .touchUpInside)
                    
                    if i < 4 {
                        self.buyOpsStackView.addArrangedSubview(presidentShareBtn)
                    } else if i < 8 {
                        secondaryStackView.addArrangedSubview(presidentShareBtn)
                    } else {
                        thirdStackView.addArrangedSubview(presidentShareBtn)
                    }
                    
                    let presidentOps = self.generateBuyOperations(shareAmount: self.gameState.presidentCertificateShareAmount, andSingleShareAmount: Double(parValue), andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: self.gameState.shareStartingLocation.getBankIndex() ?? cmpIdx, andShareDstGlobalIndex: self.operatingPlayerIndex)
                    self.operationsByTag.append(presidentOps)
                    
                }
                
//                self.view.addSubview(secondaryStackView)
//                secondaryStackView.translatesAutoresizingMaskIntoConstraints = false
//                secondaryStackView.topAnchor.constraint(equalTo: self.buyOpsStackView.bottomAnchor, constant: 20.0).isActive = true
//                secondaryStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                
                self.verticalOuterStackView.insertArrangedSubview(secondaryStackView, at: 3)
                self.verticalOuterStackView.insertArrangedSubview(thirdStackView, at: 4)
                
                self.secondaryStackView = secondaryStackView
                self.thirdStackView = thirdStackView
                
            } else if PARValues.count > 4 {
                
                let secondaryStackView = UIStackView()
                secondaryStackView.axis = .horizontal
                secondaryStackView.spacing = 20.0
                
                for (i, parValue) in PARValues.enumerated() {
                    let presidentShareBtn = UIButton(type: .custom)
                    presidentShareBtn.tag = i
                    
                    presidentShareBtn.setTitle(withText: "\(Int(self.gameState.presidentCertificateShareAmount))x PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(parValue)))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                    presidentShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                    
                    presidentShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                    presidentShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                    
                    presidentShareBtn.addTarget(self, action: #selector(self.presidentButtonPressed(sender:)), for: .touchUpInside)
                    
                    if i < PARValues.count / 2 {
                        self.buyOpsStackView.addArrangedSubview(presidentShareBtn)
                    } else {
                        secondaryStackView.addArrangedSubview(presidentShareBtn)
                    }
                    
                    let presidentOps = self.generateBuyOperations(shareAmount: self.gameState.presidentCertificateShareAmount, andSingleShareAmount: Double(parValue), andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: self.gameState.shareStartingLocation.getBankIndex() ?? cmpIdx, andShareDstGlobalIndex: self.operatingPlayerIndex)
                    self.operationsByTag.append(presidentOps)
                    
                }
                
//                self.view.addSubview(secondaryStackView)
//                secondaryStackView.translatesAutoresizingMaskIntoConstraints = false
//                secondaryStackView.topAnchor.constraint(equalTo: self.buyOpsStackView.bottomAnchor, constant: 20.0).isActive = true
//                secondaryStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                
                self.verticalOuterStackView.insertArrangedSubview(secondaryStackView, at: 3)
                
                self.secondaryStackView = secondaryStackView
                
            } else {
                
                for (i, parValue) in PARValues.enumerated() {
                    let presidentShareBtn = UIButton(type: .custom)
                    presidentShareBtn.tag = i
                    
                    presidentShareBtn.setTitle(withText: "\(Int(self.gameState.presidentCertificateShareAmount))x PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: Double(parValue)))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                    presidentShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                    
                    presidentShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                    presidentShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                    
                    presidentShareBtn.addTarget(self, action: #selector(self.presidentButtonPressed(sender:)), for: .touchUpInside)
                    
                    self.buyOpsStackView.addArrangedSubview(presidentShareBtn)
                    
                    let presidentOps = self.generateBuyOperations(shareAmount: self.gameState.presidentCertificateShareAmount, andSingleShareAmount: Double(parValue), andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: self.gameState.shareStartingLocation.getBankIndex() ?? cmpIdx, andShareDstGlobalIndex: self.operatingPlayerIndex)
                    self.operationsByTag.append(presidentOps)
                }
            }
        } else {
            
            // handle 0.5 shares
            
            let shareAvailableInIpo = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[cmpBaseIdx] > 0
            let shareAvailableInBank = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.bank.rawValue)[cmpBaseIdx] > 0
            let shareAvailableInCmp = self.gameState.getSharesPortfolioForCompany(atIndex: cmpIdx)[cmpBaseIdx] > 0
            let shareAvailableInTradeIn = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.tradeIn.rawValue)[cmpBaseIdx] > 0
            let shareAvailableInAside = self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.aside.rawValue)[cmpBaseIdx] > 0
            
            let marketPrice = self.gameState.getShareValue(forCompanyAtBaseIndex: cmpBaseIdx) ?? 0.0
            let PARPrice = Double(self.gameState.getPARvalue(forCompanyAtBaseIndex: cmpBaseIdx) ?? 0)
            
            let ipoPrice = self.gameState.sharesFromIPOHavePARprice ? PARPrice : marketPrice
            let bankPrice = self.gameState.sharesFromBankHavePARprice ? PARPrice : marketPrice
            let compPrice = self.gameState.sharesFromCompHavePARprice ? PARPrice : marketPrice
            let tradeInPrice = self.gameState.sharesFromTradeInHavePARprice ? PARPrice : marketPrice
            let asidePrice = self.gameState.sharesFromAsideHavePARprice ? PARPrice : marketPrice
            
            var tagCounter = 0
            
            if shareAvailableInIpo && ipoPrice != 0.0 {
                let buyShareBtn = UIButton(type: .custom)
                buyShareBtn.tag = tagCounter
                
                buyShareBtn.setTitle(withText: "IPO: \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: ipoPrice))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                buyShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                
                buyShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                buyShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                
                buyShareBtn.addTarget(self, action: #selector(self.buyButtonPressed(sender:)), for: .touchUpInside)
                
                self.buyOpsStackView.addArrangedSubview(buyShareBtn)
                tagCounter += 1
                
                let buyOps = self.generateBuyOperations(shareAmount: 1.0, andSingleShareAmount: ipoPrice, andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: BankIndex.ipo.rawValue, andShareDstGlobalIndex: self.operatingPlayerIndex)
                self.operationsByTag.append(buyOps)
            }
            
            if shareAvailableInBank && bankPrice != 0.0 {
                let buyShareBtn = UIButton(type: .custom)
                buyShareBtn.tag = tagCounter
                
                buyShareBtn.setTitle(withText: "Bank: \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: bankPrice))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                buyShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                
                buyShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                buyShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                
                buyShareBtn.addTarget(self, action: #selector(self.buyButtonPressed(sender:)), for: .touchUpInside)
                
                self.buyOpsStackView.addArrangedSubview(buyShareBtn)
                tagCounter += 1
                
                let buyOps = self.generateBuyOperations(shareAmount: 1.0, andSingleShareAmount: bankPrice, andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: BankIndex.bank.rawValue, andShareDstGlobalIndex: self.operatingPlayerIndex)
                self.operationsByTag.append(buyOps)
            }
            
            if shareAvailableInCmp && compPrice != 0.0 {
                let buyShareBtn = UIButton(type: .custom)
                buyShareBtn.tag = tagCounter
                
                buyShareBtn.setTitle(withText: "Comp: \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: compPrice))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                buyShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                
                buyShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                buyShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                
                buyShareBtn.addTarget(self, action: #selector(self.buyButtonPressed(sender:)), for: .touchUpInside)
                
                self.buyOpsStackView.addArrangedSubview(buyShareBtn)
                tagCounter += 1
                
                let buyOps = self.generateBuyOperations(shareAmount: 1.0, andSingleShareAmount: compPrice, andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: cmpIdx, andShareDstGlobalIndex: self.operatingPlayerIndex)
                self.operationsByTag.append(buyOps)
            }
            
            if shareAvailableInTradeIn && tradeInPrice != 0.0 {
                let buyShareBtn = UIButton(type: .custom)
                buyShareBtn.tag = tagCounter
                
                buyShareBtn.setTitle(withText: "TradeIn: \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: tradeInPrice))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                buyShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                
                buyShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                buyShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                
                buyShareBtn.addTarget(self, action: #selector(self.buyButtonPressed(sender:)), for: .touchUpInside)
                
                self.buyOpsStackView.addArrangedSubview(buyShareBtn)
                tagCounter += 1
                
                let buyOps = self.generateBuyOperations(shareAmount: 1.0, andSingleShareAmount: tradeInPrice, andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: BankIndex.tradeIn.rawValue, andShareDstGlobalIndex: self.operatingPlayerIndex)
                self.operationsByTag.append(buyOps)
            }
            
            if shareAvailableInAside && asidePrice != 0.0 {
                let buyShareBtn = UIButton(type: .custom)
                buyShareBtn.tag = tagCounter
                
                buyShareBtn.setTitle(withText: "Aside: \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: asidePrice))", fontSize: 21.0, fontWeight: .semibold, textColor: UIColor.white)
                buyShareBtn.setBackgroundColor(UIColor.primaryAccentColor, isRectangularShape: true)
                
                buyShareBtn.widthAnchor.constraint(equalToConstant: 220.0).isActive = true
                buyShareBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
                
                buyShareBtn.addTarget(self, action: #selector(self.buyButtonPressed(sender:)), for: .touchUpInside)
                
                self.buyOpsStackView.addArrangedSubview(buyShareBtn)
                tagCounter += 1
                
                let buyOps = self.generateBuyOperations(shareAmount: 1.0, andSingleShareAmount: asidePrice, andShareCmpIndex: cmpIdx, andSrcGlobalIndex: self.operatingPlayerIndex, andDstGlobalIndex: BankIndex.bank.rawValue, andShareSrcGlobalIndex: BankIndex.aside.rawValue, andShareDstGlobalIndex: self.operatingPlayerIndex)
                self.operationsByTag.append(buyOps)
            }
            
        }
    }
    
    @IBAction func activateCustomBuyVC(sender: UIButton) {
        self.parentVC.loadCustomBuyVC()
    }
    
    @IBAction func presidentButtonPressed(sender: UIButton) {
        if sender.tag < self.operationsByTag.count {
            let companionOperations = self.operationsByTag[sender.tag]
            
            if !self.gameState.areOperationsLegit(operations: companionOperations, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
            
            for op in companionOperations {
                if !self.gameState.perform(operation: op) {
                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                    return
                }
            }
            
            if companionOperations.contains(where: { $0.type == .float }) {
                if let buyOp = companionOperations.first(where: { $0.type == .buy }), let cmpBaseIdx = buyOp.shareCompanyBaseIndex {
                    var messageStr = "\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) floated"
                    if companionOperations.contains(where: { $0.type == .tokens }) {
                        messageStr += " (and paid float fees)"
                    } else if companionOperations.contains(where: { $0.type == .cash && $0.sourceGlobalIndex == BankIndex.bank.rawValue && ($0.amount ?? 0) > 0 }) {
                        messageStr += " (and received float bonus)"
                    }
                    
                    HomeViewController.presentSnackBar(withMessage: messageStr)
                }
            }
            
            self.parentVC.doneButtonPressed(sender: UIButton())
        }
    }
    
    @IBAction func buyButtonPressed(sender: UIButton) {
        if sender.tag < self.operationsByTag.count {
            let companionOperations = self.operationsByTag[sender.tag]
            
            if !self.gameState.areOperationsLegit(operations: companionOperations, reverted: false) {
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
                
            for op in companionOperations {
                if !self.gameState.perform(operation: op) {
                    let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                    return
                }
            }
            
            if companionOperations.contains(where: { $0.type == .float }) {
                if let buyOp = companionOperations.first(where: { $0.type == .buy }), let cmpBaseIdx = buyOp.shareCompanyBaseIndex {
                    var messageStr = "\(self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)) floated"
                    if companionOperations.contains(where: { $0.type == .tokens }) {
                        messageStr += " (and paid float fees)"
                    } else if companionOperations.contains(where: { $0.type == .cash && $0.sourceGlobalIndex == BankIndex.bank.rawValue && ($0.amount ?? 0) > 0 }) {
                        messageStr += " (and received float bonus)"
                    }
                    
                    HomeViewController.presentSnackBar(withMessage: messageStr)
                }
            }
            
            self.parentVC.doneButtonPressed(sender: UIButton())
        }
    }
    
    
    func generateBuyOperations(shareAmount: Double, andSingleShareAmount: Double, andShareCmpIndex: Int, andSrcGlobalIndex: Int, andDstGlobalIndex: Int, andShareSrcGlobalIndex: Int, andShareDstGlobalIndex: Int) -> [Operation] {
        
        var buyOps: [Operation] = []
        
        var amount: Double = 0.0
        
        if self.gameState.buySellRoundPolicyOnTotal == .roundUp {
            amount = ceil(andSingleShareAmount * shareAmount)
        } else {
            amount = floor(andSingleShareAmount * shareAmount)
        }
        
        let shareCmpIndex: Int = andShareCmpIndex
        let shareCmpBaseIndex: Int = self.gameState.forceConvert(index: shareCmpIndex, backwards: true, withIndexType: .companies)

        let srcGlobalIndex: Int = andSrcGlobalIndex
        var dstGlobalIndex: Int = andDstGlobalIndex
        
        let shareSrcGlobalIndex: Int = andShareSrcGlobalIndex
        let shareDstGlobalIndex: Int = andShareDstGlobalIndex
        
        if shareSrcGlobalIndex == BankIndex.ipo.rawValue && !self.gameState.buyShareFromIPOPayBank {
            dstGlobalIndex = shareCmpIndex
        } else if shareSrcGlobalIndex == BankIndex.bank.rawValue && !self.gameState.buyShareFromBankPayBank {
            dstGlobalIndex = shareCmpIndex
        } else if self.gameState.getCompanyIndexes().contains(shareSrcGlobalIndex) && !self.gameState.buyShareFromCompPayBank {
            dstGlobalIndex = shareCmpIndex
        }
        
        if let g1856companiesStatus = self.gameState.g1856CompaniesStatus {
            switch g1856companiesStatus[shareCmpBaseIndex] {
            case .incrementalCapitalizationCapped:
                if shareSrcGlobalIndex == BankIndex.ipo.rawValue && self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: BankIndex.ipo.rawValue)[shareCmpBaseIndex] > 5 {
                    dstGlobalIndex = shareCmpIndex
                } else {
                    dstGlobalIndex = BankIndex.bank.rawValue
                }
                break
            case .incrementalCapitalization:
                dstGlobalIndex = shareCmpIndex
                break
            case .fullCapitalization:
                dstGlobalIndex = BankIndex.bank.rawValue
                break
            }
        }
        
        let operation = Operation(type: .buy, uid: nil)
        operation.addCashDetails(sourceIndex: srcGlobalIndex, destinationIndex: dstGlobalIndex, amount: amount)
        operation.addSharesDetails(shareSourceIndex: shareSrcGlobalIndex, shareDestinationIndex: shareDstGlobalIndex, shareAmount: shareAmount, shareCompanyBaseIndex: shareCmpBaseIndex, sharePreviousPresidentGlobalIndex: self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: shareCmpBaseIndex))
        
        buyOps.append(operation)
        
        // should set PAR value?
        if self.gameState.getCompanyType(atBaseIndex: shareCmpBaseIndex).isShareValueTokenOnBoard() {
            if self.gameState.getShareValue(forCompanyAtBaseIndex: shareCmpBaseIndex) == nil {
                if let parIdx = self.gameState.getPARindex(fromShareValue: andSingleShareAmount) {
                    let op = Operation(type: .market, uid: operation.uid)
                    op.setOperationColorGlobalIndex(colorGlobalIndex: shareCmpIndex)
                    op.addMarketDetails(marketShareValueCmpBaseIndex: shareCmpBaseIndex, marketShareValueFromIndex: nil, marketShareValueToIndex: parIdx, marketLogStr: "\(self.gameState.getCompanyLabel(atBaseIndex: shareCmpBaseIndex)) -> PAR \(self.gameState.currencyType.getCurrencyStringFromAmount(amount: andSingleShareAmount, shouldTruncateDouble: true))")
                    
                    buyOps.append(op)
                }
            }
        }
        
        // should Float company?
        if !self.gameState.isCompanyFloated(atBaseIndex: shareCmpBaseIndex) && self.gameState.getCompanyType(atBaseIndex: shareCmpBaseIndex).canBeFloatedByPlayers() {
            let startingLocationGlobalIndex = self.gameState.shareStartingLocation.getBankIndex() ?? shareCmpIndex
                
            if shareSrcGlobalIndex == startingLocationGlobalIndex {
                if (self.gameState.getTotalShareNumberOfCompany(atBaseIndex: shareCmpBaseIndex) - (self.gameState.getSharesPortfolioForBankEntity(atBaseIndexOrIndex: startingLocationGlobalIndex)[shareCmpBaseIndex] - shareAmount)) >= Double(self.gameState.requiredNumberOfSharesToFloat) {
                    
                    let PARValues = self.gameState.getGamePARValues()
                    var floatAmount: Double = 0.0
                    if (self.gameState.buyShareFromIPOPayBank && self.gameState.buyShareFromCompPayBank) {
                        // is total capitalization
                        if PARValues.contains(Int(andSingleShareAmount)) {
                            floatAmount = andSingleShareAmount * 10
                            
                        } else if let PARvalue = self.gameState.getPARvalue(forCompanyAtBaseIndex: shareCmpBaseIndex) {
                            
                            if PARValues.contains(PARvalue) {
                                floatAmount = Double(PARvalue * 10)
                            }
                        }
                    }
                    
                    if self.gameState.game == .g1846 && self.gameState.getCompanyLabel(atIndex: shareCmpIndex) == "IC" {
                        self.gameState.floatModifiers[shareCmpBaseIndex] = self.gameState.getPARvalue(forCompanyAtBaseIndex: shareCmpBaseIndex) ?? Int(andSingleShareAmount)
                    }
                    
                    let floatOps = CompanyFloatViewController.generateFloatOperationsWithAmount(floatAmount: Int(floatAmount), forCompanyAtIndex: shareCmpIndex, andGameState: self.gameState)
                        
                    buyOps += floatOps
                }
            }
        }
        
        return buyOps
        
    }

    func commitButtonPressed() -> Bool? {
        return true
    }

}
