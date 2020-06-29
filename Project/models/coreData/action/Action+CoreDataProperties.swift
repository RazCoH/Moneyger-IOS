//
//  Action+CoreDataProperties.swift
//  Project
//
//  Created by raz cohen on 27/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//
//

import Foundation
import CoreData


extension Action {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Action> {
        return NSFetchRequest<Action>(entityName: "Action")
    }

    @NSManaged public var amount: Double
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var detail: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var userID: String
    @NSManaged public var isItExpense: Bool

}
