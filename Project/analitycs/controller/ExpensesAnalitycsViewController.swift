//
//  ExpensesAnalitycsViewController.swift
//  Project
//
//  Created by raz cohen on 23/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Charts

class ExpensesAnalitycsViewController: UIViewController {
    
    var labels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labels = [
            totalLabel,dailyLabel,weeklyLabel,mounthlyLabel,dayTextLabel,monthTextLabel,weeklyTextLabel,totalTextLabel
        ]
        
        setDarkMode(view: self.view, labels: labels)
        mounthBarChart.alpha = 0
        getTotal()
        AnalitycsDataSource.shared
            .expensesAverages(day: dailyLabel,
                              week: weeklyLabel,
                              month: mounthlyLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTotal()
        setDarkMode(view: self.view, labels: labels)
        AnalitycsDataSource.shared
            .expensesAverages(day: dailyLabel,
                              week: weeklyLabel,
                              month: mounthlyLabel)
    }
    
    //MARK: outlets
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var dailyLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var mounthlyLabel: UILabel!
    @IBOutlet weak var dayBarChart: UIView!
    @IBOutlet weak var mounthBarChart: UIView!
    @IBOutlet weak var dayTextLabel: UILabel!
    @IBOutlet weak var weeklyTextLabel: UILabel!
    @IBOutlet weak var monthTextLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    
    //MARK: functions
    
    @IBAction func dayMounthSegment(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            dayBarChart.alpha = 1
            mounthBarChart.alpha = 0
        case 1:
            dayBarChart.alpha = 0
            mounthBarChart.alpha = 1
        default:
            break
        }
    }
    
    func getTotal(){
        Totals.shared.getTotalExpenses(callback: {[weak self] (total) in
            let totalArr = String(total).components(separatedBy: ".")
            guard let userCurrency = self?.getUserCurr()else{return}
            guard let format = self?.getSymbol(forCurrencyCode: userCurrency)else{return}
            self?.totalLabel.text = "\(totalArr[0])\(format)"
            })
    }
}

extension ExpensesAnalitycsViewController:ScreenMode{}


