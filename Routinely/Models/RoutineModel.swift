//
//  RoutineModel.swift
//  Routinely
//
//  Created by Joshua Bugeja on 7/9/21.
//

import UIKit
import RealmSwift

struct RoutineModel {
    var realm = try! Realm()
    
    var routines: List<Routine>?
        
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "h:mm a"
    }
    
    //MARK: - Data manipulation methods (routine view)
    func deleteRoutine(at indexPath: IndexPath) {
        if let routineForDeletion = routines?[indexPath.row] {
           do {
               try realm.write {
                   routines?.remove(at: indexPath.row)
                   realm.delete(routineForDeletion)
               }
           } catch {
               print("Error deleting routine, \(error)")
           }
       }
    }
    
    mutating func loadRoutines() {
        routines = self.realm.objects(RoutineList.self).first!.routines
    }
    
    //MARK: - Setup methods (routine view)
    func populateNewRoutineCell(withCell cell: RoutineCell, withIndexPath indexPath: IndexPath) {
        
        cell.routineNameLabel.text = routines?[indexPath.row].name ?? "No Routines Added Yet"

        if let day = routines?[indexPath.row].day, let startTime = routines?[indexPath.row].startTime, let endTime = routines?[indexPath.row].endTime {
            let startTimeStr = dateFormatter.string(from: startTime)
            let endTimeStr = dateFormatter.string(from: endTime)

            cell.dayAndTimeLabel.text = "\(day) | \(startTimeStr) - \(endTimeStr)"
        } else {
            print("Error getting start/end times")
        }
    }
    
    //MARK: - Drag n' drop methods
    func moveCell(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write({
                routines?.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
            })
        } catch {
            print("Error moving routine from \(sourceIndexPath.row) to \(destinationIndexPath.row), \(error)")
        }
    }
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = routines?[indexPath.row]
        return [ dragItem ]
    }
    
    //MARK: - Routine Input Modal UI
    var routineInputCellDataArray: [RoutineInputCellData] = []
    
    var startTimeDate: Date {
        return dateFormatter.date(from: self.routineInputCellDataArray[1].subtitle)!
    }

    var endTimeDate: Date {
        return dateFormatter.date(from: self.routineInputCellDataArray[2].subtitle)!
    }
    
    //MARK: - Setup methods (routine input view)
    mutating func setupInputUI(_ routineBeingEdited: Routine?) {
        let startTime = (routineBeingEdited != nil) ? dateFormatter.string(from: routineBeingEdited!.startTime) : "12:00 PM"
        let endTime = (routineBeingEdited != nil) ? dateFormatter.string(from: routineBeingEdited!.endTime) : "12:00 PM"
        
        routineInputCellDataArray.append(RoutineInputCellData("Day", routineBeingEdited?.day ?? "Monday", "calendar"))
        routineInputCellDataArray.append(RoutineInputCellData("Start Time", startTime, "clock"))
        routineInputCellDataArray.append(RoutineInputCellData("End Time", endTime, "clock.fill"))
    }
    
    func populateDayTimeCell(withCell cell: DayTimeCell, withIndexPath indexPath: IndexPath, _ routineBeingEdited: Routine?) {
        cell.titleLabel.text = routineInputCellDataArray[indexPath.row].title
        cell.subtitleLabel.text = routineInputCellDataArray[indexPath.row].subtitle
        cell.cellImageView.image = UIImage(systemName: routineInputCellDataArray[indexPath.row].imageName)

        if let existingRoutine = routineBeingEdited {
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
    }
 
    //MARK: - Data manipulation methods (routine input view)
    func updateRoutine(from existingRoutine: Routine, with routineName: String) {
        do {
            try realm.write {
                existingRoutine.name = routineName
                existingRoutine.day = self.routineInputCellDataArray[0].subtitle
                existingRoutine.startTime = startTimeDate
                existingRoutine.endTime = endTimeDate
            }
        } catch {
            print("Error updating context, \(error)")
        }
    }
    
    func addRoutine(with routineName: String) {
        let newRoutine = Routine()
        newRoutine.name = routineName
        newRoutine.day = routineInputCellDataArray[0].subtitle
        newRoutine.startTime = startTimeDate
        newRoutine.endTime = endTimeDate

        do {
            try realm.write {
                realm.add(newRoutine)
                realm.objects(RoutineList.self).first!.routines.append(newRoutine)
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    //MARK: - Updating methods
    mutating func updateDayTimeCell(with indexPath: IndexPath, with dayOrTime: String) {
        routineInputCellDataArray[indexPath.row].subtitle = dayOrTime
    }
}
