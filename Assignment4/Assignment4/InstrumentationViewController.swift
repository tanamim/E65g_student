//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITextFieldDelegate {

//    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let minSize = 3
    let maxSize = 100
    
    var engine: StandardEngine!
//    var size = 10
//    var refreshRate = 3.0
//    var isRefresh = true
    @IBOutlet weak var sizeTextFieldRow: UITextField!
    @IBOutlet weak var sizeTextFieldCol: UITextField!
    @IBOutlet weak var sizeStepperRow: UIStepper!
    @IBOutlet weak var sizeStepperCol: UIStepper!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var refreshLabel: UILabel!

    internal func drawInst() -> Void {
        let size = engine.rows
        sizeTextFieldRow.text = "\(size)"
        sizeTextFieldCol.text = "\(size)"
        sizeStepperRow.value = Double(size)
        sizeStepperCol.value = Double(size)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        size = appDelegate.instrumentation.size  // update
        engine = StandardEngine.engine
//        size = StandardEngine.engine.cols
//        refreshRate = StandardEngine.engine.refreshRate
        drawInst()
        
//        sizeTextFieldRow.text = "\(size)"
//        sizeTextFieldCol.text = "\(size)"
//        sizeStepperRow.value = Double(size)
//        sizeStepperCol.value = Double(size)

        //        appDelegate.instrumentation.size = size

        // To receive changes when simulation controller (+) (-) modified the size
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
//            let size = self.appDelegate.instrumentation.size
//            let size = StandardEngine.engine.rows
            print("Notification [GridUpdate] received at [Instrumentation]")
//            self.sizeTextFieldRow.text = "\(size)"
//            self.sizeTextFieldCol.text = "\(size)"
//            self.sizeStepperRow.value = Double(size)
//            self.sizeStepperCol.value = Double(size)
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
//        appDelegate.instrumentation.refresh = isRefresh
//        StandardEngine.engine.isRefresh = isRefresh
        let on_off = engine.isRefresh ? "ON" : "OFF"
        refreshLabel.text = "Refresh: \(on_off)"
        print("Refresh " + on_off)
    }
    
    
    // Slider Event Handling
    @IBAction func slide(_ sender: UISlider) {
        let tmpRate = (Double(sender.value) * 10).rounded() / 10
        rateLabel.text = "\(tmpRate) Hz"
    }

    
    @IBAction func slided(_ sender: UISlider) {
        engine.refreshRate = (Double(sender.value) * 10).rounded() / 10
//        appDelegate.instrumentation.rate = refreshRate
//        engine.refreshRate = refreshRate
        print("rate is " + String(engine.refreshRate))
    }
    
    
    // Stepper Event Handling
    @IBAction func step(_ sender: UIStepper) {
        let size = Int(sender.value)
        engine.rows = size
        engine.cols = size
        //        appDelegate.instrumentation.size = size

        drawInst()
//        sizeTextFieldRow.text = "\(size)"
//        sizeTextFieldCol.text = "\(size)"
//        sizeStepperRow.value = Double(size)
//        sizeStepperCol.value = Double(size)
        print("size is " + String(engine.rows))

        // DEBUG
//        StandardEngine.engine.rows = size
//        StandardEngine.engine.cols = size
        engine.refreshSimulation()
        engine.statPublish()  // DEBUG
        print("DEBUG-size is \(engine.rows)")
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
//        drawInst()
//        sizeStepperRow.value = Double(size)
//        sizeStepperCol.value = Double(size)
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
        print("ended")
        drawInst()
//        sizeTextFieldRow.text = "\(size)"
//        sizeTextFieldCol.text = "\(size)"
//        appDelegate.instrumentation.size = size
        print("edit ended. size is " + String(engine.rows))

        // DEBUG
//        StandardEngine.engine.rows = size
//        StandardEngine.engine.cols = size
        engine.refreshSimulation()
//        print("DEBUG-size is \(size)")
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
}

