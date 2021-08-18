//
//  ExercisesViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

class ExercisesViewController: UIViewController {
    
    @IBOutlet weak var exercisesTableView: UITableView!
    
    var realm = try! Realm()
    
    var exercises: Results<Exercise>?
    
    var selectedRoutine: Routine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exercisesTableView.rowHeight = 80.0
        exercisesTableView.separatorStyle = .none
        
        exercisesTableView.dataSource = self
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
