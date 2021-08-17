//
//  RealmHelper.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

struct RealmManager {
    static let shared = RealmManager()

    private init() {}
    
    //MARK: - Delete Data
    static func delete(_ object: Object, from realm: Realm) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("Error deleting routine, \(error)")
        }
        
    }
    
    //MARK: - Create/Update Data
    static func save(_ object: Object, to realm: Realm) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

