//
//  Day.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.11.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Day: NSManagedObject {
    static let EntityName = "Day"
    static let Key_day = "day"
    static let Key_sortnumber = "sortnumber"
    
    /**Inserts a new Entity object into NSManagedObjectContext
    :param: context: NSManagedObjectContext
    :returns: NSManagedObject
    How to use:
    let myDay:Day = Day.InsertDayIntoManagedObjectContext(appDel.managedObjectContext) as! Day*/
    static func InsertIntoManagedObjectContext(_ context:NSManagedObjectContext)->Day{
        let obj = (NSEntityDescription.insertNewObject(forEntityName: Day.EntityName, into: context)) as! Day
        print("\(Day.EntityName) Entity object created in NSManagedObjectContext")        
        return obj
    }
    
    
    /**Fetches all records
     :returns: Array of [NSManagedObject]?*/
    static func FetchData(_ context:NSManagedObjectContext)->[Day]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Day.EntityName)
            let sortDescriptor = NSSortDescriptor(key: Day.Key_sortnumber , ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let fetchResults = try context.fetch(fetchRequest) as? [Day]
            print("\(fetchResults!.count) Days fetched from Core Data from Day class")
            
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        return nil
    }
    
    /**Fetches Data with Predicate
     :param: predicateKey: String of key to filter
     :param: value: Value of Key to filter
     :param: context: NSManagedObjectContext*/
    static func FetchDataWithPredicate(_ predicateKey: String, value:String, context:NSManagedObjectContext )->[Day]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Day.EntityName)
            let sortDescriptor = NSSortDescriptor(key: Day.Key_sortnumber , ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "\(predicateKey) == %@", value)
            fetchRequest.predicate = predicate
            let fetchResults = try context.fetch(fetchRequest) as? [Day]
            print("\(fetchResults!.count) Days with predicate \(value) fetched from Core Data from Day class")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        
        return nil
    }
    
    /**Saves a Day Object to Core Data
     :param: strDay: as String
     :param: context: NSManagedObjectContext*/
    static func SaveDay(_ strDay: String, intSortnumber:NSNumber, context: NSManagedObjectContext){
        let t = Day.InsertIntoManagedObjectContext(context)
        t.sortnumber = intSortnumber
        t.day = strDay
        
        do{ try context.save()
            print("Day \(t.day!) saved in Core Data from Day class")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
    /**Deletes an Teacher from Core Data
     :param: objTeacher: Teacher class Object to delete
     :param: context: NSManagedObjectContext*/
    static func DeleteDay(_ objDay: Day, context: NSManagedObjectContext){
        context.delete(objDay)
        
        do{ try context.save()
            print("Day object deleted from class Day")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
    /** Deletes all Day objects from Core Data containing strDay in Key_Day
    :param: strDay: String predicate to delete
    :param: context: NSManagedObjectContext*/
    static func DeleteDayWithPredicate(_ strDay: String, context: NSManagedObjectContext){
        let days = Day.FetchDataWithPredicate(Day.Key_day, value: strDay, context: context)
        for d in days!{
            d.managedObjectContext?.delete(d)
            
            do{ try context.save()
                print("Day object \(strDay) deleted with predicate func from class Day")
            }
            catch let error as NSError{
                print(error.localizedDescription)}
        }
    }
}
