
import CoreData
import UIKit

open class TimelineManager{
    /*Members
    ###############################################################################################################*/
    fileprivate var hoursPerDay:Int!
    fileprivate var HoursPerDayUIValue:String! {
        get { return "\(hoursPerDay)" }
        set { self.HoursPerDayUIValue = newValue } }
    //var HoursPerDayArray:[String] = []
    fileprivate var StartTime:Date!
    fileprivate var EndTime:Date!
    fileprivate var LastEndTime:Date!
    fileprivate var dateComponets:DateComponents!
    fileprivate var calendar:Calendar!
    var TimeLineDataCollection:[TimelineData]!
    
/*Public Functions
    ###################################################################*/
    func GetHoursPerDayUIValueAsString()->String{
        if HoursPerDayUIValue != nil && HoursPerDayUIValue != "" {
            return HoursPerDayUIValue
        }else{
            return String()
        }
    }
    func GetHoursPerDay()->Int{
        return hoursPerDay
    }
    func GetHoursPerDayAsString()->String{
        return "\(hoursPerDay)"
    }
    func SetHoursPerDay(_ hours:Int){
         self.hoursPerDay = hours
        SetHoursPerDayElementCount()
    }
    func SetStartTime(_ time:Date){
         self.StartTime = time
        print("StartTime changed in TimeLine Model: \(self.StartTime)")
    }
    func SetEndTime(_ time:Date){
        self.EndTime = time
        //Automatic set last end Time
        SetLastEndTime(time)
        print("EndTime changed in TimeLine Model: \(self.EndTime)")
    }
    func GetStartTime()->Date{
        return StartTime
    }
    func GetEndTime()->Date{
        return EndTime
    }
    func GetTimeAsHour(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.hour = (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: date).hour
      return dateComponents.hour!
    }
    func GetTimeAsMinute(_ date:Date)->Int{
        var dateComponents = DateComponents()
        dateComponents.minute = (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: date).minute
        return dateComponents.minute!
    }
    func LoadHoursPerDayFromCoreData(_ context:NSManagedObjectContext){
   
        
//        let hpdArray:HoursPerDayData = HoursPerDayData.FetchData(context)
//        for hrs in hpdArray{
//            self.HoursPerDayArray.append("\(hrs.)")
//        }
       
    }
    
    
    
/*Private Functions
    ###################################################################*/
    /** Resets the element count of the HoursPerDayArray to 0*/
    fileprivate func ResetHoursPerDayArrayCount(){
        //self.HoursPerDayArray.removeAll()
    }
    
    /**Sets the number of Elemets in the HoursPerDayArray 
     to the int value of HoursPerDay property
     - Resets the element count to 0 before appending new elements*/
   fileprivate func SetHoursPerDayElementCount(){
    ResetHoursPerDayArrayCount()
//        for i in 1...self.hoursPerDay{
//           self.HoursPerDayArray.append("\(i)")
//        }
    }
    /** Sets last Endtime value
    :param: lastEndTime: time of latest set Time*/
    fileprivate func SetLastEndTime(_ time:Date){
        self.LastEndTime = time
    }
    
    fileprivate func saveHoursPerDayInCoreData(_ _hours: Int){
    
    }
}
