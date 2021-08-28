//
//  ExercisesViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var exerciseTableView: UITableView!
        
    var cancelBarButton: UIBarButtonItem!
    
    var saveBarButton: UIBarButtonItem!
    
    var addBarButton: UIBarButtonItem!
    
    var realm = try! Realm()
    
    var exercises: Results<Exercise>?
    
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
        
        loadExercises()
    }
    
    //MARK: - Navigation bar button methods
    @objc func addButtonPressed() {
        do {
            try realm.write {
                let newExercise = Exercise()

                newExercise.name = "Enter name..."
                newExercise.setsActual = "3"
                newExercise.repsActual = "3"
                newExercise.setsExpected = "5"
                newExercise.repsExpected = "5"
                
                realm.add(newExercise)

                selectedRoutine?.exercises.append(newExercise)
            }
        } catch {
            print("Error adding exercise, \(error)")
        }
        
        loadExercises()
    }
    
    @objc func saveButtonPressed() {
        if let cell = cellBeingEdited, let indexPath = exerciseTableView.indexPath(for: cell),
           let exercise = exercises?[indexPath.row] {
            do {
                try realm.write {
                    exercise.name = cell.exerciseNameTextField.text ?? ""
                    exercise.repsExpected = cell.repsExpectedTextField.text ?? ""
                    exercise.setsExpected = cell.setsExpectedTextField.text ?? ""
                    exercise.repsActual = cell.repsActualTextField.text ?? ""
                    exercise.setsActual = cell.setsActualTextField.text ?? ""
                }
            } catch {
                print("Error updating exercise, \(error)")
            }
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
    }
    
    //MARK: - Data manipulation methods
    func loadExercises() {
        exercises = selectedRoutine?.exercises.sorted(byKeyPath: "name", ascending: true)
        exerciseTableView.reloadData()
    }
    
    func deleteExercise(at indexPath: IndexPath) {
        if let exerciseForDeletion = self.exercises?[indexPath.row] {
            RealmManager.delete(exerciseForDeletion, from: realm)
        }
    }
}

//MARK: - UITableViewDataSource methods
extension ExerciseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        cell.delegate = self
        
        if let safeExercises = exercises {
            cell.exerciseNameTextField.text = safeExercises[indexPath.row].name
            cell.setsExpectedTextField.text = safeExercises[indexPath.row].setsExpected
            cell.repsExpectedTextField.text = safeExercises[indexPath.row].repsExpected
            cell.setsActualTextField.text = safeExercises[indexPath.row].setsActual
            cell.repsActualTextField.text = safeExercises[indexPath.row].repsActual
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate methods
extension ExerciseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)!!")
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
                    self.editExercise(on: cell)
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
            cancelButtonPressed()
            options.expansionStyle = .selection
        } else if orientation == .left {
            options.expansionStyle = .selection
        }
        
        return options
    }
    
    func editExercise(on cell: ExerciseCell) {
        cancelButtonPressed()
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        cell.enableEditing(isEditing: true)
        cellBeingEdited = cell
    }
}
