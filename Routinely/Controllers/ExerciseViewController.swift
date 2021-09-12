//
//  ExercisesViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift
import SwipeCellKit
import BottomPopup

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var exerciseTableView: UITableView!
        
    var cancelBarButton: UIBarButtonItem!
    
    var saveBarButton: UIBarButtonItem!
    
    var addBarButton: UIBarButtonItem!
    
    var realm = try! Realm()
    
    var exerciseModel = ExerciseModel()
        
    var selectedRoutine: Routine?
    
    var cellBeingEdited: ExerciseCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonPressed))
        
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonPressed))
        
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed))
        navigationItem.rightBarButtonItem = addBarButton
        
        exerciseTableView.rowHeight = 132
        exerciseTableView.register(UINib(nibName: "ExerciseCell",
                                        bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        
        exerciseTableView.dragInteractionEnabled = true
        exerciseTableView.dragDelegate = self
        
        navigationItem.title = selectedRoutine?.name
        
        loadExercises()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseInput" {
            
            let destinationVC = segue.destination as! ExerciseInputViewController
            
            destinationVC.exerciseModel = exerciseModel
            destinationVC.delegate = self
        }
    }
    
    //MARK: - Navigation bar button methods
    @objc func addButtonPressed() {
        performSegue(withIdentifier: "goToExerciseInput", sender: self)
    }
    
    @objc func saveButtonPressed() {
        if let cell = cellBeingEdited, let indexPath = exerciseTableView.indexPath(for: cell) {
            exerciseModel.saveExercise(with: cell, with: indexPath)
        }
        cancelButtonPressed()
    }
    
    @objc func cancelButtonPressed() {
        for visibleCell in exerciseTableView.visibleCells {
            if let cell = visibleCell as? ExerciseCell {
                cell.enableEditing(isEditing: false)
                                
                self.navigationItem.leftBarButtonItem = nil
                self.navigationItem.rightBarButtonItem = addBarButton
            }
        }
        exerciseTableView.reloadData()
    }
    
    //MARK: - Data manipulation methods
    func loadExercises() {
        exerciseModel.exercises = selectedRoutine?.exercises
        exerciseTableView.reloadData()
    }
    
    func deleteExercise(at indexPath: IndexPath) {
        exerciseModel.deleteExercise(at: indexPath)
    }
}

//MARK: - UITableViewDataSource methods
extension ExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseModel.exercises?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        cell.delegate = self
        
        exerciseModel.populateNewExerciseCell(withCell: cell, withIndexPath: indexPath)
        
        return cell
    }
}

//MARK: - UITableViewDelegate methods
extension ExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        exerciseModel.moveCell(from: sourceIndexPath, to: destinationIndexPath)
    }
}

//MARK: - SwipeTableViewCellDelegate methods
extension ExerciseViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                Helper.displayDeletionConfirmationAlert(self, itemNameBeingDeleted: "Exercise", completion: { deleteTapped in
                    if deleteTapped {
                        action.fulfill(with: .delete)
                        self.deleteExercise(at: indexPath)
                        self.exerciseTableView.deleteRows(at: [indexPath], with: .left)
                    } else {
                        action.fulfill(with: .reset)
                    }
                })
            }
            deleteAction.image = UIImage(systemName: "trash")
            
            return [deleteAction]
        } else if orientation == .left {
            let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
                if let cell = tableView.cellForRow(at: indexPath) as? ExerciseCell {
                    self.enableEditing(on: cell)
                }

            }
            editAction.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.6274509804, blue: 0.9294117647, alpha: 1)
            editAction.image = UIImage(systemName: "square.and.pencil")
            editAction.hidesWhenSelected = true
            
            return [editAction]
        }

        return nil
    }
        
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        if orientation == .right {
            options.expansionStyle = .selection
        } else if orientation == .left {
            options.expansionStyle = .selection
        }
        
        return options
    }
    
    private func enableEditing(on cell: ExerciseCell) {
        cancelButtonPressed()
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        cell.enableEditing(isEditing: true)
        cellBeingEdited = cell
    }
}

//MARK: - UITableViewDragDelegate methods
extension ExerciseViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return exerciseModel.dragItems(for: indexPath)
    }
}

//MARK: - ExerciseInputViewDelegate methods
extension ExerciseViewController: ExerciseInputViewDelegate {
    func didAddExercise(_ exerciseInputViewController: ExerciseInputViewController) {
        loadExercises()
    }
}
