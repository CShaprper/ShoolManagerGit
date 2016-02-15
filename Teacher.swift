//
//  Teacher.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.11.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import CoreData


class Teacher: NSManagedObject {
    
    static let EntityName = "Teacher"
    static let Key_id = "id"
    static let Key_name = "name"
    static let Key_imageName = "imageName"
    
    /**Inserts a new Entity object into NSManagedObjectContext
     :param: context: NSManagedObjectContext
     :returns: NSManagedObject
     How to use:
     let myDay:Day = Day.InsertDayIntoManagedObjectContext(appDel.managedObjectContext) as! Day*/
     static func insertIntoManagedObjectContext(context: NSManagedObjectContext)->Teacher{
        let obj = (NSEntityDescription.insertNewObjectForEntityForName(Teacher.EntityName, inManagedObjectContext: context)) as! Teacher
        print("\(Subject.EntityName) Entity object created in NSManagedObjectContext")
        
        return obj
    }
    
    
    /**Fetches all records
     :returns: Array of [NSManagedObject]?*/
   static func FetchData(context: NSManagedObjectContext)->[Teacher]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: Teacher.EntityName)
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Teacher]
            print("\(fetchResults!.count) Teachers fetched from Core Data from Teacher class")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
    
    /**Fetches Data with Predicate
     :param: predicateKey: String of key to filter
     :param: value: Value of Key to filter*/
   static func FetchDataWithPredicate(predicateKey: String, value: String, context: NSManagedObjectContext )->[Teacher]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: Teacher.EntityName)
            let sortDescriptor = NSSortDescriptor(key: predicateKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "\(predicateKey) == %@", value)
            fetchRequest.predicate = predicate
            let fetchResults = try context.executeFetchRequest(fetchRequest) as? [Teacher]
            print("\(fetchResults!.count) Teachers with predicate \(value) fetched from Core Data from Teacher class")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription) }
        
        return nil
    }
    
    /**Edits Teacher Object*/
    static func EditTeacher(teacherToEdit: Teacher, context: NSManagedObjectContext){
        do{ try context.save()
            print("Teacher Edited in Core Data from Teacher class")
        }
        catch let error as NSError{
            print(error.localizedDescription)}

    }
    
    /**
     Saves an Teacher Entity Object
     
     - Parameters:
        - strName String:  name of the Teacher
        - isMale Bool:   Teacher gender
     */
    static func SaveTeacher(strName: String, imageName: String, context: NSManagedObjectContext){
        let t = Teacher.insertIntoManagedObjectContext(context)
        t.name = strName
        t.iamgeName = imageName
        
        do{ try context.save()
            print("Teacher \(t.name!) saved in Core Data from Teacher class")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
        
    }
    
    /**
     Deletes an Teacher Entity Object from Core Data
     
     - Parameters:
        - objTeacher Teacher:   Teacher object to delete
        - context NSManagedObjectContext:   NSManagedObjectContext to save data
     */
    static func DeleteTeacher(objTeacher: Teacher, context: NSManagedObjectContext){
        context.deleteObject(objTeacher)
        
        do{ try context.save()
            print("Teacher object deleted from class Teacher")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
}
