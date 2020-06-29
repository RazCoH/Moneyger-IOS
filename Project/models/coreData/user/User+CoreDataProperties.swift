//
//  User+CoreDataProperties.swift
//  Project
//
//  Created by raz cohen on 31/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String
    @NSManaged public var userCurrency: String
    @NSManaged public var darkMode: Bool

}
