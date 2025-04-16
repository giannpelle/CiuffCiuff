//
//  G18ChSetupViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 17/03/25.
//

import UIKit

class G18ChSetupViewController: UIViewController {
    
    var gameState: GameState!
    var game: Game!
    var turnOrderType: PlayerTurnOrderType!
    var players: [String]!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var offTheRailsSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.backButton.setTitle(withText: "Back", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.backButton.setBackgroundColor(UIColor.redAccentColor)
        self.continueButton.setTitle(withText: "Continue", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.continueButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.offTheRailsSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.offTheRailsSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.offTheRailsSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.offTheRailsSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        
        var overrideMetadata: [String: Any] = [String: Any]()
        
        if self.offTheRailsSegmentedControl.selectedSegmentIndex == 1 {
            
            overrideMetadata["totalBankAmount"] = [12000] as [Double]
            overrideMetadata["gamePARValues"] = [67, 71, 76, 82, 90, 100]
            overrideMetadata["openCompanyValues"] = [335, 355, 380, 410, 450, 500]
            overrideMetadata["PARCompanyValues"] = [67, 71, 76, 82, 90, 100]
            overrideMetadata["requiredNumberOfSharesToFloat"] = 5
            overrideMetadata["trainPriceValues"] = [80, 180, 300, 500, 630, 800, 1100]
            
            overrideMetadata["shareValues"] = [[76, 70, 65, 60, 55, 50, 45, 40, 30, 20, 10],
                                               [82, 76, 70, 66, 62, 58, 54, 50, 40, 30, 20],
                                               [90, 82, 76, 71, 67, 65, 63, 60, 50, 40, 30],
                                               [100, 90, 82, 76, 71, 67, 67, 67, 60, 50, 40],
                                               [112, 100, 90, 82, 76, 71, 69, 68, nil, nil, nil],
                                               [126, 112, 100, 90, 82, 75, 70, nil, nil, nil, nil],
                                               [142, 126, 111, 100, 90, 80, nil, nil, nil, nil, nil],
                                               [160, 142, 125, 110, 100, nil, nil, nil, nil, nil, nil],
                                               [180, 160, 140, 120, nil, nil, nil, nil, nil, nil, nil],
                                               [200, 180, 155, 130, nil, nil, nil, nil, nil, nil, nil],
                                               [225, 200, 170, nil, nil, nil, nil, nil, nil, nil, nil],
                                               [250, 220, 185, nil, nil, nil, nil, nil, nil, nil, nil],
                                               [275, 240, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                                               [300, 260, nil, nil, nil, nil, nil, nil, nil, nil, nil]] as [[Double?]]
        }
        
        let gameState = GameState(game: self.game, turnOrderType: self.turnOrderType, players: self.players, customOverrides: overrideMetadata)
        
        if self.offTheRailsSegmentedControl.selectedSegmentIndex == 1 {
            gameState.setOpeningLocations([(3, 0), (3, 1), (3, 2), (3, 3), (3, 4), (3, 5)].map { ShareValueIndexPath(x: $0.0, y: $0.1) })
            gameState.setYellowShareValueIndexPaths([(0, 3), (0, 4), (0, 5), (1, 5), (1, 6), (1, 7), (2, 7), (2, 8), (3, 8), (3, 9)].map { ShareValueIndexPath(x: $0.0, y: $0.1) })
            gameState.setOrangeShareValueIndexPaths([(0, 6), (0, 7), (1, 8), (2, 9), (3, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) })
            gameState.setBrownShareValueIndexPaths([(0, 8), (0, 9), (0, 10), (1, 9), (1, 10), (2, 10)].map { ShareValueIndexPath(x: $0.0, y: $0.1) })
            
            gameState.setGameEndLocation(gameEndLocation: ShareValueIndexPath(x: 13, y: 0))
        }
        
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "privatesAuctionViewController") as! PrivatesAuctionViewController
        nextVC.gameState = gameState
        nextVC.modalTransitionStyle = .crossDissolve
        
        self.present(nextVC, animated: true)
        
    }

}
