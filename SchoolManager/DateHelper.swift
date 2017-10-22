//
//  DateHelper.swift
//  SchoolManager
//
//  Created by Peter Sypek on 03.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation

class DateHelper{
    /**
     **Creates a date from integer components**
     - Parameters:
     - year: **Int:**   For digit Year
     - month: **Int:**   Two digit month
     - day: **Int:**   Two digit day
     - hour: **Int:**   Two digit hour
     - day: **Int:**   Two digit day
     - minute: **Int:**   Two digit day
     - returns: Calendar Date made of integer Components: **NSDate**
     */
    static func createDateFromComponents(year:Int, month:Int, day:Int, hour:Int, minute:Int)->NSDate{
        let dateComponents:NSDateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        dateComponents.timeZone = NSTimeZone.system
        let calendar = NSCalendar.current
        return calendar.dateComponents(dateComponents)!
    }
    /**
     **Gets hour as Integer value from an NSDate**
     
     - Parameters:
     - date: **NSDate:**   The date which hour will be returned
     - returns: hour as Integer value: **Int**
     */
   static func GetTimeAsHour(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
    dateComponents.hour = NSCalendar.current.component(.hour, from: date as Date)
        return dateComponents.hour
    }
    /**
     **Gets minute as Integer value from an NSDate**
     
     - Parameters:
     - date: **NSDate:**   The date which minutes will be returned
     - returns: minutes as Integer value: **Int**
     */
   static func GetTimeAsMinute(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
    dateComponents.minute = NSCalendar.current.component(.minute, from: date as Date)
        return dateComponents.minute
    }
    
   static func isGreaterThanDate(sourceDate:NSDate,  dateToCompare:NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        //Compare Values
        if sourceDate.compare(dateToCompare as Date) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        //Return Result
        return isGreater
    }
    
    
   static func isLessThanDate(sourceDate:NSDate, dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        //Compare Values
        if sourceDate.compare(dateToCompare as Date) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        //Return Result
        return isLess
    }
    
    
  static  func isSameToDate(sourceDate:NSDate, dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        //Compare Values
        if sourceDate.compare(dateToCompare as Date) == ComparisonResult.orderedSame
        {
            isEqualTo = true
        }
        //Return Result
        return isEqualTo
    }

}
