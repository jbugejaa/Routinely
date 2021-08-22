//
//  Routine.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

class Routine: Object {
    @objc dynamic var name: String = "Untitled"
    @objc dynamic var day: String?
    @objc dynamic var startTime: Date?
    @objc dynamic var endTime: Date?
}
