//
//  ProfitsAnalyticsViewController.swift
//  Project
//
//  Created by raz cohen on 23/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class ProfitsAnalyticsViewController: UIViewController {
    
    var labels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayProfit.alpha = 1
        monthProfit.alpha = 0
        labels = [
            dayLabel,mounthLabel,weekLabel,totalLabel,totalText,
            monthText,totalText,weekText,dayText
        ]
        setDarkMode(view: self.view, labels: labels)
        getTotal()
        
        AnalitycsDataSource.shared
            .profitsAverages(
                day: dayLabel,
                week: weekLabel,
                month: mounthLabel
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTotal()
        setDarkMode(view: self.view, labels: labels)
        AnalitycsDataSource.shared
            .profitsAverages(
                day: dayLabel,
                week: weekLabel,
                month: mounthLabel
        )
    }
    
    // MARK: outlets
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var mounthLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayProfit: UIView!
    @IBOutlet weak var monthProfit: UIView!
    @IBOutlet weak var totalText: UILabel!
    @IBOutlet weak var dayText: UILabel!
    @IBOutlet weak var weekText: UILabel!
    @IBOutlet weak var monthText: UILabel!
    
    //MARK: actions
    
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
        case 0:
            dayProfit.alpha = 1
            monthProfit.alpha = 0
        case 1:
            dayProfit.alpha = 0
            monthProfit.alpha = 1
        default:
            break
        }
    }
    
    //MARK: functions
    
    func getTotal(){
        Totals.shared.getTotalProfits(callback: {[weak self] (total) in
            guard let userCurrency = self?.getUserCurr()else{return}
            guard let format = self?.getSymbol(forCurrencyCode: userCurrency)else{return}
            let totalArr = String(total).components(separatedBy: ".")
            self?.totalLabel.text = "\(totalArr[0])\(format)"
        })
    }
}
extension ProfitsAnalyticsViewController:ScreenMode{}
