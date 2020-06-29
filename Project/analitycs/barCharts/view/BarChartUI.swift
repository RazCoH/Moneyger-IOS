//
//  BarChartUI.swift
//  Project
//
//  Created by raz cohen on 26/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Charts
import UIKit

struct BarChartUI{
    
    func chartUI(barChart: BarChartView,set:BarChartDataSet,values:[String]){
        
        if isItDarkMode(){
         set.colors = [#colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1),#colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)]
         barChart.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1)
         barChart.xAxis.labelTextColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
         barChart.leftAxis.labelTextColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
         barChart.leftAxis.gridColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
         
            
        }else{
          set.colors = [#colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1),#colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1),#colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)]
            barChart.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            barChart.xAxis.labelTextColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
            barChart.leftAxis.labelTextColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
            barChart.leftAxis.gridColor = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1)
        }
        
        set.barBorderWidth = 1
        
        barChart.animate(yAxisDuration: 2.0)
        let formmater = ChartFormatter()
        formmater.setVlues(values: values)
        let xaxis = XAxis()
        xaxis.valueFormatter = formmater
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.valueFormatter = xaxis.valueFormatter
        barChart.chartDescription?.enabled = false
        barChart.legend.enabled = false
        barChart.doubleTapToZoomEnabled = true
        barChart.xAxis.labelFont = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 12)!
        barChart.leftAxis.labelFont = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 14)!
        barChart.rightAxis.enabled = false
        barChart.leftAxis.drawGridLinesEnabled = true
        barChart.leftAxis.drawLabelsEnabled = true
        barChart.leftAxis.axisMinimum = 0
    }
    
}

extension BarChartUI:ScreenMode{}
