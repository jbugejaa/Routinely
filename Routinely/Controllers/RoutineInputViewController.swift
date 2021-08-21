//
//  RoutineInputViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 18/8/21.
//

import UIKit
import RealmSwift

protocol RoutineInputViewDelegate {
    func didUpdateWeather(_ routineInputViewController: RoutineInputViewController)
}

class RoutineInputViewController: UIViewController {
    
    var realm = try! Realm()
    
    var delegate: RoutineInputViewDelegate?
        
    @IBOutlet weak var routineNameText: UITextField!
    
    @IBOutlet weak var enterRoutineBarView: UIView!
        
    @IBOutlet weak var routineInputTableView: UITableView!
    
    var timeRowSelected: Bool = false
    
    var dayRowSelected: Bool = false
    
    var routineInputCellDataArray: [RoutineInputCellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routineInputTableView.layer.cornerRadius = 20
        routineInputTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        enterRoutineBarView.layer.cornerRadius = 20
        enterRoutineBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        routineInputCellDataArray.append(RoutineInputCellData("Day", "Monday", "calendar"))
        routineInputCellDataArray.append(RoutineInputCellData("Start Time", "12:00 PM", "clock"))
        routineInputCellDataArray.append(RoutineInputCellData("End Time", "2:00 PM", "clock.fill"))
        
        routineInputTableView.register(UINib(nibName: "DayTimeCell",
                                        bundle: nil), forCellReuseIdentifier: "DayTimeCell")
        
        routineInputTableView.dataSource = self
        routineInputTableView.delegate = self
        
        routineInputTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    
    //MARK: - Top bar button Actions
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            let newRoutine = Routine()
            let dateformat = DateFormatter()
            dateformat.dateFormat = "h:mm a"
            
            newRoutine.name = self.routineNameText.text ?? ""
            newRoutine.day = self.routineInputCellDataArray[0].subtitle
            newRoutine.startTime = dateformat.date(from: self.routineInputCellDataArray[1].subtitle)
            newRoutine.endTime = dateformat.date(from: self.routineInputCellDataArray[2].subtitle)
            
            RealmManager.save(newRoutine, to: self.realm)
            
            self.delegate?.didUpdateWeather(self)
        }
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
    func didUpdateDayTime(_ dayTimeCell: DayTimeCell, time: String) {
        if let collectionView = dayTimeCell.superview as? UITableView, let indexPath = collectionView.indexPath(for: dayTimeCell)
               {
            routineInputCellDataArray[indexPath.row].subtitle = time
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
