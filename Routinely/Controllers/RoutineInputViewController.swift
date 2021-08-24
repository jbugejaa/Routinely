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
    
    var delegate: RoutineInputViewDelegate?
        
    @IBOutlet weak var routineNameText: UITextField!
    
    @IBOutlet weak var enterRoutineBarView: UIView!
        
    @IBOutlet weak var routineInputTableView: UITableView!
    
    var routineBeingEdited: Routine?
    
    var timeRowSelected: Bool = false
    
    var dayRowSelected: Bool = false
    
    var routineInputCellDataArray: [RoutineInputCellData] = []
    
    var startTime: String = "12:00 PM"
    
    var startTimeDate: Date {
        return dateFormatter.date(from: self.routineInputCellDataArray[1].subtitle)!
    }
    
    var endTime: String = "12:00 PM"
    
    var endTimeDate: Date {
        return dateFormatter.date(from: self.routineInputCellDataArray[2].subtitle)!
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise dateformat
        dateFormatter.dateFormat = "h:mm a"
        
        // Setup UI components
        routineInputTableView.layer.cornerRadius = 20
        routineInputTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        enterRoutineBarView.layer.cornerRadius = 20
        enterRoutineBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Setup initial routine values
        if let existingRoutine = self.routineBeingEdited {
            startTime = dateFormatter.string(from: existingRoutine.startTime)
            endTime = dateFormatter.string(from: existingRoutine.endTime)
        }
        routineNameText.text = self.routineBeingEdited?.name
        routineInputCellDataArray.append(RoutineInputCellData("Day", self.routineBeingEdited?.day ?? "Monday", "calendar"))
        routineInputCellDataArray.append(RoutineInputCellData("Start Time", startTime, "clock"))
        routineInputCellDataArray.append(RoutineInputCellData("End Time", endTime, "clock.fill"))
        
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
        } else if startTimeDate > endTimeDate {
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
    
    //MARK: - Update routine methods
    func updateRoutine(from existingRoutine: Routine) {
        do {
            try realm.write {
                existingRoutine.name = self.routineNameText.text!
                existingRoutine.day = self.routineInputCellDataArray[0].subtitle
                existingRoutine.startTime = startTimeDate
                existingRoutine.endTime = endTimeDate
            }
        } catch {
            print("Error updating context, \(error)")
        }
    }
    func addRoutine() {
        let newRoutine = Routine()
        newRoutine.name = self.routineNameText.text!
        newRoutine.day = self.routineInputCellDataArray[0].subtitle
        newRoutine.startTime = startTimeDate
        newRoutine.endTime = endTimeDate

        RealmManager.save(newRoutine, to: self.realm)
    }
}

//MARK: - UITableViewDataSource methods
extension RoutineInputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return routineInputCellDataArray.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayTimeCell", for: indexPath) as! DayTimeCell
        
        cell.titleLabel.text = routineInputCellDataArray[indexPath.row].title
        cell.subtitleLabel.text = routineInputCellDataArray[indexPath.row].subtitle
        cell.cellImageView.image = UIImage(systemName: routineInputCellDataArray[indexPath.row].imageName)
        
        if let existingRoutine = self.routineBeingEdited {

            switch cell.titleLabel.text {
            case "Day":
                if let indexPosition = cell.dayPickerData.firstIndex(of: existingRoutine.day) {
                    cell.dayPicker.selectRow(indexPosition, inComponent: 0, animated: true)
                }
            case "Start Time":
                cell.timePicker.date = existingRoutine.startTime
            case "End Time":
                cell.timePicker.date = existingRoutine.endTime
            default:
                print("Error, incorrect title for day/time cell")
            }
        }
                
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
            routineInputCellDataArray[indexPath.row].subtitle = dayOrTime
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
