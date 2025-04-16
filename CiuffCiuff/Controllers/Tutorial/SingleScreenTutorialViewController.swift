//
//  SingleScreenTutorialViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 27/11/24.
//

import UIKit

class SingleScreenTutorialViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondaryAccentColor

        self.backgroundImageView.image = UIImage(named: self.imageName)
    }
    
}
