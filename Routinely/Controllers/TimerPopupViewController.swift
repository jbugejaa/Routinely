//
//  TimerPopupViewController.swift
//  Routinely
//
//  Created by Joshua Bugeja on 12/9/21.
//

import UIKit
import BottomPopup

class TimerPopupViewController: BottomPopupViewController {
    @IBOutlet weak var timePickerView: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectPickerViewRows()
    }

}

extension TimerPopupViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = String(row)
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if let label = pickerView.view(forRow: row, forComponent: component) as? UILabel {

            if component == 0, row > 1 {
                label.text = String(row) + " hours"
            }
            else if component == 0 {
                label.text = String(row) + " hour"
            }
            else if component == 1 {
                label.text = String(row) + " min"
            }
            else if component == 2 {
                label.text = String(row) + " sec"
            }
        }
    }
    
    func selectPickerViewRows() {
        timePickerView.selectRow(0, inComponent: 0, animated: false)
        timePickerView.selectRow(0, inComponent: 1, animated: false)
        timePickerView.selectRow(30, inComponent: 2, animated: false)

        pickerView(timePickerView, didSelectRow: 0, inComponent: 0)
        pickerView(timePickerView, didSelectRow: 0, inComponent: 1)
        pickerView(timePickerView, didSelectRow: 30, inComponent: 2)
    }
}
