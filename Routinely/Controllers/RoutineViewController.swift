//
//  ViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift
import SwipeCellKit

// TODO(Joshua) - Load routine date from local DB properly

class RoutineViewController: UIViewController {
    
    var realm = try! Realm()
    
    @IBOutlet weak var routineTableView: UITableView!
    
    var routines: Results<Routine>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        routineTableView.register(UINib(nibName: "RoutineCell",
                                        bundle: nil), forCellReuseIdentifier: "RoutineCell")
        routineTableView.rowHeight = 80.0
        routineTableView.separatorStyle = .none
        
        loadRoutines()
    }

    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToRoutineInput", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExercises" {
            
            let destinationVC = segue.destination as! ExercisesViewController
    
            if let indexPath = routineTableView.indexPathForSelectedRow {
                destinationVC.selectedRoutine = routines?[indexPath.row]
            }
        } else if segue.identifier == "goToRoutineInput" {
            let destinationVC = segue.destination as! RoutineInputViewController
            
            destinationVC.delegate = self
        }
    }
    
    //MARK: - Data Manipulation methods
    func loadRoutines() {
        
        DispatchQueue.main.async {
            self.routines = self.realm.objects(Routine.self)
            self.routineTableView.reloadData()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: indexPath) as! RoutineCell
        
        cell.routineNameLabel.text = routines?[indexPath.row].name ?? "No Routines Added Yet"

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

//MARK: - RoutineInputViewDelegate methods
extension RoutineViewController: RoutineInputViewDelegate {
    func didUpdateWeather(_ routineInputViewController: RoutineInputViewController) {
        loadRoutines()
    }
}
