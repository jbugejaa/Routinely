//
//  ExerciseModel.swift
//  Routinely
//
//  Created by Joshua Bugeja on 7/9/21.
//

import UIKit
import RealmSwift

struct ExerciseModel {
    var realm = try! Realm()
    
    var exercises: List<Exercise>?

    //MARK: - Data manipulation methods
    func addExercise() {
        do {
            try realm.write {
                let newExercise = Exercise()

                newExercise.name = "Enter name..."
                newExercise.setsActual = "3"
                newExercise.repsActual = "3"
                newExercise.setsExpected = "5"
                newExercise.repsExpected = "5"
                newExercise.weightInKg = "60"
                
                realm.add(newExercise)

                exercises?.append(newExercise)
            }
        } catch {
            print("Error adding exercise, \(error)")
        }
    }
    
    func saveExercise(with cell: ExerciseCell, with indexPath: IndexPath) {
        if let exercise = exercises?[indexPath.row] {
            do {
                try realm.write {
                    exercise.name = cell.exerciseNameTextField.text ?? ""
                    exercise.weightInKg = cell.weightTextField.text ?? ""
                    exercise.repsExpected = cell.repsExpectedTextField.text ?? ""
                    exercise.setsExpected = cell.setsExpectedTextField.text ?? ""
                    exercise.repsActual = cell.repsActualTextField.text ?? ""
                    exercise.setsActual = cell.setsActualTextField.text ?? ""
                }
            } catch {
                print("Error updating exercise, \(error)")
            }
        }
    }
    
    func deleteExercise(at indexPath: IndexPath) {
        if let exerciseForDeletion = exercises?[indexPath.row] {
            do {
                try realm.write {
                    exercises?.remove(at: indexPath.row)
                    realm.delete(exerciseForDeletion)
                }
            } catch {
                print("Error deleting routine, \(error)")
            }
        }
    }
    
    //MARK: - Setup methods
    func populateNewExerciseCell(withCell cell: ExerciseCell, withIndexPath indexPath: IndexPath) {
        if let safeExercises = exercises {
            cell.exerciseNameTextField.text = safeExercises[indexPath.row].name
            cell.weightTextField.text = safeExercises[indexPath.row].weightInKg
            cell.setsExpectedTextField.text = safeExercises[indexPath.row].setsExpected
            cell.repsExpectedTextField.text = safeExercises[indexPath.row].repsExpected
            cell.setsActualTextField.text = safeExercises[indexPath.row].setsActual
            cell.repsActualTextField.text = safeExercises[indexPath.row].repsActual
        }
    }
    
    //MARK: - Drag n' drop methods
    func moveCell(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write({
                exercises?.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
            })
        } catch {
            print("Error moving exercise from \(sourceIndexPath.row) to \(destinationIndexPath.row), \(error)")
        }
    }
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = exercises?[indexPath.row]
        return [ dragItem ]
    }
}
