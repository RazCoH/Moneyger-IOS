//
//  CoreDatabase.swift
//  Project
//
//  Created by raz cohen on 03/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import CoreData

class CoreDatabase{
    
       //singletone
     private init(){}
     static let shared = CoreDatabase()
        
        // MARK: - Core Data stack

        lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
            */
            let container = NSPersistentContainer(name: "Project")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

        // MARK: - Core Data Saving support

        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    
    //computed property for the context:
      var context: NSManagedObjectContext{
          return persistentContainer.viewContext
      }
    
    func fetchUser()->[User]{
             let request = NSFetchRequest<User>(entityName: "User")
             
             do{
                 let users = try context.fetch(request)
                 return users
             }catch let error{
                 print("Error!",error)
                 return[]
             }
         }
    
    func fetchAction()->[Action]{
              let request = NSFetchRequest<Action>(entityName: "Action")
              
              do{
                  let action = try context.fetch(request)
                  return action
              }catch let error{
                  print("Error!",error)
                  return[]
              }
          }
}
