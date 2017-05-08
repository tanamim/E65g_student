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


    // DEBUG
    @IBAction func testButtonPressed(_ sender: Any) {
        gridView.size = 8
        sizeLabel.text = "Size: \(gridView.size) x \(gridView.size)"
        gridView.setNeedsDisplay()
    }
        
    var configValue: String?
    var saveClosure: ((String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let configValue = configValue {
            configName.text = configValue
        }
        
        gridView.size = 3
        sizeLabel.text = "Size: \(gridView.grid.size.rows) x \(gridView.grid.size.cols)"  // draw info
        gridView.setNeedsDisplay()
    
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false  // true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let newValue = configName.text,
            let saveClosure = saveClosure {
            saveClosure(newValue)
            self.navigationController!.popViewController(animated: true)
        }
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }

}
