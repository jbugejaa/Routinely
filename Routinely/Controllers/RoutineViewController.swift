//
//  ViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

class RoutineViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var routines: Results<Routine>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRoutines()
    }

    
    @IBAction func addRoutine(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Workout Routine", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            // Add item action
            
            let newRoutine = Routine()
            newRoutine.name = textField.text!
            
            self.save(withRoutine: newRoutine)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new routine"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines?.count ?? 1
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = routines?[indexPath.row].name ?? "No Routines Added Yet"
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func save(withRoutine routine: Routine) {
        do {
            try realm.write {
                realm.add(routine)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadRoutines() {
        routines = realm.objects(Routine.self)
        self.tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let routineForDeletion = self.routines?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(routineForDeletion)
                }
            } catch {
                print("Error deleting routine, \(error)")
            }
        }
    }
    
}

