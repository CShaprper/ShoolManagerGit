
import CoreData

protocol IRepository{
    var context:NSManagedObjectContext { get set }
    
    func CreateEmptyEntityObject(entityName:String)->NSManagedObject
    
    /** Saves a NSManagedObject
     :param: ObjectToSave  -  NSManagedObject*/
    func Save(entity: NSManagedObject)
    
    func FetchData(entityName:String)->[NSManagedObject]?
    
    func FetchDataWithPredicate(entityName:String, predicateKey: String, value: String)->[NSManagedObject]?
}

