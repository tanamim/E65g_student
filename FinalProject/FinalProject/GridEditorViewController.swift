//
//  GridEditorViewController.swift
//  FinalProject
//
//  Created by Masakazu Tanami on 5/8/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController {
    
    var configValue: String?
    var saveClosure: ((String) -> Void)?
    
    @IBOutlet weak var configValueTextField: UITextField!
    
    @IBAction func backToTop(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let configValue = configValue {
            configValueTextField.text = configValue
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false  // true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let newValue = configValueTextField.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController!.popViewController(animated: true)
        }
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }

}
