
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
    func CreateEmptyEntityObject() -> NSManagedObject {
        let obj = NSEntityDescription.insertNewObjectForEntityForName(Day.EntityName, inManagedObjectContext: self.context)
        return obj
    }
    
    
    func Save(){
        
    }
    
    func FetchData(){
        
    }
    
    func FetchDataWithKey(key: String, value: NSObject){
        
    }
    
}

