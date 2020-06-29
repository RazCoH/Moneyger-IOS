//
//  ProfitsDataSource.swift
//  Project
//
//  Created by raz cohen on 29/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import UIKit
import Foundation

class ActionDataSource{
    
    static let shared = ActionDataSource()
    
    
    //currency format:
    
    func currencyFormat(amount:Double)->String{
        
        let userCurrency = getUserCurr()
        guard let format = getSymbol(forCurrencyCode: userCurrency)else{return "0"}
        let string = String(amount)
        let arr = string.components(separatedBy: ".")
        let afterDotNumber = arr[1]
        guard let number = Double(arr[0])else{return "0"}
        var numToPresent = String()
        var finalNum = String()
        if arr[0].first == "-"{
            let num = arr[0].components(separatedBy: "-")
            finalNum = num[1]
        }else{
            finalNum = arr[0]
        }
        if finalNum.count <= 3{
            numToPresent = "\(finalNum).\(afterDotNumber.first!)\(format)"
        }else if finalNum.count >= 4 && finalNum.count < 7 {
            let thausends = number / 1000
            let thausendsArr = String(thausends).components(separatedBy: ".")
            var afterDotString = thausendsArr[1]
            for i in 0..<afterDotString.count{
                if i > 3{
                    afterDotString.removeLast()
                }
            }
            
            numToPresent = "\(thausendsArr[0]).\(thausendsArr[1])K\(format)"
        }else{
            let miliones = number / 1000000
            numToPresent = "\(miliones)M\(format)"
        }
        return numToPresent
    }
    
