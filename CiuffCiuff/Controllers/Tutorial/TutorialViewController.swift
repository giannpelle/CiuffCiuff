//
//  TutorialViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 27/11/24.
//

import UIKit

protocol TutorialViewControllerDelegate: AnyObject {
    func pageIndexChanged(currentIndex: Int, newTitleStr: String) -> Void
}

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var childView: UIView!
    
    var isInitialVC: Bool = true
    var childVC: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        self.childVC?.willMove(toParent: nil)
        self.childVC?.view.removeFromSuperview()
        self.childVC?.removeFromParent()
        
        self.gotItButton.setTitle(withText: "Got it", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.gotItButton.setBackgroundColor(UIColor.primaryAccentColor)
    
        let childrenVC = storyboard?.instantiateViewController(withIdentifier: "tutorialPageViewController") as! TutorialPageViewController
        childrenVC.overrideDelegate = self
        
        self.addChild(childrenVC)
        self.childView.addSubview(childrenVC.view)
        childrenVC.view.translatesAutoresizingMaskIntoConstraints = false
        childrenVC.view.topAnchor.constraint(equalTo: self.childView.topAnchor).isActive = true
        childrenVC.view.bottomAnchor.constraint(equalTo: self.childView.bottomAnchor).isActive = true
        childrenVC.view.leftAnchor.constraint(equalTo: self.childView.leftAnchor).isActive = true
        childrenVC.view.rightAnchor.constraint(equalTo: self.childView.rightAnchor).isActive = true
        childrenVC.didMove(toParent: self)
        self.childVC = childrenVC
    }
    
    @IBAction func gotItButtonPressed(sender: UIButton) {
        
        if self.isInitialVC {
            let setupVC = storyboard?.instantiateViewController(withIdentifier: "setupViewController") as! SetupViewController
            setupVC.modalPresentationStyle = .fullScreen
            setupVC.modalTransitionStyle = .crossDissolve
            self.present(setupVC, animated: false)
        } else {
            self.dismiss(animated: true)
        }
    }

}

extension TutorialViewController: TutorialViewControllerDelegate {
    
    func pageIndexChanged(currentIndex: Int, newTitleStr: String) {
        self.titleLabel.text = newTitleStr
        
//        if currentIndex >= 2 {
//            UIView.animate(withDuration: 0.7) {
//                self.gotItButton.isHidden = false
//            }
//        }
    }
}
