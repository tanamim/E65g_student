//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITextFieldDelegate {

    @IBInspectable var size = 3
    @IBOutlet var sizeTextFieldRow: UITextField!
    @IBOutlet var sizeStepperRow: UIStepper!
    @IBOutlet var sizeTextFieldCol: UITextField!
    @IBOutlet var sizeStepperCol: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sizeTextFieldRow.text = "\(size)"
        sizeStepperRow.value = Double(size)
        sizeTextFieldCol.text = "\(size)"
        sizeStepperCol.value = Double(size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Stepper Event Handling
    @IBAction func step(_ sender: UIStepper) {
        size = Int(sender.value)
        sizeTextFieldRow.text = "\(size)"
        sizeTextFieldCol.text = "\(size)"
        print("size is " + String(size))
    }
    

    // TextField Event Handling
    @IBAction func editingBegan(_ sender: UITextField) {
//        print("began")
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
//        print("changed")
    }
    
    @IBAction func editingEndedOnExit(_ sender: UITextField) {
//        print("ended on exit")
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid value: \(text), please try again.") {
                sender.text = "\(self.size)"
            }
            return
        }
        size = val
        sizeStepperRow.value = Double(val)
        sizeStepperCol.value = Double(val)
    }
    
    @IBAction func editingEnded(_ sender: UITextField) {
//        print("ended")
        sizeTextFieldRow.text = "\(size)"
        sizeTextFieldCol.text = "\(size)"
        print("edit ended. size is " + String(size))
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

