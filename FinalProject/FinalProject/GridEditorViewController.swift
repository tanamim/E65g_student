//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Masakazu Tanami on 5/8/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController {

    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var configName: UITextField!

    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var configValue: Config?
    var saveClosure: ((Config) -> Void)?

    
    func getGridSize(_ config: Config) -> Int {
        let joined = config.alive + config.born + config.died
        let maxVal = joined.reduce(0, {max($0, $1[0], $1[1])})
        return maxVal * 2
    }

//    func drawGrid(_ state: CellState, _ list: [[Int]]) -> Void {
//        list.forEach { gridView.grid[$0[0], $0[1]] = state }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let configValue = configValue {
            configName.text = configValue.name
            gridView.size = configValue.size
            sizeLabel.text = "Size: \(gridView.size) x \(gridView.size)"
            gridView.setNeedsDisplay()

            // DEBUG
            print("alive ", configValue.alive)
            print("born  ", configValue.born)
            print("died  ", configValue.died)

            // set cell state
            gridView.drawGrid(.alive, configValue.alive)
            gridView.drawGrid(.born,  configValue.born)
            gridView.drawGrid(.died,  configValue.died)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false  // true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func exportToEngine(config: Config) -> Void {
            let engine = StandardEngine.engine
            engine.rows = config.size
            engine.cols = config.size
        
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        var newValue = gridView.getConfig()
        if let saveClosure = saveClosure {
            newValue.name = configName.text!  // change name from "New Config"
            saveClosure(newValue)
            self.navigationController!.popViewController(animated: true)

            // update global variable
            appDelegate.currentConfig = newValue
            // notification [GridUpdate] pualisher to tell Instrumentation to redraw info
            print("Grid Export to Simulation!")
            let nc = NotificationCenter.default
            let name = Notification.Name(rawValue: "GridExport")
            let n = Notification(name: name, object: nil, userInfo: ["GridEditorViewController": self])
            nc.post(n)
        }
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }

}
