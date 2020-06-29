//
//  PieChartUI.swift
//  Project
//
//  Created by raz cohen on 17/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Charts
import UIKit


protocol PieChartUI{
  
        func customeText(string:String,size:CGFloat,pieChart:PieChartView)
}

extension PieChartUI{
    func customeText(string:String,size:CGFloat,pieChart:PieChartView){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
         NSAttributedString.Key.font: UIFont(name: "Hiragino Maru Gothic Pro W4", size: size),
         NSAttributedString.Key.paragraphStyle: paragraphStyle,
         NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 73, green: 88, blue: 103)
        ]
        let myText = NSAttributedString(string: string, attributes: attributes
            as [NSAttributedString.Key : Any])
        pieChart.centerAttributedText = myText
    }
    
    func centerCircle(pieChart:PieChartView){
        pieChart.holeRadiusPercent = 0.5
        pieChart.holeColor = #colorLiteral(red: 0.6452198029, green: 0.599394381, blue: 1, alpha: 1)
        pieChart.legend.formSize = 8
        pieChart.legend.form = .circle
        pieChart.legend.font = UIFont.systemFont(ofSize: 16)
        let users = CoreDatabase.shared.fetchUser()
        for u in users{
            if u.id == HomeViewController.uid{
                if u.darkMode{
                    pieChart.transparentCircleColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1)
                    pieChart.legend.textColor = .white
                }else{
                    pieChart.transparentCircleColor = UIColor.white
                    pieChart.legend.textColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1)
                }
                break
            }
        }
        
        pieChart.noDataText = "No data to show yet"
        pieChart.noDataFont = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 32)!
        pieChart.noDataTextColor = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1)
    }
}

extension ExpensesPieChartViewController : PieChartUI{}
extension ProfitsPieChartViewController : PieChartUI{}



