//
//  RoutineInputViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 18/8/21.
//

import UIKit
import RealmSwift

protocol RoutineInputViewDelegate {
    func didUpdateRoutines(_ routineInputViewController: RoutineInputViewController)
}

class RoutineInputViewController: UIViewController {
    
    var realm = try! Realm()
    
    var routineModel:  RoutineModel?
    
    var delegate: RoutineInputViewDelegate?
        
    @IBOutlet weak var routineNameText: UITextField!
    
    @IBOutlet weak var enterRoutineBarView: UIView!
        
    @IBOutlet weak var routineInputTableView: UITableView!
    
    var routineBeingEdited: Routine?
    
    var timeRowSelected: Bool = false
    
    var dayRowSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI components
        routineInputTableView.layer.cornerRadius = 20
        routineInputTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        enterRoutineBarView.layer.cornerRadius = 20
        enterRoutineBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Setup input UI routine values in model
        routineModel?.setupInputUI(routineBeingEdited)
        routineNameText.text = self.routineBeingEdited?.name
        
        // Input table view setup
        routineInputTableView.register(UINib(nibName: "DayTimeCell",
                                        bundle: nil), forCellReuseIdentifier: "DayTimeCell")
        routineInputTableView.dataSource = self
        routineInputTableView.delegate = self
        routineInputTableView.tableFooterView = UIView(frame: .zero)
    }
    
    //MARK: - Top bar button press actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {

        // Verifying user input
        if self.routineNameText.text == nil || self.routineNameText.text == "" {
            let alert = UIAlertController(title: "Oops", message: "Please enter a routine name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if routineModel!.startTimeDate > routineModel!.endTimeDate {
            let alert = UIAlertController(title: "Oops", message: "Please enter a valid time range", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Dismiss modal and save data to DB
            dismiss(animated: true) {
                if let existingRoutine = self.routineBeingEdited {
                    self.updateRoutine(from: existingRoutine)
                } else {
                    self.addRoutine()
                }
                
                self.delegate?.didUpdateRoutines(self)
            }
        }
    }
    
    //MARK: - Data manipulation methods
    func updateRoutine(from existingRoutine: Routine) {
        routineModel?.updateRoutine(from: existingRoutine, with: routineNameText.text!)
    }
    
    func addRoutine() {
        routineModel?.addRoutine(with: routineNameText.text!)
    }
}

//MARK: - UITableViewDataSource methods
extension RoutineInputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (routineModel?.routineInputCellDataArray.count)! }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayTimeCell", for: indexPath) as! DayTimeCell
        
        routineModel?.populateDayTimeCell(withCell: cell, withIndexPath: indexPath, routineBeingEdited)
                
        cell.delegate = self
        
        return cell
    }
}

//MARK: - UITableViewDelegate methods
extension RoutineInputViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? DayTimeCell {
            if cell.titleLabel.text == "Day" {
                cell.dayPickerView.isHidden = !cell.dayPickerView.isHidden
            } else {
                cell.timePickerView.isHidden = !cell.timePickerView.isHidden
            }
            tableView.reloadData()
        }
    }
}

//MARK: - DayTimeCellDelegate methods
extension RoutineInputViewController: DayTimeCellDelegate {
    func didUpdateDayTime(_ dayTimeCell: DayTimeCell, dayOrTime: String) {
        if let collectionView = dayTimeCell.superview as? UITableView, let indexPath = collectionView.indexPath(for: dayTimeCell)
               {
            routineModel?.updateDayTimeCell(with: indexPath, with: dayOrTime)
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
