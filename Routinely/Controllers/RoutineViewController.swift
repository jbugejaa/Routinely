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
    
    @IBOutlet weak var routineTableView: UITableView!
    
    var routines: Results<Routine>?
    
    var rowBeingEdited: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        routineTableView.register(UINib(nibName: "RoutineCell",
                                        bundle: nil), forCellReuseIdentifier: "RoutineCell")
        routineTableView.rowHeight = 80.0
        routineTableView.separatorStyle = .none
        
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
            
            let destinationVC = segue.destination as! ExercisesViewController
    
            if let indexPath = routineTableView.indexPathForSelectedRow {
                destinationVC.selectedRoutine = routines?[indexPath.row]
            }
        } else if segue.identifier == "goToRoutineInput" {
            let destinationVC = segue.destination as! RoutineInputViewController
            
            if let row = rowBeingEdited {
                destinationVC.routineBeingEdited = routines?[row]
            }
            
            destinationVC.delegate = self
        }
    }
    
    //MARK: - Data Manipulation methods
    func loadRoutines() {
    
        self.routines = self.realm.objects(Routine.self)
        self.routineTableView.reloadData()
    }
    
    func deleteRoutine(at indexPath: IndexPath) {
        if let routineForDeletion = self.routines?[indexPath.row] {
            RealmManager.delete(routineForDeletion, from: realm)
        }
    }
}

//MARK: - UITableViewDataSource methods
extension RoutineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "h:mm a"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: indexPath) as! RoutineCell
        
        cell.routineNameLabel.text = routines?[indexPath.row].name ?? "No Routines Added Yet"
                
        if let day = routines?[indexPath.row].day, let startTime = routines?[indexPath.row].startTime, let endTime = routines?[indexPath.row].endTime {
            let startTimeStr = dateformat.string(from: startTime)
            let endTimeStr = dateformat.string(from: endTime)
            
            cell.dayAndTimeLabel.text = "\(day) | \(startTimeStr) - \(endTimeStr)"
        } else {
            print("Error getting start/end times")
        }

        cell.delegate = self
    
        return cell
    }
}

//MARK: - UITableViewDelegate methods
extension RoutineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToExercises", sender: self)
    }
}

//MARK: - SwipeTableViewCellDelegate methods
extension RoutineViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                self.displayConfirmationAlert { deleteTapped in
                    if deleteTapped {
                        action.fulfill(with: .delete)
                        self.deleteRoutine(at: indexPath)
                        self.routineTableView.deleteRows(at: [indexPath], with: .left)
                    } else {
                        action.fulfill(with: .reset)
                    }
                }
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
        
        if orientation == .right {
            options.expansionStyle = .selection
        } else if orientation == .left {
            options.expansionStyle = .selection
        }
        
        return options
    }
    
    // Create delete confirmation alert with handler
    private func displayConfirmationAlert(completion: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this routine?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
            alert.dismiss(animated: true, completion: nil)
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
            completion(false)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - RoutineInputViewDelegate methods
extension RoutineViewController: RoutineInputViewDelegate {
    func didUpdateRoutines(_ routineInputViewController: RoutineInputViewController) {
        loadRoutines()
    }
}
