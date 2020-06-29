//
//  ChartFormatter.swift
//  Project
//
//  Created by raz cohen on 24/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Charts

class ChartFormatter:NSObject,IAxisValueFormatter{
    
    var objects = [String]()
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return objects[Int(value)]
    }

    func setVlues(values:[String]){
        self.objects = values
    }
}
