//
//  HoursPerDay.swift
//  SchoolManager
//
//  Created by Peter Sypek on 08.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import CoreData


class HoursPerDayData: NSManagedObject {
    static let EntityName = "HoursPerDayData"
    static let Key_hoursCount = "hoursCount"
    
    /**Inserts a new Entity object into NSManagedObjectContext
     :param: context: NSManagedObjectContext
     :returns: NSManagedObject */
     static func InsertIntoManagedObjectContext(context:NSManagedObjectContext)->HoursPerDayData{
        let obj = (NSEntityDescription.insertNewObjectForEntityForName(HoursPerDayData.EntityName, inManagedObjectContext: context)) as! HoursPerDayData
        print("\(HoursPerDayData.EntityName) Entity object created in NSManagedObjectContext")
        return obj
    }
    
    static func GetHoursPerDay(context: NSManagedObjectContext )->NSNumber?{
        do{
            let fetchRequest = NSFetchRequest(entityName: HoursPerDayData.EntityName)
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [HoursPerDayData]
            print("\(fetchResults![0].hoursCount!) fetched from Core Data from HoursPerDay class")
            if fetchResults?.count > 0{
                let num:Int = Int(fetchResults![0].hoursCount!)!
                return NSNumber(integer: num)
            }else{
                return NSNumber(integer: 1)
            }
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        return nil
    }
    
    
    /**Fetches all records
     :returns: Array of [NSManagedObject]?*/
    static func FetchData(context:NSManagedObjectContext)->[HoursPerDayData]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: HoursPerDayData.EntityName)
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [HoursPerDayData]
            if(fetchResults?.count > 0){
                print("\(fetchResults![0].hoursCount!) HoursPerDay fetched from Core Data from HoursPerDay class")}
            
            return fetchResults!
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        return nil
    }
    
    /**Saves a HoursPerDay Object to Core Data
     :param: strDay: as String
     :param: context: NSManagedObjectContext*/
    static func SaveHoursPerDayCount(strHoursPerDay: String, context: NSManagedObjectContext){
        let t = HoursPerDayData.InsertIntoManagedObjectContext(context)
        t.hoursCount = strHoursPerDay
        
        do{ try context.save()
            print("hoursPerDay \(t.hoursCount!) saved in Core Data from hoursPerDay class")
        }
        catch let error as NSError{
            print(error.localizedDescription) }
    }
    
    /**Deletes an HoursPerDay from Core Data
     :param: objHoursPerDay: HoursPerDay class Object to delete
     :param: context: NSManagedObjectContext*/
    static func DeleteHoursPerDayCount(objHoursPerDayData: HoursPerDayData, context: NSManagedObjectContext){
        context.deleteObject(objHoursPerDayData)
        
        do{ try context.save()
            print("HoursPerDay object deleted from class HoursPerDay")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
}
