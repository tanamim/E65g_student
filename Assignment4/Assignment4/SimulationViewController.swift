//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, UITabBarDelegate {

    
//    @IBOutlet weak var step: UIButton!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var sizeLabel: UILabel!  // shows like (Size: 10 x 10)
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let minSize = 3
    let maxSize = 100
    let stepAmount = 5  // amount in Instrumentation is 10
    
    var engine: StandardEngine!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set initial size
        let size = appDelegate.instrumentation.size
        gridView.size = size
        sizeLabel.text = "Size: \(size) x \(size)"
        
        engine = StandardEngine(size, size)  // singleton
        engine.delegate = self
        
        gridView.setNeedsDisplay()
        print("Now the size is \(size)")
 
        // notification [GridUpdate] receiver
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            print("Notification [GridUpdate] received at [Simulation]. Now size is \(self.appDelegate.instrumentation.size)")
            self.gridView.size = self.appDelegate.instrumentation.size
            self.sizeLabel.text = "Size: \(self.gridView.size) x \(self.gridView.size)"
            self.gridView.setNeedsDisplay()
        }
    }

    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.statGenerate(gridView.grid)
        engine.statPublish()
        self.gridView.setNeedsDisplay()
    }

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func next (_ sender: Any) {
        gridView.grid = gridView.grid.next()
        gridView.statGenerate(gridView.grid)
        engine.statPublish()
        gridView.setNeedsDisplay()
    }
    
    
    // Assignment3 Part6 (Modified)
    @IBAction func pressStepUp(_ sender: Any) {
        var size = appDelegate.instrumentation.size + stepAmount
        size = min(max(size, minSize), maxSize)
        appDelegate.instrumentation.size = size
        gridView.size = size
        var _ = engine.step()
    }

    @IBAction func pressStepDown(_ sender: Any) {
        var size = appDelegate.instrumentation.size - stepAmount
        size = min(max(size, minSize), maxSize)
        appDelegate.instrumentation.size = size
        gridView.size = size
        var _ = engine.step()
    }
    
    @IBAction func pressReset(_ sender: Any) {
        gridView.grid = Grid(gridView.size, gridView.size)
        gridView.statGenerate(gridView.grid)
        engine.statPublish()
        gridView.setNeedsDisplay()
    }


}

