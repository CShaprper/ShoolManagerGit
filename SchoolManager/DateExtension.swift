//
//  DateExtension.swift
//  SchoolManager
//
//  Created by Peter Sypek on 15.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation

extension NSDate
{
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        //Return Result
        return isLess
    }
    
    
    func isSameToDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame
        {
            isEqualTo = true
        }
        //Return Result
        return isEqualTo
    }
    
    
    
    func addDays(daysToAdd : Int) -> NSDate
    {
        let secondsInDays : TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded : NSDate = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    
    func addHours(hoursToAdd : Int) -> NSDate
    {
        let secondsInHours : TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded : NSDate = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func getDayOfWeek(date:NSDate)->Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: date as Date)
        let weekDay = myComponents.weekday
        return weekDay!
    }
    
    /**
     **Formats the hour of an Date to String HH:mm**
     
     - Parameters:
     - date: **NSDate:**   The date to format the hour
     
     - returns: String: **HH:mm from date**
     */
   static func hourFormatter(date:NSDate)->String{
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        let str = hourFormatter.string(from: date as Date)
        return str
    }
    
    /**
     **Formats the hour of an Date to String HH:mm**
     
     - Parameters:
     - date: **NSDate:**   The date to format the hour
     
     - returns: String: **HH:mm from date**
     */
    static func dateTimeFormatter(date:NSDate)->String{
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "EEE dd MMM yy - HH:mm"
        let str = hourFormatter.string(from: date as Date)
        return str
    }
}
