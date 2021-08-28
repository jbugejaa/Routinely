//
//  ExerciseCell.swift
//  Routinely
//
//  Created by Joshua Bugeja on 23/8/21.
//

import UIKit
import SwipeCellKit

class ExerciseCell: SwipeTableViewCell {
    
    @IBOutlet weak var exerciseNameTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var setsExpectedTextField:
        UITextField!
    @IBOutlet weak var repsExpectedTextField: UITextField!

    @IBOutlet weak var setsActualTextField: UITextField!
    @IBOutlet weak var repsActualTextField: UITextField!
    
    var textFields: [UITextField] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textFields = [exerciseNameTextField, weightTextField, setsExpectedTextField, repsExpectedTextField, setsActualTextField, repsActualTextField]
        
        enableEditing(isEditing: false)
    }
    
    func enableEditing(isEditing: Bool) {
        for textField in textFields {
            textField.borderStyle = isEditing ? .roundedRect : .none
            textField.isEnabled = isEditing
        }
    }
}
