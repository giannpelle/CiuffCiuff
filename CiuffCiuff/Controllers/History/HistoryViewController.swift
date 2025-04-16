//
//  HistoryViewController.swift
//  CiuffCiuff
//
//  Created by Gianluigi Pelle on 05/01/23.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var parentVC: HomeViewController!
    var gameState: GameState!
    
    var operationTypes: [OperationType] = []
    var entitiesGlobalIndexes: [Int] = []
    
    var currentFilterOpType: OperationType? = nil
    var currentFilterEntityGlobalIndex: Int? = nil
    
    var cmpBaseIdxToBeUpdated: Int? = nil
    var filteredOperations: [Operation] = []
    var firstCancellableIndexPathRow: Int = 0

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var operationTypesPopupButton: UIButton!
    @IBOutlet weak var entitiesPopupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.primaryAccentColor
        
        self.closeButton.setTitle(withText: "Close", fontSize: 18, fontWeight: .medium, textColor: UIColor.white)
        self.closeButton.setBackgroundColor(UIColor.primaryAccentColor)
        
        self.closeButton.layer.borderColor = UIColor.white.cgColor
        self.closeButton.layer.borderWidth = 2
        self.closeButton.layer.cornerRadius = 8
        self.closeButton.clipsToBounds = true
        
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.backgroundColor = UIColor.systemGray6
        
        self.operationTypes = Array(Set(self.gameState.operations.map{ $0.type }.sorted(by: {$0.rawValue < $1.rawValue}).filter { !self.gameState.roundOperationTypes.contains($0) }))
        self.entitiesGlobalIndexes = [-1] + self.gameState.getBankEntityIndexes() + self.gameState.getCompanyIndexes() + self.gameState.getPlayerIndexes()
        self.filteredOperations = self.gameState.operations
        
        self.updateCancellableOperations()
        
        self.setupPopupButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.scrollToBottom()
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.parentVC.refreshUI()
    }
    
    func updateCancellableOperations() {
        if let lastIndex = self.gameState.operations.lastIndex(where: { self.gameState.roundOperationTypes.contains($0.type) }) {
            self.firstCancellableIndexPathRow = lastIndex
        }
    }
    
    func setupPopupButtons() {
        
        var opTypesActions: [UIAction] = []
        
        opTypesActions.append(UIAction(title: "any", state: .on, handler: { action in
            if action.title == "any" {
                self.currentFilterOpType = nil
            } else {
                self.currentFilterOpType = OperationType(rawValue: action.title)
            }
            
            self.operationTypesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
            
            self.updateTableView()
        }))
        
        for opType in self.operationTypes {
            opTypesActions.append(UIAction(title: opType.rawValue, handler: { action in
                if action.title == "any" {
                    self.currentFilterOpType = nil
                } else {
                    self.currentFilterOpType = OperationType(rawValue: action.title)
                }
                
                self.operationTypesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                
                self.updateTableView()
            }))
        }
        
        if opTypesActions.isEmpty {
            self.operationTypesPopupButton.isHidden = true
        } else {
            self.operationTypesPopupButton.isHidden = false
            if opTypesActions.count == 1 {
                self.operationTypesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.operationTypesPopupButton.setPopupTitle(withText: opTypesActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.operationTypesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.operationTypesPopupButton.setPopupTitle(withText: opTypesActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.operationTypesPopupButton.menu = UIMenu(children: opTypesActions)
            self.operationTypesPopupButton.showsMenuAsPrimaryAction = true
            self.operationTypesPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        self.operationTypesPopupButton.layer.borderColor = UIColor.white.cgColor
        self.operationTypesPopupButton.layer.borderWidth = 2
        self.operationTypesPopupButton.layer.cornerRadius = 8
        self.operationTypesPopupButton.clipsToBounds = true
        
        var entitiesActions: [UIAction] = []
        for (i, entityGlobalIdx) in self.entitiesGlobalIndexes.enumerated() {
            if i == 0 {
                entitiesActions.append(UIAction(title: "any", image: UIImage.circle(diameter: 20.0, color: UIColor.white), state: .on, handler: { action in
                    if action.title == "any" {
                        self.currentFilterEntityGlobalIndex = nil
                    } else {
                        self.currentFilterEntityGlobalIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    }
                    
                    self.entitiesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    
                    self.updateTableView()
                }))
            } else {
                entitiesActions.append(UIAction(title: self.gameState.labels[entityGlobalIdx], image: UIImage.circle(diameter: 20.0, color: self.gameState.colors[entityGlobalIdx].uiColor), handler: { action in
                    if action.title == "any" {
                        self.currentFilterEntityGlobalIndex = nil
                    } else {
                        self.currentFilterEntityGlobalIndex = self.gameState.getGlobalIndexFromPopupButtonTitle(title: action.title)
                    }
                    
                    self.entitiesPopupButton.setPopupTitle(withText: action.title, textColor: UIColor.white)
                    
                    self.updateTableView()
                }))
            }
        }
        
        if entitiesActions.isEmpty {
            self.entitiesPopupButton.isHidden = true
        } else {
            self.entitiesPopupButton.isHidden = false
            if entitiesActions.count == 1 {
                self.entitiesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.entitiesPopupButton.setPopupTitle(withText: entitiesActions.first?.title ?? "", textColor: UIColor.white)
            } else {
                self.entitiesPopupButton.setBackgroundColor(UIColor.primaryAccentColor)
                self.entitiesPopupButton.setPopupTitle(withText: entitiesActions.first?.title ?? "", textColor: UIColor.white)
            }
            
            self.entitiesPopupButton.menu = UIMenu(children: entitiesActions)
            self.entitiesPopupButton.showsMenuAsPrimaryAction = true
            self.entitiesPopupButton.changesSelectionAsPrimaryAction = true
        }
        
        self.entitiesPopupButton.layer.borderColor = UIColor.white.cgColor
        self.entitiesPopupButton.layer.borderWidth = 2
        self.entitiesPopupButton.layer.cornerRadius = 8
        self.entitiesPopupButton.clipsToBounds = true
    }
    
    func updateTableView() {
        var operationsCopy = self.gameState.operations
        
        if let opType = self.currentFilterOpType {
            operationsCopy = operationsCopy.filter { $0.type == opType || self.gameState.roundOperationTypes.contains($0.type) }
        }
        
        if let entityGlobalIdx = self.currentFilterEntityGlobalIndex {
            operationsCopy = operationsCopy.filter { op in
                var test = op.sourceGlobalIndex == entityGlobalIdx || op.destinationGlobalIndex == entityGlobalIdx || op.shareSourceGlobalIndex == entityGlobalIdx || op.shareDestinationGlobalIndex == entityGlobalIdx || op.trashTargetGlobalIndex == entityGlobalIdx || op.generateTargetGlobalIndex == entityGlobalIdx
                
                if op.type == .payout, let payoutCompanyBaseIndex = op.payoutWithholdCompanyBaseIndex {
                    let payoutGlobalIndex = self.gameState.convert(index: payoutCompanyBaseIndex, backwards: false, withIndexType: .companies)
                    test = test || payoutGlobalIndex == entityGlobalIdx
                }
                
                return self.gameState.roundOperationTypes.contains(op.type) || test
            }
        }
        
        self.filteredOperations = operationsCopy
        self.historyTableView.reloadData()
        self.scrollToBottom()

    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func toggleOp(op: Operation) -> Bool {
        
        let updatingOperations: [Operation] = self.gameState.operations.filter { operation in
            operation.uid == op.uid
        }
        
        if updatingOperations.allSatisfy({ $0.isActive }) || updatingOperations.allSatisfy({ !$0.isActive }) {
            
            if !op.isActive {
                
                if !self.gameState.areOperationsLegit(operations: updatingOperations, reverted: false) {
                    return false
                }
                
                for operation in updatingOperations {
                    if self.gameState.perform(operation: operation, save: false) {
                        operation.isActive = true
                        
//                        if [OperationType.payout, OperationType.withhold].contains(operation.type) {
//                            self.cmpBaseIdxToBeUpdated = operation.payoutWithholdCompanyBaseIndex
//                        }
                    }
                }
                
            } else {

                if !self.gameState.areOperationsLegit(operations: updatingOperations, reverted: true) {
                    return false
                }
                
                for operation in updatingOperations {
                    if self.gameState.perform(operation: operation, reverted: true, save: false) {
                        operation.isActive = false
                        
//                        if [OperationType.payout, OperationType.withhold].contains(operation.type) {
//                            self.cmpBaseIdxToBeUpdated = operation.payoutWithholdCompanyBaseIndex
//                        }
                    }
                }
            }
            
            self.gameState.saveToDisk()
            
            self.historyTableView.reloadData()
            self.scrollToBottom()
            
            return true
        }
        
        return false
        
    }
    
    func openEditPayoutWithholdVC(forOperationsWithUid uid: Int) {
        let editPayoutWithholdVC = storyboard?.instantiateViewController(withIdentifier: "editPayoutWithholdViewController") as! EditPayoutWithholdViewController
        editPayoutWithholdVC.gameState = self.gameState
        editPayoutWithholdVC.parentVC = self
        editPayoutWithholdVC.payoutOpUid = uid
        
        self.present(editPayoutWithholdVC, animated: true)
    }
    
    func eraseOperation(withUid uid: Int) {
        if let opIdx = self.gameState.operations.firstIndex(where: { op in
            op.uid == uid
        }) {
            self.gameState.operations.remove(at: opIdx)
            
            if let lastRoundTypeOp = self.gameState.operations.last(where: { op in
                self.gameState.roundOperationTypes.contains(op.type)
            }) {
                self.gameState.currentRoundOperationType = lastRoundTypeOp.type
                self.updateCancellableOperations()
            }
            
            self.gameState.saveToDisk()
            
            self.updateTableView()
        }
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.filteredOperations.count - 1, section: 0)
            self.historyTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredOperations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let revertedIndexPathRow = abs(indexPath.row - (self.filteredOperations.count - 1))
        let op = self.filteredOperations[indexPath.row]//[revertedIndexPathRow]
        
        if self.gameState.roundOperationTypes.contains(op.type) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "roundTypeCell") as! RoundTypeTableViewCell
            cell.parentVC = self
            cell.operation = op
            
            cell.operationLabel.text = op.getDescription()
            cell.operationLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            
            if let lastRoundTypeOp = self.gameState.operations.last(where: { operation in
                self.gameState.roundOperationTypes.contains(operation.type)
            }) {
                if lastRoundTypeOp.uid == op.uid && indexPath.row != 0 {
                    cell.trashButton.isHidden = false
                } else {
                    cell.trashButton.isHidden = true
                }
            } else {
                cell.trashButton.isHidden = true
            }
            
            if self.gameState.roundOperationTypes.contains(op.type), let idx = self.gameState.roundOperationTypes.firstIndex(of: op.type) {
                cell.backgroundColor = self.gameState.roundOperationTypeColors[idx].uiColor
                cell.operationLabel.textColor = self.gameState.roundOperationTypeTextColors[idx].uiColor
            } else {
                cell.backgroundColor = UIColor.white
                cell.operationLabel.textColor = UIColor.black
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableViewCell
            cell.parentVC = self
            cell.operation = op
            
            cell.contentView.backgroundColor = UIColor.systemGray6
            
            let prevRow = indexPath.row - 1
            let nextRow = indexPath.row + 1
            
            if prevRow >= 0 && self.filteredOperations[prevRow].uid == op.uid {
                cell.linkUpImageView.isHidden = false
            } else {
                cell.linkUpImageView.isHidden = true
            }
            
            if nextRow < self.filteredOperations.count && self.filteredOperations[nextRow].uid == op.uid {
                cell.linkDownImageView.isHidden = false
            } else {
                cell.linkDownImageView.isHidden = true
            }
            
            let opDescriptionComponents = op.getDescription().components(separatedBy: "-:-")
            if opDescriptionComponents.count == 2 {
                let operationTypeStr = "\(opDescriptionComponents[0])"
                
                cell.operationTypeLabel.text = operationTypeStr
                cell.operationTypeLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
                
                cell.operationTypeBackgroundView.backgroundColor = self.gameState.colors[op.colorGlobalIndex].uiColor
                cell.operationTypeLabel.textColor = self.gameState.textColors[op.colorGlobalIndex].uiColor
                
                cell.operationTypeBackgroundView.layer.cornerRadius = 4.0
                
                let operationDescriptionStr = opDescriptionComponents[1]
                
                let attributedString = NSMutableAttributedString(string: operationDescriptionStr)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20.0, weight: .regular), range: NSMakeRange(0, attributedString.length))
                
                cell.operationLabel.attributedText = attributedString
                
                cell.invalidSwitch.isHidden = !(op.type.canBeUndo() && indexPath.row >= self.firstCancellableIndexPathRow)
                cell.invalidSwitch.setOn(op.isActive, animated: false)
                cell.backgroundColor = op.isActive ? UIColor.white : UIColor.systemGray6
                
                cell.editPayoutButton.isHidden = !([OperationType.payout, OperationType.withhold].contains(op.type) && indexPath.row >= self.firstCancellableIndexPathRow && op.isActive && op.isStandardPayout == true)
                
                return cell
            }
//            else {
//                let operationTypeStr = "OTHER"
//                
//                cell.operationTypeLabel.text = operationTypeStr
//                cell.operationTypeLabel.textColor = UIColor.white
//                cell.operationTypeLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
//                
//                cell.operationTypeBackgroundView.backgroundColor = UIColor.primaryAccentColor
//                cell.operationTypeBackgroundView.layer.cornerRadius = 4.0
//                
//                let attributedString = NSMutableAttributedString(string: op.getDescription())
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.lineSpacing = 4
//                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20.0, weight: .regular), range: NSMakeRange(0, attributedString.length))
//                
//                cell.operationLabel.attributedText = attributedString
//                
//                cell.invalidSwitch.isHidden = false
//                cell.invalidSwitch.setOn(op.isActive, animated: false)
//                cell.backgroundColor = op.isActive ? UIColor.white : UIColor.systemGray6
//                
//                return cell
//            }
            return cell
            
        }
       
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    
}
