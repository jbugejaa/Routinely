//
//  Helper.swift
//  Routinely
//
//  Created by Joshua Bugeja on 28/8/21.
//

import UIKit
import Foundation

struct Helper {
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
