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
    
    func populateNewCell(withCell cell: RoutineCell, withIndexPath indexPath: IndexPath) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "h:mm a"
        
        cell.routineNameLabel.text = routines?[indexPath.row].name ?? "No Routines Added Yet"

        if let day = routines?[indexPath.row].day, let startTime = routines?[indexPath.row].startTime, let endTime = routines?[indexPath.row].endTime {
            let startTimeStr = dateformat.string(from: startTime)
            let endTimeStr = dateformat.string(from: endTime)

            cell.dayAndTimeLabel.text = "\(day) | \(startTimeStr) - \(endTimeStr)"
        } else {
            print("Error getting start/end times")
        }
    }
    
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
}
