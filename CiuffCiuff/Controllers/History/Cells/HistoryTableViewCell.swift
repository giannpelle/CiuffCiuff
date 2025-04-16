//
//  HistoryTableViewCell.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/01/23.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    var parentVC: HistoryViewController!
    var operation: Operation!
    
    @IBOutlet weak var operationTypeLabel: UILabel!
    @IBOutlet weak var operationTypeBackgroundView: UIView!
    @IBOutlet weak var operationLabel: UILabel!
    
    @IBOutlet weak var linkUpImageView: UIImageView!
    @IBOutlet weak var linkDownImageView: UIImageView!
    
    @IBOutlet weak var invalidSwitch: UISwitch!
    @IBOutlet weak var editPayoutButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func operationSwitchValueChanged(sender: UISwitch) {
        if !self.parentVC.toggleOp(op: self.operation) {
            DispatchQueue.main.async {
                sender.setOn(!sender.isOn, animated: false)
            }
            
            let alert = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "The operation you tried to enable/disable is illegal")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.parentVC.present(alert, animated: true)
        }
    }
    
    @IBAction func editPayoutButtonPressed(sender: UIButton) {
        self.parentVC.openEditPayoutWithholdVC(forOperationsWithUid: self.operation.uid)
    }

}
