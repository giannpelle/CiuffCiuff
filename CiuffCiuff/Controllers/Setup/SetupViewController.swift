//
//  ViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 29/12/22.
//

import UIKit
import UniformTypeIdentifiers

class SetupViewController: UIViewController {
    
    let games: [Game] = [Game.g1830, Game.g1840, Game.g1846, Game.g1848, Game.g1849, Game.g1856, Game.g1882, Game.g1889, Game.g18Chesapeake, Game.g18MEX] //Game.g1860, Game.g1871, Game.g1880, Game.g18CZ,
    var tags: [String] = []
    
    var firstPlayerTagIndex: Int?
    var selectedGame: Game = Game.g1830
    var tempUrl: URL?
    var didPickDocumentCallback: ((URL) -> Void) = {_ in }
    var centerYConstraintConstant: CGFloat? = nil
    
    @IBOutlet weak var centerYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var gameSelectionButton: UIButton!
    @IBOutlet weak var turnOrderSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var playersTextField: WSTagsField!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(simulator)
        self.tags = ["Fede", "Matteo", "Gian", "Nick"]
        self.firstPlayerTagIndex = 0
        self.selectedGame = .g1846
        #endif
        
        self.view.backgroundColor = UIColor.secondaryAccentColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGestRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestRecognizer)
        
        self.playersTextField.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.playersTextField.contentInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10)
        self.playersTextField.spaceBetweenLines = 22.0
        self.playersTextField.spaceBetweenTags = 10.0
        self.playersTextField.font = .systemFont(ofSize: 18.0, weight: .semibold)
        self.playersTextField.backgroundColor = .secondaryAccentColor
        self.playersTextField.tintColor = UIColor.primaryAccentColor
        self.playersTextField.textColor = UIColor.white
        self.playersTextField.selectedColor = .systemPink
        self.playersTextField.selectedTextColor = .white
        self.playersTextField.isDelimiterVisible = false
        self.playersTextField.placeholderColor = UIColor.primaryAccentColor
        self.playersTextField.placeholderAlwaysVisible = true
        self.playersTextField.keyboardAppearance = .dark
        self.playersTextField.acceptTagOption = .space
        self.playersTextField.shouldTokenizeAfterResigningFirstResponder = true
        self.playersTextField.layer.cornerRadius = 8.0
        self.playersTextField.clipsToBounds = true
        
        self.borderView.layer.cornerRadius = 8.0
        self.borderView.clipsToBounds = true
        self.borderView.backgroundColor = UIColor.primaryAccentColor
        
        self.playersTextField.onShouldAcceptTag = { field in
            
            if let text = field.textField.text {
                if text.count > 6 {
                    let alert = self.storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "You cannot enter a player's name longer than 6 characters")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                    return false
                }
                
                if text.count < 3 {
                    let alert = self.storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "You cannot enter a player's name shorter than 3 characters")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                    return false
                }
                
                if self.tags.contains(text) {
                    let alert = self.storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                    alert.setup(withTitle: "ATTENTION", andMessage: "Two players cannot have the same name")
                    alert.addConfirmAction(withLabel: "OK")
                    
                    let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                    alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                    
                    self.present(alert, animated: true)
                    return false
                }
                
                return true
            }
            
            return false
        }
        
        self.playersTextField.onDidAddTag = { field, tag in
            if !self.tags.contains(tag.text) {
                self.tags.append(tag.text)
                self.updateRandomFirstPlayer()
            }
        }
        
        self.playersTextField.onDidRemoveTag = { field, tag in
            if let idx = self.tags.firstIndex(of: tag.text) {
                self.tags.remove(at: idx)
                self.updateRandomFirstPlayer()
            }
        }

        self.gameSelectionButton.setTitle(withText: self.selectedGame.getVeryVeryShortTitle(), fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.gameSelectionButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.doneButton.setTitle(withText: "Done", fontSize: 18.0, fontWeight: .medium, textColor: UIColor.white)
        self.doneButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.turnOrderSegmentedControl.backgroundColor = UIColor.secondaryAccentColor
        self.turnOrderSegmentedControl.selectedSegmentTintColor = UIColor.primaryAccentColor
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.primaryAccentColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .semibold)]
        self.turnOrderSegmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        self.turnOrderSegmentedControl.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        
        self.importButton.setTitle(withText: "Import", fontSize: 19.0, fontWeight: .bold, textColor: UIColor.white)
        self.importButton.setBackgroundColor(UIColor.redAccentColor)
        self.importButton.layer.cornerRadius = 25
        self.importButton.clipsToBounds = true
        
    }
    
    func updateRandomFirstPlayer() {
        let firstPlayerIndex = Int.random(in: 0..<self.tags.count)
        self.firstPlayerTagIndex = firstPlayerIndex
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var const = 0.0
            
            if let constraintConstant = self.centerYConstraintConstant {
                const = constraintConstant
            } else {
                
                let textFieldOrigin = self.playersTextField.superview!.convert(self.playersTextField.frame.origin, to: self.view)
                let textFieldY = textFieldOrigin.y + self.playersTextField.frame.height
                let availableSpaceForKeyboard = UIScreen.main.bounds.height - textFieldY
                
                let offset = availableSpaceForKeyboard - keyboardSize.height
                const = offset - 12.0
                
                self.centerYConstraintConstant = const
            }
            
            UIView.animate(withDuration: 0.3) {
                self.centerYLayoutConstraint.constant = const
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.centerYLayoutConstraint.constant = 0.0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
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
    
    @IBAction func gameSelectionButtonPressed(sender: UIButton) {
        
        let gameSelectionVC = storyboard?.instantiateViewController(withIdentifier: "gameSelectionViewController") as! GameSelectionViewController
        gameSelectionVC.parentVC = self
        gameSelectionVC.games = self.games
        
        gameSelectionVC.preferredContentSize = CGSize(width: 640.0, height: UIScreen.main.bounds.size.height * 7.0 / 9.0)
        
        self.present(gameSelectionVC, animated: true)
    }
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        
        // PLAYERS
        let playersNames = self.tags
        var players = playersNames.filter { name in
            return name != ""
        }
        
        if players.count < 2 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "You must enter at least 2 players name to begin")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        if players.contains(where: { $0.count > 6 }) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "You cannot enter a player's name longer than 6 characters")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        if players.contains(where: { $0.count < 3 }) {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "You cannot enter a player's name shorter than 3 characters")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        let playerCount = self.selectedGame.getNumberOfPlayers()
        if players.count < playerCount.0 || players.count > playerCount.1 {
            let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
            alert.setup(withTitle: "ATTENTION", andMessage: "The selected game cannot be played with the specified number of players")
            alert.addConfirmAction(withLabel: "OK")
            
            let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
            
            self.present(alert, animated: true)
            return
        }
        
        if let turnOrderType = PlayerTurnOrderType(rawValue: self.turnOrderSegmentedControl.selectedSegmentIndex), let firstPlayerTagIndex = self.firstPlayerTagIndex {
         
            if self.firstPlayerTagIndex != 0 {
                let playersSortedIndexes = Array<Int>(firstPlayerTagIndex..<players.count) + Array<Int>(0..<firstPlayerTagIndex)
                players = playersSortedIndexes.map { players[$0] }
            }
            
            // GAME STATE
            let gameState = GameState(game: self.selectedGame, turnOrderType: turnOrderType, players: players)
            
            var allEntityLabels = gameState.labels + gameState.privatesLabels
            
            if let linesLabels = gameState.g1840LinesLabels {
                allEntityLabels += linesLabels
            }
            
            var repeatedNames: [String] = []
            for playerName in players {
                if (allEntityLabels.filter { $0 == playerName }).count > 1 {
                    repeatedNames.append(playerName)
                }
            }
            
            if !repeatedNames.isEmpty {
                
                let alert = storyboard?.instantiateViewController(withIdentifier: "customAlertViewController") as! CustomAlertViewController
                alert.setup(withTitle: "ATTENTION", andMessage: "[\(repeatedNames.joined(separator: ","))] is already in use in the app, please change it")
                alert.addConfirmAction(withLabel: "OK")
                
                let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
                alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
                
                self.present(alert, animated: true)
                return
            }
            
            let setupSeatingOrderVC = storyboard?.instantiateViewController(withIdentifier: "setupSeatingOrderViewController") as! SetupSeatingOrderViewController
            setupSeatingOrderVC.gameState = gameState
            setupSeatingOrderVC.turnOrderType = turnOrderType
            setupSeatingOrderVC.players = players
            setupSeatingOrderVC.game = self.selectedGame
            setupSeatingOrderVC.modalTransitionStyle = .crossDissolve
            
            self.present(setupSeatingOrderVC, animated: true)
        }
    }

}

