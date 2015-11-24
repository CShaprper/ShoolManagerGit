
import CoreData

protocol IRepository{
    var context:NSManagedObjectContext { get set }
    
    func CreateEmptyEntityObject(entityName:String)->NSManagedObject
    
    /** Saves a NSManagedObject
     :param: ObjectToSave  -  NSManagedObject*/
    func Save(entity: NSManagedObject)
    
    func FetchData(entityName:String)->[NSManagedObject]?
    
    /**Fetches Data with Predicate
     :param: entityName: String of EntityName
     :param: predicateKey: String of key to filter
     :param: value: Value of Key to filter*/
    func FetchDataWithPredicate(entityName:String, predicateKey: String, value: String)->[NSManagedObject]?
    
    /**Deletes a specific Entity
     :param: entity  -  entity NSMannagedObject*/
    func DeleteData(entity:NSManagedObject?)
}

