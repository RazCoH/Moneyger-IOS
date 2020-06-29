//
//  Action+CoreDataClass.swift
//  Project
//
//  Created by raz cohen on 27/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Action)
public class Action: NSManagedObject {

    func getdateInTimezone(date:Date)->Date{
        let chosenDate = date
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        let epochDate = chosenDate.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
    
    public override var description: String{
        return "amount: \(amount) \ncategory: \(category) \ndetail: \(detail ?? "") \ndate: \(date) \nuserID:\(userID) isItExpense:\(isItExpense)"
    }
    
    
    convenience init(amount:Double,category:String,detail:String,date:Date,userID:String,imageUrl:String? = nil,isItExpense:Bool){
        
        self.init(context: CoreDatabase.shared.persistentContainer.viewContext)
        self.amount = amount
        self.category = category
        self.detail = detail
        self.date = getdateInTimezone(date: date)
        self.imageUrl = imageUrl
        self.userID = userID
        self.isItExpense = isItExpense
    }
}
