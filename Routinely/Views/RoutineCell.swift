//
//  RoutineCellVIew.swift
//  Routinely
//
//  Created by Joshua Bugeja on 18/8/21.
//

import UIKit
import SwipeCellKit

class RoutineCell: SwipeTableViewCell {
    
    @IBOutlet weak var routineNameLabel: UILabel!
    
    @IBOutlet weak var dayAndTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
