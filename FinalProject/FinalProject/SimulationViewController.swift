//
//  SecondViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate, UITabBarDelegate {

    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var sizeLabel: UILabel!  // shows like (Size: 10 x 10)

    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let minSize = 3
    let maxSize = 100
    let stepAmount = 5  // step in Instrumentation is 10
    
    var isFirstUpdate = true  // check if first time
    
    var engine: StandardEngine!
    var timer: Timer?

    
    func drawConfigCell() {
        // set cell state
        let configValue = appDelegate.currentConfig!
        self.upDateGrid(configValue.size, configValue.size)
        self.gridView.drawGrid(.alive, configValue.alive)
        self.gridView.drawGrid(.born,  configValue.born)
        self.gridView.drawGrid(.died,  configValue.died)
        self.gridView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engine = StandardEngine.engine
        engine.delegate = self
        
        // To receive changes when grid editor pressed the save button
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridExport")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            print("Notification [GridExport] received at [Simulation]")
            self.drawConfigCell()  // redraw grids to reflect config
        }

        // for the first time
        drawConfigCell()
        sizeLabel.text = "Size: \(engine.rows) x \(engine.cols)"
        print("Now the size is \(gridView.size)")
    }

    
    func engineDidUpdate(withGrid: GridProtocol) {

//        if (gridView.size != withGrid.size.rows) {
        if (isFirstUpdate) {
            gridView.size = withGrid.size.rows
            self.isFirstUpdate = false
        }

        gridView.grid = gridView.grid.next()  // iterate each cell to go nextState
        self.gridView.setNeedsDisplay()
        
        engine.grid = gridView.grid           // sync with engine to publish stat
        engine.statPublish()
        
        self.sizeLabel.text = "Size: \(withGrid.size.rows) x \(withGrid.size.cols)"  // draw info
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func next (_ sender: Any) {
        var _ = engine.step()
    }
    
    
    // Assignment3 Part6 (Modified)
    internal func upDateGrid(_ rows: Int, _ cols: Int) -> Void {
        isFirstUpdate = true
        let size = min(max(rows, minSize), maxSize)
        engine.rows = size
        engine.cols = size
        engine.renew()
    }

    @IBAction func pressStepUp(_ sender: Any) {
        let size = engine.rows + stepAmount
        upDateGrid(size, size)
    }
    
    @IBAction func pressStepDown(_ sender: Any) {
        let size = engine.rows - stepAmount
        upDateGrid(size, size)
    }
    
    @IBAction func pressReset(_ sender: Any) {
        isFirstUpdate = true
        gridView.size = engine.rows  // invoke didset to create new Grid in gridView
        var _ = engine.step()
    }

}

