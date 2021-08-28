//
//  ExercisesViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

// TODO(Joshua): Finish mapping exercise data in table view cell to DB

class ExerciseViewController: UIViewController {
    
    @IBOutlet weak var exerciseTableView: UITableView!
        
    var cancelBarButton: UIBarButtonItem!
    
    var saveBarButton: UIBarButtonItem!
    
    var addBarButton: UIBarButtonItem!
    
    var realm = try! Realm()
    
    var exercises: Results<Exercise>?
    
    var selectedRoutine: Routine?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.clearTableEditing))
        
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveButtonPressed))
        
        addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed))
        navigationItem.rightBarButtonItem = addBarButton

        
        exerciseTableView.rowHeight = 132
        exerciseTableView.register(UINib(nibName: "ExerciseCell",
                                        bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        
        
        loadExercises()
    }
    
    @objc func addButtonPressed() {
        do {
            try realm.write {
                let newExercise = Exercise()

                newExercise.name = "Enter name..."
                newExercise.numberOfSetsActual = "3"
                newExercise.numberOfSetsCurrent = "3"
                newExercise.numberOfRepsRangeCurrent = "5"
                newExercise.numberOfRepsRangeCurrent = "5"
                
                realm.add(newExercise)

                selectedRoutine?.exercises.append(newExercise)
            }
        } catch {
            print("Error updating context, \(error)")
        }
        
        loadExercises()
    }
    
    @objc func saveButtonPressed() {
        clearTableEditing()
    }
    
    @objc func clearTableEditing() {
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
    
    func updateExercise() {
        
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
        guard orientation == .left else { return nil }

        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            if let cell = tableView.cellForRow(at: indexPath) as? ExerciseCell {
                self.editExercise(on: cell)
            }

        }
        editAction.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.6274509804, blue: 0.9294117647, alpha: 1)
        editAction.image = UIImage(systemName: "square.and.pencil")
        
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        if orientation == .left {
            options.expansionStyle = .selection
        }
        
        return options
    }
    
    func editExercise(on cell: ExerciseCell) {
        clearTableEditing()
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        
        cell.enableEditing(isEditing: true)
    }
}
