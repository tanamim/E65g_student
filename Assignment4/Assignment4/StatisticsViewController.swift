//
//  ThirdViewController.swift
//  Assignment4
//
//  Created by Chiryoku Inc. on 4/18/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var aliveLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var diedLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var engine: StandardEngine!

    internal func drawStat() -> Void {
        self.aliveLabel.text = "alive: \(engine.gridStat.alive)"
        self.bornLabel.text = "born: \(engine.gridStat.born)"
        self.diedLabel.text = "died: \(engine.gridStat.died)"
        self.emptyLabel.text = "empty: \(engine.gridStat.empty)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        engine = StandardEngine.engine
        drawStat()
        
//        self.aliveLabel.text = "alive: \(appDelegate.gridStat.alive)"
//        self.bornLabel.text = "born: \(appDelegate.gridStat.born)"
//        self.diedLabel.text = "died: \(appDelegate.gridStat.died)"
//        self.emptyLabel.text = "empty: \(appDelegate.gridStat.empty)"  // [Update]
//        self.emptyLabel.text = "empty: all"  // initially all is empty
        
        
        // notification [StatUpdate] receiver catches grid size chages
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "StatUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
//            let stat = appDelegate.gridStat
            print("Notification [StatUpdate] received at [Statistics].")
//            self.aliveLabel.text = "alive: \(appDelegate.gridStat.alive)"
//            self.bornLabel.text = "born: \(appDelegate.gridStat.born)"
//            self.diedLabel.text = "died: \(appDelegate.gridStat.died)"
//            self.emptyLabel.text = "empty: \(appDelegate.gridStat.empty)"
            self.drawStat()
        }

        // notification [GridUpdate] receiver from instrumentation
//        let nc2 = NotificationCenter.default
//        let name2 = Notification.Name(rawValue: "GridUpdate")
//        nc2.addObserver(forName: name2, object: nil, queue: nil) { (n) in
//            let stat = appDelegate.gridStat
//            print("Notification [GridUpdate] received at [Statistics].", stat)
//            self.aliveLabel.text = "alive: \(appDelegate.gridStat.alive)"
//            self.bornLabel.text = "born: \(appDelegate.gridStat.born)"
//            self.diedLabel.text = "died: \(appDelegate.gridStat.died)"
//            self.emptyLabel.text = "empty: \(appDelegate.gridStat.empty)"
//        }
    
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
