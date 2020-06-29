//
//  WeekData.swift
//  Project
//
//  Created by raz cohen on 24/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import Firebase


struct Week{
    let number:Int
    let day:String
    let date:[String]
}

class WeekData{
    
    var ref: DatabaseReference!
    
    static let shared = WeekData()
  
    
    func getDayOfThisWeek(date:Date)->[String]{
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
           
        var currontWeekDays = [String]()
        for i in 0..<days.count{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d, y"
            let dateInFormat = dateFormatter.string(from: days[i])
            currontWeekDays.append(dateInFormat)
        }

        return currontWeekDays
    }
}

