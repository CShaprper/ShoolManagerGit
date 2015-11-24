
import CoreData

protocol IRepository{
    var context:NSManagedObjectContext { get set }
    
    func CreateEmptyEntityObject()->NSManagedObject
    
    /** Saves a NSManagedObject
     :param: ObjectToSave  -  NSManagedObject*/
    func Save()
    
    func FetchData()
    
    func FetchDataWithKey(key: String, value: NSObject)
}

