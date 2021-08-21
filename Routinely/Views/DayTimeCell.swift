//
//  DayTimeCell.swift
//  Routinely
//
//  Created by Joshua Bugeja on 19/8/21.
//

import UIKit

protocol DayTimeCellDelegate {
    func didUpdateDayTime(_ dayTimeCell: DayTimeCell, time: String)
    func didFailWithError(error: Error)
}

class DayTimeCell: UITableViewCell {
    
    var delegate: DayTimeCellDelegate?

    @IBOutlet weak var iconBackground: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var timePickerView: UIView!
    
    @IBOutlet weak var dayPicker: UIPickerView!
    
    @IBOutlet weak var dayPickerView: UIView!
    
    let dayPickerData = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconBackground.layer.cornerRadius = 15
        iconBackground.layer.masksToBounds = true
        
        timePickerView.isHidden = true
        dayPickerView.isHidden = true
        
        dayPicker.dataSource = self
        dayPicker.delegate = self
    }

    @IBAction func timeValueChanged(_ sender: UIDatePicker) {
        
        let timeString = sender.date.getFormattedDate(format: "h:mm a")
        
        subtitleLabel.text = timeString
        delegate?.didUpdateDayTime(self, time: timeString)
    }
}

extension DayTimeCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayPickerData.count
    }
}

extension DayTimeCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let dayString = dayPickerData[row]

        delegate?.didUpdateDayTime(self, time: dayString)
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
