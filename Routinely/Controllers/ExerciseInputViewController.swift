//
//  ExerciseInputViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 10/9/21.
//

import UIKit
import RealmSwift

class ExerciseInputViewController: UIViewController {
    @IBOutlet weak var selectionButtonOne: UIButton!
    @IBOutlet weak var selectionButtonTwo: UIButton!
    @IBOutlet weak var selectionButtonThree: UIButton!
    @IBOutlet weak var selectionButtonFour: UIButton!
    
    var selectionButtons: [UIView] = []
    
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        selectionButtons = [selectionButtonOne, selectionButtonTwo, selectionButtonThree, selectionButtonFour]
        
        for button in selectionButtons {
            button.layer.cornerRadius = 25
        }
    }
    
    @IBAction func selectionButtonPressed(_ sender: UIButton) {
        if let safeSelectedButton = selectedButton {
            safeSelectedButton.layer.borderColor = nil
            safeSelectedButton.layer.borderWidth = 0.0
        }
            
        sender.layer.borderColor = #colorLiteral(red: 0.3647058824, green: 0.8862745098, blue: 0.2352941176, alpha: 1)
        sender.layer.borderWidth = 0.75
        
        Helper.animatePress(on: sender)
        
        selectedButton = sender
        print("\(sender.currentTitle!) button pressed")
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            // handler
        }
    }
}
