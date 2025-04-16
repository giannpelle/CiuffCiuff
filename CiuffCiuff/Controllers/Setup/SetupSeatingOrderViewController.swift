//
//  SetupRoundTableViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 31/03/25.
//

import UIKit

class SetupSeatingOrderViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var randomizeButton: UIButton!
    
    @IBOutlet var playersPopupButtons: [UIButton]!
    
    var gameState: GameState!
    var game: Game!
    var turnOrderType: PlayerTurnOrderType!
    var players: [String]!
    
    var activePopupButtonSortedIndexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.randomizeButton.setTitle(withText: "   Randomize", fontSize: 19.0, fontWeight: .semibold, textColor: UIColor.white)
        self.randomizeButton.setBackgroundColor(UIColor.tertiaryAccentColor)
        
        switch self.players.count {
        case 2:
            self.activePopupButtonSortedIndexes = [0, 2]
        case 3:
            self.activePopupButtonSortedIndexes = [0, 1, 4]
        case 4:
            self.activePopupButtonSortedIndexes = [0, 1, 2, 4]
        case 5:
            self.activePopupButtonSortedIndexes = [0, 1, 2, 3, 4]
        case 6:
            self.activePopupButtonSortedIndexes = [0, 1, 2, 3, 4, 5]
        default:
            break
        }
        
        for (i, btn) in self.playersPopupButtons.enumerated() {
            if self.activePopupButtonSortedIndexes.contains(i) {
                btn.isHidden = false
                
                var titleStr = ""
                
                var playersActions: [UIAction] = []
                for playerBaseIdx in 0..<self.players.count {
                    if playerBaseIdx == (self.activePopupButtonSortedIndexes.firstIndex(of: i) ?? 0) {
                        titleStr = self.players[playerBaseIdx]
                        playersActions.append(UIAction(title: titleStr, image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), state: .on, handler: { action in
                            self.updatePopupButtons(ignoringPopupBaseIdx: i, andPlayerBaseIdx: playerBaseIdx)
                            self.playersPopupButtons[i].setPopupTitle(withText: action.title, textColor: UIColor.white)
                        }))
                    } else {
                        playersActions.append(UIAction(title: self.players[playerBaseIdx], image: UIImage.circle(diameter: 20.0, color: UIColor.primaryAccentColor), handler: { action in
                            self.updatePopupButtons(ignoringPopupBaseIdx: i, andPlayerBaseIdx: playerBaseIdx)
                            self.playersPopupButtons[i].setPopupTitle(withText: action.title, textColor: UIColor.white)
                        }))
                    }
                }
                
                if playersActions.isEmpty {
                    btn.isHidden = true
                } else {
                    btn.isHidden = false
                    
                    if playersActions.count == 1 {
                        btn.setBackgroundColor(UIColor.systemGray2)
                        btn.setPopupTitle(withText: titleStr, textColor: UIColor.white)
                    } else {
                        btn.setBackgroundColor(UIColor.primaryAccentColor)
                        btn.setPopupTitle(withText: titleStr, textColor: UIColor.white)
                    }
                    
                    btn.menu = UIMenu(children: playersActions)
                    btn.showsMenuAsPrimaryAction = true
                    btn.changesSelectionAsPrimaryAction = true
                }
                
            } else {
                btn.isHidden = true
            }
        }
    }
    
    func updatePopupButtons(ignoringPopupBaseIdx: Int, andPlayerBaseIdx playerBaseIdx: Int) {
        
        var visiblePlayerNames: Set<String> = []
        
        for (i, btn) in self.playersPopupButtons.enumerated() {
            if self.activePopupButtonSortedIndexes.contains(i) {
                if let name = btn.currentTitle, name != "" {
                    visiblePlayerNames.insert(name)
                }
            }
        }
        
        if let nameToBeReplaced = Set<String>(self.players).subtracting(visiblePlayerNames).first {
            for (i, btn) in self.playersPopupButtons.enumerated() {
                if self.activePopupButtonSortedIndexes.contains(i) {
                    if i != ignoringPopupBaseIdx && self.players[playerBaseIdx] == btn.currentTitle {
                        btn.forceSelectedIndex(self.players.firstIndex(of: nameToBeReplaced) ?? 0)
                        btn.setPopupTitle(withText: nameToBeReplaced, textColor: UIColor.white)
                    }
                }
            }
        }
        
    }
    
    @IBAction func randomizeButtonPressed(sender: UIButton) {
        let randomPlayers = self.players.shuffled()
        
        var counter = 0
        for (i, btn) in self.playersPopupButtons.enumerated() {
            if self.activePopupButtonSortedIndexes.contains(i) {
                if let idx = self.players.firstIndex(of: randomPlayers[counter]) {
                    btn.forceSelectedIndex(idx)
                    btn.setPopupTitle(withText: randomPlayers[counter], textColor: UIColor.white)
                }
                
                counter += 1
            }
        }
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        
        let oldPlayersSet = Set<String>(self.players)
        
        var newPlayersSet: Set<String> = []
        for (i, btn) in self.playersPopupButtons.enumerated() {
            if self.activePopupButtonSortedIndexes.contains(i) {
                newPlayersSet.insert(btn.currentTitle ?? "")
            }
        }
        
        guard oldPlayersSet == newPlayersSet else {
            return
        }
        
        var newPlayers: [String] = []
        for (i, btn) in self.playersPopupButtons.enumerated() {
            if self.activePopupButtonSortedIndexes.contains(i) {
                newPlayers.append(btn.currentTitle ?? "")
            }
        }
        
        let setupRulesVC = storyboard?.instantiateViewController(withIdentifier: "setupRulesViewController") as! SetupRulesViewController
        setupRulesVC.gameState = gameState
        setupRulesVC.turnOrderType = turnOrderType
        setupRulesVC.players = newPlayers
        setupRulesVC.game = self.game
        setupRulesVC.modalTransitionStyle = .crossDissolve
        
        self.present(setupRulesVC, animated: true)
    }
}
