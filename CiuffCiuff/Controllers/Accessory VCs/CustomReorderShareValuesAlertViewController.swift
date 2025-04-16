//
//  CustomReorderShareValuesAlertViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 18/02/25.
//

import UIKit

class CustomReorderShareValuesAlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companiesCollectionView: UICollectionView!
    @IBOutlet weak var actionButtonsStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var titleStr: String?
    var cancelActionStr: String?
    var confirmActionStr: String?
    var completionHandler: (([Int]) -> Void)?
    var cancelHandler: (() -> Void)?
    
    var collectionViewElementsCompLogos: [String] = []
    
    var sortedIndexes: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        
        self.sortedIndexes = Array<Int>(0..<self.collectionViewElementsCompLogos.count)

        if let titleStr = self.titleStr {
            self.titleLabel.text = titleStr
        }
        
        self.companiesCollectionView.delegate = self
        self.companiesCollectionView.dataSource = self
        self.companiesCollectionView.clipsToBounds = false
        
        let longGestureGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        longGestureGesture.minimumPressDuration = 0.01
        self.companiesCollectionView.addGestureRecognizer(longGestureGesture)
        
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
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = self.companiesCollectionView.indexPathForItem(at: gesture.location(in: self.companiesCollectionView)) else {return}
            self.companiesCollectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            self.companiesCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: self.companiesCollectionView))
        case .ended:
            self.companiesCollectionView.endInteractiveMovement()
         default:
            self.companiesCollectionView.cancelInteractiveMovement()
        }
    }
    
    func setup(withTitle title: String, andElementsLogos elementsLogos: [String]) {
        self.titleStr = title
        self.collectionViewElementsCompLogos = elementsLogos
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
            completionHandler(self.sortedIndexes)
        }
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true)
        
        if let cancelHandler = self.cancelHandler {
            cancelHandler()
        }
    }
    
}

extension CustomReorderShareValuesAlertViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewElementsCompLogos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reorderCompanyShareIndexesCollectionViewCell", for: indexPath) as! ReorderCompanyShareIndexesCollectionViewCell
        cell.contentView.backgroundColor = .clear
        cell.companyImageView.image = UIImage(named: self.collectionViewElementsCompLogos[self.sortedIndexes[indexPath.row]])
        
        return cell
    }
}

extension CustomReorderShareValuesAlertViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.sortedIndexes.remove(at: sourceIndexPath.row)
        self.sortedIndexes.insert(item, at: destinationIndexPath.row)
    }
}

extension CustomReorderShareValuesAlertViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360.0, height: 60.0)
    }
}
