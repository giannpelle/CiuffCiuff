//
//  PlayerSellCollectionViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 17/12/24.
//

import UIKit

class PlayerSellCollectionViewCell: UICollectionViewCell {
    
    var parentVC: PlayerSellViewController!
    var gameState: GameState!
    var totSharesAmount: Double!
    var indexPathRow: Int!
    
    @IBOutlet weak var sharesAmountPopupButton: UIButton!
    @IBOutlet weak var sellLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupPopupButtons() {
        let sharesAmountSuggestions = self.gameState.predefinedShareAmounts.filter { $0 > 0 && $0 <= self.totSharesAmount }
        
        if sharesAmountSuggestions.isEmpty {
            self.sharesAmountPopupButton.isHidden = true
            return
        }
        
        self.sharesAmountPopupButton.isHidden = false
        
        var sharesAmountActions: [UIAction] = []
        
        for shareAmount in sharesAmountSuggestions {
            if shareAmount <= 1 {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) share", state: .on, handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.primaryAccentColor, fontSize: 19.0, fontWeight: .bold)
                    let shareAmount = self.gameState.getAmountFromPopupButtonTitle(title: action.title)
                    self.updateShareAmount(forCompanyAtIndexPathRow: self.indexPathRow, withAmount: shareAmount)
                }))
            } else {
                sharesAmountActions.append(UIAction(title: "\(self.gameState.printShareAmountsAsInt ? String(Int(shareAmount)) : String(shareAmount)) shares", handler: { action in
                    self.sharesAmountPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.primaryAccentColor, fontSize: 19.0, fontWeight: .bold)
                    let shareAmount = self.gameState.getAmountFromPopupButtonTitle(title: action.title)
                    self.updateShareAmount(forCompanyAtIndexPathRow: self.indexPathRow, withAmount: shareAmount)
                }))
            }
        }
        
        if sharesAmountActions.isEmpty {
            self.sharesAmountPopupButton.isHidden = true
        } else {
            self.sharesAmountPopupButton.isHidden = false
            self.sharesAmountPopupButton.setPopupTitle(withText: sharesAmountActions.first?.title ?? "", textColor: UIColor.primaryAccentColor, fontSize: 19.0, fontWeight: .bold)
            
            self.sharesAmountPopupButton.menu = UIMenu(children: sharesAmountActions)
            self.sharesAmountPopupButton.showsMenuAsPrimaryAction = true
            self.sharesAmountPopupButton.changesSelectionAsPrimaryAction = true
        }
    }
    
    func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sellButtonPressed))
        
        self.sellLabel.isUserInteractionEnabled = true
        self.sellLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateShareAmount(forCompanyAtIndexPathRow: Int, withAmount: Double) {
        self.parentVC.updateShareAmount(forCompanyAtIndexPathRow: forCompanyAtIndexPathRow, withAmount: withAmount)
    }
    
    @objc func sellButtonPressed(_ sender: UITapGestureRecognizer) {
        self.parentVC.sell(forIndexPathRow: self.indexPathRow)
    }
}
