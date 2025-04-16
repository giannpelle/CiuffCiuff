//
//  RulesViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 20/01/24.
//

import UIKit

class RulesViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var contentSegmentedControl: UISegmentedControl!
    @IBOutlet weak var rulesTextView: UITextView!
    
    var gameState: GameState!
    var titleStr: String!
    var rulesText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.closeButton.setTitle(withText: "Close", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.closeButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.contentSegmentedControl.selectedSegmentIndex = 0
        
        self.contentSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.contentSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.contentSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.contentSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        self.updateTextView()

        self.rulesTextView.isEditable = false
        self.rulesTextView.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        self.rulesTextView.backgroundColor = UIColor.white
        self.rulesTextView.layer.borderColor = UIColor.primaryAccentColor.cgColor
        self.rulesTextView.layer.borderWidth = 3
        self.rulesTextView.layer.cornerRadius = 8
        self.rulesTextView.clipsToBounds = true
    }
    
    func updateTextView() {
        
        var contentStr: String = ""
        
        if self.contentSegmentedControl.selectedSegmentIndex == 0 {
            contentStr = self.rulesText
        } else {
            for privateBaseIdx in 0..<self.gameState.privatesLabels.count {
                contentStr += "@bPrivate \(self.gameState.privatesLabels[privateBaseIdx])\n"
                contentStr += "@n\(self.gameState.privatesDescriptions[privateBaseIdx])\n"
                contentStr += "\n@l"
            }
        }
        
        let components = contentStr.components(separatedBy: "@")
        
        let attributedText = NSMutableAttributedString()
        
        let littleLineSpacingParagraphStyle = NSMutableParagraphStyle()
        littleLineSpacingParagraphStyle.lineSpacing = 2.5
        
        for component in components where !component.isEmpty {
            let componentStr = String(Array(component)[1...])
            
            if component.first! == "n" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0)]))
            } else if component.first! == "b" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier-Bold", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0)]))
            } else if component.first! == "u" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier", size: 22.0) ?? UIFont.systemFont(ofSize: 22.0), NSAttributedString.Key.underlineStyle: 1]))
            } else if component.first! == "l" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont(name: "Courier", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)]))
            }
        }
        
        attributedText.addAttribute(.paragraphStyle, value: littleLineSpacingParagraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        self.rulesTextView.attributedText = attributedText
    }
    
    @IBAction func contentSegmentedControlValueChanged(sender: UISegmentedControl) {
        self.updateTextView()
    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }

}
