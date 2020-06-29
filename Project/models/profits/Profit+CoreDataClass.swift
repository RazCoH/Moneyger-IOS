//
//  Profit+CoreDataClass.swift
//  Project
//
//  Created by raz cohen on 03/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Profit)
public class Profit: NSManagedObject {
    
    func getdateInTimezone(date:Date)->Date{
         let chosenDate = date
         let timezoneOffset =  TimeZone.current.secondsFromGMT()
         let epochDate = chosenDate.timeIntervalSince1970
         let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
         let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
         return timeZoneOffsetDate
     }

    public override var description: String{
        return "amount: \(amount) \ncategory: \(category) \ndetail: \(detail ?? "") \ndate: \(date) \nuserID: \(userID)"
    }
    
    convenience init(amount:Double,category:String,detail:String,userID:String,date:Date,imageUrl:String? = nil){
        self.init(context: CoreDatabase.shared.persistentContainer.viewContext)
        self.amount = amount
        self.category = category
        self.detail = detail
        self.date = getdateInTimezone(date: date)
        self.imageUrl = imageUrl
        self.userID = userID
    }
    
}
