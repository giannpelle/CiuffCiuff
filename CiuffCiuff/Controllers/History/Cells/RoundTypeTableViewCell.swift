//
//  RoundTypeTableViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 02/02/24.
//

import UIKit

class RoundTypeTableViewCell: UITableViewCell {
    
    var parentVC: HistoryViewController!
    var operation: Operation!
    
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func trashButtonPressed(sender: UIButton) {
        self.parentVC.eraseOperation(withUid: self.operation.uid)
    }

}
