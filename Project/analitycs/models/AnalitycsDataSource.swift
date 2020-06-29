//
//  AnalitycsDataSource.swift
//  Project
//
//  Created by raz cohen on 21/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class AnalitycsDataSource{
    
    static let shared = AnalitycsDataSource()
    
    func convertToDate()->Date{
        let stringDate = Dates().getCurrentDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, y"
        let date = dateFormatter.date(from: stringDate)
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = date!.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
    
    func numberOfDays(toDate:Date)->Int{
        let registerDate = Auth.auth().currentUser?.metadata.creationDate
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: registerDate!)
        let date2 = calendar.startOfDay(for: toDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        guard let days = components.day else{return 0}
        return days
    }
    
    func numberOfMounths(toDate:Date)->Int{
        let registerDate = Auth.auth().currentUser?.metadata.creationDate
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: registerDate!)
        let date2 = calendar.startOfDay(for: toDate)
        
        let components = calendar.dateComponents([.month], from: date1, to: date2)
        guard let mounths = components.month else{return 0}
        
        
        return mounths + 1
    }
    
    func profitsAverages(day:UILabel,week:UILabel,month:UILabel){
        var weeks = 0
        Totals.shared.getTotalProfits(callback: { [weak self] (sum) in
            let date = AnalitycsDataSource.shared.convertToDate()
            let days = AnalitycsDataSource.shared.numberOfDays(toDate: date) + 1
            if days > 7{
                weeks = days / 7
            }else{
                weeks = 1
            }
            guard let userCurrency = self?.getUserCurr()else{return}
            guard let format = self?.getSymbol(forCurrencyCode: userCurrency)else{return}
            let months = AnalitycsDataSource.shared.numberOfMounths(toDate:date)
            let weeklyAverage = sum / Double(weeks)
            let monthlyAverage = sum / Double(months)
            let dailyAverage = sum / Double(days)
            let dayArr = String(dailyAverage).components(separatedBy: ".")
            let weekArr = String(weeklyAverage).components(separatedBy: ".")
            let monthArr = String(monthlyAverage).components(separatedBy: ".")
            day.text = "\(dayArr[0])\(format)"
            week.text = "\(weekArr[0])\(format)"
            month.text = "\(monthArr[0])\(format)"
        })
    }
    
    
    func expensesAverages(day:UILabel,week:UILabel,month:UILabel){
        var weeks = 0
        Totals.shared.getTotalExpenses(callback: {(sum) in
            let date = AnalitycsDataSource.shared.convertToDate()
            let days = AnalitycsDataSource.shared.numberOfDays(toDate: date) + 1
            if days > 7{
                weeks = days / 7
            }else{
                weeks = 1
            }
            let userCurrency = self.getUserCurr()
            guard let format = self.getSymbol(forCurrencyCode: userCurrency)else{return}
            
          let months = AnalitycsDataSource.shared.numberOfMounths(toDate:date)
            let weeklyAverage = sum / Double(weeks)
            let monthlyAverage = sum / Double(months)
            let dailyAverage = sum / Double(days)
            let dayArr = String(dailyAverage).components(separatedBy: ".")
            let weekArr = String(weeklyAverage).components(separatedBy: ".")
            let monthArr = String(monthlyAverage).components(separatedBy: ".")
              day.text = "\(dayArr[0])\(format)"
              week.text = "\(weekArr[0])\(format)"
              month.text = "\(monthArr[0])\(format)"
        })
    }
}

