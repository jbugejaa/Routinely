//
//  Helper.swift
//  Routinely
//
//  Created by Joshua Bugeja on 28/8/21.
//

import UIKit
import Foundation

struct Helper {
    //MARK: - Method to display deletion confirmation alert
    static func displayDeletionConfirmationAlert(_ vc: UIViewController, itemNameBeingDeleted: String, completion: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this \(itemNameBeingDeleted.lowercased())?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
            alert.dismiss(animated: true, completion: nil)
            completion(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
            completion(false)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Create extension method for UITextField to set maxLength of field
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t: String = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
