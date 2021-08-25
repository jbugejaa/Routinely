//
//  ExercisesViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

// TODO(Joshua): Finish mapping exercise data in table view cell to DB

class ExercisesViewController: UIViewController {
    
    @IBOutlet weak var exerciseTableView: UITableView!
    
    var realm = try! Realm()
    
    var exercises: Results<Exercise>?
    
    var selectedRoutine: Routine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseTableView.rowHeight = 132
        exerciseTableView.register(UINib(nibName: "ExerciseCell",
                                        bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        
        loadExercises()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try realm.write {
                let newExercise = Exercise()

                newExercise.name = ""
                newExercise.numberOfSetsActual = 1
                newExercise.numberOfSetsCurrent = 1
                newExercise.numberOfRepsRangeCurrent.append(1)
                newExercise.numberOfRepsRangeCurrent.append(1)
                
                realm.add(newExercise)

                selectedRoutine?.exercises.append(newExercise)
            }
        } catch {
            print("Error updating context, \(error)")
        }
        
        loadExercises()
    }
    
    //MARK: - Data manipulation methods
    func loadExercises() {
        exercises = selectedRoutine?.exercises.sorted(byKeyPath: "name", ascending: true)
        exerciseTableView.reloadData()
    }
}

//MARK: - UITableViewDataSource methods
extension ExercisesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        cell.textLabel?.text = exercises?[indexPath.row].name ?? "No Exercises Added Yet"
        
        return cell
    }
}
