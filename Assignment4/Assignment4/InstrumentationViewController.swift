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
        rateLabel.text = "\(engine.refreshRate) Hz"
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
        let tmpRate = (Double(sender.value) * 10).rounded() / 10
        rateLabel.text = "\(tmpRate) Hz"
    }
    
    @IBAction func slided(_ sender: UISlider) {
        let tmpRate = (Double(sender.value) * 10).rounded() / 10
        engine.refreshRate = tmpRate
        if (refreshSwitch.isOn) {
            print("refreshSwitch is ON")
            engine.timerInterval = 0.0  // remove current timer
            engine.timerInterval = tmpRate
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
}

