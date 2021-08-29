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
    var repsTextFields: [UITextField] = []
    var setsTextFields: [UITextField] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textFields = [exerciseNameTextField, weightTextField, setsExpectedTextField, repsExpectedTextField, setsActualTextField, repsActualTextField]
        repsTextFields = [repsExpectedTextField, repsActualTextField]
        setsTextFields = [setsExpectedTextField, setsActualTextField]
        
        for textField in textFields {
            textField.delegate = self
        }
        
        // Set maximum textfield lengths
        repsExpectedTextField.maxLength = 12
        repsActualTextField.maxLength = 12
        setsExpectedTextField.maxLength = 1
        setsActualTextField.maxLength = 1
        weightTextField.maxLength = 6
        
        ///^[0-9]{1,2}(,[0-9]{1,2})*$/gm
        
        // Disable editing for all textfield on load
        enableEditing(isEditing: false)
    }
    
    func enableEditing(isEditing: Bool) {
        for textField in textFields {
            textField.borderStyle = isEditing ? .roundedRect : .none
            textField.isEnabled = isEditing
        }
    }
}

extension ExerciseCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let repsAllowedCharacters = CharacterSet(charactersIn:"0123456789,").inverted
        let weightAllowedCharacters = CharacterSet(charactersIn:"0123456789.").inverted
        let setsAllowedCharacters = CharacterSet(charactersIn:"0123456789").inverted
        
        var allowedCharacters: CharacterSet
        if repsTextFields.contains(textField) {
            allowedCharacters = repsAllowedCharacters
        } else if setsTextFields.contains(textField) {
            allowedCharacters = setsAllowedCharacters
        } else if weightTextField == textField {
            allowedCharacters = weightAllowedCharacters
        } else {
            return true
        }
        
        let compSepByCharInSet = string.components(separatedBy: allowedCharacters)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        return string == numberFiltered
    }
}
