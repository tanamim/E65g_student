//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var step: UIButton!
    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Assignment3 Part6
    @IBAction func pressStep(_ sender: Any) {
        gridView.grid = gridView.grid.next()
        gridView.setNeedsDisplay()
    }
    
    @IBAction func pressReset(_ sender: Any) {
        gridView.grid = Grid(gridView.size, gridView.size)
        gridView.setNeedsDisplay()
    }
    
    
}

