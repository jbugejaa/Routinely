//
//  DateCell.swift
//  Routinely
//
//  Created by Joshua Bugeja on 18/8/21.
//

import UIKit

class DayCell: UITableViewCell {
    
    @IBOutlet weak var iconBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconBackground.layer.cornerRadius = 15
        iconBackground.layer.masksToBounds = true
        
    }
}
