//
//  AnalitycsViewController.swift
//  Project
//
//  Created by raz cohen on 21/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class AnalitycsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expensesContainer.alpha = 1
        profitsContainer.alpha = 0
        
    }
    
    // MARK: outlets
    
    @IBOutlet weak var expensesContainer: UIView!
    @IBOutlet weak var profitsContainer: UIView!
    
    //MARK: actions
    
    @IBAction func analyticsSegment(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            expensesContainer.alpha = 1
            profitsContainer.alpha = 0
        case 1:
            expensesContainer.alpha = 0
            profitsContainer.alpha = 1
        default:
            break
        }
    }
    
}
