//
//  AppDelegate.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // save and load user data
    let defaults = UserDefaults.standard
    
    // keep track of the current config here
    var currentConfig: Config?  // struct Config is defined in InstrumentationViewController

    //  list of user config
    var userData: [Config] = [
        Config(
            name: "Test Data",
            size:  6,
            alive: [[1,0], [1,1]],
            born:  [[0,0], [0,1]],
            died:  [[2,0], [2,1]]
        )
    ]
        {
        didSet {
            let config = userData[0]
            let configDict = ["title" : config.name, "size" : config.size, "alive" : config.alive, "born" : config.born, "died" : config.died] as [String : Any]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: configDict, options: .prettyPrinted)
                print("json is ", jsonData)
                defaults.set(jsonData, forKey: "jsonData")
            } catch {
                print(error.localizedDescription)
            }            

            defaults.set(userData[0].name, forKey: "userData")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

//        fetch() // fetch JSON to create networkData
        
        // default setting if no user saved data
        currentConfig = Config(
            name: "Config Name",
            size:  10,
            alive: [],
            born:  [],
            died:  []
        )

        let defaults = UserDefaults.standard
        let recoveredData = defaults.object(forKey: "userData")
        guard recoveredData != nil else { return true }

        // DEBUG to check if the name on top of userData is recovered.
        print(recoveredData as! String)

//        let recoveredJson = defaults.object(forKey: "jsonData")
//        guard recoveredJson != nil else { return true }
//        let recoveredArray = recoveredJson as! NSArray
////        let recoveredDictionary = recoveredArray as! NSDictionary
//        print("recoveredArray is ", recoveredArray)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

