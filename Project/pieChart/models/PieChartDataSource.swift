//
//  PieChartDataSource.swift
//  Project
//
//  Created by raz cohen on 26/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Firebase
import Charts
import UIKit

class PieChartDataSource{
    
    static let shared = PieChartDataSource()
    private init(){}
    
    func exspensesData(totalSum:Double,numberOfData:[PieChartDataEntry],pieChart:PieChartView,index:Int,chosenDate:Date){
        
        var numberOfData = numberOfData
        
        var billsArr = [Double]()
        var shoppingArr = [Double]()
        var familyArr = [Double]()
        var foodArr = [Double]()
        var helthArr = [Double]()
        var presentsArr = [Double]()
        var transportationArr = [Double]()
        var groceriesArr = [Double]()
        var leisureArr = [Double]()
        var sportArr = [Double]()
        var travelArr = [Double]()
        var generalArr = [Double]()
        
        getDataForPie(callback: { (dictionary) in
            
            for i in 0..<dictionary.count{
                for (k,v) in dictionary[i]{
                    
                    switch k {
                    case Categorys.bills.rawValue:
                        billsArr.append(v)
                        
                    case Categorys.shopping.rawValue:
                        shoppingArr.append(v)
                        
                    case Categorys.family.rawValue:
                        familyArr.append(v)
                        
                    case Categorys.health.rawValue:
                        helthArr.append(v)
                        
                    case Categorys.food.rawValue:
                        foodArr.append(v)
                        
                    case Categorys.presents.rawValue:
                        presentsArr.append(v)
                        
                    case Categorys.groceries.rawValue:
                        groceriesArr.append(v)
                        
                    case Categorys.leisure.rawValue:
                        leisureArr.append(v)
                        
                    case Categorys.transport.rawValue:
                        transportationArr.append(v)
                        
                    case Categorys.sport.rawValue:
                        sportArr.append(v)
                        
                    case Categorys.travel.rawValue:
                        travelArr.append(v)
                        
                    case Categorys.general.rawValue:
                        generalArr.append(v)
                        
                    default:
                        break
                    }
                }
            }
            
            let arrDictionary = [
                Categorys.bills.rawValue:billsArr,
                Categorys.shopping.rawValue:shoppingArr,
                Categorys.family.rawValue:familyArr,
                Categorys.health.rawValue:helthArr,
                Categorys.food.rawValue:foodArr,
                Categorys.transport.rawValue:transportationArr,
                Categorys.presents.rawValue:presentsArr,
                Categorys.groceries.rawValue:groceriesArr,
                Categorys.leisure.rawValue:leisureArr,
                Categorys.sport.rawValue:sportArr,
                Categorys.travel.rawValue:travelArr,
                Categorys.general.rawValue:generalArr
            ]
            
            var existCategories = [String]()
            for (k,v) in arrDictionary{
                if v.count > 0{
                    //canculating:
                    numberOfData.append(self.canculating(array: v, totalSum: totalSum, label: k))
                    existCategories.append(k)
                }
            }
            
            self.updateChartData(numberOfData:numberOfData,pieChart:pieChart, categories: existCategories)
            
        },index:index, chosenDate: chosenDate)
        
    }
    
    func profitsData(totalSum:Double,numberOfData:[PieChartDataEntry],pieChart:PieChartView,index:Int,chosenDate:Date){
        
        var numberOfData = numberOfData
        
        var salaryArr = [Double]()
        var giftArr = [Double]()
        var investmrntsArr = [Double]()
        var globalArr = [Double]()
        
        
        getDataForPie(callback: { (dictionary) in
            for i in 0..<dictionary.count{
                
                for (k,v) in dictionary[i]{
                    
                    switch k {
                    case Categorys.salary.rawValue:
                        salaryArr.append(v)
                        
                    case Categorys.gifts.rawValue:
                        giftArr.append(v)
                        
                    case Categorys.investments.rawValue:
                        investmrntsArr.append(v)
                        
                    case Categorys.global.rawValue:
                        globalArr.append(v)
                        
                    default:
                        break
                    }
                }
            }
            
            //canculating:
            var existCategories = [String]()
            let arrDictionary = [
                Categorys.salary.rawValue:salaryArr,
                Categorys.gifts.rawValue:giftArr,
                Categorys.investments.rawValue:investmrntsArr,
                Categorys.global.rawValue:globalArr
            ]
            
            for (k,v) in arrDictionary{
                if v.count > 0{
                    numberOfData.append(self.canculating(array: v, totalSum: totalSum, label: k))
                    existCategories.append(k)
                }
            }
            self.updateChartData(numberOfData:numberOfData,pieChart:pieChart, categories: existCategories)

        },index:index, chosenDate: chosenDate)
        
    }
    
    
    func canculating(array:[Double],totalSum:Double,label:String)->PieChartDataEntry{
        let sum = array.reduce(0){$0 + $1}
        let percent = PieChartDataEntry(value:
            (sum * 100 / totalSum * 0.01))
        percent.label = label
        return percent
    }
    
