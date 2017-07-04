//
//  Subject.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.11.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import CoreData


class Subject: NSManagedObject {
    static let EntityName = "Subject"
    static let Key_id = "id"
    static let Key_subject = "subject"
    
    /**Inserts a new Entity object into NSManagedObjectContext
     :param: context: NSManagedObjectContext
     :returns: NSManagedObject
     How to use:
     let myDay:Day = Day.InsertDayIntoManagedObjectContext(appDel.managedObjectContext) as! Day*/
    static func InsertIntoManagedObjectContext(_ context:NSManagedObjectContext)->Subject{
        let obj = (NSEntityDescription.insertNewObject(forEntityName: Subject.EntityName, into: context)) as! Subject
        print("\(Subject.EntityName) Entity object created in NSManagedObjectContext")
    
        return obj
    }
    
    
    /**Fetches all records
     :returns: Array of [NSManagedObject]?*/
    static func FetchData(_ context:NSManagedObjectContext)->[Subject]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Subject.EntityName)
            let fetchResults = try context.fetch(fetchRequest) as? [Subject]
            print("\(fetchResults!.count) Subjects fetched from Core Data from Day class")
            
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        
        return nil
    }
    
    /**Fetches Data with Predicate
     :param: predicateKey: String of key to filter
     :param: value: Value of Key to filter*/
    static func FetchDataWithPredicate(_ predicateKey: String, value:String, context:NSManagedObjectContext )->[Subject]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Subject.EntityName)
            let sortDescriptor = NSSortDescriptor(key: predicateKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "\(predicateKey) == %@", value)
            fetchRequest.predicate = predicate
            let fetchResults = try context.fetch(fetchRequest) as? [Subject]
            print("\(fetchResults!.count) Subjects with predicate \(value) fetched from Core Data from Day class")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        
        return nil
    }
    
    /**Edits Subject Object*/
    static func EditTeacher(_ subjectToEdit: Subject, context: NSManagedObjectContext){
        do{ try context.save()
            print("Subject Edited in Core Data from Teacher class")
        }
        catch let error as NSError{ print("Error Editing Teacher in Teacher class: \(error)")}
        
    }
    
    /**Saves a Subject Object to Core Data
     :param: strSubject: as String*/
    static func SaveSubject(_ strSubject: String, hexColor: String, imageName: String, context: NSManagedObjectContext){
        let t = Subject.InsertIntoManagedObjectContext(context)
        t.subject = strSubject
        t.imageName = imageName
        t.color = hexColor
        
        do{ try context.save()
            print("Subject \(t.subject!) saved in Core Data from Subject class")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
    
    /**Deletes an Teacher from Core Data
     :param: objTeacher: Teacher class Object to delete*/
    static func DeleteSubject(_ objSubject: Subject, context: NSManagedObjectContext){
        context.delete(objSubject)        
        
        do{ try context.save()
            print("Subject object deleted from class Subject")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
    
    /** Deletes all Subject objects from Core Data containing strSubject in Key_Subject
     :param: strDay: String predicate to delete
     :param: context: NSManagedObjectContext*/
    static func DeleteDayWithPredicate(_ strSubject: String, context: NSManagedObjectContext){
        let subjects = Subject.FetchDataWithPredicate(Subject.Key_subject, value: strSubject, context: context)
        for s in subjects!{
            s.managedObjectContext?.delete(s)
            
            do{ try s.managedObjectContext?.save()                
                print("Subject object deleted with predicate func from class Subject")
            }
            catch let error as NSError{
                print(error.localizedDescription)}
        }
    }
}
