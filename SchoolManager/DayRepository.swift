
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
            print(entity)
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
    
    func FetchDataWithPredicate(entityName:String, predicateKey: String, value:String )->[NSManagedObject]?{
        do{
            let fetchRequest = NSFetchRequest(entityName: entityName)
            let sortDescriptor = NSSortDescriptor(key: Day.Key_day, ascending: true)
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
    
    func DeleteData(entity:NSManagedObject?){
        do{
            context.deleteObject(entity!)
            try context.save()
            print("Deleted Record: \(entity)")
        }
        catch let error as NSError{
            print(error)
        }
    }
}

