//
//  AppDelegate.swift
//  Routinely
//
//  Created by Joshua Bugeja on 17/8/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            let realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "No URL")
            
            if (realm.objects(RoutineList.self).first == nil) {
                try realm.write {
                    realm.create(RoutineList.self)
                }
            }
        } catch {
            print("Error initialising new realm, \(error)")
        }
        return true
    }
}

