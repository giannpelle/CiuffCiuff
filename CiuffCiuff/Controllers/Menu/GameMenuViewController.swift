//
//  GameMenuViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 07/11/24.
//

import UIKit
import StoreKit
import MessageUI
import UniformTypeIdentifiers
import SafariServices

class GameMenuViewController: UIViewController {
    
    var window: UIWindow?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playerTurnOrderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var endGameButton: UIButton!
    
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var openTutorialButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    
    @IBOutlet weak var creditsCollectionView: UICollectionView!
    
    var gameState: GameState!
    var parentVC: HomeViewController!
    var tempUrl: URL?
    var didPickDocumentCallback: ((URL) -> Void) = {_ in }
    
    var creditsLabels: [String] = ["Cuputo",
                                   "Juan Beltrán",
                                   "Yasashii Studio",
                                   "reminiarch",
                                   "kumakamu",
                                   "Riyan Resdian",
                                   "Poups",
                                   "Uut Eva Ariani",
                                   "Adrien Coquet",
                                   "Vectors Point",
                                   "Chapman Fromm",
                                   "Neil",
                                   "SEFEICN",
                                   "The Icon Z"]
    
    var creditsUrls: [String] = ["https://thenounproject.com/creator/imron46/",
                                 "https://thenounproject.com/creator/graficojuanp/",
                                 "https://thenounproject.com/creator/yasashii/",
                                 "https://thenounproject.com/creator/reminiarch/",
                                 "https://thenounproject.com/creator/kumakamu/",
                                 "https://thenounproject.com/creator/yaicon/",
                                 "https://thenounproject.com/creator/poups0122/",
                                 "https://thenounproject.com/creator/mamahevinovino/",
                                 "https://thenounproject.com/creator/coquet_adrien/",
                                 "https://thenounproject.com/creator/vectorspoint/",
                                 "https://thenounproject.com/creator/martincf/",
                                 "https://thenounproject.com/creator/coops8/",
                                 "https://thenounproject.com/creator/efendik_eko/",
                                 "https://thenounproject.com/creator/theiconz/"]
    
    var creditsLogos: [String] = ["train", "book", "cash", "checkbox", "controls", "edit", "info", "link", "pawn_xl", "shares_black", "tick", "tools", "table", "flag"]
    var creditsRandomIndexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.creditsRandomIndexes = Array(0..<self.creditsLabels.count).shuffled()
        
        self.closeButton.setTitle(withText: "Close", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.closeButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.closeButton.layer.borderColor = UIColor.white.cgColor
        self.closeButton.layer.borderWidth = 2
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.clipsToBounds = true
        
        self.view.backgroundColor = UIColor.primaryAccentColor
        
        self.exportButton.setTitle(withText: "Export", fontSize: 17.0, fontWeight: .medium, textColor: UIColor.white)
        self.exportButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.openTutorialButton.setTitle(withText: "Open tutorial", fontSize: 17.0, fontWeight: .medium, textColor: UIColor.white)
        self.openTutorialButton.setBackgroundColor(UIColor.primaryAccentColor)
        self.contactUsButton.setTitle(withText: "Contact us", fontSize: 17.0, fontWeight: .medium, textColor: UIColor.white)
        self.contactUsButton.setBackgroundColor(UIColor.primaryAccentColor)

        self.playerTurnOrderSegmentedControl.selectedSegmentIndex = self.gameState.playerTurnOrderType.rawValue
        
        self.playerTurnOrderSegmentedControl.backgroundColor = UIColor.white
        self.playerTurnOrderSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.playerTurnOrderSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.playerTurnOrderSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        self.endGameButton.setTitle(withText: "End game", fontSize: 19.0, fontWeight: .bold, textColor: UIColor.white)
        self.endGameButton.setBackgroundColor(UIColor.redAccentColor)
        self.endGameButton.layer.cornerRadius = 25
        self.endGameButton.clipsToBounds = true
        
        self.creditsCollectionView.delegate = self
        self.creditsCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.gameState.getBankAmount() < 0 {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.parentVC.refreshUI()
    }
    
    @IBAction func playerTurnOrderInfoButtonPressed(sender: UIButton) {
        
        let descriptionStr = "@bGame specific:@n\nrespect official game rules\n@bDynamic pass order:@n\nfirst player to pass becomes next first player\n@bClassic:@n\nclockwise after last player buy/sell"
        
        let components = descriptionStr.components(separatedBy: "@")
        
        let attributedText = NSMutableAttributedString()
        
        let littleLineSpacingParagraphStyle = NSMutableParagraphStyle()
        littleLineSpacingParagraphStyle.lineSpacing = 2.5
        
        for component in components where !component.isEmpty {
            let componentStr = String(Array(component)[1...])
            
            if component.first! == "n" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .regular)]))
            } else if component.first! == "b" {
                attributedText.append(NSAttributedString(string: componentStr, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19, weight: .bold)]))
            }
        }
        
        attributedText.addAttribute(.paragraphStyle, value: littleLineSpacingParagraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "Turn order types:", andAttributedMessage: attributedText)
        alert.addConfirmAction(withLabel: "OK")
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
    }
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func playerTurnOrderSegmentedControlValueChanged(sender: UISegmentedControl) {
        if let playerTurnOrderType = PlayerTurnOrderType.init(rawValue: sender.selectedSegmentIndex) {
            self.gameState.playerTurnOrderType = playerTurnOrderType
        }
    }
    
    @IBAction func contactUsButtonPressed(sender: UIButton) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["gianluigi.developer@gmail.com"])
            mail.setSubject("CiuffCiuff - Contact us")
            self.present(mail, animated: true)
        } else {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please send an email to gianluigi.developer@gmail.com")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func openTutorialButtonPressed(sender: UIButton) {
        let tutorialVC = storyboard?.instantiateViewController(withIdentifier: "tutorialViewController") as! TutorialViewController
        tutorialVC.isInitialVC = false
        tutorialVC.modalPresentationStyle = .fullScreen
        tutorialVC.modalTransitionStyle = .crossDissolve
        self.present(tutorialVC, animated: true)
    }
    
    @IBAction func endGameButtonPressed(sender: UIButton) {
        
        let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
        alert.setup(withTitle: "ATTENTION", andMessage: "Are you sure you want to delete the game data and start a new game?")
        alert.addConfirmAction(withLabel: "Cancel")
        alert.addCancelAction(withLabel: "OK") {
            do {
                let fileURL = try FileManager.default
                    .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("CiuffCiuffGameState.json")

                try FileManager.default.removeItem(at: fileURL)
                print("JSON file deleted")

            } catch {
            }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let newRoot = storyboard.instantiateViewController(withIdentifier: "setupViewController") as? SetupViewController else {
                return // This shouldn't happen
            }

            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = newRoot
            self.window?.makeKeyAndVisible()
        }
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
    }

}