    func updateChartData(numberOfData:[PieChartDataEntry],pieChart:PieChartView,categories:[String]){
        
        let chartDataSet = PieChartDataSet(entries: numberOfData,label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.xValuePosition = .outsideSlice
        chartDataSet.yValuePosition = .insideSlice
        chartDataSet.valueLineWidth = 0
        chartDataSet.sliceSpace = 2
        //chartDataSet.valueLineColor = .none
        chartDataSet.colors = getColor(categories: categories)
        let format = NumberFormatter()
        format.numberStyle = .percent
        let formatter = DefaultValueFormatter(formatter: format)
        chartData.setValueFormatter(formatter)
        chartData.setValueFont(UIFont.systemFont(ofSize: 16,weight: .bold))
        if isItDarkMode(){

            chartData.setValueTextColor(#colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1))
            
        }else{
            
            chartData.setValueTextColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
        }
        pieChart.data = chartData
        
    }
    
    func getColor(categories:[String])->[UIColor]{
        var colors = [UIColor]()
        for c in  categories{
            switch c {
            case Categorys.bills.rawValue:
                colors.append(Categorys.bills.color)
                
            case Categorys.shopping.rawValue:
                colors.append(Categorys.shopping.color)
                
            case Categorys.family.rawValue,Categorys.salary.rawValue:
                colors.append(Categorys.family.color)
                
            case Categorys.food.rawValue:
                colors.append(Categorys.food.color)
                
            case Categorys.health.rawValue,Categorys.global.rawValue:
                colors.append(Categorys.health.color)
                
            case Categorys.presents.rawValue:
                colors.append(Categorys.presents.color)
                
            case Categorys.groceries.rawValue:
                colors.append(Categorys.groceries.color)
                
            case Categorys.leisure.rawValue,Categorys.gifts.rawValue:
                colors.append(Categorys.leisure.color)
                
            case Categorys.transport.rawValue:
                colors.append(Categorys.transport.color)
                
            case Categorys.sport.rawValue:
                colors.append(Categorys.sport.color)
                
            case Categorys.travel.rawValue,Categorys.investments.rawValue:
                colors.append(Categorys.travel.color)
                
            case Categorys.general.rawValue:
                colors.append(Categorys.general.color)
            default:
                colors.append(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            }
        }
        return colors
    }
    
    func getDataForPie(callback:@escaping ([[String:Double]])->Void,index:Int,chosenDate:Date){
        
        let stringChosenDate = Dates().castToString(date: chosenDate)
        let actions = CoreDatabase.shared.fetchAction()
        let chosenMonth = Dates().splitToMonth(string: stringChosenDate)
        let thisYear = Dates().splitToYear(string: stringChosenDate)
        let weekDays = WeekData().getDayOfThisWeek(date: chosenDate)
        var date = Date()
        var stringDate = String()
        var month = String()
        var year = String()
        var array = [[String:Double]]()
        
        for action in actions{
            if action.isItExpense{
                date = action.date
                stringDate = Dates().castToString(date: date)
                month = Dates().splitToMonth(string:stringDate)
                year = Dates().splitToYear(string: stringDate)
                
            }else{
                
                date = action.date
                stringDate = Dates().castToString(date: date)
                month = Dates().splitToMonth(string:stringDate)
                year = Dates().splitToYear(string: stringDate)
            }
            
            switch index {
            case 0:
                if stringDate.elementsEqual(stringChosenDate) && action.userID == HomeViewController.uid{
                    let amount = action.amount
                    let category = action.category
                    array.append([category:amount])
                }
            case 1:
                for i in 0..<weekDays.count{
                    if stringDate.elementsEqual(weekDays[i]) && action.userID == HomeViewController.uid{
                        let amount = action.amount
                        let category = action.category
                        array.append([category:amount])
                    }
                }
            case 2:
                
                if month.elementsEqual(chosenMonth) && action.userID == HomeViewController.uid{
                    let amount = action.amount
                    let category = action.category
                    array.append([category:amount])
                }
            case 3:
                
                if year.elementsEqual(thisYear) && action.userID == HomeViewController.uid{
                    let amount = action.amount
                    let category = action.category
                    array.append([category:amount])
                }
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            callback(array)
        }
    }
}

extension PieChartDataSource:ScreenMode{}


