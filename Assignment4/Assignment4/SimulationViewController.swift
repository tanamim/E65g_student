//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, UITabBarDelegate {

    
    @IBOutlet weak var step: UIButton!
    @IBOutlet weak var gridView: GridView!
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var engine: StandardEngine!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set initial size
        let size = appDelegate.instrumentation.size
        gridView.size = size

        engine = StandardEngine(size, size)  // singleton
        engine.delegate = self
        
        gridView.setNeedsDisplay()
        print("Now the size is \(size)")
 
        // notification receiver
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            print("Notification received. Now size is \(self.appDelegate.instrumentation.size)")
            self.gridView.size = self.appDelegate.instrumentation.size
            self.gridView.setNeedsDisplay()
        }
    }

    func engineDidUpdate(withGrid: GridProtocol) {
        self.gridView.setNeedsDisplay()
    }

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func next (_ sender: Any) {
        gridView.grid = gridView.grid.next()
        gridView.setNeedsDisplay()
    }
    
    
    // Assignment3 Part6
    @IBAction func pressStep(_ sender: Any) {

        print(appDelegate.instrumentation.size)
        gridView.grid = gridView.grid.next()
        gridView.setNeedsDisplay()
    }
    
    @IBAction func pressReset(_ sender: Any) {
        gridView.grid = Grid(gridView.size, gridView.size)
        gridView.setNeedsDisplay()
    }


}

