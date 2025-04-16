//
//  CustomMultiselectionPickerViewAlertViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 04/01/25.
//

import UIKit

class CustomMultiselectionPickerViewAlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var multiselectionCollectionView: UICollectionView!
    @IBOutlet weak var actionButtonsStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var titleStr: String?
    var cancelActionStr: String?
    var confirmActionStr: String?
    var completionHandler: (([Int]) -> Void)?
    var cancelHandler: (() -> Void)?
    
    var collectionViewElementsTexts: [String] = []
    var collectionViewElementsTextColors: [UIColor] = []
    var collectionViewElementsBackgroundColors: [UIColor] = []
    
    var elementsFlags: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        
        self.elementsFlags = Array(repeating: false, count: self.collectionViewElementsTexts.count)

        if let titleStr = self.titleStr {
            self.titleLabel.text = titleStr
        }
        
        self.multiselectionCollectionView.delegate = self
        self.multiselectionCollectionView.dataSource = self
        
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
    
    func setup(withTitle title: String, andElementsTexts elementsTexts: [String], andElementsTextColors elementsTextColors: [UIColor], andElementsBackgroundColors elementsBackgroundColors: [UIColor]) {
        self.titleStr = title
        self.collectionViewElementsTexts = elementsTexts
        self.collectionViewElementsTextColors = elementsTextColors
        self.collectionViewElementsBackgroundColors = elementsBackgroundColors
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
            completionHandler(self.elementsFlags.enumerated().filter { $0.1 }.map { $0.0 })
        }
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true)
        
        if let cancelHandler = self.cancelHandler {
            cancelHandler()
        }
    }
    
}

extension CustomMultiselectionPickerViewAlertViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewElementsTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "multiselectionPickerCollectionViewCell", for: indexPath) as! MultiselectionPickerCollectionViewCell
        
        cell.checkboxImageView.image = self.elementsFlags[indexPath.row] ? UIImage(named: "checkbox") : UIImage(named: "box")
        cell.elementLabel.text = self.collectionViewElementsTexts[indexPath.row]
        cell.elementLabel.backgroundColor = self.collectionViewElementsBackgroundColors[indexPath.row]
        cell.elementLabel.textColor = self.collectionViewElementsTextColors[indexPath.row]
        
        return cell
    }
}

extension CustomMultiselectionPickerViewAlertViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.elementsFlags[indexPath.row] {
            self.elementsFlags[indexPath.row] = false
        } else {
            self.elementsFlags[indexPath.row] = true
        }
        
        collectionView.reloadData()
    }
}

extension CustomMultiselectionPickerViewAlertViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360.0, height: 50.0)
    }
}
