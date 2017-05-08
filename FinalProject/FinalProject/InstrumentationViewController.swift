//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITextFieldDelegate {

    let minSize = 3
    let maxSize = 100
    var engine: StandardEngine!

    @IBOutlet weak var sizeTextFieldRow: UITextField!
    @IBOutlet weak var sizeTextFieldCol: UITextField!
    @IBOutlet weak var sizeStepperRow: UIStepper!
    @IBOutlet weak var sizeStepperCol: UIStepper!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var refreshSwitch: UISwitch!
    
    
    // redraw instrumentation info
    internal func drawInst() -> Void {
        let size = engine.rows
        sizeTextFieldRow.text = "\(size)"
        sizeTextFieldCol.text = "\(size)"
        sizeStepperRow.value = Double(size)
        sizeStepperCol.value = Double(size)
    }

    // reset timer and swich off
    internal func resetSwitch() -> Void {
        refreshSwitch.isOn = false
        refreshLabel.text = "Refresh: OFF"
        StandardEngine.engine.isRefresh = false
        StandardEngine.engine.timerInterval = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engine = StandardEngine.engine
        rateLabel.text = "\(1/engine.refreshRate) Hz"
        rateSlider.setValue(Float(engine.refreshRate), animated: true)
        drawInst()
        
        // To receive changes when simulation controller (+) (-) modified the size
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            print("Notification [GridUpdate] received at [Instrumentation]")
            self.resetSwitch()  // comment out if you don't want to reset each time gride updates
            self.drawInst()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Switch Event Handling
    @IBAction func refreshSwich(_ sender: UISwitch) {
        engine.isRefresh = sender.isOn
        let on_off = sender.isOn ? "ON" : "OFF"
        refreshLabel.text = "Refresh: \(on_off)"
        print("Refresh " + on_off)
        
        if (sender.isOn) {
            engine.timerInterval = engine.refreshRate
        } else {
            self.refreshSwitch.isOn = false
            engine.timerInterval = 0.0
        }
    }
    
    // Slider Event Handling
    @IBAction func slide(_ sender: UISlider) {
        let hz = (Double(sender.value) * 10).rounded() / 10
        rateLabel.text = "\(hz) Hz"
    }
    
    @IBAction func slided(_ sender: UISlider) {
        let hz = (Double(sender.value) * 10).rounded() / 10
        engine.refreshRate = 1/hz
        if (refreshSwitch.isOn) {
            print("refreshSwitch is ON")
            engine.timerInterval = 0.0  // remove current timer
            engine.timerInterval = 1/hz
        }
        print("rate is " + String(engine.refreshRate))
    }
    
    // Stepper Event Handling
    @IBAction func step(_ sender: UIStepper) {
        let size = Int(sender.value)
        engine.rows = size
        engine.cols = size
        drawInst()
        print("size is " + String(engine.rows))

        engine.renew()
//        engine.statPublish()
    }
    

    // TextField Event Handling
    @IBAction func editingBegan(_ sender: UITextField) {
        print("began")
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        print("changed")
    }
    
    @IBAction func editingEndedOnExit(_ sender: UITextField) {
        print("ended on exit")
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid value: \(text), please try again.") {
                sender.text = "\(self.engine.rows)"
            }
            return
        }
        let size = min(max(val, minSize),maxSize)
        engine.rows = size
        engine.cols = size
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
        drawInst()
        print("edit ended. size is " + String(engine.rows))
        engine.renew()
    }
    
    //MARK: AlertController Handling
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var tableView: UITableView!

}



// Data Model Development //


var sectionHeaders = ["User Saved", "Originals"]

struct Config {
    var name:  String
    var born:  [[Int]]
    var alive: [[Int]]
    var died:  [[Int]]
}

var userData: [Config] = [
    // user config
    Config(
        name: "Test Data",
        born:  [[0,0], [0,1]],
        alive: [[1,0], [1,1]],
        died:  [[2,0], [2,1]]
    )
]

var networkData: [Config] = [
    // network config - from JSON
    Config(
        name: "Apple",
        born:  [[0,0], [0,1]],
        alive: [[1,0], [1,1]],
        died:  [[2,0], [2,1]]
    ),
    Config(
        name: "Banana",
        born:  [[10,0], [10,1]],
        alive: [[11,0], [11,1]],
        died:  [[12,0], [12,1]]
    ),
    Config(
        name: "Cherry",
        born:  [[20,0], [20,1]],
        alive: [[21,0], [21,1]],
        died:  [[22,0], [22,1]]
    )
]

// Master Table Data
var data = [userData, networkData]

extension InstrumentationViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false  // true
    }
    
    @IBAction func addRowToTop(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addConfig", sender: self)
    }
    
    //MARK: TableView DataSource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "config"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = data[indexPath.section][indexPath.item].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var newData = data[indexPath.section]
            newData.remove(at: indexPath.row)
            data[indexPath.section] = newData
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue is triggered by '+'
        if segue.identifier == "addConfig" {
            if let vc = segue.destination as? GridEditorViewController {
                vc.configValue = "New Config"
                vc.saveClosure = { newValue in
                    let newConfig = Config(name: newValue, born: [], alive: [], died: [])
                    data[0] = [newConfig] + data[0]  // add a new item
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: 0, section: 0)  // select the new item
                    self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
                }
            }
        } else {  // segue is triggerd by a table cell
            let indexPath = tableView.indexPathForSelectedRow
            if let indexPath = indexPath {
                let configValue = data[indexPath.section][indexPath.row].name
                print("selected is ", configValue)
                if let vc = segue.destination as? GridEditorViewController {
                    vc.configValue = configValue
                    vc.saveClosure = { newValue in
                        let newConfig = Config(name: newValue, born: [], alive: [], died: [])
                        data[indexPath.section][indexPath.row] = newConfig
                        self.tableView.reloadData()
                        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
                    }
                }
            }
        }
    }
}














