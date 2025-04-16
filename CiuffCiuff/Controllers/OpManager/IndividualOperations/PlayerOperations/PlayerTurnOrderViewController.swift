//
//  PlayerTurnOrderViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 26/12/24.
//

import UIKit

class PlayerTurnOrderViewController: UIViewController, Operable {
    
    var gameState: GameState!
    var parentVC: OpManagerViewController!
    var localHomePlayersCollectionViewBaseIndexesSorted: [Int] = []
    
    @IBOutlet weak var playerTurnOrderCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.localHomePlayersCollectionViewBaseIndexesSorted = self.parentVC.gameState.homePlayersCollectionViewBaseIndexesSorted

        self.playerTurnOrderCollectionView.delegate = self
        self.playerTurnOrderCollectionView.dataSource = self
        self.playerTurnOrderCollectionView.clipsToBounds = false
        self.playerTurnOrderCollectionView.backgroundColor = UIColor.secondaryAccentColor
        
        let longGestureGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longGestureGesture.minimumPressDuration = 0.01
        self.playerTurnOrderCollectionView.addGestureRecognizer(longGestureGesture)
        
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = self.playerTurnOrderCollectionView.indexPathForItem(at: gesture.location(in: self.playerTurnOrderCollectionView)) else {return}
            self.playerTurnOrderCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            self.playerTurnOrderCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: self.playerTurnOrderCollectionView))
        case .ended:
            self.playerTurnOrderCollectionView.endInteractiveMovement()
         default:
            self.playerTurnOrderCollectionView.cancelInteractiveMovement()
        }
    }
    
    func commitButtonPressed() -> Bool? {
        self.parentVC.gameState.homePlayersCollectionViewBaseIndexesSorted = self.localHomePlayersCollectionViewBaseIndexesSorted
        return true
    }

}

extension PlayerTurnOrderViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.localHomePlayersCollectionViewBaseIndexesSorted.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerTurnOrderCollectionViewCell", for: indexPath) as! PlayerTurnOrderCollectionViewCell
        
        cell.playerLabel.text = self.parentVC.gameState.getPlayerLabel(atBaseIndex: self.localHomePlayersCollectionViewBaseIndexesSorted[indexPath.row])
        cell.playerLabel.textColor = .white
        cell.playerLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
        cell.contentView.backgroundColor = .primaryAccentColor
        cell.contentView.layer.cornerRadius = 25.0
//        cell.contentView.layer.borderColor = self.parentVC.gameState.getPlayerColor(atBaseIndex: self.localHomePlayersCollectionViewBaseIndexesSorted[indexPath.row]).cgColor
//        cell.contentView.layer.borderWidth = 4.0
        cell.contentView.clipsToBounds = true
        
        return cell
    }
}

extension PlayerTurnOrderViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.localHomePlayersCollectionViewBaseIndexesSorted.remove(at: sourceIndexPath.row)
        self.localHomePlayersCollectionViewBaseIndexesSorted.insert(item, at: destinationIndexPath.row)
    }
}

extension PlayerTurnOrderViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240.0, height: 50.0)
    }
}
