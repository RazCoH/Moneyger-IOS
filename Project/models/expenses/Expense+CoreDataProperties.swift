//
//  Expense+CoreDataProperties.swift
//  Project
//
//  Created by raz cohen on 25/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var detail: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var userID: String

}
