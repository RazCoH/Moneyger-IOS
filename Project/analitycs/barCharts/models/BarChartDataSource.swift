//
//  BarChartDataSource.swift
//  Project
//
//  Created by raz cohen on 25/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation

class BarChartDataSource{
    
    static let shared = BarChartDataSource()
    
    func getExpenseForSpesificDay(callback1:@escaping (Double)->Void,day:String)
    {
        var array = [Double]()
        let expenses = CoreDatabase.shared.fetchAction()
        for e in expenses{
            if e.isItExpense{
            let date = e.date
            let expenseDate = Dates().castToString(date: date)
            if day.elementsEqual(expenseDate) && e.userID == HomeViewController.uid{
                array.append(e.amount)
             }
          }
        }
        let sum = array.reduce(0){$0 + $1}
        DispatchQueue.main.async {
            callback1(sum)
        }
    }
    
    func getProfitForSpesificDay(callback1:@escaping (Double)->Void,day:String)
    {
        var array = [Double]()
        let profits = CoreDatabase.shared.fetchAction()
        for p in profits{
            if !p.isItExpense{
            let stringDate = Dates().castToString(date: p.date)
            if day.elementsEqual(stringDate) && p.userID == HomeViewController.uid{
                array.append(p.amount)
            }
          }
        }
        let sum = array.reduce(0){$0 + $1}
        DispatchQueue.main.async {
            callback1(sum)
        }
    }
    
    func getExpenseForSpesificMonth(callback:@escaping (Double)->Void,month:String){
        
        var array = [Double]()
        let expenses = CoreDatabase.shared.fetchAction()
        
        for e in expenses{
            if e.isItExpense{
            let date = e.date
            let expenseDate = Dates().castToString(date:date)
            let expenseMonth = Dates().splitToMonth(string: expenseDate)
            if month.elementsEqual(expenseMonth) && e.userID == HomeViewController.uid{
                array.append(e.amount)
            }
         }
        }
        let sum = array.reduce(0){$0 + $1}
        DispatchQueue.main.async {
            callback(sum)
        }
    }
    
    func getProfitForSpesificMonth(callback:@escaping (Double)->Void,month:String){
        
        var array = [Double]()
        let profits = CoreDatabase.shared.fetchAction()
        
        for p in profits{
            if !p.isItExpense{
            let stringDate = Dates().castToString(date: p.date)
            let expenseMonth = Dates().splitToMonth(string: stringDate)
            if month.elementsEqual(expenseMonth) && p.userID == HomeViewController.uid{
                array.append(p.amount)
            }
          }
        }
        let sum = array.reduce(0){$0 + $1}
        DispatchQueue.main.async {
            callback(sum)
        }
    }
}

