//
//  TimelineData.swift
//  SchoolManager
//
//  Created by Peter Sypek on 05.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import CoreData

enum CollidingTime{
    case noCollision
    case collidesWithExistingTime
    case startTimeIsBiggerThanEndTime
}

class TimelineData: NSManagedObject {
    static let EntityName = "TimelineData"
    static let Key_hour = "hour"
    static let Key_startTime = "startTime"
    static let Key_endTime = "endTime"
    
    /**Inserts a new Entity object into NSManagedObjectContext
     :param: context: NSManagedObjectContext
     :returns: NSManagedObject*/
    static func InsertIntoManagedObjectContext(context:NSManagedObjectContext)->TimelineData{
        let obj = (NSEntityDescription.insertNewObjectForEntityForName(TimelineData.EntityName, inManagedObjectContext: context)) as! TimelineData
        print("\(TimelineData.EntityName) Entity object created in NSManagedObjectContext")
        return obj
    }
    
    /*MARK: Fetch actions    ###############################################################################################################*/
    /**Fetches all records
    :returns: Array of [NSManagedObject]?*/
    static func FetchData(context:NSManagedObjectContext)->[TimelineData]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: TimelineData.EntityName)
            let sortDescriptor = NSSortDescriptor(key: TimelineData.Key_hour, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [TimelineData]
            print("\(fetchResults!.count) TimelineData fetched from Core Data from TimelineData class")
            
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
    static func FetchDataWithPredicate(predicateKey: String, value:String, context:NSManagedObjectContext )->[TimelineData]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: TimelineData.EntityName)
            let sortDescriptor = NSSortDescriptor(key: TimelineData.Key_hour, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "\(predicateKey) == %@", value)
            fetchRequest.predicate = predicate
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [TimelineData]
            print("\(fetchResults!.count) TimelineData with predicate \(value) fetched from Core Data from TimelineData class")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        
        return nil
    }
    /**Fetches Data with 2 Predicate
     :param: predicateKey: String of key to filter
     :param: value: Value of Key to filter
     :param: context: NSManagedObjectContext*/
    static func FetchDataWithAndCompoundPredicate(predicateKey: String, value:String, predicateKey2: String, value2:String, context:NSManagedObjectContext )->[TimelineData]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: TimelineData.EntityName)
            let sortDescriptor = NSSortDescriptor(key: TimelineData.Key_hour, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "\(predicateKey) == %@", value)
            let predicate2 = NSPredicate(format: "\(predicateKey2) == %@", value2)
            let compoundpredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
            fetchRequest.predicate = compoundpredicate
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [TimelineData]
            print("\(fetchResults!.count) TimelineData with predicate \(value) fetched from Core Data from TimelineData class")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription)}
        
        return nil
    }
    
    /*MARK: Save actions    ###############################################################################################################*/
    /**Saves a TimelineData Object to Core Data
    :param: hour: as NSNumber
    :praram: starttime: as NSDate
    :param: endtime: as NSDate
    :param: context: NSManagedObjectContext*/
    static func SaveTimelineData(hour: NSNumber, starttime: NSDate, endtime: NSDate, context: NSManagedObjectContext){
        //Get current calendar for correct Date conversion
        let calendar =  NSCalendar.currentCalendar()
        //Get Datecomponents of startdate
        let sdateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: starttime)
        sdateComponents.second = 0
        //Make da date corresponding to current calendar
        let sDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(sdateComponents)
        //Get Datecomponents of startdate
        let edateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: endtime)
        edateComponents.second = 0
        //Make da date corresponding to current calendar
        let eDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(edateComponents)
        
        let obj = TimelineData.InsertIntoManagedObjectContext(context)
        obj.hour = hour
        obj.startTime = sDate
        obj.endTime = eDate
        
        do{ try context.save()
            print("TimelineData saved in Core Data from TimelineData class")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
    /*MARK: Edit actions    ###############################################################################################################*/
    /**
    **Edits a TimelineData Entity object**
    
    - Parameters:
    - objToEdit: **TimelineData:**  object to edit
    - context: **NSManagedObjectContext:**   ManagedObjectContext to perform edit action
    */
    static func EditTimeLineData(objToEdit: TimelineData, context: NSManagedObjectContext){
        do{ try context.save()
            print("TimelineData \(objToEdit.hour!) Edited in Core Data")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
        
    }
    
    /**
     **Creates & Sets values for an TimelineData Entity object**
     - Parameters:
     - hour: **NSNumber:**   hour number to edit
     - startDateTime: **NSDate:**   starttime to edit
     - endDateTime: **NSDate:**   endtime to edit
     - editObject: **TimelineData:**   TimelineData object to edit
     - context: **NSManagedObjectContext:**     ManagedObjectContext to perform edit action
     */
    static func setValuesForExistingTimelineDataAndSaveEditedObject(hour: NSNumber, startDateTime: NSDate, endDateTime: NSDate, editObject: TimelineData, context: NSManagedObjectContext){
        // Set values to editObject
        editObject.hour = hour
        editObject.startTime = startDateTime
        editObject.endTime = endDateTime
        
        do{ try context.save()
            print("TimelineData \(editObject) Edited in Core Data")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
    
    /*MARK: Delete actions    ###############################################################################################################*/
    /**
    **Delete TimelineData Object from Core Data**
    
    - Parameters:
    - objTimelineData: **TimelineData:**   TimelineData object to delete
    - context: **NSManagedObjectContext:**   ManagedObjectContext to perform delete action
    */
    static func DeleteTimelineData(objTimelineData: TimelineData, context: NSManagedObjectContext){
        context.deleteObject(objTimelineData)
        do{ try context.save()
            print("TimelineData object deleted from class TimelineData")
            
        }
        catch let error as NSError{ print("Error deleting TimelineData in TimelineData class: \(error)")}
    }
    
    /** Deletes all TimelineData objects from Core Data containing strDay in Key_Day
     :param: strDay: String predicate to delete
     :param: context: NSManagedObjectContext*/
    static func DeleteTimelineDataWithPredicate(strDay: String, context: NSManagedObjectContext){
        let days = TimelineData.FetchDataWithPredicate(Day.Key_day, value: strDay, context: context)
        for d in days!{
            d.managedObjectContext?.deleteObject(d)
            
            do{ try context.save()
                print("TimelineData object \(strDay) deleted with predicate func from class TimelineData")
            }
            catch let error as NSError{
                print(error.localizedDescription)}
        }
    }
    
    /**
     **Checks if a hour exists as timetable element in TimeTable**
     
     - Parameters:
     - hour: **String:**   The day to check
     - context: **NSManagedObjectContext:**   The ManagedObjectContext to perform CoreData actions
     - returns: Bool: **True/False dependend on the containing timetable elements**
     */
    static func checkIfTimeLineDataContaisPlanerElementsWithSpecificHour(hour:String, context:NSManagedObjectContext )->Bool{
        var containsElements:Bool = false
        let planerElements = TimelineData.FetchDataWithPredicate(TimelineData.Key_hour, value: hour, context: context)
        if planerElements!.count > 0{
            print("TimeLineData contains elements with hour \(hour)")
            containsElements = true
        }
        return containsElements
    }
    
    
    static func collidesWithExistingTimelineData(itemscount:Int, allData:[TimelineData], cStartDate:NSDate, cEndDate:NSDate)->CollidingTime{
        let currSDate = createDateFromComponents(2016, month: 01, day: 01, hour: GetTimeAsHour(cStartDate) , minute: GetTimeAsMinute(cStartDate))
        let currEDate = createDateFromComponents(2016, month: 01, day: 01, hour: GetTimeAsHour(cEndDate) , minute: GetTimeAsMinute(cEndDate))
        let compareSDate = createDateFromComponents(2016, month: 01, day: 01, hour: GetTimeAsHour(allData[itemscount].startTime!) , minute: GetTimeAsMinute(allData[itemscount].startTime!))
        let compareEDate = createDateFromComponents(2016, month: 01, day: 01, hour: GetTimeAsHour(allData[itemscount].endTime!) , minute: GetTimeAsMinute(allData[itemscount].endTime!))
        
        if currSDate.compare(currEDate) == .OrderedDescending{
            return .startTimeIsBiggerThanEndTime
        }
        
        if(itemscount > 0){
            //Compare current Date with possible end startdates
            if (currSDate.compare(compareSDate) == .OrderedDescending || currSDate.compare(compareSDate) == .OrderedSame)  &&  (currSDate.compare(compareEDate) == .OrderedDescending || currSDate.compare(compareEDate) == .OrderedSame) {
                return collidesWithExistingTimelineData(itemscount - 1, allData: allData, cStartDate: cStartDate, cEndDate: cEndDate)
            }else { return .collidesWithExistingTime }
        }else if (itemscount == 0){
            //Compare current Date with possible end startdates
            if (currSDate.compare(compareSDate) == .OrderedDescending || currSDate.compare(compareSDate) == .OrderedSame)  &&  (currSDate.compare(compareEDate) == .OrderedDescending || currSDate.compare(compareEDate) == .OrderedSame) {
                return .noCollision
            }else { return .collidesWithExistingTime }
        }
        return .noCollision
    }
    
    private static func createDateFromComponents(year:Int, month:Int, day:Int, hour:Int, minute:Int)->NSDate{
        let dateComponents:NSDateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        dateComponents.timeZone = NSTimeZone.systemTimeZone()
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateFromComponents(dateComponents)!
    }
    
    /**
     **Gets hour as Integer value from an NSDate**
     
     - Parameters:
     - date: **NSDate:**   The date which hour will be returned
     - returns: hour as Integer value: **Int**
     */
    private static func GetTimeAsHour(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
        dateComponents.hour = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date).hour
        return dateComponents.hour
    }
    /**
     **Gets minute as Integer value from an NSDate**
     
     - Parameters:
     - date: **NSDate:**   The date which minutes will be returned
     - returns: minutes as Integer value: **Int**
     */
    private static func GetTimeAsMinute(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
        dateComponents.minute = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date).minute
        return dateComponents.minute
    }
    
}
