//
//  Totals.swift
//  Project
//
//  Created by raz cohen on 29/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Firebase

class Totals{
    var ref:DatabaseReference!
    private init(){}
    static let shared = Totals()
    
    // difference total:
    
    func getDifference(callback:@escaping (Double)->Void){
        
        let actions = CoreDatabase.shared.fetchAction()
        var expenses = [Double]()
        var profits = [Double]()
        
        if actions.count > 0{
        for a in actions{
            if a.userID == HomeViewController.uid{
                if a.isItExpense{
                    let expenseAmount = a.amount
                    expenses.append(expenseAmount)
                }else{
                    let profitAmount = a.amount
                    profits.append(profitAmount)
                }
                DispatchQueue.main.async {
                    let exSum = expenses.reduce(0) {$0 + $1}
                    let profSum = profits.reduce(0) {$0 + $1}
                    callback(profSum - exSum )
                }
              }
           }
            
        }else{
           callback(0)
        }
    }
    
    
    // all:
    func getTotalExpenses(callback:@escaping (Double)->Void){
        let actions = CoreDatabase.shared.fetchAction()
        var array = [Double]()
        for a in actions{
            if a.userID == HomeViewController.uid{
                if a.isItExpense{
                    let expenseAmount = a.amount
                    array.append(expenseAmount)
                    let sum = array.reduce(0) {$0 + $1}
                    DispatchQueue.main.async {
                        callback(sum)
                    }
                }
            }
        }
    }
    
    func getTotalProfits(callback:@escaping (Double)->Void){
        let actions = CoreDatabase.shared.fetchAction()
        var array = [Double]()
        for a in actions{
            if a.userID == HomeViewController.uid{
                if !a.isItExpense{
                    let expenseAmount = a.amount
                    array.append(expenseAmount)
                    let sum = array.reduce(0) {$0 + $1}
                    DispatchQueue.main.async {
                        callback(sum)
                    }
                }
            }
        }
    }
    
    // day:
    
    func getTotalDayExpenses(callback:@escaping (Double)->Void , date:Date){
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        let dateString = Dates().castToString(date: date)
        
        for a in actions{
            if a.isItExpense{
                let amount = a.amount
                let date = a.date
                let expenseDate = Dates().castToString(date: date)
                if expenseDate.elementsEqual(dateString) && a.userID == HomeViewController.uid{
                    array.append(amount)
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
    
    func getTotalDayProfits(callback:@escaping (Double)->Void , date:Date){
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        let dateString = Dates().castToString(date: date)
        
        for a in actions{
            if !a.isItExpense{
                let amount = a.amount
                let date = a.date
                let expenseDate = Dates().castToString(date: date)
                if expenseDate.elementsEqual(dateString) && a.userID == HomeViewController.uid{
                    array.append(amount)
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
    
    //week:
    
    func getTotalWeekExpenses(callback:@escaping (Double)->Void , date:Date){
        let weekDays = WeekData.shared.getDayOfThisWeek(date: date)
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        
        for a in actions{
            if a.isItExpense{
                let amount = a.amount
                let date = a.date
                let actionDate = Dates().castToString(date:date)
                for i in 0..<weekDays.count{
                    if actionDate.isEqual(weekDays[i]) && a.userID == HomeViewController.uid{
                        array.append(amount)
                    }
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
    
    func getTotalWeekProfits(callback:@escaping (Double)->Void , date:Date){
        let weekDays = WeekData.shared.getDayOfThisWeek(date: date)
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        for a in actions{
            if !a.isItExpense{
                let amount = a.amount
                let date = a.date
                let actionDate = Dates().castToString(date:date)
                for i in 0..<weekDays.count{
                    if actionDate.isEqual(weekDays[i]) && a.userID == HomeViewController.uid{
                        array.append(amount)
                    }
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
    
    // month:
    
    func getTotalMonthExpenses(callback:@escaping (Double)->Void, date:Date){
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        let dateString = Dates().castToString(date: date)
        let currontMonth = Dates().splitToMonth(string: dateString)
        
        for a in actions{
            if a.isItExpense{
                let amount = a.amount
                let date = a.date
                let actionDate = Dates().castToString(date: date)
                let actionMonth = Dates().splitToMonth(string: actionDate)
                if actionMonth.elementsEqual(currontMonth) && a.userID == HomeViewController.uid{
                    
                    array.append(amount)
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
    
    func getTotalMonthProfits(callback:@escaping (Double)->Void , date:Date){
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        let dateString = Dates().castToString(date: date)
        let currontMonth = Dates().splitToMonth(string: dateString)
        
        for a in actions{
            if !a.isItExpense{
                let amount = a.amount
                let date = a.date
                let actionDate = Dates().castToString(date: date)
                let actionMonth = Dates().splitToMonth(string: actionDate)
                if actionMonth.elementsEqual(currontMonth) && a.userID == HomeViewController.uid{
                    array.append(amount)
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
    
    //year:
    
    func getTotalYearExpenses(callback:@escaping (Double)->Void, date:Date){
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        let dateString = Dates().castToString(date: date)
        let currontYear = Dates().splitToYear(string: dateString)
        
        for a in actions{
            if a.isItExpense{
                let amount = a.amount
                let date = a.date
                let actionDate = Dates().castToString(date: date)
                let actionYear = Dates().splitToYear(string: actionDate)
                if actionYear.elementsEqual(currontYear) && a.userID == HomeViewController.uid{
                    array.append(amount)
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
    
    func getTotalYearProfits(callback:@escaping (Double)->Void , date:Date){
        var array = [Double]()
        let actions = CoreDatabase.shared.fetchAction()
        let dateString = Dates().castToString(date: date)
        let currontYear = Dates().splitToYear(string: dateString)
        
        for a in actions{
            if !a.isItExpense{
                let amount = a.amount
                let date = a.date
                let actionDate = Dates().castToString(date: date)
                let actionYear = Dates().splitToYear(string: actionDate)
                if actionYear.elementsEqual(currontYear) && a.userID == HomeViewController.uid{
                    array.append(amount)
                }
                let sum = array.reduce(0) {$0 + $1}
                DispatchQueue.main.async {
                    callback(sum)
                }
            }
        }
    }
}


