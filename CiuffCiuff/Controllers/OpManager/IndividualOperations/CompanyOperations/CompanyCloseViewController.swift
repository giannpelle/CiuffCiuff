//
//  CompanyCloseViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 02/04/25.
//

import UIKit

class CompanyCloseViewController: UIViewController, Operable, ClosingCompanyOperableDelegate {
    
    var parentVC: OpManagerViewController!
    var gameState: GameState!
    var operatingCompanyIndex: Int!
    var operatingCompanyBaseIndex: Int!
    var startingAmountText: String!
    var startingAmountColor: UIColor!
    var startingAmountBackgroundColor: UIColor!
    var startingAmountFont: UIFont!
    
    @IBOutlet weak var startingAmountLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.closeButton.setTitle(withText: "CLOSE company", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.closeButton.setBackgroundColor(UIColor.redAccentColor, isRectangularShape: true)
        
        self.operatingCompanyBaseIndex = self.gameState.convert(index: self.operatingCompanyIndex, backwards: true, withIndexType: .companies)

        self.startingAmountLabel.text = self.startingAmountText
        self.startingAmountLabel.textColor = self.startingAmountColor
        self.startingAmountLabel.backgroundColor = self.startingAmountBackgroundColor
        self.startingAmountLabel.font = self.startingAmountFont
        self.startingAmountLabel.layer.cornerRadius = 25
        self.startingAmountLabel.clipsToBounds = true
        
        if !self.gameState.floatedCompanies[self.operatingCompanyBaseIndex] {
            self.view.isHidden = true
            self.parentVC.emptyLabel.isHidden = false
            self.parentVC.doneButton.isHidden = true
            return
        }
        self.parentVC.emptyLabel.isHidden = true
        self.view.isHidden = false
        
    }
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.closeCompany(atBaseIndex: self.operatingCompanyBaseIndex, hasUserExplicitlyRequestedClosure: true)
    }
    
    func commitButtonPressed() -> Bool? {
        return true
    }
   

}
