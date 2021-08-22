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
    
    @Persisted var numberOfSets: Int = 0
    
    @Persisted var numberOfRepsMin: Int = 0
    @Persisted var numberOfRepsMax: Int?
    
}
