//
//  GameSelectionViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 07/01/25.
//

import UIKit

class GameSelectionViewController: UIViewController {
    
    @IBOutlet weak var topBarBackgroundView: UIView!
    @IBOutlet weak var filterPopupButton: UIButton!
    @IBOutlet weak var gameSelectionCollectionView: UICollectionView!
    
    var parentVC: SetupViewController!
    var games: [Game]!
    var filteredAndSortedGames: [Game] = []
    var filteredAndSortedGamesSuggestedByBGGFlags: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.topBarBackgroundView.backgroundColor = UIColor.primaryAccentColor
        
        self.filteredAndSortedGames = self.games
        self.filteredAndSortedGamesSuggestedByBGGFlags = Array(repeating: false, count: self.games.count)
        
        var filterActions: [UIAction] = []
        
        // ALL
        filterActions.append(UIAction(title: "All", state: .on, handler: { action in
            self.filteredAndSortedGames = self.games
            self.filteredAndSortedGamesSuggestedByBGGFlags = Array(repeating: false, count: self.games.count)
            self.gameSelectionCollectionView.reloadData()
            self.filterPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
        }))
        
        // 3 players
        filterActions.append(UIAction(title: "3 players", handler: { action in
            var bggSuggestedGames: [Game] = []
            var notSuggestedGames: [Game] = []
            
            for game in self.games {
                let (minPlayerSize, maxPlayerSize) = game.getNumberOfPlayers()
                if minPlayerSize <= 3 && 3 <= maxPlayerSize {
                    if game.isBGGSuggestedFor3p() {
                        bggSuggestedGames.append(game)
                    } else {
                        notSuggestedGames.append(game)
                    }
                }
            }
            
            self.filteredAndSortedGames = bggSuggestedGames + notSuggestedGames
            self.filteredAndSortedGamesSuggestedByBGGFlags = Array(repeating: true, count: bggSuggestedGames.count) + Array(repeating: false, count: notSuggestedGames.count)
            self.gameSelectionCollectionView.reloadData()
            self.filterPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
        }))
        
        // 4 players
        filterActions.append(UIAction(title: "4 players", handler: { action in
            var bggSuggestedGames: [Game] = []
            var notSuggestedGames: [Game] = []
            
            for game in self.games {
                let (minPlayerSize, maxPlayerSize) = game.getNumberOfPlayers()
                if minPlayerSize <= 4 && 4 <= maxPlayerSize {
                    if game.isBGGSuggestedFor4p() {
                        bggSuggestedGames.append(game)
                    } else {
                        notSuggestedGames.append(game)
                    }
                }
            }
            
            self.filteredAndSortedGames = bggSuggestedGames + notSuggestedGames
            self.filteredAndSortedGamesSuggestedByBGGFlags = Array(repeating: true, count: bggSuggestedGames.count) + Array(repeating: false, count: notSuggestedGames.count)
            self.gameSelectionCollectionView.reloadData()
            self.filterPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
        }))
        
        // 5 players
        filterActions.append(UIAction(title: "5 players", handler: { action in
            var bggSuggestedGames: [Game] = []
            var notSuggestedGames: [Game] = []
            
            for game in self.games {
                let (minPlayerSize, maxPlayerSize) = game.getNumberOfPlayers()
                if minPlayerSize <= 5 && 5 <= maxPlayerSize {
                    if game.isBGGSuggestedFor5p() {
                        bggSuggestedGames.append(game)
                    } else {
                        notSuggestedGames.append(game)
                    }
                }
            }
            
            self.filteredAndSortedGames = bggSuggestedGames + notSuggestedGames
            self.filteredAndSortedGamesSuggestedByBGGFlags = Array(repeating: true, count: bggSuggestedGames.count) + Array(repeating: false, count: notSuggestedGames.count)
            self.gameSelectionCollectionView.reloadData()
            self.filterPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
        }))

        if filterActions.isEmpty {
            self.filterPopupButton.isHidden = true
        } else {
            self.filterPopupButton.isHidden = false
            if filterActions.count == 1 {
                self.filterPopupButton.setBackgroundColor(UIColor.systemGray2)
                self.filterPopupButton.setPopupTitle(withText: "All", textColor: UIColor.white)
            } else {
                self.filterPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.filterPopupButton.setPopupTitle(withText: "All", textColor: UIColor.white)
                self.filterPopupButton.layer.borderColor = UIColor.white.cgColor
                self.filterPopupButton.layer.borderWidth = 2
                self.filterPopupButton.layer.cornerRadius = 8
                self.filterPopupButton.clipsToBounds = true
            }

            self.filterPopupButton.menu = UIMenu(children: filterActions)
            self.filterPopupButton.showsMenuAsPrimaryAction = true
            self.filterPopupButton.changesSelectionAsPrimaryAction = true
        }

        self.gameSelectionCollectionView.delegate = self
        self.gameSelectionCollectionView.dataSource = self
        
    }

}

extension GameSelectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGame = self.filteredAndSortedGames[indexPath.row]
        self.parentVC.selectedGame = selectedGame
        self.parentVC.gameSelectionButton.setTitle(withText: selectedGame.getVeryVeryShortTitle(), fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.dismiss(animated: true)
    }
}

extension GameSelectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredAndSortedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
        cell.contentView.backgroundColor = UIColor.secondaryAccentColor
        
        let currentGame = self.filteredAndSortedGames[indexPath.row]
        
        cell.publisherImageView.image = currentGame.getPublisherLogo()
        cell.titleLabel.text = currentGame.getFullTitle()
        
        cell.playersLabel.clipsToBounds = true
        cell.playersLabel.paddingLeft = 6.0
        cell.playersLabel.paddingRight = 6.0
        cell.playersLabel.paddingTop = 2.0
        cell.playersLabel.paddingBottom = 3.0
        cell.playersLabel.backgroundColor = UIColor.primaryAccentColor
        cell.playersLabel.textColor = UIColor.white
        cell.playersLabel.clipsToBounds = true
        cell.playersLabel.layer.cornerRadius = 6.0
        
        if self.filterPopupButton.currentTitle == "3 players" {
            if currentGame.isBGGSuggestedFor3p() {
                cell.playersLabel.text = "best in 3p (bgg)"
            } else {
                cell.playersLabel.text = "playable in 3p"
            }
        } else if self.filterPopupButton.currentTitle == "4 players" {
            if currentGame.isBGGSuggestedFor4p() {
                cell.playersLabel.text = "best in 4p (bgg)"
            } else {
                cell.playersLabel.text = "playable in 4p"
            }
        } else if self.filterPopupButton.currentTitle == "5 players" {
            if currentGame.isBGGSuggestedFor5p() {
                cell.playersLabel.text = "best in 5p (bgg)"
            } else {
                cell.playersLabel.text = "playable in 5p"
            }
        } else {
            let playersValues = currentGame.getNumberOfPlayers()
            cell.playersLabel.text = "\(playersValues.0)-\(playersValues.1) players"
        }
        
        return cell
    }
}

extension GameSelectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 110.0)
    }
}
