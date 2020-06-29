//
//  MonthProfitBarChartViewController.swift
//  Project
//
//  Created by raz cohen on 26/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Charts

class MonthProfitBarChartViewController: UISplitViewController,ChartViewDelegate {
    
    //MARK: variables
    
    var mounths: [String] =  ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    
    var m = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    var amounts:[Double] = [Double]()
    var a:[Double] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var barChart = BarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.delegate = self
        getDataTest()
        barChartData()
        barChart.xAxis.labelCount = 12
        barChart.xAxis.labelRotationAngle = CGFloat(exactly: -14)!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if amounts.count > 0{
        updateBarCahrtData()
        }
    }
    
    func getDataTest(){
        for i in 0..<m.count{
            BarChartDataSource.shared.getProfitForSpesificMonth(callback: {[weak self] (sum) in
                self?.amounts.append(sum)
                }, month: m[i])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.height)
        
        barChart.center = view.center
        view.addSubview(barChart)
    }
    
    func barChartData(){
        var entries = [BarChartDataEntry]()
        for i in 0..<mounths.count{
            let dataPoint = BarChartDataEntry(x: Double(i), y: a[i])
            entries.append(dataPoint)
        }
        let set = BarChartDataSet(entries: entries)
        BarChartUI().chartUI(barChart: barChart, set: set, values: mounths)
        let data = BarChartData(dataSet: set)
        barChart.data = data
        
        if isItDarkMode(){
            
        barChart.barData?.setValueTextColor(NSUIColor(red: 255, green: 255, blue: 255, alpha: 1))
            
        }
        data.barWidth = Double(0.7)
        data.setValueFont(NSUIFont(name: "Hiragino Maru Gothic Pro W4", size: 14)!)
        
    }
    
    func updateBarCahrtData(){
        var entries = [BarChartDataEntry]()
        for i in 0..<mounths.count{
            let amount = amounts[i]
            let amountString = String(format: "%.1f", amount)
            guard let amountToShow = Double(amountString)else{return}
            let dataPoint = BarChartDataEntry(x: Double(i), y: amountToShow)
            entries.append(dataPoint)
        }
        
        while amounts.count > 12{
            amounts.removeFirst()
        }
        let set = BarChartDataSet(entries: entries)
        BarChartUI().chartUI(barChart: barChart, set: set, values: mounths)
        let data = BarChartData(dataSet: set)
        barChart.data = data
        if isItDarkMode(){
            
        barChart.barData?.setValueTextColor(NSUIColor(red: 255, green: 255, blue: 255, alpha: 1))
            
        }
        data.barWidth = Double(0.7)
        data.setValueFont(NSUIFont(name: "Hiragino Maru Gothic Pro W4", size: 14)!)
    }
}

extension MonthProfitBarChartViewController:ScreenMode{}
