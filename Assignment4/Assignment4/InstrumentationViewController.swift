//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITextFieldDelegate {

    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let minSize = 3
    let maxSize = 100
    var size = 10
    var rate = 3.0
    var refresh = true
    @IBOutlet weak var sizeTextFieldRow: UITextField!
    @IBOutlet weak var sizeTextFieldCol: UITextField!
    @IBOutlet weak var sizeStepperRow: UIStepper!
    @IBOutlet weak var sizeStepperCol: UIStepper!
    @IBOutlet weak var refreshRate: UILabel!
    @IBOutlet weak var isRefresh: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        size = appDelegate.instrumentation.size  // update
        sizeTextFieldRow.text = "\(size)"
        sizeTextFieldCol.text = "\(size)"
        sizeStepperRow.value = Double(size)
        sizeStepperCol.value = Double(size)
        appDelegate.instrumentation.size = size

        // notification receiver
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "GridUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) { (n) in
            print("Notification [GridUpdate] received at [Instrumentation]. Now size is \(self.appDelegate.instrumentation.size)")
            let size = self.appDelegate.instrumentation.size
            self.sizeTextFieldRow.text = "\(size)"
            self.sizeTextFieldCol.text = "\(size)"
            self.sizeStepperRow.value = Double(size)
            self.sizeStepperCol.value = Double(size)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Switch Event Handling
    @IBAction func refreshSwich(_ sender: UISwitch) {
        refresh = sender.isOn
        appDelegate.instrumentation.refresh = refresh
        let on_off = refresh ? "ON" : "OFF"
        isRefresh.text = "Refresh: \(on_off)"
        print("refreshis " + on_off)
    }
    
    
    // Slider Event Handling
    @IBAction func slide(_ sender: UISlider) {
        rate = (Double(sender.value) * 10).rounded() / 10
        refreshRate.text = "\(rate) Hz"
    }

    @IBAction func slided(_ sender: UISlider) {
        rate = (Double(sender.value) * 10).rounded() / 10
        appDelegate.instrumentation.rate = rate
        print("rate is " + String(rate))
    }
    
    
    // Stepper Event Handling
    @IBAction func step(_ sender: UIStepper) {
        size = Int(sender.value)
        appDelegate.instrumentation.size = size
        sizeTextFieldRow.text = "\(size)"
        sizeTextFieldCol.text = "\(size)"
        sizeStepperRow.value = Double(size)
        sizeStepperCol.value = Double(size)
        print("size is " + String(size))
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
                sender.text = "\(self.size)"
            }
            return
        }
        size = min(max(val, minSize),maxSize)
        sizeStepperRow.value = Double(val)
        sizeStepperCol.value = Double(val)
        
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
        print("ended")
        sizeTextFieldRow.text = "\(size)"
        sizeTextFieldCol.text = "\(size)"
        appDelegate.instrumentation.size = size
        print("edit ended. size is " + String(size))

        // DEBUG
        StandardEngine.engine.rows = size
        StandardEngine.engine.cols = size
        StandardEngine.engine.sayHello2()
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