extension GameMenuViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.creditsLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "creditsCollectionViewCell", for: indexPath) as! CreditsCollectionViewCell
        cell.parentVC = self
        cell.indexPathRow = indexPath.row
        
        let originalIconName = self.creditsLogos[self.creditsRandomIndexes[indexPath.row]]
        if let blackImage = UIImage(named: originalIconName + "_black") {
            cell.iconImageView.image = blackImage
        } else {
            cell.iconImageView.image = UIImage(named: originalIconName)
        }
        cell.creditsLabel.text = "[\(self.creditsLabels[self.creditsRandomIndexes[indexPath.row]])]"
        
        cell.creditsAccessoryLabel.text = "from Noun Project"
        cell.creditsAccessoryLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        cell.creditsAccessoryLabel.textColor = .primaryAccentColor
        
        return cell
    }
    
    func openURL(forCreditsAtIndexPathRow indexPathRow: Int) {
        if let url = URL(string: self.creditsUrls[self.creditsRandomIndexes[indexPathRow]]) {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
}

extension GameMenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160.0, height: 140.0)
    }
}

extension GameMenuViewController: UICollectionViewDelegate {
    
}

extension GameMenuViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
      self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension GameMenuViewController: UIDocumentPickerDelegate {
    
    @IBAction func onExportButtonPress(_ sender: UIButton) {
        
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "customActivityIndicatorAlertViewController") as! CustomActivityIndicatorAlertViewController
        alert.setup(withTitle: "Exporting game")
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
        
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let todayDate = dateFormatter.string(from: Date())
            
            // save file temporarily
            let fileUrl =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let destinationUrl = fileUrl.appendingPathComponent("CiuffCiuff \(self.gameState.game.getVeryVeryShortTitle()) (\(todayDate)).txt")
            self.tempUrl = destinationUrl
            if FileManager().fileExists(atPath: destinationUrl.path) {
                try FileManager().removeItem(at: destinationUrl)
            }
            
            let gameStateURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("CiuffCiuffGameState.json")
            let rawData = try Data(contentsOf: gameStateURL)
            try rawData.write(to: destinationUrl)
            
            self.didPickDocumentCallback = {_ in
                try? FileManager().removeItem(at: destinationUrl)
            }
            
            alert.dismiss(animated: true) {
                DispatchQueue.main.async {
                    let documentPickerViewController =  UIDocumentPickerViewController(forExporting: [destinationUrl])
                    documentPickerViewController.delegate = self
                    self.present(documentPickerViewController, animated: true)
                }
            }
            
        } catch(let error) {
            print(error.localizedDescription)
            
            alert.dismiss(animated: true) {
                DispatchQueue.main.async {
                    let alert = self.storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "Something went wrong, please try again")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                }
            }
        }

    }
        
//    @IBAction func onImportButtonPress(_ sender: UIButton) {
//        self.didPickDocumentCallback = {fileURL in
//            do {
//                guard fileURL.startAccessingSecurityScopedResource() else { return }
//                defer { fileURL.stopAccessingSecurityScopedResource() }
//                
//                let data = try Data(contentsOf: fileURL)
//                let importedGameState = try JSONDecoder().decode(GameState.self, from: data)
//                
//                print("UE")
//                
//            } catch {
//                print("Failed to import")
//            }
//            
//        }
//        
//        let documentPickerViewController =  UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: false)
//        documentPickerViewController.delegate = self
//        self.present(documentPickerViewController, animated: true)
//    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.didPickDocumentCallback(url)
    }
}
