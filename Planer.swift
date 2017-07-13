//
//  Planer.swift
//  SchoolManager
//
//  Created by Peter Sypek on 29.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit
import CoreData


class Planer: NSManagedObject {
    static let EntityName = "Planer"
    static let Key_note = "room"
    static let Key_day = "day"
    static let Key_hour = "hour"
    static let Key_subject = "subject"
    static let Key_teacher = "teacher"
    static let Key_daystring = "daystring"
    static let Key_isEmptyElement = "isEmptyElement"
    static let Key_selectedWeek = "selectedWeek"
    static var planerCollection = [Planer]()
    
    /**
     **Creates a new Entity object in NSManagedObjectContext**
     - Parameters:
     - context: **NSManagedObjecContext:**   NSManagedObjectContext for Core Data operations
     - returns: Planer: **Planer Entity object**
     */
    static func InsertIntoManagedObjectContext(context:NSManagedObjectContext)->Planer{
        let obj = (NSEntityDescription.insertNewObject(forEntityName: Planer.EntityName, into: context)) as! Planer
        print("\(Planer.EntityName) Entity object created in NSManagedObjectContext")
        return obj
    }
    
    /**
     **Fetches all Planer Data from Core Data**
     - Parameters:
     - context: **NSManagedObjecContext:**   NSManagedObjectContext for Core Data operations
     - returns: [Planer]: **Array of Planer Entity objects**
     */
    static func fetchData(context:NSManagedObjectContext)->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Planer.EntityName)
             planerCollection = try context.fetch(fetchRequest) as! [Planer]
            
            return planerCollection
        }
        catch let error as NSError{ print("Error fetching Days from Day class: \(error)") }
        return nil
    }
    
    /**
     **Saves a Planer Entity object to Core Data**
     
     - Parameters:
     - context: **NSManagedObjecContext:**   NSManagedObjectContext for Core Data operations
     - planerObj: **Planer:**   Planer Entity Object
     */
    static func savePlaner(isHeaderElement:Bool, strRoom:String, selectedWeek: Int, subject:Subject, hour:TimelineData, day:Day, teacher:Teacher, context: NSManagedObjectContext){
        let t = Planer.InsertIntoManagedObjectContext(context: context)
        t.daystring = day.day!
        t.isEmptyElement = false
        t.room = strRoom
        t.subject = subject
        t.hour = hour
        t.day = day
        t.selectedWeek = selectedWeek as NSNumber
        t.teacher = teacher
        t.isHeaderElement = isHeaderElement as NSNumber
        
        do{ try context.save()
            print("Planer object saved in Core Data from Day class")
        }
        catch let error as NSError{ print("Error saving Planer in Planer class: \(error)")}
    }
    
    /**
     **Fetches Data with predicate**
     - Parameters:
     - predicateKey: **String:**   The Entity Key for the filter predicate
     - value: **String:**   The filter string to filter
     - context: **NSManagedObjectContext:**   The NSManagedObjectContext to perform Core Data operations
     - returns: [Planer]: **Array of Planer Entity objects**
     */
    static func fetchDataWithDaystringPredicate(value: String, context: NSManagedObjectContext )->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context))
            
            let predicate = NSPredicate(format: "\(Planer.Key_daystring)== %@", value)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Planer]
            print("\(fetchResults!.count) Planer objects with predicate \(value) fetched from Core Data")
            return fetchResults
        }
        catch let error as NSError{ print("Error Fetching Planer with predicate \(value) in Planer class: \(error)")
            return nil
        }
    }

    static func fetchPlanerObjectsWithSubjectPredicate(subject:String, context:NSManagedObjectContext)->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context))
            
            let predicate = NSPredicate(format: "%K == %@", "subject.subject", subject)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Planer]
            print("\(fetchResults!.count) Planer objects with predicate \(subject) fetched from Core Data")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func fetchPlanerObjectsWithTeachernamePredicate(teacher:String, context:NSManagedObjectContext)->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context))
            
            let predicate = NSPredicate(format: "%K == %@", "teacher.name", teacher)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Planer]
            print("\(fetchResults!.count) Planer objects with predicate \(teacher) fetched from Core Data")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    static func fetchPlanerObjectsWithTimeLineDataHourPredicate(hour:String, context:NSManagedObjectContext)->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context))
            
            let predicate = NSPredicate(format: "%K == %@", "hour.hour", hour)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Planer]
            print("\(fetchResults!.count) Planer objects with predicate \(hour) fetched from Core Data")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func deleteAllPlanerData(context:NSManagedObjectContext){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Planer.EntityName)
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    context.delete(result)
                }
                
                try context.save()
            }
        } catch {
            print("failed to clear core data")
        }
    }
    
    static func fetchPlanerObjectsWithDaySortnumberPredicate(sortnumber:NSNumber, context:NSManagedObjectContext)->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context))
            
            let predicate = NSPredicate(format: "%K == %@", "day.sortnumber", sortnumber)
            let predicate2 = NSPredicate(format: "%K == %@", "isEmptyElement", false as CVarArg)
            let predicate3 = NSPredicate(format: "%K == %@", "isHeaderElement", false as CVarArg)
            let compoundpredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2, predicate3])
            fetchRequest.predicate = compoundpredicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Planer]
            print("\(fetchResults!.count) Planer objects with predicate sortnumber \(sortnumber) fetched from Core Data")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**Edits Teacher Object*/
    static func EditPlanerObject(planerToEdit: Planer, context: NSManagedObjectContext){
        do{ try context.save()
            print("Planer object edited in Core Data from Planer class")
        }
        catch let error as NSError{ print("Error Editing Planer object in Planer class: \(error)")}
        
    }
    
    static func fetchExistingPlanerElement(hourSortnumber:NSNumber, day:String, context:NSManagedObjectContext)->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context))
            
            let predicate = NSPredicate(format: "%K == %@", "hour.hour", hourSortnumber)
            let predicate2 = NSPredicate(format: "%K == %@", "isEmptyElement", false as CVarArg)
            let predicate3 = NSPredicate(format: "%K == %@", "day.day", day)
            let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2, predicate3])
            fetchRequest.predicate = andPredicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Planer]
            print("\(fetchResults!.count) Planer objects with predicate fetched from Core Data")
            return fetchResults!
        }
        catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func fetchNotEmptyPlanerElementsWithHour(hourSortnumber:NSNumber, context:NSManagedObjectContext)->[Planer]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Planer.EntityName, in: context))
            
            let predicate = NSPredicate(format: "%K == %@", "hour.hour", hourSortnumber)
            let predicate2 = NSPredicate(format: "%K == %@", "isEmptyElement", false as CVarArg)
            let predicate3 = NSPredicate(format: "%K == %@", "isHeaderElement", false as CVarArg)
            let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2, predicate3])
            fetchRequest.predicate = andPredicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Planer]
            print("\(fetchResults!.count) Planer objects with predicate fetched from Core Data")
            return fetchResults!
        }
        catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**Deletes an Teacher from Core Data
     :param: objTeacher: Teacher class Object to delete
     :param: context: NSManagedObjectContext*/
    static func DeletePlanerObject(objPlaner: Planer, context: NSManagedObjectContext){
        context.delete(objPlaner)
        do{ try context.save()
            print("Planer object deleted from class Planer")
        }
        catch let error as NSError{ print("Error deleting Planer object  in Planer class: \(error)")}
    }
    
    static func collidesWithExistingPlanerData(itemscount:Int, allData:[Planer], hour:NSNumber, selectedWeekIndex:Int)->Bool{
        if(itemscount > 0){
            print("arraycounter: \(itemscount) current hour: \(hour) comparehour: \(allData[itemscount-1].hour!.hour!) selectedWeekIndex: \(selectedWeekIndex)")
            if hour == allData[itemscount-1].hour!.hour! && (selectedWeekIndex == allData[itemscount-1].selectedWeek! || allData[itemscount-1].selectedWeek! == 2){ return true }
            else { return collidesWithExistingPlanerData(itemscount: itemscount-1, allData: allData, hour:  hour, selectedWeekIndex: selectedWeekIndex) }
        }
        return false
    }
    
    
    
    /**
     **Checks if a day contains Elements in TimeTable**
     
     - Parameters:
     - day: **String:**   The day to check
     - context: **NSManagedObjectContext:**   The ManagedObjectContext to perform CoreData actions
     - returns: Bool: **True/False dependend on the containing timetable elements**
     */
    static func checkIfDayContaisPlanerElements(day:String, context:NSManagedObjectContext )->Bool{
        var containsElements:Bool = false
        let planerElements = Planer.fetchDataWithDaystringPredicate(value: day, context: context )
        if (planerElements?.count)! > 0{
            containsElements = true
        }        
        return containsElements
    }
    
    /**
     **Checks if a hour exists as timetable element in TimeTable**
     
     - Parameters:
     - hour: **String:**   The day to check
     - context: **NSManagedObjectContext:**   The ManagedObjectContext to perform CoreData actions
     - returns: Bool: **True/False dependend on the containing timetable elements**
     */
    static func checkIfTimeTableContaisPlanerElementsWithSpecificHour(hour:String, context:NSManagedObjectContext )->Bool{
        var containsElements:Bool = false
        let planerElements = Planer.fetchPlanerObjectsWithTimeLineDataHourPredicate(hour: hour, context: context)
        if planerElements!.count > 0{
            print("Planer contains elements with hour \(hour)")
            containsElements = true
        }
        return containsElements
    }
    
    static var tupelski:[(hour:NSNumber, day:String)] = []
    static func needsFillEmptyPlanerElement(itemscount:Int, allData:[Planer], hour:NSNumber, day:String)->[(hour:NSNumber, day:String)]{
        if(itemscount > 0){
            print("day: \(day) compareday: \(allData[itemscount-1].daystring!) hour: \(hour) comparehoue: \(allData[itemscount-1].hour!.hour!)")
            if day == allData[itemscount-1].daystring && hour == allData[itemscount-1].hour!.hour!{
                print("appending: \(hour) on day: \(day)")
                tupelski.append((hour, day))
            }else{ needsFillEmptyPlanerElement(itemscount: itemscount-1, allData: allData, hour: hour, day: day) }
        }
        return tupelski
    }
    
    static func fillEmptyPlanerElement(hour:NSNumber, day:String, context:NSManagedObjectContext){
        let t = Planer.InsertIntoManagedObjectContext(context: context)
        let d = Day.FetchDataWithPredicate(Day.Key_day, value: day, context: context)
        t.day = d![0]
        t.daystring = d![0].day!
        let h = TimelineData.FetchDataWithPredicate(TimelineData.Key_hour, value: hour.stringValue, context: context)
        t.hour = h![0]
        do{ try context.save()
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
}
