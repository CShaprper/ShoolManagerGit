
import CoreData

/**Class that manages communication to core Data
 :implements: IRepository */
class DayRepository: IRepository {
    var context:NSManagedObjectContext
    
    /** Constructor
     :param: context  -  NSManagedOjectContext*/
    init(context:NSManagedObjectContext){
        self.context = context
    }
    
    /** Creates Day Entity NSManagedObject
     :returns: Day Entity NSManagedObject*/
    func CreateEmptyEntityObject(entityName:String) -> NSManagedObject {
        let obj = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: self.context)
        return obj
    }
    
    /**Adds a new record to Entity
     :param: daystring     The day to add as string.*/
    func Save(entity: NSManagedObject){
        do{
            try self.context.save()
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    /**Fetches all records
     :returns: Array of [NSManagedObject]?*/
    func FetchData(entityName:String)->[NSManagedObject]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let fetchResults = try self.context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if fetchResults!.count > 0 {
                return fetchResults
            }
        }
        catch let error as NSError{
            print("\(entityName) not fetched \(error)")
        }
        return nil
    }
    
    /**Fetches Data with Predicate
     :param: entityName: String of EntityName
     :param: predicateKey: String of key to filter
     :param: value: Value of Key to filter*/
    func FetchDataWithPredicate(entityName:String, predicateKey: String, value:String )->[NSManagedObject]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let sortDescriptor = NSSortDescriptor(key: predicateKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "\(predicateKey) == %@", value)
            fetchRequest.predicate = predicate
            let fetchResults = try self.context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            return fetchResults
        }
        catch let error as NSError{
            print(error)
        }
        return nil
    }
    
    /**Deletes a specific Entity
     :param: entity  -  entity NSMannagedObject*/
    func DeleteData(entity:NSManagedObject?){
        do{
            context.deleteObject(entity!)
            try context.save()
        }
        catch let error as NSError{
            print(error)
        }
    }
}

