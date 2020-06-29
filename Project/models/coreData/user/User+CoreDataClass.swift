//
//  User+CoreDataClass.swift
//  Project
//
//  Created by raz cohen on 25/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

    public override var description: String{
        return "id: \(id) \ncurrency: \(userCurrency), \ndarkMode: \(darkMode) "
    }
    
    convenience init(id:String,userCurrency:String,darkMode:Bool) {
        self.init(context: CoreDatabase.shared.persistentContainer.viewContext)
        self.id = id
        self.userCurrency = userCurrency
        self.darkMode = darkMode
    }
}
