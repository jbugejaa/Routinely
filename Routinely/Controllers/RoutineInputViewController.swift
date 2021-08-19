//
//  RoutineInputViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 18/8/21.
//

import UIKit

class RoutineInputViewController: UIViewController {
        
    @IBOutlet weak var routineNameText: UITextField!
    
    @IBOutlet weak var optionsContainerView: UIView!
    
    @IBOutlet weak var routineInputTableView: UITableView!
    
    var timeRowSelected: Bool = false
    
    var dayRowSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsContainerView.layer.cornerRadius = 20
        optionsContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        routineInputTableView.register(UINib(nibName: "DayCell",
                                        bundle: nil), forCellReuseIdentifier: "DayCell")
        routineInputTableView.register(UINib(nibName: "TimeCell",
                                        bundle: nil), forCellReuseIdentifier: "TimeCell")
        
        routineInputTableView.dataSource = self
        routineInputTableView.delegate = self
    }
}

extension RoutineInputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            assertionFailure("Missing sections")
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeCell
        default:
            assertionFailure("Missing sections")
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension RoutineInputViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("Selected day row")
        case 1:
            print("Selected time row")
        default:
            assertionFailure("Missing sections")
        }
    }
}
