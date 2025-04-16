//
//  SetupRulesViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 17/11/24.
//

import UIKit

class SetupRulesViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rulesTextView: UITextView!
    
    var gameState: GameState!
    var game: Game!
    var turnOrderType: PlayerTurnOrderType!
    var players: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)

        self.titleLabel.text = "\(self.gameState.game.rawValue) rules"

        let rulesStr = self.gameState.rulesText as NSString
        
        let components = rulesStr.components(separatedBy: "@")
        
        let attributedText = NSMutableAttributedString()
        
        let littleLineSpacingParagraphStyle = NSMutableParagraphStyle()
        littleLineSpacingParagraphStyle.lineSpacing = 2.5
        
        for component in components where !component.isEmpty {
            let componentStr = String(Array(component)[1...])
            
            if component.first! == "n" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0)]))
            } else if component.first! == "b" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier-Bold", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0)]))
            } else if component.first! == "u" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0, weight: .regular), NSAttributedString.Key.underlineStyle: 1]))
            } else if component.first! == "l" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)]))
            }
        }
        
        attributedText.addAttribute(.paragraphStyle, value: littleLineSpacingParagraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        self.rulesTextView.isEditable = false
        self.rulesTextView.attributedText = attributedText
        self.rulesTextView.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        self.rulesTextView.backgroundColor = UIColor.systemGray6
        self.rulesTextView.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.rulesTextView.layer.borderWidth = 3
        self.rulesTextView.layer.cornerRadius = 8
        self.rulesTextView.clipsToBounds = true
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
            
        switch self.gameState.game {
        case .g1830:
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "g1830SetupViewController") as! G1830SetupViewController
            nextVC.game = game
            nextVC.turnOrderType = turnOrderType
            nextVC.players = players
            nextVC.gameState = gameState
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
            
        case .g1840:
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "g1840SetupViewController") as! G1840SetupViewController
            nextVC.game = game
            nextVC.turnOrderType = turnOrderType
            nextVC.players = players
            nextVC.gameState = gameState
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
            
        case .g1846:
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "g1846SetupViewController") as! G1846SetupViewController
            nextVC.game = game
            nextVC.turnOrderType = turnOrderType
            nextVC.players = players
            nextVC.gameState = gameState
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
            
        case .g1849:
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "g1849SetupViewController") as! G1849SetupViewController
            nextVC.game = game
            nextVC.turnOrderType = turnOrderType
            nextVC.players = players
            nextVC.gameState = gameState
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
            
        case .g1889:
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
            
            let gameMetadata = game.getMetadata()
            
            var overrideMetadata: [String: Any] = [String: Any]()
            let privatesPrices = gameMetadata["privatesPrices"] as! [Double]
            let privatesIncomes = gameMetadata["privatesIncomes"] as! [Double]
            
            if players.count == 2 {
                overrideMetadata["privatesPrices"] = (0..<privatesPrices.count - 2).map { privatesPrices[$0] }
                overrideMetadata["privatesIncomes"] = (0..<privatesIncomes.count - 2).map { privatesIncomes[$0] }
            } else if players.count == 3 {
                overrideMetadata["privatesPrices"] = (0..<privatesPrices.count - 1).map { privatesPrices[$0] }
                overrideMetadata["privatesIncomes"] = (0..<privatesIncomes.count - 1).map { privatesIncomes[$0] }
            }
            
            let g1889GameState = GameState(game: game, turnOrderType: self.turnOrderType, players: players, customOverrides: overrideMetadata)
            nextVC.gameState = g1889GameState
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
            
        case .g18Chesapeake:
            
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "g18ChSetupViewController") as! G18ChSetupViewController
            nextVC.game = game
            nextVC.turnOrderType = turnOrderType
            nextVC.players = players
            nextVC.gameState = gameState
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
            
        case .g18MEX:

            let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
            
            nextVC.gameState = gameState
            nextVC.modalTransitionStyle = .crossDissolve
            
            self.present(nextVC, animated: true)
            
        case .g1848, .g1856, .g1882:
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
            nextVC.gameState = gameState
            nextVC.modalTransitionStyle = .crossDissolve
            
            self.present(nextVC, animated: true)
        }
        
    }
    

}
