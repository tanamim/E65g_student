//
//  MyTabBarController.swift
//  Assignment4
//
//  Created by Masakazu Tanami on 4/18/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // icon color
        UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 233/255, blue: 51/255, alpha: 1.0) // yellow
        
        // icon background
        UITabBar.appearance().barTintColor = UIColor(red: 66/255, green: 74/255, blue: 93/255, alpha: 1.0) // grey black
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
