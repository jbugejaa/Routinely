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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        routineTableView.rowHeight = 80.0
        routineTableView.separatorStyle = .none
        
        loadRoutines()
    }

    
    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Workout Routine", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Routine", style: .default) { action in
            // Add item action
            
            let newRoutine = Routine()
            newRoutine.name = textField.text!
            
            RealmManager.save(newRoutine, to: self.realm)
            self.routineTableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new routine"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation methods
    func loadRoutines() {
        routines = realm.objects(Routine.self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = routines?[indexPath.row].name ?? "No Routines Added Yet"

        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate methods
extension RoutineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToExercises", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExercisesViewController
        
        if let indexPath = routineTableView.indexPathForSelectedRow {
            destinationVC.selectedRoutine = routines?[indexPath.row]
        }
    }
}

//MARK: - SwipeTableViewCellDelegate methods
extension RoutineViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteRoutine(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

