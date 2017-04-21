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

    var viewControllers: [UIViewController] = []

    // Globals for instrumentation and simulation
    struct Instrumentation {
        var size: Int
        var rate: Double
        var refresh: Bool
    }

    // Globals for Statistics
    struct GridStat {
        var alive: Int
        var born: Int
        var died: Int
        var empty: Int
    }

    // this value will be changed by StatUpdate notification
    var gridStat = GridStat(alive: 0, born: 0, died: 0, empty: 100)

    // monitor Globals for instrumentation and publish GridUpdate notification
    var instrumentation = Instrumentation(
    size: 10, rate: 3.0, refresh: true) {
        didSet {
            print("AppDelegate: instrumentation.size is \(self.instrumentation.size)")
            print("AppDelegate: instrumentation.rate is \(self.instrumentation.rate)")
            print("AppDelegate: instrumentation.refresh is \(self.instrumentation.refresh)")

            gridStat = GridStat(alive: 0, born: 0, died: 0, empty: self.instrumentation.size * self.instrumentation.size)
            
            // notification [GridUpdate] pualisher
            let nc = NotificationCenter.default
            let name = Notification.Name(rawValue: "GridUpdate")
            let n = Notification(name: name, object: nil, userInfo: ["AppDelegate": self])
            nc.post(n)
        }
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

