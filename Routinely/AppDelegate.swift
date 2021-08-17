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
            _ = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL ?? "No URL")
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

}