    func categoryExpenseCoreData(index:Int,billsLabel:UILabel,shoppingLabel:UILabel,familyLabel:UILabel,foodLabel:UILabel,healthLabel:UILabel,presentsLabel:UILabel,transportationLabel:UILabel,groceriesLabel:UILabel,leisureLabel:UILabel,sportLabel:UILabel,travrlLabel:UILabel,generalLabel:UILabel
        ,totalLabel:UILabel,date:Date){
        
        var billsArr = [Action]()
        var shoppingArr = [Action]()
        var familyArr = [Action]()
        var foodArr = [Action]()
        var helthArr = [Action]()
        var presentsArr = [Action]()
        var transportationArr = [Action]()
        var groceriesArr = [Action]()
        var leisureArr = [Action]()
        var generalArr = [Action]()
        var sportArr = [Action]()
        var travelArr = [Action]()
        
        var billsSum = 0.0
        var shoppingSum = 0.0
        var familySum = 0.0
        var foodSum = 0.0
        var helthSum = 0.0
        var presentsSum = 0.0
        var transportationSum = 0.0
        var groceriesSum = 0.0
        var leisureSum = 0.0
        var generalSum = 0.0
        var sportSum = 0.0
        var travelSum = 0.0
        
        getExpensesFromCoreData(index: index, callback: { (expenses) in
            
            for expense in expenses{
                
                let category = expense.category
                
                switch category {
                    
                case Categorys.bills.rawValue:
                    if !billsArr.contains(expense) && expense.userID == HomeViewController.uid{
                        billsArr.append(expense)
                        billsSum += expense.amount
                    }
                case Categorys.general.rawValue:
                    if !generalArr.contains(expense) && expense.userID == HomeViewController.uid{
                        generalArr.append(expense)
                        generalSum += expense.amount
                    }
                case Categorys.sport.rawValue:
                    if !sportArr.contains(expense) && expense.userID == HomeViewController.uid{
                        sportArr.append(expense)
                        sportSum += expense.amount
                    }
                case Categorys.travel.rawValue:
                    if !travelArr.contains(expense) && expense.userID == HomeViewController.uid{
                        travelArr.append(expense)
                        travelSum += expense.amount
                    }
                case Categorys.shopping.rawValue:
                    if !shoppingArr.contains(expense) && expense.userID == HomeViewController.uid{
                        shoppingArr.append(expense)
                        shoppingSum += expense.amount
                    }
                case Categorys.family.rawValue:
                    if !familyArr.contains(expense) && expense.userID == HomeViewController.uid{
                        familyArr.append(expense)
                        familySum += expense.amount
                    }
                case Categorys.food.rawValue:
                    if !foodArr.contains(expense) && expense.userID == HomeViewController.uid{
                        foodArr.append(expense)
                        foodSum += expense.amount
                    }
                case Categorys.health.rawValue:
                    if !helthArr.contains(expense) && expense.userID == HomeViewController.uid{
                        helthArr.append(expense)
                        helthSum += expense.amount
                    }
                case Categorys.presents.rawValue:
                    if !presentsArr.contains(expense) && expense.userID == HomeViewController.uid{
                        presentsArr.append(expense)
                        presentsSum += expense.amount
                    }
                case Categorys.transport.rawValue:
                    if !transportationArr.contains(expense) && expense.userID == HomeViewController.uid{
                        transportationArr.append(expense)
                        transportationSum += expense.amount
                    }
                case Categorys.groceries.rawValue:
                    if !groceriesArr.contains(expense) && expense.userID == HomeViewController.uid{
                        groceriesArr.append(expense)
                        groceriesSum += expense.amount
                    }
                case Categorys.leisure.rawValue:
                    if !leisureArr.contains(expense) && expense.userID == HomeViewController.uid{
                        leisureArr.append(expense)
                        leisureSum += expense.amount
                    }
                default:
                    break
                }
            }
            
            billsLabel.text = self.currencyFormat(amount: billsSum)
            shoppingLabel.text = self.currencyFormat(amount: shoppingSum)
            familyLabel.text = self.currencyFormat(amount: familySum)
            foodLabel.text = self.currencyFormat(amount: foodSum)
            healthLabel.text = self.currencyFormat(amount: helthSum)
            presentsLabel.text = self.currencyFormat(amount: presentsSum)
            transportationLabel.text = self.currencyFormat(amount: transportationSum)
            groceriesLabel.text = self.currencyFormat(amount: groceriesSum)
            leisureLabel.text = self.currencyFormat(amount: leisureSum)
            generalLabel.text = self.currencyFormat(amount: generalSum)
            travrlLabel.text = self.currencyFormat(amount: travelSum)
            sportLabel.text = self.currencyFormat(amount: sportSum)
            
            let allAmountsSum  = billsSum + shoppingSum + familySum + foodSum
                + helthSum + presentsSum + transportationSum + groceriesSum + leisureSum
                + generalSum + sportSum + travelSum
            
            totalLabel.text = "-\(self.currencyFormat(amount: allAmountsSum))"
            
        }, date: date)
    }
    
    
    func categoryProfitCoreData(index:Int,salaryLabel:UILabel,giftLabel:UILabel,investmentsLabel:UILabel,gloabalLabel:UILabel ,totalLabel:UILabel,date:Date){
        
        var salaryArr = [Action]()
        var giftArr = [Action]()
        var invesrmentsArr = [Action]()
        var globalArr = [Action]()
        
        var salarySum = 0.0
        var giftSum = 0.0
        var investmentsSum = 0.0
        var globalSum = 0.0
        
        
        getProfitFromCoreData(index: index, callback: { (profits) in
            
            for profit in profits{
                
                let category = profit.category
                switch category {
                    
                case Categorys.salary.rawValue:
                    
                    if !salaryArr.contains(profit) && profit.userID == HomeViewController.uid{
                        
                        salaryArr.append(profit)
                        salarySum += profit.amount
                    }
                    
                case Categorys.gifts.rawValue:
                    
                    if !giftArr.contains(profit) && profit.userID == HomeViewController.uid{
                        
                        giftArr.append(profit)
                        giftSum += profit.amount
                    }
                    
                case Categorys.investments.rawValue:
                    
                    if !invesrmentsArr.contains(profit) && profit.userID == HomeViewController.uid{
                        
                        invesrmentsArr.append(profit)
                        investmentsSum += profit.amount
                    }
                    
                case Categorys.global.rawValue:
                    
                    if !globalArr.contains(profit) && profit.userID == HomeViewController.uid{
                        
                        globalArr.append(profit)
                        globalSum += profit.amount
                    }
                    
                default:
                    break
                }
            }
            
            salaryLabel.text = self.currencyFormat(amount: salarySum)
            giftLabel.text = self.currencyFormat(amount: giftSum)
            investmentsLabel.text = self.currencyFormat(amount: investmentsSum)
            gloabalLabel.text = self.currencyFormat(amount: globalSum)
            let totalProfSum = giftSum + salarySum + investmentsSum + globalSum
            totalLabel.text = "+\(self.currencyFormat(amount: totalProfSum))"
            
        }, date: date)
    }
    
    
    func getExpensesFromCoreData(index:Int,callback:@escaping([Action])->Void , date:Date){
        
        let expenses = CoreDatabase.shared.fetchAction()
        let dateString = Dates().castToString(date: date)
        let thisMounth = Dates().splitToMonth(string: dateString)
        let thisYear = Dates().splitToYear(string: dateString)
        let weekDays = WeekData().getDayOfThisWeek(date: date)
        var array = [Action]()
        
        for expense in expenses{
            
            if expense.isItExpense{
                
                let expenseDate = expense.date
                let date = Dates().castToString(date: expenseDate)
                let expenseMounth = Dates().splitToMonth(string:date)
                let expenseYear = Dates().splitToYear(string: date)
                
                switch index {
                case 0:
                    
                    if date.elementsEqual(dateString){
                        if !array.contains(expense){
                            array.append(expense)
                        }
                    }
                case 1:
                    
                    for i in 0..<weekDays.count{
                        if date.elementsEqual(weekDays[i]){
                            if !array.contains(expense){
                                array.append(expense)
                            }
                        }
                    }
                case 2:
                    
                    if expenseMounth.elementsEqual(thisMounth){
                        if !array.contains(expense){
                            array.append(expense)
                        }
                    }
                case 3:
                    
                    if expenseYear.elementsEqual(thisYear){
                        if !array.contains(expense){
                            array.append(expense)
                        }
                    }
                default:
                    break
                }
            }
        }
        
        DispatchQueue.main.async {
            callback(array)
        }
    }
    
