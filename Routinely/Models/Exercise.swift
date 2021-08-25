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
    @Persisted var weightInKg: Int = 0
    @Persisted var numberOfSetsActual: Int = 0
    @Persisted var numberOfRepsRangeActual: List<Int> = List<Int>()
    @Persisted var numberOfSetsCurrent: Int = 0
    @Persisted var numberOfRepsRangeCurrent: List<Int> = List<Int>()
    
    var parentRoutine = LinkingObjects(fromType: Routine.self, property: "exercises")
}