extension SetupViewController: UIDocumentPickerDelegate {
        
    @IBAction func onImportButtonPress(_ sender: UIButton) {
        
        let alert = self.storyboard?.instantiateViewController(withIdentifier: "customActivityIndicatorAlertViewController") as! CustomActivityIndicatorAlertViewController
        alert.setup(withTitle: "Import game")
        
        let preferredContentSize = alert.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        alert.preferredContentSize = CGSize(width: max(320, preferredContentSize.width), height: preferredContentSize.height)
        
        self.present(alert, animated: true)
        
        self.didPickDocumentCallback = { fileURL in
            do {
                guard fileURL.startAccessingSecurityScopedResource() else {
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
    
                    return
                }
                defer { fileURL.stopAccessingSecurityScopedResource() }

                let data = try Data(contentsOf: fileURL)
                let importedGameState = try JSONDecoder().decode(GameState.self, from: data)

                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let startVC: HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
                startVC.gameState = importedGameState
                Operation.lastUid = importedGameState.lastUid
                Operation.privateCompanyLabels = (0..<importedGameState.privatesLabels.count).map({ importedGameState.privatesLabels[$0] })
                Operation.opEntityLabels = importedGameState.labels
                Operation.opBaseCompanyLabels = (0..<importedGameState.companiesSize).map({ importedGameState.getCompanyLabel(atBaseIndex: $0) })
                
                self.modalTransitionStyle = .crossDissolve
                self.dismiss(animated: false)
                self.present(startVC, animated: true)

            } catch {
                print("Failed to import")
                
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
                
                return
            }
        }
        
        alert.dismiss(animated: true) {
            DispatchQueue.main.async {
                let documentPickerViewController =  UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: false)
                documentPickerViewController.delegate = self
                self.present(documentPickerViewController, animated: true)
            }
        }
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.didPickDocumentCallback(url)
    }
}
