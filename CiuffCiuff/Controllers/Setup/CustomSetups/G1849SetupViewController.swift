//
//  G1849SetupViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 21/10/24.
//

import UIKit

class G1849SetupViewController: UIViewController {
    
    var gameState: GameState!
    var game: Game!
    var turnOrderType: PlayerTurnOrderType!
    var players: [String]!
    
    var presidentCompanyIndexes: [Int] = []
    var excludedCompanyIndexes: [Int] = []
    var suggestedCompanyBaseIndexes: [Int] = []
    
    var excludedCompanyBaseIndex: Int? = nil
    var presidentCompanyBaseIndex: Int = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var suggestedCompaniesStackView: UIStackView!
    
    @IBOutlet weak var presidentCertificateCompanyPopupButton: UIButton!
    @IBOutlet weak var excludedCompanyPopupButton: UIButton!
    @IBOutlet weak var excludedCompanyStackView: UIStackView!
    @IBOutlet weak var excludedCompanyRerollButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.presidentCompanyIndexes = Array<Int>(self.gameState.getCompanyIndexes())
        self.excludedCompanyIndexes = [-1] + self.gameState.getCompanyIndexes()
        self.suggestedCompanyBaseIndexes = Array<Int>(0..<self.gameState.companiesSize).shuffled()
        
        self.setupPopupButtons()
        
