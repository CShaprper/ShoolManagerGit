//
//  Note.swift
//  SchoolManager
//
//  Created by Peter Sypek on 29.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Note: NSManagedObject {
    static let EntityName = "Note"
    static let Key_note = "note"

    /**
    **Creates a new Entity object in NSManagedObjectContext**
    - Parameter context: NSManagedObjectContext for Core Data operations
    - returns: Planer: Planer Entity object
    */
    static func InsertIntoManagedObjectContext(context:NSManagedObjectContext)->Note{
        let obj = (NSEntityDescription.insertNewObject(forEntityName: Note.EntityName, into: context)) as! Note
        print("\(Note.EntityName) Entity object created in NSManagedObjectContext")
        return obj
    }
    
    /**
     **Fetches all Note Data from Core Data**
     
    - Parameter context: *NSManagedObjectContext for Core Data operations.*
    - Returns: [Note]:  *Array of Note Entity objects.*
     */
    static func FetchData(context:NSManagedObjectContext)->[Note]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Note.EntityName)
            let fetchResults = try context.fetch(fetchRequest) as? [Note]
            //  print("\(fetchResults!.count) Note objects fetched from Core Data")
            
            return fetchResults
        }
        catch let error as NSError{
          print(error.localizedDescription)
        }
        return nil
    }
    
    /**
     **Fetches Note Object with given ID**
     
     - parameter ID: - String: *ID to fetch Note*
     - parameter context: - NSManagedObjectContext: *Context to perform CoreData operations*
     - returns: fetchResults: - [Note]: *Array of Note objects*
     */
    static func fetchNoteWithID(ID:String, context:NSManagedObjectContext)->[Note]?{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            fetchRequest.entity = (NSEntityDescription.entity(forEntityName: Note.EntityName, in: context))
            
            let predicate = NSPredicate(format: "%K == %@", "guid", ID)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchResults = try context.fetch(fetchRequest) as? [Note]
            print("\(fetchResults!.count) Note objects with predicate \(ID) fetched from Core Data")
            return fetchResults
        }
        catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }

    /**
     **Saves a Note Entity object to Core Data**     

     - parameter context: NSManagedObjecContext: - *NSManagedObjectContext for Core Data operations*
     - parameter noteObj: **Note:**   Note Entity Object
     */
    static func SaveNote(dueDate:NSDate, strUUID:String, strNote:String, subject:Subject, context: NSManagedObjectContext){
        let n = Note.InsertIntoManagedObjectContext(context: context)
        n.note = strNote
        n.subject = subject
        n.guid  = strUUID
        n.reminderDate = dueDate
        
        do{ try context.save()
            print("Note object saved in Core Data")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }   
    
    /**
     **Deletes an Note from Core Data**
     - parameter objNote: Note class Object to delete
     - parameter context: NSManagedObjectContext
     */
    static func deleteNote(objNote: Note, context: NSManagedObjectContext){
        context.delete(objNote)
        
        do{ try context.save()
            print("Note object deleted from Core Data")
        }
        catch let error as NSError{
            print(error.localizedDescription)}
    }
    
    /**
     **deleteAllNotes**
     
     - parameter context: - *NSManagedObjectContext: context for CoreData operations*
     
     - remark:
     Deletes all objects of type Note: in CoreData managed database.
     */
    static func deleteAllNotes(context:NSManagedObjectContext){
        UIApplication.shared.cancelAllLocalNotifications()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Note.EntityName)
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: Note.EntityName, in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    context.delete(result)
                }
                
                try context.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)}
    }

}
