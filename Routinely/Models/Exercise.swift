//
//  Exercise.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

class Exercise: Object {
    
    @Persisted var name: String = ""
    @Persisted var weightInKg: String = ""
    
    @Persisted var setsActual: String = ""
    @Persisted var repsActual: String = ""
    
    @Persisted var setsExpected: String = ""
    @Persisted var repsExpected: String = ""
    
    var parentRoutine = LinkingObjects(fromType: Routine.self, property: "exercises")
}
