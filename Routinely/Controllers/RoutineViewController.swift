//
//  ViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

class RoutineViewController: UIViewController {
    
    var realm = try! Realm()
    
    var routineModel = RoutineModel()
    
    @IBOutlet weak var routineTableView: UITableView!
    
    var rowBeingEdited: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        routineTableView.register(UINib(nibName: "RoutineCell",
                                        bundle: nil), forCellReuseIdentifier: "RoutineCell")
        routineTableView.rowHeight = 80.0
        routineTableView.separatorStyle = .none
        
        routineTableView.dragInteractionEnabled = true
        routineTableView.dragDelegate = self
        
        loadRoutines()
    }
    
    
    //MARK: - Segues + preparation
    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        rowBeingEdited = nil
        performSegue(withIdentifier: "goToRoutineInput", sender: self)
    }
    
    func editRoutine(at indexPath: IndexPath) {
        rowBeingEdited = indexPath.row
        performSegue(withIdentifier: "goToRoutineInput", sender: self)
        rowBeingEdited = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExercises" {
            
            let destinationVC = segue.destination as! ExerciseViewController
    
            if let indexPath = routineTableView.indexPathForSelectedRow {
                destinationVC.selectedRoutine = routineModel.routines?[indexPath.row]
            }
        } else if segue.identifier == "goToRoutineInput" {
            let destinationVC = segue.destination as! RoutineInputViewController
            
            if let row = rowBeingEdited {
                destinationVC.routineBeingEdited = routineModel.routines?[row]
            }
            
            destinationVC.delegate = self
        }
    }
    
    //MARK: - Data Manipulation methods
    func loadRoutines() {
        routineModel.loadRoutines()
        self.routineTableView.reloadData()
    }
    
    func deleteRoutine(at indexPath: IndexPath) {
        routineModel.deleteRoutine(at: indexPath)
    }
}

//MARK: - UITableViewDataSource methods
extension RoutineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineModel.routines?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "h:mm a"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: indexPath) as! RoutineCell
        
        routineModel.populateNewRoutineCell(withCell: cell, withIndexPath: indexPath)
        
        cell.delegate = self
    
        return cell
    }
}

//MARK: - UITableViewDelegate methods
extension RoutineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToExercises", sender: self)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        routineModel.moveCell(from: sourceIndexPath, to: destinationIndexPath)
    }
}

//MARK: - SwipeTableViewCellDelegate methods
extension RoutineViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                Helper.displayDeletionConfirmationAlert(self, itemNameBeingDeleted: "Routine", completion: { deleteTapped in
                    if deleteTapped {
                        action.fulfill(with: .delete)
                        self.deleteRoutine(at: indexPath)
                        self.routineTableView.deleteRows(at: [indexPath], with: .left)
                    } else {
                        action.fulfill(with: .reset)
                    }
                })
            }
            deleteAction.image = UIImage(systemName: "trash")
            
            return [deleteAction]
        } else if orientation == .left {
            let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
                self.editRoutine(at: indexPath)
            }
            editAction.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.6274509804, blue: 0.9294117647, alpha: 1)
            editAction.image = UIImage(systemName: "square.and.pencil")
            
            return [editAction]
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        if orientation == .right ||  orientation == .left{
            options.expansionStyle = .selection
        }
        
        return options
    }
}

//MARK: - RoutineInputViewDelegate methods
extension RoutineViewController: RoutineInputViewDelegate {
    func didUpdateRoutines(_ routineInputViewController: RoutineInputViewController) {
        loadRoutines()
    }
}

//MARK: - UITableViewDragDelegate methods
extension RoutineViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return routineModel.dragItems(for: indexPath)
    }
}
