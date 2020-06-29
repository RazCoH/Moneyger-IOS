//
//  Dates.swift
//  Project
//
//  Created by raz cohen on 26/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation

struct Dates{
    
    
    
    func getCurrentDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, y"
        let dateInFormat = dateFormatter.string(from: NSDate() as Date)
        return dateInFormat
    }
        
    func castToString(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, y"
        let dateInFormat = dateFormatter.string(from: date)
        return dateInFormat
    }
    
    func castToDate(string:String)->Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, y"
        guard let dateInFormat = dateFormatter.date(from: string) else { return Date() }
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = dateInFormat.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
        
    }
    func splitToMonth(string:String)->String{
        let fullDateArr = string.components(separatedBy: ",")
        let mounthAndDay = fullDateArr[1]
        let mountArr = mounthAndDay.components(separatedBy: " ")
        let mounth = mountArr[1]
        return mounth
    }
    
    func splitToYear(string:String)->String{
        let fullDateArr = string.components(separatedBy: ",")
        let year = fullDateArr[2]
        return year
    }
    
    func splitToDay(string:String)->String{
        let fullDateArr = string.components(separatedBy: ",")
        let mounthAndDay = fullDateArr[1]
        let mountArr = mounthAndDay.components(separatedBy: " ")
        let day = mountArr[0]
        return day
    }
    
    func daySearch(string:String)->String{
        let fullDateArr = string.components(separatedBy: ",")
        let day = fullDateArr[0]
        return day
    }
    
    func dayAndMonth(string:String)->String{
        let fullDateArr = string.components(separatedBy: ",")
        let dayAndMonth = fullDateArr[1]
        return dayAndMonth
    }
}
