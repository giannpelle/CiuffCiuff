//
//  CustomPickerViewAlertViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 04/01/25.
//

import UIKit

class CustomPickerViewAlertViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var actionButtonsStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var titleStr: String?
    var attributedTitle: NSAttributedString?
    var cancelActionStr: String?
    var confirmActionStr: String?
    var completionHandler: (([Int]) -> Void)?
    var cancelHandler: (() -> Void)?
    
    var pickerElementsAttributedTextsByComponent: [[NSAttributedString]] = []
    var pickerViewSuggestionIndexesByComponent: [Int?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true

        if let titleStr = self.titleStr {
            self.titleLabel.text = titleStr
        }
        
        if let attributedTitle = self.attributedTitle {
            self.titleLabel.attributedText = attributedTitle
        }
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        for (i, suggestedIdx) in self.pickerViewSuggestionIndexesByComponent.enumerated() {
            if let suggestedIdx = suggestedIdx {
                self.pickerView.selectRow(suggestedIdx, inComponent: i, animated: false)
            }
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
    
    func setup(withAttributedTitle attributedTitle: NSAttributedString, andPickerElementsAttributedTextsByComponent pickerElementsAttributedTextsByComponent: [[NSAttributedString]]) {
        self.attributedTitle = attributedTitle
        self.pickerElementsAttributedTextsByComponent = pickerElementsAttributedTextsByComponent
        self.pickerViewSuggestionIndexesByComponent = Array<Int?>(repeating: nil, count: self.pickerElementsAttributedTextsByComponent.count)
    }

    func setup(withTitle title: String, andPickerElementsAttributedTextsByComponent pickerElementsAttributedTextsByComponent: [[NSAttributedString]]) {
        self.titleStr = title
        self.pickerElementsAttributedTextsByComponent = pickerElementsAttributedTextsByComponent
        self.pickerViewSuggestionIndexesByComponent = Array<Int?>(repeating: nil, count: self.pickerElementsAttributedTextsByComponent.count)
    }
    
    func suggestInitialPickerViewIndex(hint: Int, forComponent component: Int) {
        self.pickerViewSuggestionIndexesByComponent[component] = hint
    }
    
    func addCancelAction(withLabel label: String, andCancelHandler cancelHandler: (() -> Void)? = nil) {
        self.cancelActionStr = label
        self.cancelHandler = cancelHandler
    }
    
    func addConfirmAction(withLabel label: String, andCompletionHandler completionHandler: (([Int]) -> Void)? = nil) {
        self.confirmActionStr = label
        self.completionHandler = completionHandler
    }
    
    @objc func confirmAction() {
        self.dismiss(animated: true)
        
        if let completionHandler = self.completionHandler {
            completionHandler((0..<self.pickerView.numberOfComponents).map { self.pickerView.selectedRow(inComponent: $0) })
        }
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true)
        
        if let cancelHandler = self.cancelHandler {
            cancelHandler()
        }
    }
    
}

extension CustomPickerViewAlertViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.pickerElementsAttributedTextsByComponent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerElementsAttributedTextsByComponent[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return self.pickerElementsAttributedTextsByComponent[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.0
    }
}

extension CustomPickerViewAlertViewController: UIPickerViewDelegate {
    
}
