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
    
    @Persisted var numberOfSetsActual: String = ""
    @Persisted var numberOfRepsRangeActual: String = ""
    
    @Persisted var numberOfSetsCurrent: String = ""
    @Persisted var numberOfRepsRangeCurrent: String = ""
    
    var parentRoutine = LinkingObjects(fromType: Routine.self, property: "exercises")
}
