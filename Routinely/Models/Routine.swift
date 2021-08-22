//
//  Routine.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

class Routine: Object {
    @Persisted var name: String = ""
    @Persisted var day: String = ""
    @Persisted var startTime: Date = Date()
    @Persisted var endTime: Date = Date()
}
