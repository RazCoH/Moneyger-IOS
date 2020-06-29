//
//  DayProfitBarChartViewController.swift
//  Project
//
//  Created by raz cohen on 26/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Charts

class DayProfitBarChartViewController: UISplitViewController,ChartViewDelegate {
    
    //MARK: variables
    
    var days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    var amounts:[Double] = [Double]()
    var a:[Double] = [0,0,0,0,0,0,0]
    var barChart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self
        getData()
        barChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        updateBarChartData()
    }
    
    func getData(){
        let weekDays = WeekData.shared.getDayOfThisWeek(date: Date())
        for i in 0..<weekDays.count{
            BarChartDataSource.shared.getProfitForSpesificDay(
                callback1: { [weak self](sum) in
                    self?.amounts.append(sum)
                }, day: weekDays[i])
        }
    }
    
    // add bar chart from code:
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.height)
        
        barChart.center = view.center
        view.addSubview(barChart)
    }
    // Data:
    func barChartData(){
        var entries = [BarChartDataEntry]()
        for i in 0..<days.count{
            
            let dataPoint = BarChartDataEntry(x: Double(i), y: a[i])
            entries.append(dataPoint)
        }
        let set = BarChartDataSet(entries: entries)
        BarChartUI().chartUI(barChart: barChart, set: set, values: days)
        let data = BarChartData(dataSet: set)
        barChart.data = data
        if isItDarkMode(){
            
        barChart.barData?.setValueTextColor(NSUIColor(red: 255, green: 255, blue: 255, alpha: 1))
            
        }
        data.setValueFont(NSUIFont(name: "Hiragino Maru Gothic Pro W4", size: 14)!)
        data.barWidth = Double(0.8)
    }
    
    func updateBarChartData(){
        while amounts.count < 7 {
            amounts.append(0)
        }
        
        while amounts.count > 7{
            amounts.removeFirst()
        }
        var entries = [BarChartDataEntry]()
        for i in 0..<days.count{
            let amount = amounts[i]
            let amountString = String(format: "%.1f", amount)
            guard let amountToShow = Double(amountString)else{return}
            let dataPoint = BarChartDataEntry(x: Double(i), y: amountToShow)
            entries.append(dataPoint)
            
        }
        let set = BarChartDataSet(entries: entries)
        BarChartUI().chartUI(barChart: barChart, set: set, values: days)
        let data = BarChartData(dataSet: set)
        barChart.data = data
        if isItDarkMode(){
            
        barChart.barData?.setValueTextColor(NSUIColor(red: 255, green: 255, blue: 255, alpha: 1))
            
        }
        data.setValueFont(NSUIFont(name: "Hiragino Maru Gothic Pro W4", size: 14)!)
        data.barWidth = Double(0.8)
    }
}

extension DayProfitBarChartViewController:ScreenMode{}
