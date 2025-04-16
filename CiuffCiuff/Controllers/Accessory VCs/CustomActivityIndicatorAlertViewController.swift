//
//  Custom.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 03/02/25.
//

import UIKit

class CustomActivityIndicatorAlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var titleStr: String?
    var messageStr: String?
    var attributedMessage: NSMutableAttributedString?
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
        
        self.activityIndicator.startAnimating()
        
    }
    
    func setup(withTitle title: String, andMessage message: String = "Please wait...") {
        self.titleStr = title
        self.messageStr = message
    }
    
//    func setup(withTitle title: String, andAttributedMessage attributedMessage: NSMutableAttributedString) {
//        self.titleStr = title
//        self.attributedMessage = attributedMessage
//    }
    
//    func addCancelAction(withLabel label: String, andCancelHandler cancelHandler: (() -> Void)? = nil) {
//        self.cancelActionStr = label
//        self.cancelHandler = cancelHandler
//    }
//    
//    func addConfirmAction(withLabel label: String, andCompletionHandler completionHandler: (() -> Void)? = nil) {
//        self.confirmActionStr = label
//        self.completionHandler = completionHandler
//    }
    
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
