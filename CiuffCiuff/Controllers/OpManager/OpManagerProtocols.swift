//
//  OpManagerProtocols.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 02/04/25.
//

import UIKit

protocol ClosingCompanyOperableDelegate: UIViewController, Operable {
    
}

extension ClosingCompanyOperableDelegate {
    func closeCompany(atBaseIndex cmpBaseIdx: Int, hasUserExplicitlyRequestedClosure: Bool = false) {
        let cmpIdx = self.gameState.forceConvert(index: cmpBaseIdx, backwards: false, withIndexType: .companies)
        
        let userMessage = "Do you want to close the company?"
        
        switch self.gameState.game {
            
        case .g1848:
            
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: hasUserExplicitlyRequestedClosure ? userMessage : "The company was taken over by the Bank of England (Receivership). Do you want to close the company?")
            alert.addCancelAction(withLabel: "Cancel") {
                self.parentVC.dismiss(animated: true)
            }
            alert.addConfirmAction(withLabel: "Close") {
                self.parentVC.startingAmountText = self.gameState.getCompanyLabel(atIndex: cmpIdx) + ": " + self.gameState.currencyType.getCurrencyStringFromAmount(amount: self.gameState.getCompanyAmount(atIndex: cmpIdx))
                self.parentVC.amountsCollectionView.reloadData()
                self.parentVC.activateMenuAction(atIndex: ActionMenuType.close.rawValue)
                self.parentVC.loadViewController(withTag: ActionMenuType.close.rawValue)
            }
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
            
        case .g1849:
            
            // repay bond in emergency?
            if let bondsAmount = self.gameState.bonds?[cmpBaseIdx], bondsAmount > 0 && self.gameState.getCompanyAmount(atBaseIndex: cmpBaseIdx) < 500 {
                
                let firstComponentElementsAttributedTexts = (0..<self.gameState.playersSize).map { self.gameState.getPlayerLabel(atBaseIndex: $0) }.map { NSAttributedString(string: $0) }
                
                let alert = storyboard?.instantiateViewController(withIdentifier: "customPickerViewAlertViewController") as! CustomPickerViewAlertViewController
                alert.setup(withTitle: (hasUserExplicitlyRequestedClosure ? userMessage : "The company reached the CLOSE share value space. Do you want to close the company?") + "Select President to help the company repay the Bond", andPickerElementsAttributedTextsByComponent: [firstComponentElementsAttributedTexts])
                
                let presidentPlayerIdx = self.gameState.getPresidentPlayerIndex(forCompanyAtBaseIndex: cmpBaseIdx) ?? 0
                let presidentPlayerBaseIdx = self.gameState.forceConvert(index: presidentPlayerIdx, backwards: true, withIndexType: .players)
                
                alert.suggestInitialPickerViewIndex(hint: presidentPlayerBaseIdx, forComponent: 0)
                alert.addCancelAction(withLabel: "Cancel") {
                    self.parentVC.dismiss(animated: true)
                }
                alert.addConfirmAction(withLabel: "OK") { selectedIndexesByComponent in
                    
                    let playerIndexSelected = selectedIndexesByComponent[0]
                    let remainingAmount = 500.0 - self.gameState.getCompanyAmount(atBaseIndex: cmpBaseIdx)
                    let playerGlobalIndex = self.gameState.forceConvert(index: playerIndexSelected, backwards: false, withIndexType: .players)
                    
                    let emergencyOp = Operation(type: .cash, uid: nil)
                    emergencyOp.setOperationColorGlobalIndex(colorGlobalIndex: cmpIdx)
                    emergencyOp.addCashDetails(sourceIndex: playerGlobalIndex, destinationIndex: BankIndex.bank.rawValue, amount: remainingAmount, isEmergencyEnabled: true)
                    
                    _ = self.gameState.perform(operation: emergencyOp)
                    
                    self.gameState.closeCompany(atBaseIndex: cmpBaseIdx)
                    self.parentVC.cancelButtonPressed(sender: UIButton())
                }
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
                
            }
            
        case .g1830, .g1840, .g1846, .g1856, .g1882, .g1889, .g18Chesapeake, .g18MEX:
            break
        }
        
        // Standard close procedure
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "ATTENTION", andMessage: hasUserExplicitlyRequestedClosure ? userMessage : "The company reached the CLOSE share value space. Do you want to close the company?")
        alert.addCancelAction(withLabel: "Cancel") {
            self.parentVC.cancelButtonPressed(sender: UIButton())
        }
        alert.addConfirmAction(withLabel: "Close") {
            self.gameState.closeCompany(atBaseIndex: cmpBaseIdx)
            self.parentVC.cancelButtonPressed(sender: UIButton())
        }
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
        return
    }
}

protocol Operable {
    var gameState: GameState! { get }
    var parentVC: OpManagerViewController! { get }
    
    func commitButtonPressed() -> Bool?
}
