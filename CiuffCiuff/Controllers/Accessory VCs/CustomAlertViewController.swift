//
//  CustomAlertViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 04/01/25.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButtonsStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var titleStr: String?
    var messageStr: String?
    var attributedMessage: NSMutableAttributedString?
    var cancelActionStr: String?
    var confirmActionStr: String?
    var completionHandler: (() -> Void)?
    var cancelHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true

        if let titleStr = self.titleStr {
            self.titleLabel.text = titleStr
        }
        
        if let messageStr = self.messageStr {
            self.messageLabel.text = messageStr
        }
        
        if let attributedMessage = self.attributedMessage {
            self.messageLabel.attributedText = attributedMessage
        }
        
        if let cancelActionStr = self.cancelActionStr {
            self.cancelButton.isHidden = false
            self.cancelButton.setTitle(withText: cancelActionStr, fontSize: 18.0, fontWeight: .bold, textColor: UIColor.redAccentColor)
            self.cancelButton.setBackgroundColor(UIColor.systemGray6, isRectangularShape: true)
            self.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        } else {
            self.cancelButton.isHidden = true
        }
        
        if let confirmActionStr = self.confirmActionStr {
            self.confirmButton.isHidden = false
            self.confirmButton.setTitle(withText: confirmActionStr, fontSize: 18.0, fontWeight: .bold, textColor: UIColor.primaryAccentColor)
            self.confirmButton.setBackgroundColor(UIColor.systemGray6, isRectangularShape: true)
            self.confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        } else {
            self.confirmButton.isHidden = true
        }
    }
    
    func setup(withTitle title: String, andMessage message: String) {
        self.titleStr = title
        self.messageStr = message
    }
    
    func setup(withTitle title: String, andAttributedMessage attributedMessage: NSMutableAttributedString) {
        self.titleStr = title
        self.attributedMessage = attributedMessage
    }
    
    func addCancelAction(withLabel label: String, andCancelHandler cancelHandler: (() -> Void)? = nil) {
        self.cancelActionStr = label
        self.cancelHandler = cancelHandler
    }
    
    func addConfirmAction(withLabel label: String, andCompletionHandler completionHandler: (() -> Void)? = nil) {
        self.confirmActionStr = label
        self.completionHandler = completionHandler
    }
    
    @objc func confirmAction() {
        self.dismiss(animated: true)
        
        if let completionHandler = self.completionHandler {
            completionHandler()
        }
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true)
        
        if let cancelHandler = self.cancelHandler {
            cancelHandler()
        }
    }

}