        if self.players.count == 3 {
            let cmpBaseIndex = Int.random(in: 0..<self.gameState.companiesSize)
            
            self.excludedCompanyPopupButton.forceSelectedIndex(cmpBaseIndex + 1)
            self.excludedCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIndex), textColor: self.gameState.getCompanyTextColor(atBaseIndex: cmpBaseIndex))
            self.excludedCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atBaseIndex: cmpBaseIndex))
            
            self.excludedCompanyBaseIndex = cmpBaseIndex
        }
        
        self.excludedCompanyStackView.isHidden = self.players.count == 5
        self.excludedCompanyRerollButton.isHidden = self.players.count == 5
        
        let cmpBaseIndex = self.suggestedCompanyBaseIndexes.last ?? 0
        self.presidentCertificateCompanyPopupButton.forceSelectedIndex(cmpBaseIndex)
        self.presidentCertificateCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIndex), textColor: self.gameState.getCompanyTextColor(atBaseIndex: cmpBaseIndex))
        self.presidentCertificateCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atBaseIndex: cmpBaseIndex))
        
        self.presidentCompanyBaseIndex = cmpBaseIndex
        
        self.drawSuggestedCompanies()
        
    }
    
    func drawSuggestedCompanies() {
        for (i, view) in self.suggestedCompaniesStackView.arrangedSubviews.enumerated() {
            if let label = view as? PaddingLabel {
                let cmpBaseIdx = self.suggestedCompanyBaseIndexes[i]
                
                if cmpBaseIdx == self.excludedCompanyBaseIndex {
                    label.isHidden = true
                    continue
                }
                
                label.isHidden = false
                label.font = UIFont.systemFont(ofSize: 19.0, weight: .semibold)
                label.text = self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx)
                label.textColor = self.gameState.getCompanyTextColor(atBaseIndex: cmpBaseIdx)
                label.backgroundColor = self.gameState.getCompanyColor(atBaseIndex: cmpBaseIdx)
                
                label.paddingLeft = 8.0
                label.paddingRight = 8.0
                label.paddingTop = 4.0
                label.paddingBottom = 4.0
            }
        }
    }
    
    func setupPopupButtons() {
        
        var presidentActions: [UIAction] = []
        for (i, presidentCompanyIdx) in self.presidentCompanyIndexes.enumerated() {
            if i == 0 {
                presidentActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: presidentCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: presidentCompanyIdx)), state: .on, handler: {action in
                    let cmpBaseIdx = self.gameState.getBaseIndex(forEntity: action.title)
                    self.updatePresidentCompanyBaseIndex(cmpBaseIdx: cmpBaseIdx)
                }))
            } else {
                presidentActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: presidentCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: presidentCompanyIdx)), handler: {action in
                    let cmpBaseIdx = self.gameState.getBaseIndex(forEntity: action.title)
                    self.updatePresidentCompanyBaseIndex(cmpBaseIdx: cmpBaseIdx)
                }))
            }
        }
        
        if presidentActions.isEmpty {
            self.presidentCertificateCompanyPopupButton.isHidden = true
        } else {
            self.presidentCertificateCompanyPopupButton.isHidden = false
            if presidentActions.count == 1 {
                self.presidentCertificateCompanyPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.presidentCertificateCompanyPopupButton.setPopupTitle(withText: presidentActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.presidentCertificateCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atIndex: self.presidentCompanyIndexes[0]))
                self.presidentCertificateCompanyPopupButton.setPopupTitle(withText: presidentActions.first?.title ?? "", textColor: self.gameState.getCompanyTextColor(atIndex: self.presidentCompanyIndexes[0]))
            }
            
            self.presidentCertificateCompanyPopupButton.menu = UIMenu(children: presidentActions)
            self.presidentCertificateCompanyPopupButton.showsMenuAsPrimaryAction = true
            self.presidentCertificateCompanyPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        
        var excludedActions: [UIAction] = []
        for (i, excludedCompanyIdx) in self.excludedCompanyIndexes.enumerated() {
            if i == 0 {
                excludedActions.append(UIAction(title: "no exclusion", image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: {action in
                    let cmpBaseIdx = self.gameState.getBaseIndex(forEntity: action.title)
                    self.updateExcludedCompanyBaseIndex(cmpBaseIdx: cmpBaseIdx)
                }))
            } else {
                excludedActions.append(UIAction(title: self.gameState.getCompanyLabel(atIndex: excludedCompanyIdx), image: UIImage.circle(diameter: 20.0, color: self.gameState.getCompanyColor(atIndex: excludedCompanyIdx)), handler: {action in
                    let cmpBaseIdx = self.gameState.getBaseIndex(forEntity: action.title)
                    self.updateExcludedCompanyBaseIndex(cmpBaseIdx: cmpBaseIdx)
                }))
            }
        }
        
        if excludedActions.isEmpty {
            self.excludedCompanyPopupButton.isHidden = true
        } else {
            self.excludedCompanyPopupButton.isHidden = false
            if excludedActions.count == 1 {
                self.excludedCompanyPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.excludedCompanyPopupButton.setPopupTitle(withText: excludedActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.excludedCompanyPopupButton.setBackgroundColor(self.excludedCompanyIndexes[0] == -1 ? UIColor.primaryAccentColor : self.gameState.getCompanyColor(atIndex: self.excludedCompanyIndexes[0]))
                self.excludedCompanyPopupButton.setPopupTitle(withText: excludedActions.first?.title ?? "", textColor: self.excludedCompanyIndexes[0] == -1 ? UIColor.white : self.gameState.getCompanyTextColor(atIndex: self.excludedCompanyIndexes[0]))
            }
            
            self.excludedCompanyPopupButton.menu = UIMenu(children: excludedActions)
            self.excludedCompanyPopupButton.showsMenuAsPrimaryAction = true
            self.excludedCompanyPopupButton.changesSelectionAsPrimaryAction = true
        }
    }
    
    @IBAction func randomP5PresidentCertificateButtonPressed(sender: UIButton) {
        let cmpBaseIndexes: [Int] = Array<Int>(0..<self.gameState.companiesSize).filter { self.excludedCompanyBaseIndex != $0 }
        let randomCmpBaseIdx = cmpBaseIndexes.randomElement() ?? 0
        
        self.presidentCertificateCompanyPopupButton.forceSelectedIndex(randomCmpBaseIdx)
        self.updatePresidentCompanyBaseIndex(cmpBaseIdx: randomCmpBaseIdx)
    }
    
    func updatePresidentCompanyBaseIndex(cmpBaseIdx: Int) {
        self.presidentCertificateCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atBaseIndex: cmpBaseIdx))
        self.presidentCertificateCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx), textColor: self.gameState.getCompanyTextColor(atBaseIndex: cmpBaseIdx))
        
        self.presidentCompanyBaseIndex = cmpBaseIdx
        
        self.suggestedCompanyBaseIndexes = self.suggestedCompanyBaseIndexes.filter { $0 != cmpBaseIdx }.shuffled() + [cmpBaseIdx]
        self.drawSuggestedCompanies()
    }
    
    @IBAction func randomExcludedCompanyButtonPressed(sender: UIButton) {
        let randomCmpBaseIdx = Int.random(in: 0..<self.gameState.companiesSize)
        
        self.excludedCompanyPopupButton.forceSelectedIndex(randomCmpBaseIdx + 1)
        self.updateExcludedCompanyBaseIndex(cmpBaseIdx: randomCmpBaseIdx)
    }
    
    func updateExcludedCompanyBaseIndex(cmpBaseIdx: Int) {
        if cmpBaseIdx == -1 {
            self.excludedCompanyPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
            self.excludedCompanyPopupButton.setPopupTitle(withText: "no exclusion", textColor: UIColor.white)
            
            self.excludedCompanyBaseIndex = nil
            self.presidentCertificateCompanyPopupButton.isUserInteractionEnabled = true
            self.presidentCertificateCompanyPopupButton.alpha = 1.0
        } else {
            self.excludedCompanyPopupButton.setBackgroundColor(self.gameState.getCompanyColor(atBaseIndex: cmpBaseIdx))
            self.excludedCompanyPopupButton.setPopupTitle(withText: self.gameState.getCompanyLabel(atBaseIndex: cmpBaseIdx), textColor: self.gameState.getCompanyTextColor(atBaseIndex: cmpBaseIdx))
            
            self.excludedCompanyBaseIndex = cmpBaseIdx
            self.presidentCertificateCompanyPopupButton.isUserInteractionEnabled = false
            self.presidentCertificateCompanyPopupButton.alpha = 0.5
            
            if self.presidentCompanyBaseIndex == cmpBaseIdx {
                self.randomP5PresidentCertificateButtonPressed(sender: UIButton())
            }
        }
        
        self.drawSuggestedCompanies()
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        
        if self.excludedCompanyBaseIndex == nil && self.players.count == 3 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "In a 3p game you must exclude a company from play")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if self.excludedCompanyBaseIndex == self.presidentCompanyBaseIndex {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "P5 cannot come with the president share of the excluded company")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            
            return
        }
        
        let gameMetadata = self.game.getMetadata()
        
        let activeCompanies = (self.suggestedCompanyBaseIndexes).filter { $0 != self.excludedCompanyBaseIndex }
        
        var overrideMetadata: [String: Any] = [String: Any]()
        overrideMetadata["companies"] = activeCompanies.map { (gameMetadata["companies"] as! [String])[$0] }
        overrideMetadata["floatModifiers"] = activeCompanies.map { (gameMetadata["floatModifiers"] as! [Int])[$0] }
        overrideMetadata["companiesTypes"] = activeCompanies.map { (gameMetadata["companiesTypes"] as! [CompanyType])[$0] }
        overrideMetadata["compTotShares"] = activeCompanies.map { (gameMetadata["compTotShares"] as! [Double])[$0] }
        overrideMetadata["compLogos"] = activeCompanies.map { (gameMetadata["compLogos"] as! [String])[$0] }
        overrideMetadata["compColors"] = activeCompanies.map { (gameMetadata["compColors"] as! [UIColor])[$0] }
        overrideMetadata["compTextColors"] = activeCompanies.map { (gameMetadata["compTextColors"] as! [UIColor])[$0] }
        
        overrideMetadata["certificateLimit"] = (self.excludedCompanyBaseIndex == nil ? [0, 12, 11, 9, 0] : [0, 12, 9, 9, 0]) as [Double]
        
        let gameState = GameState(game: self.game, turnOrderType: self.turnOrderType, players: self.players, customOverrides: overrideMetadata)
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
        nextVC.gameState = gameState
        nextVC.userSelectedCompany = self.gameState.getCompanyLabel(atBaseIndex: self.presidentCompanyBaseIndex)
        nextVC.modalTransitionStyle = .crossDissolve
        
        self.present(nextVC, animated: true)
        
    }

}
