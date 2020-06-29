//
//  ProfitsTotals.swift
//  Project
//
//  Created by raz cohen on 04/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation

class ProfitsTotals{
    
    private init(){}
    static let shared = ProfitsTotals()
    
    // all:
    func getTotalProfits(callback:@escaping (Double)->Void){
        var array = [Double]()
        let profits = CoreDatabase.shared.fetchProfit()
        for p in profits{
            let amount = p.amount
            if p.userID == HomeViewController.uid{
               array.append(amount)
            }
        }
        let sum = array.reduce(0) {$0 + $1}
        DispatchQueue.main.async {
            callback(sum)
        }
    }
    
    // day:
     
     func getTotalDayProfits(callback:@escaping (Double)->Void){
         var array = [Double]()
         let profits = CoreDatabase.shared.fetchProfit()
         let todayDate = Dates().getCurrentDate()
         for p in profits{
             let amount = p.amount
             let profitDate = p.date
             let stringDate = Dates().castToString(date: profitDate)
             if  stringDate.elementsEqual(todayDate) && p.userID == HomeViewController.uid{
                 array.append(amount)
             }
             let sum = array.reduce(0) {$0 + $1}
             DispatchQueue.main.async {
                 callback(sum)
             }
         }
     }
     
     //week:
     
     func getTotalWeekProfits(callback:@escaping (Double)->Void){
         let weekDays = WeekData.shared.getDayOfThisWeek()
         var array = [Double]()
         let profits = CoreDatabase.shared.fetchProfit()
         for p in profits{
            let amount = p.amount
            let profitDate = p.date
            let stringDate = Dates().castToString(date: profitDate)
             for i in 0..<weekDays.count{
                 if stringDate.isEqual(weekDays[i]) && p.userID == HomeViewController.uid{
                     array.append(amount)
                 }
             }
             let sum = array.reduce(0) {$0 + $1}
             DispatchQueue.main.async {
                 callback(sum)
             }
         }
     }
     
     // month:
     
     func getTotalMonthProfits(callback:@escaping (Double)->Void){
         var array = [Double]()
         let profits = CoreDatabase.shared.fetchProfit()
         let todayDate = Dates().getCurrentDate()
         let currontMonth = Dates().splitToMonth(string: todayDate)
         for p in profits{
             let amount = p.amount
             let profitDate = p.date
             let stringDate = Dates().castToString(date: profitDate)
             let profitMonth = Dates().splitToMonth(string: stringDate)
             if profitMonth.elementsEqual(currontMonth) && p.userID == HomeViewController.uid{
                 array.append(amount)
             }
             let sum = array.reduce(0) {$0 + $1}
             DispatchQueue.main.async {
                 callback(sum)
             }
         }
     }
     
     //year:
     
     func getTotalYearProfits(callback:@escaping (Double)->Void){
         var array = [Double]()
         let profits = CoreDatabase.shared.fetchProfit()
         let todayDate = Dates().getCurrentDate()
         let currontYear = Dates().splitToYear(string: todayDate)
         for p in profits{
             let amount = p.amount
             let profitDate = p.date
             let stringDate = Dates().castToString(date: profitDate)
             let profitYear = Dates().splitToYear(string: stringDate)
             if profitYear.elementsEqual(currontYear) && p.userID == HomeViewController.uid{
                 array.append(amount)
             }
             let sum = array.reduce(0) {$0 + $1}
             DispatchQueue.main.async {
                 callback(sum)
             }
         }
     }
}
