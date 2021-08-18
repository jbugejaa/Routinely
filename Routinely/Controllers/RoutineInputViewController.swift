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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsContainerView.layer.cornerRadius = 20
        optionsContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
