
import CoreData
import UIKit

public class TimelineManager{
    /*Members
    ###############################################################################################################*/
    private var hoursPerDay:Int!
    private var HoursPerDayUIValue:String! {
        get { return "\(hoursPerDay)" }
        set { self.HoursPerDayUIValue = newValue } }
    //var HoursPerDayArray:[String] = []
    private var StartTime:NSDate!
    private var EndTime:NSDate!
    private var LastEndTime:NSDate!
    private var dateComponets:NSDateComponents!
    private var calendar:NSCalendar!
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
    func SetHoursPerDay(hours:Int){
         self.hoursPerDay = hours
        SetHoursPerDayElementCount()
    }
    func SetStartTime(time:NSDate){
         self.StartTime = time
        print("StartTime changed in TimeLine Model: \(self.StartTime)")
    }
    func SetEndTime(time:NSDate){
        self.EndTime = time
        //Automatic set last end Time
        SetLastEndTime(time)
        print("EndTime changed in TimeLine Model: \(self.EndTime)")
    }
    func GetStartTime()->NSDate{
        return StartTime
    }
    func GetEndTime()->NSDate{
        return EndTime
    }
    func GetTimeAsHour(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
        dateComponents.hour = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date).hour
      return dateComponents.hour
    }
    func GetTimeAsMinute(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
        dateComponents.minute = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date).minute
        return dateComponents.minute
    }
    func LoadHoursPerDayFromCoreData(context:NSManagedObjectContext){
   
        
//        let hpdArray:HoursPerDayData = HoursPerDayData.FetchData(context)
//        for hrs in hpdArray{
//            self.HoursPerDayArray.append("\(hrs.)")
//        }
       
    }
    
    
    
/*Private Functions
    ###################################################################*/
    /** Resets the element count of the HoursPerDayArray to 0*/
    private func ResetHoursPerDayArrayCount(){
        //self.HoursPerDayArray.removeAll()
    }
    
    /**Sets the number of Elemets in the HoursPerDayArray 
     to the int value of HoursPerDay property
     - Resets the element count to 0 before appending new elements*/
   private func SetHoursPerDayElementCount(){
    ResetHoursPerDayArrayCount()
//        for i in 1...self.hoursPerDay{
//           self.HoursPerDayArray.append("\(i)")
//        }
    }
    /** Sets last Endtime value
    :param: lastEndTime: time of latest set Time*/
    private func SetLastEndTime(time:NSDate){
        self.LastEndTime = time
    }
    
    private func saveHoursPerDayInCoreData(_hours: Int){
    
    }
}