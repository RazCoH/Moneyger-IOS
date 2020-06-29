//
//  ChartViewController.swift
//  Project
//
//  Created by raz cohen on 02/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    //MARK: outlets
    
    @IBOutlet weak var profitsView: UIView!
    @IBOutlet weak var exspensesView: UIView!
 
    //MARK: functions
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
               if sender.selectedSegmentIndex == 0 {
                   exspensesView.alpha = 1
                   profitsView.alpha = 0
               }else{
                   exspensesView.alpha = 0
                   profitsView.alpha = 1
               }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