    func getProfitFromCoreData(index:Int,callback:@escaping([Action])->Void , date:Date){
        
        let profits = CoreDatabase.shared.fetchAction()
        let stringDate = Dates().castToString(date: date)
        let thisMounth = Dates().splitToMonth(string: stringDate)
        let thisYear = Dates().splitToYear(string: stringDate)
        let weekDays = WeekData().getDayOfThisWeek(date: date)
        var array = [Action]() 
        
        for profit in profits{
            
            if !profit.isItExpense{
                
                
                let date = Dates().castToString(date: profit.date)
                let profitMounth = Dates().splitToMonth(string:date)
                let profitYear = Dates().splitToYear(string: date)
                
                switch index {
                    
                case 0:
                    
                    if date.elementsEqual(stringDate){
                        if !array.contains(profit){
                            array.append(profit)
                        }
                    }
                    
                case 1:
                    
                    for i in 0..<weekDays.count{
                        if date.elementsEqual(weekDays[i]){
                            if !array.contains(profit){
                                array.append(profit)
                            }
                        }
                    }
                    
                case 2:
                    
                    if profitMounth.elementsEqual(thisMounth){
                        if !array.contains(profit){
                            array.append(profit)
                        }
                    }
                case 3:
                    
                    if profitYear.elementsEqual(thisYear){
                        if !array.contains(profit){
                            array.append(profit)
                        }
                    }
                    
                default:
                    break
                }
            }
        }
        
        DispatchQueue.main.async {
            
            callback(array)
        }
    }
}




